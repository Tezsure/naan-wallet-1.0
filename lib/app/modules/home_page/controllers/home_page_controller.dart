import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:simple_gql/simple_gql.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/data/data_handler_controller.dart';
import 'package:tezster_wallet/app/utils/apis_handler/http_helper.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_singleton.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/beacon/beacon_plugin.dart';
import 'package:tezster_wallet/models/nft_token_model.dart';
import 'package:tezster_wallet/models/token_tx_model.dart';
import 'package:tezster_wallet/models/tokens_model.dart';
import 'package:tezster_wallet/models/tzkt_txs_model.dart';

class HomePageController extends GetxController {
  // bottom navigation index
  final index = 0.obs;
  List<int> indexStack = [0];

  AnimationController animController;
  Animation<double> animation;
  InAppWebViewController webViewController;

  var priceData = {}.obs;
  var publicKeyHash = "".obs;
  final balance = "0".obs;
  var tokenXtzBalance = 0.obs;
  var transactionModels = <TzktTxsModel>[].obs;
  var tokenTransactionModels = <TokenTxModel>[].obs;
  var tokensModel = <TokensModel>[].obs;
  var nftsModel = <NFTToken>[].obs;
  var onGoingTx = <DataVariable>[].obs;
  var currentBackGroundTx = Map<String, String>().obs;
  StorageModel _storage;

  StorageModel get storage => _storage ?? StorageSingleton().storage;

  set storage(StorageModel storage) {
    _storage = storage;
  }

  Timer timer;
  var isShowingInXtz = false.obs;
  var dollerValue = 0.0.obs;

  var tokenRefDuration = Duration(seconds: 10);
  var isCClosed = false.obs;
  var isMainPageListScrolling = false.obs;
  var isTxHistoryListScrolling = false.obs;
  var isKeyRevealed = false.obs;

  var accoutnName = ''.obs;
  var pkH = ''.obs;
  var accounts = [].obs;

  var isWertLaunched = false.obs;
  var isWalletEmpty = false.obs;

  var scrollControllerHomePage = ScrollController().obs;
  var opacityHomePage = 0.0.obs;
  var fontSizeHomePage = 24.0.obs;

  var scrollControllerNFT = ScrollController().obs;
  var opacityNFT = 0.0.obs;
  var fontSizeNFT = 24.0.obs;

  var scrollControllerTx = ScrollController().obs;
  var opacityTx = 0.0.obs;
  var fontSizeTx = 24.0.obs;

  var scrollControllerSettings = ScrollController().obs;
  var opacitySettings = 0.0.obs;
  var fontSizeSettings = 24.0.obs;

  //Baker Delegation
  var delegate = "".obs;
  var name = "".obs;
  var imageUrl = "".obs;
  var isFetchingDelegate = true.obs;

  //StringPage
  // ignore: non_constant_identifier_names
  var privateKey_SeedPhrase = "".obs;

  //NftTab
  var nftDetailSelectedTab = 0.obs;
  //Nft edit galerry
  var editGalaryTextController = TextEditingController().obs;

  //multipleAccounts
  var createAccountEditingController = TextEditingController().obs;

  // Map<String, dynamic> accountData = {};

  // gloable context
  BuildContext parentKeyContext;

  // Loading animation
  var isNftGalleryLoading = false.obs;
  var isHomePageLoading = true.obs;

  //Remove bottom nav bar if nft is selected
  var isNftSelected = false.obs;

  // Dapp
  String lastVisitedUrlOnDapp = 'https://www.naanwallet.com/dapp.html';

  @override
  Future<void> onInit() async {
    super.onInit();
    bool isNameEdited = false;
    storage = StorageSingleton().storage;
    // await StorageUtils().getStorage();
    List s = storage.accounts[storage.provider];
    for (int i = 0; i < s.length; i++) {
      if (!s[i].containsKey('name')) {
        s[i]['name'] = "Account ${i + 1}";
        isNameEdited = true;
      }
    }
    if (storage.accounts[storage.provider][storage.currentAccountIndex]['name']
        .toString()
        .isEmpty) {
      storage.accounts[storage.provider][storage.currentAccountIndex]['name'] =
          'Account ${storage.currentAccountIndex + 1}';
    }
    accoutnName.value =
        storage.accounts[storage.provider][storage.currentAccountIndex]['name'];
    pkH.value = storage.accounts[storage.provider][storage.currentAccountIndex]
        ['publicKeyHash'];
    accounts.value = storage.accounts[storage.provider];
    if (isNameEdited) {
      await StorageUtils().postStorage(storage);
    }

    //
    if (accounts.value.length > 0 &&
        accounts.value[storage.currentAccountIndex]['secretKey'].length == 0) {
      isNftSelected.value = true;
      //redirecting to the nft gallery tab
      index.value = 2;
    } else {
      // reset the nav bar visibility if normal account is selected
      isNftSelected.value = false;
    }

    if (DataHandlerController().timer == null)
      startDataHandlerListener();
    else
      startDataHandlerListener(true);

    if (!BeaconPlugin.isBeaconStarted)
      BeaconPlugin.startBeacon(storage.accounts[storage.provider]
          [storage.currentAccountIndex]['publicKey']);

    getDeligator();
    getNftForPkh(pkH.value);
  }

  getDeligator() async {
    isFetchingDelegate.value = true;
    var delegateResponse = await HttpHelper.performGetRequest(
        "https://api.tzstats.com", "explorer/account/${pkH.value}");
    delegate.value = delegateResponse['delegate'] ?? "";
    if (delegate.value.length > 0) {
      var nameResponse = await HttpHelper.performGetRequest(
          "https://api.tzkt.io", "v1/accounts/${delegate.value}");
      name.value = nameResponse['alias'];
      imageUrl.value = "https://services.tzkt.io/v1/avatars/${delegate.value}";
    } else {
      name.value = "";
      imageUrl.value = "";
    }
    isFetchingDelegate.value = false;
  }

  void startDataHandlerListener([alreadyRunning = false]) {
    pkH.listen((String data) {
      // if (index.value == 2) {
      isNftGalleryLoading.value = true;
      getNftForPkh(pkH.value);
      // }

      onGoingTx.value = <DataVariable>[];

      isHomePageLoading.value = true;
      balance.value = "0";
      tokenXtzBalance.value = 0;
      tokensModel.value = <TokensModel>[];
      if (DataHandlerController().accountAddress != null ||
          DataHandlerController().accountAddress.toString().isNotEmpty)
        DataHandlerController().updateAccountAddress(pkH.value);
      getDeligator();
    });
    DataHandlerController()
        .updateAccountAddress(pkH.value)
        .updaterpcUrl(StorageUtils.rpc[storage.provider])
        .updateProvider(storage.provider)
        .updateTezsureApi(storage.tezsureApi)
          ..dollarValue.registerVariable(dollerValue)
          ..tokensModels.registerCallback((data) {
            isHomePageLoading.value = false;
          })
          ..xtzBalance.registerVariable(balance)
          ..tzktTransactionModels.registerVariable(transactionModels)
          ..tokensModels.registerCallback((value) {
            if (storage.provider != "mainnet") {
              tokensModel.value = [];
            } else {
              tokensModel.value = value;
            }
          })
          ..tokenBalanceInXtz.registerVariable(tokenXtzBalance)
          // ..nftTokensModels.registerVariable(nftsModel)
          ..currentTransactions.registerCallback((data) {
            print(data.length);
            onGoingTx.value = data;
            if (onGoingTx.length > 0)
              onGoingTx[0].registerCallback((data) {
                currentBackGroundTx.value = data;
                if (data['status'] != "Pending") {
                  if (data['amount'] == "Delegation") getDeligator();
                  Future.delayed(Duration(seconds: 5), () {
                    DataHandlerController()
                        .currentTransactions
                        .value
                        .removeAt(0);
                    currentBackGroundTx.value = null;
                    DataHandlerController().currentTransactions =
                        DataHandlerController().currentTransactions;
                  });
                }
              });
          });
    if (!alreadyRunning) {
      DataHandlerController().startUpdates();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    isCClosed.value = true;
    if (timer != null) timer.cancel();
  }

  Future<String> getAccountBalance(String pkH) async {
    var bal =
        await TezsterDart.getBalance(pkH, StorageUtils.rpc[storage.provider]);
    if (bal == "0") return bal;
    return ((int.parse(bal.toString()) / 1000000) * dollerValue.value)
        .toStringAsFixed(2);
  }

  void setBottomNavigationIndex(int i) => this.index.value = i;

  getNftForPkh(String pkH) async {
    if (pkH.isEmpty) return;
    isNftGalleryLoading.value = true;
    try {
      final response = await GQLClient(
        'https://data.objkt.com/v2/graphql',
      ).query(
        query: r'''
        query GetNftForUser($address: String!) {
  token(where: {holders: {holder: {address: {_eq: $address}}, token: {}}, fa_contract: {_neq: "KT1GBZmSxmnKJXGMdMLbugPfLyUPmuLSMwKS"}}) {
    artifact_uri
    description
    display_uri
    lowest_ask
    level
    mime
    pk
    royalties {
      id
      decimals
      amount
    }
    supply
    thumbnail_uri
    timestamp
    fa_contract
    token_id
    name
    creators {
      creator_address
      token_pk
    }
    holders(where: {holder_address: {_eq: $address}, quantity: {_gt: "0"}}) {
      quantity
      holder_address
    }
    events(where: {recipient: {address: {_eq: $address}}, event_type: {}}) {
      id
      fa_contract
      price
      recipient_address
      timestamp
      creator {
        address
        alias
      }
      event_type
      amount
    }
    fa {
      name
      collection_type
      floor_price
    }
    metadata
  }
}

      ''',
        variables: {'address': pkH},
      );
      nftsModel.value = response.data['token']
          .map<NFTToken>((e) => NFTToken.fromJson(e))
          .toList()
          .where((NFTToken e) => e.holders.length > 0 && e.tokenId.isNotEmpty)
          .toList();
      isNftGalleryLoading.value = false;
    } on GQLError {
      isNftGalleryLoading.value = false;
    } catch (e) {
      isNftGalleryLoading.value = false;
    }
  }
}
