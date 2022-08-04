import 'package:get/get.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/data/data_handler_controller.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/beacon/beacon_plugin.dart';
import 'package:tezster_wallet/models/beacon_permission_model.dart';
import 'package:tezster_wallet/models/tokens_model.dart';
import 'package:tezster_dart/helper/http_helper.dart' as http_helper;

class BeaconFormController extends GetxController {
  var fromController = 0.obs;
  var selectedAccountIndex = 0.obs;
  var isFetched = false.obs;
  var dollerValue = 0.0.obs;
  StorageModel storage;
  String selectedAccountPkH;
  var selectedAccountName = "".obs;

  // confirm transaction variables
  var fee = "0.000413 tez".obs;

  // Beacon permission variable
  var balances = Map<String, dynamic>().obs;

  var argsModel = BeaconPermissionModel().obs;

  var accounts = [].obs;
  var opPair = <String, Object>{}.obs;
  @override
  void onInit() async {
    super.onInit();
    storage = await StorageUtils().getStorage();
    accounts.value = storage.accounts[storage.provider]
        .where((e) =>
            e['secretKey'] != null && e['secretKey'].toString().isNotEmpty)
        .toList();
    selectedAccountIndex.value = 0;
    selectedAccountPkH =
        accounts.value[selectedAccountIndex.value]['publicKey'];
    selectedAccountName.value =
        accounts.value[selectedAccountIndex.value]['name'];
    isFetched.value = true;
    DataHandlerController()..dollarValue.registerVariable(dollerValue);
    if (argsModel.value.operationDetails != null &&
        argsModel.value.payload == null) {
      opPair = BeaconPlugin.opPair;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  getAccountBalance(String pkH, int index) async {
    // (xtzBalance + tokenBalanceInXtz)/1e6 * dollarValue
    var bal =
        await TezsterDart.getBalance(pkH, StorageUtils.rpc[storage.provider]);
    if (bal != "0") {
      double xtzBalance =
          ((int.parse(bal.toString()) / 1000000) * dollerValue.value);
      balances.value[pkH]['balance'] = r"$" + xtzBalance.toStringAsFixed(2);
      // balances.value = balances.value;
    }
    updateTtokensModels(
            pkH, storage.provider, DataHandlerController().priceData)
        .then((tokenBalanceInXtz) {
      double actual_value = ((int.parse(bal) + tokenBalanceInXtz) / 1e6) *
          DataHandlerController().priceData['xtzusdValue'];
      balances.value[pkH]['balance'] = r"$" + actual_value.toStringAsFixed(2);
      balances.value = balances.value;
    });
  }

  static Future<int> updateTtokensModels(String accountAddress, String provider,
      Map<dynamic, dynamic> priceData) async {
    callApi(network, pkHash, offset) async {
      return await http_helper.HttpHelper.performGetRequest(
        'https://api.better-call.dev',
        'v1/account/$network/$pkHash/token_balances?size=50&offset=$offset',
        // 'v1/account/${storage.provider == 'mainnet' ? 'mainnet' : 'florencenet'}/tz2TyvECPRzAJyBk61NUenXEJioTqpQNdoKA/token_balances?size=50',
      );
    }

    var offset = 0;

    var tokensData = await callApi(
      provider == 'mainnet' ? 'mainnet' : 'florencenet',
      accountAddress,
      offset,
    );

    var totalApiCall = (tokensData['total'] / 50).round();

    for (var i = 0; i < totalApiCall; i++) {
      offset += 50;
      var tempTokensData = await callApi(
        provider == 'mainnet' ? 'mainnet' : 'florencenet',
        accountAddress,
        offset,
      );
      tokensData['balances'].addAll(tempTokensData['balances']);
    }

    tokensData['balances'] = tokensData['balances']
        .where((e) =>
            e.containsKey("network") ? e['network'] != 'florencenet' : true)
        .toList();

    if (tokensData.length > 0) {
      var _tokenXtzv = 0;

      var sortPriceData = priceData['contracts'].toList();
      var data = tokensData['balances'].map<TokensModel>((e) {
        var result = TokensModel.fromJson(e);
        var t;
        if (result.tokenType != TypeModel.NFT &&
            result.symbol != null &&
            result.symbol.isNotEmpty) {
          try {
            var t = sortPriceData
                .where((e) =>
                    e['symbol'].toString().toLowerCase() ==
                    result.symbol.toLowerCase())
                .toList()[0];
            result.price = t['currentPrice'].toString();
          } catch (e) {}
        }
        var cData = CommonFunction.allTokens[result.symbol];
        if (cData != null) {
          result.dexContractAddress = cData['dexContractAddress'];
          result.type = cData['type'];
          result.tokenId = cData['tokenId'] ?? 0;
        } else {
          if (t != null)
            result.type = t['type'] == "fa2" ? TOKEN_TYPE.FA2 : TOKEN_TYPE.FA1;
          else
            result.type = TOKEN_TYPE.FA2;
        }
        if (result.tokenType == TypeModel.TOKEN &&
            double.parse(result.balance) > 0.0)
          _tokenXtzv += ((double.parse(result.balance) * 1000000).round() *
                  double.parse(result.price))
              .round();
        return result;
      }).toList();
      var token = data
          .where((e) =>
              e.tokenType == TypeModel.TOKEN && double.parse(e.balance) > 0.0)
          .toList();

      data.sort(
          (a, b) => double.parse(b.balance).compareTo(double.parse(a.balance)));
      return _tokenXtzv;
    }
  }
}
