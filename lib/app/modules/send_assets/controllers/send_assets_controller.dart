import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/data/data_handler_controller.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/utils/apis_handler/http_helper.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/models/nft_token_model.dart';
import 'package:tezster_wallet/models/tokens_model.dart';
import 'package:simple_gql/simple_gql.dart';

enum PROGRESS_STATE {
  ACTIVE,
  COMPLETED,
  PENDING,
}

class SendAssetsController extends GetxController {
  var currentStateList = <PROGRESS_STATE>[
    PROGRESS_STATE.ACTIVE,
    PROGRESS_STATE.PENDING,
    PROGRESS_STATE.PENDING,
    PROGRESS_STATE.PENDING
  ].obs;

  var stateNames = <String>[
    "Asset",
    "Recipient",
    "Amount",
    "Summary",
  ];

  // Select assest variabls
  var currentAssetPageSelected = 0.obs;
  var isWalletEmpty = false.obs;
  var nftsModel = <NFTToken>[].obs;

  /// 0 => XTZ
  /// 1 => Token
  /// 2 => NFT
  int selectedAssestType;
  NFTToken selectedNFT;
  TokensModel selectedToken;

  // Add Recepient
  var currentRecepientPageSelected = 0.obs;
  TextEditingController addressController = TextEditingController();
  var receiverAddress = "".obs;

  // Enter amount
  var enteredAmount = "".obs;
  var dollarValueOfCurrentAmount = "0.00".obs;

  // account variables
  StorageModel storage;
  var balance = "0".obs;
  var dollerValue = 0.0.obs;
  var tokensModel = <TokensModel>[].obs;

  // Summary variables
  var summaryFormController = 0.obs;
  var isSummaryLoading = false.obs;

  //AppBar animation
  var fontSizeHomePage = 28.0.obs;

  /// Add Contact
  var contactNameController = TextEditingController().obs;
  var contactAddressController = TextEditingController().obs;
  var isAddContactIsValid = false.obs;
  var rebuildAllContactList = true.obs;
  var editContactIndex = (-1).obs;

  //
  var isKeyRevealed = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    storage = await StorageUtils().getStorage();
    if (!storage.accounts[storage.provider][storage.currentAccountIndex]
        .containsKey('name'))
      storage.accounts[storage.provider][storage.currentAccountIndex]['name'] =
          'Account ${storage.currentAccountIndex + 1}';

    // DataHandlerController().nftTokensModels.isUpdate = true;
    checkIsManagerKeyRevealedForAccount(storage.accounts[storage.provider]
        [storage.currentAccountIndex]['publicKeyHash']);

    getNftForPkh(storage.accounts[storage.provider][storage.currentAccountIndex]
        ['publicKeyHash']);
    DataHandlerController()
      ..updateAccountAddress(storage.accounts[storage.provider]
          [storage.currentAccountIndex]['publicKeyHash'])
      ..xtzBalance.registerVariable(balance)
      ..tokensModels.registerCallback((value) {
        if (storage.provider != "mainnet") {
          tokensModel.value = [];
        } else {
          tokensModel.value = value;
        }
      })
      ..dollarValue.registerVariable(dollerValue);
    // ..nftTokensModels.registerVariable(nftsModel);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // DataHandlerController().nftTokensModels.isUpdate = false;
  }

  void checkIsManagerKeyRevealedForAccount(String pkH) {
    HttpHelper.performGetRequest(StorageUtils.rpc[storage.provider],
            'chains/main/blocks/head/context/contracts/$pkH/manager_key')
        .then((value) {
      if ((value ?? '').length > 0) isKeyRevealed.value = true;
    });
  }

  getNftForPkh(String pkH) async {
    // isNftGalleryLoading.value = true;
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
      // isNftGalleryLoading.value = false;
    } on GQLError {
      // isNftGalleryLoading.value = false;
    } catch (e) {
      // isNftGalleryLoading.value = false;
    }
  }

  // Common Widgets
  Widget getTabText(int index, int currentPageSelected, String s) {
    return index == currentPageSelected
        ? Stack(
            children: [
              Transform.translate(
                offset: Offset(
                  currentPageSelected == 1 ? 3 : -3,
                  -5.0,
                ),
                child: Container(
                  color: backgroundColor,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Container(
                color: backgroundColor,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: GradientText(
                  s,
                  gradient: gradientBackground,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          )
        : Stack(
            children: [
              Transform.translate(
                offset: Offset(
                  0,
                  -5.0,
                ),
                child: Container(
                  color: backgroundColor,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Container(
                color: backgroundColor,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text(
                    s,
                    style: TextStyle(
                      color: Color(0xFF8E8E95),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
