import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:simple_gql/simple_gql.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/custom_packges/image_cache_manager/image_cache_widget.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_dart/helper/http_helper.dart' as http_helper;

class NFT {
  String lowestAsk;
  String description;
  String buyId;
  String name;
  String faContract;

  NFT(
      {this.buyId,
      this.description,
      this.lowestAsk,
      this.name,
      this.faContract});
}

// ignore: must_be_immutable
class NftUsdt extends StatefulWidget {
  final String url;
  final String token;
  String faContract;
  String tokenId;
  NftUsdt(this.url, this.token) {
    var mainUrl = url.replaceFirst("https://objkt.com/asset/", '').split("/");
    this.faContract = mainUrl[0];
    this.tokenId = mainUrl[1];
  }

  @override
  _NftUsdtState createState() => _NftUsdtState();
}

class _NftUsdtState extends State<NftUsdt> {
  NFT nft;
  double tezPrice = 0.0;
  bool loading = false;

  void getNFTdata() async {
    try {
      var price = (await http_helper.HttpHelper.performGetRequest(
          'https://networkanalyticsindexer.plentydefi.com',
          'analytics/tokens/tez'))[0]["price"]["value"];
      var tokPrice = (await http_helper.HttpHelper.performGetRequest(
          'https://networkanalyticsindexer.plentydefi.com',
          'analytics/tokens/${widget.token}'))[0]["price"]["value"];
      var response;
      if (widget.faContract.startsWith('KT1')) {
        response = await GQLClient(
          'https://data.objkt.com/v2/graphql',
        ).query(
          query: r'''
          query NftDetails($address: String!, $tokenId: String!) {
            token(where: {token_id: {_eq: $tokenId}, fa_contract: {_eq: $address}}) {
              description
              name
              fa_contract
              asks(limit: 1,where: {status: {_eq: "active"}}, order_by: {price: asc}) {
                id
                price
              }
            }
          }
      ''',
          variables: {'address': widget.faContract, 'tokenId': widget.tokenId},
        );
      } else {
        response = await GQLClient(
          'https://data.objkt.com/v2/graphql',
        ).query(
          query: r'''
          query NftDetails($address: String!, $tokenId: String!) {
            token(where: {token_id: {_eq: $tokenId}, fa: {path: {_eq: $address}}}) {
              description
              asks(limit: 1,where: {status: {_eq: "active"}}, order_by: {price: asc}) {
                id
                price
              }
              name
              fa_contract
            }
          }
      ''',
          variables: {'address': widget.faContract, 'tokenId': widget.tokenId},
        );
      }
      print(response);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          tezPrice = double.parse(price) / double.parse(tokPrice);
          nft = NFT(
              buyId: response.data["token"][0]["asks"][0]["id"].toString(),
              lowestAsk:
                  response.data["token"][0]["asks"][0]["price"].toString(),
              name: response.data["token"][0]["name"],
              description: response.data["token"][0]["description"],
              faContract: response.data["token"][0]["fa_contract"]);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    print(widget.faContract);
    print(widget.tokenId);
    getNFTdata();
    super.initState();
  }

  buyWithUsd() async {
    try {
      setState(() {
        loading = true;
      });
      StorageModel storage = await StorageUtils().getStorage();
      if (!storage.accounts[storage.provider][storage.currentAccountIndex]
          .containsKey('name'))
        storage.accounts[storage.provider][storage.currentAccountIndex]
            ['name'] = 'Account ${storage.currentAccountIndex + 1}';
      var keyStore = KeyStoreModel(
        publicKeyHash: storage.accounts[storage.provider]
            [storage.currentAccountIndex]['publicKeyHash'],
        publicKey: storage.accounts[storage.provider]
            [storage.currentAccountIndex]['publicKey'],
        secretKey: storage.accounts[storage.provider]
            [storage.currentAccountIndex]['secretKey'],
      );
      var transactionSigner = await TezsterDart.createSigner(
          TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));
      String priceInToken;
      var transactionResult;
      if (widget.token == "USDt") {
        priceInToken =
            (((int.parse(nft.lowestAsk) / 1e6) * tezPrice) * 1.1).toString();
        transactionResult = await TezsterDart.sendContractInvocationOperation(
          "https://mainnet.smartpy.io",
          transactionSigner,
          keyStore,
          [
            "KT1XnTn74bUtxHfDtBmm2bGZAQfhPbvKWR8o",
            "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
          ],
          [0, 0],
          120000,
          1000,
          100000,
          ['transfer', 'routerSwap'],
          [
            """[ { "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, [ { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] } ] } ] ] } ]""",
            //"""{ "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1D1NcffeDR3xQ75fUFoJXZzD6WQp96Je3L" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "prim": "Pair", "args": [ { "int": "${(double.parse(priceInUSDT) * 1e6).toStringAsFixed(0)}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] }""",
            """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1D1NcffeDR3xQ75fUFoJXZzD6WQp96Je3L" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
            //"""{ "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "None" } ] }"""
          ],
          codeFormat: TezosParameterFormat.Micheline,
        );
        setState(() {
          loading = false;
        });
      } else if (widget.token == "uUSD") {
        priceInToken =
            (((int.parse(nft.lowestAsk) / 1e6) * tezPrice) * 1.1).toString();
        transactionResult = await TezsterDart.sendContractInvocationOperation(
          "https://mainnet.smartpy.io",
          transactionSigner,
          keyStore,
          [
            "KT1XRPEPXbZK25r3Htzp2o1x7xdMMmfocKNW",
            "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
          ],
          [0, 0],
          120000,
          1000,
          100000,
          ['transfer', 'routerSwap'],
          [
            """[ { "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, [ { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken) * 1e12).toStringAsFixed(0)}" } ] } ] } ] ] } ]""",
            """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1Ji4hVDeQ5Ru7GW1Tna9buYSs3AppHLwj9" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1UsSfaXyqcjSVPeiD7U1bWgKy3taYN7NWY" }, { "int": "2" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1Dhy1gVW3PSC9cms9QJ7xPMPPpip2V9aA6" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "2" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e12).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
          ],
          codeFormat: TezosParameterFormat.Micheline,
        );
        setState(() {
          loading = false;
        });
      } else if (widget.token == "kUSD") {
        priceInToken =
            (((int.parse(nft.lowestAsk) / 1e6) * tezPrice) * 1.1).toString();
        transactionResult = await TezsterDart.sendContractInvocationOperation(
          "https://mainnet.smartpy.io",
          transactionSigner,
          keyStore,
          [
            "KT1K9gCRgaLRFKTErYt1wVxA3Frb9FjasjTV",
            "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
          ],
          [0, 0],
          120000,
          1000,
          100000,
          ['transfer', 'routerSwap'],
          [
            """{ "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "int": "${(double.parse(priceInToken) * 1e18).toStringAsFixed(0)}" } ] } ] }""",
            """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1HgFcDE8ZXNdT1aXXKpMbZc6GkUS2VHiPo" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1UsSfaXyqcjSVPeiD7U1bWgKy3taYN7NWY" }, { "int": "2" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1Dhy1gVW3PSC9cms9QJ7xPMPPpip2V9aA6" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "2" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e18).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
          ],
          codeFormat: TezosParameterFormat.Micheline,
        );
        setState(() {
          loading = false;
        });
      } else if (widget.token == "EURL") {
        priceInToken =
            (((int.parse(nft.lowestAsk) / 1e6) * tezPrice) * 1.1).toString();
        transactionResult = await TezsterDart.sendContractInvocationOperation(
          "https://mainnet.smartpy.io",
          transactionSigner,
          keyStore,
          [
            "KT1JBNFcB5tiycHNdYGYCtR3kk6JaJysUCi8",
            "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
          ],
          [0, 0],
          120000,
          1000,
          100000,
          ['transfer', 'routerSwap'],
          [
            """[ { "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, [ { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] } ] } ] ] } ]""",
            """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1LqEgLikLE2obnyzgPJA6vMtnnG5agXVCn" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
          ],
          codeFormat: TezosParameterFormat.Micheline,
        );
        setState(() {
          loading = false;
        });
      } else if (widget.token == "ctez") {
        priceInToken =
            (((int.parse(nft.lowestAsk) / 1e6) * tezPrice) * 1.1).toString();
        transactionResult = await TezsterDart.sendContractInvocationOperation(
          "https://mainnet.smartpy.io",
          transactionSigner,
          keyStore,
          [
            "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4",
            "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
          ],
          [0, 0],
          120000,
          1000,
          100000,
          ['transfer', 'routerSwap'],
          [
            """{ "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] } ] }""",
            """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
          ],
          codeFormat: TezosParameterFormat.Micheline,
        );
        setState(() {
          loading = false;
        });
      }

      print(transactionResult['operationGroupID']
          .toString()
          .replaceAll('\n', ''));
      Fluttertoast.showToast(
          fontSize: 12,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          msg: "Yay! Tx Successful (${transactionResult['operationGroupID']})",
          backgroundColor: Colors.green,
          textColor: Colors.white);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        loading = false;
        Fluttertoast.showToast(
            msg: "Something went wrong",
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: nft != null
            ? Container(
                height: Get.height,
                width: Get.width,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Platform.isAndroid ? 20 : 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            backButton(context),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: Get.width - 56,
                              width: Get.width - 56,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CacheImageBuilder(
                                  imageUrl:
                                      "https://assets.objkt.media/file/assets-003/${nft.faContract}/${widget.tokenId.toString()}/thumb400",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            informationUI(),
                            Center(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xFF484A92))),
                                  onPressed: buyWithUsd,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Buy For ${(((int.parse(nft.lowestAsk) / 1e6) * tezPrice * 1.1)).toStringAsFixed(2)} ${widget.token} (${(int.parse(nft.lowestAsk) / 1e6).toStringAsFixed(2)} tez)"),
                                        loading
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget informationUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nft.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          nft.description == null ? '' : nft.description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
            // fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 12,
        ),
        // CustomAnimatedActionButton(
        //   "View on objkt.com",
        //   true,
        //   () async {
        //     String url =
        //         "https://objkt.com/asset/${widget.value.fa2Id}/${widget.value.id}";
        //     if (await canLaunch(url)) {
        //       launch(url);
        //     }
        //   },
        //   height: 60,
        //   fontSize: 16,
        // ),
      ],
    );
  }

/*   Widget activity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: List.generate(widget.value.events.length, (index) {
          var date =
              DateTime.parse(widget.value.events[index].timestamp).toLocal();
          Duration diff = DateTime.now().difference(date);
          String time;
          if (diff.inDays >= 1) {
            time = '${diff.inDays} day ago';
          } else if (diff.inHours >= 1) {
            time = '${diff.inHours} hour ago';
          } else if (diff.inMinutes >= 1) {
            time = '${diff.inMinutes} minute ago';
          } else if (diff.inSeconds >= 1) {
            time = '${diff.inSeconds} second ago';
          } else {
            time = 'just now';
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.value.events[index].eventType.camelCase} ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 4,
                        ),
                        Text(
                          " " +
                              widget.value.events[index].creator.address
                                  .substring(0, 3) +
                              "..." +
                              widget.value.events[index].creator.address
                                  .substring(
                                      widget.value.events[index].creator.address
                                              .length -
                                          4,
                                      widget.value.events[index].creator.address
                                          .length) +
                              " ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 4,
                        ),
                        Text(
                          " " +
                              widget.value.events[index].recipientAddress
                                  .substring(0, 3) +
                              "..." +
                              widget
                                  .value.events[index].recipientAddress
                                  .substring(
                                      widget.value.events[index]
                                              .recipientAddress.length -
                                          4,
                                      widget.value.events[index]
                                          .recipientAddress.length) +
                              " ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 4,
                        ),
                        Text(
                          " ${(double.parse((widget.value.events[index].price ?? 0.0).toString()) / 1e6).toStringAsFixed(0)} tez",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: Color(0xff8E8E95),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                height: 1,
                width: Get.width,
                color: Colors.white.withOpacity(0.04),
              ),
            ],
          );
        }).reversed.toList(),
      ),
    );
  } */
}
