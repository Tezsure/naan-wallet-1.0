import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tezster_dart/helper/http_helper.dart' as http_helper;
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/modules/common/functions/isolate_process.dart';
import 'package:tezster_wallet/app/utils/apis_handler/http_helper.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_singleton.dart';
import 'package:tezster_wallet/models/tokens_model.dart';
import 'package:tezster_wallet/models/tzkt_txs_model.dart';

class DataHandlerController {
  Duration updateDuration = Duration(seconds: 15);
  var priceData = {};

  // instance logic
  static DataHandlerController _instance;
  factory DataHandlerController() =>
      DataHandlerController._instance ??= new DataHandlerController._();
  DataHandlerController._();

  // Account and rpc update and variable
  var accountAddress;
  DataHandlerController updateAccountAddress(String pkh) {
    DataHandlerController().accountAddress = pkh;
    restartTimerForNewAccount();
    // DataHandlerController().nftTokensModelsUpdate();
    return DataHandlerController();
  }

  var rpcUrl;
  DataHandlerController updaterpcUrl(String rpc) {
    DataHandlerController().rpcUrl = rpc;
    return DataHandlerController();
  }

  var provider;
  DataHandlerController updateProvider(String provider) {
    DataHandlerController().provider = provider;
    return DataHandlerController();
  }

  var tezsureApi;
  DataHandlerController updateTezsureApi(String tezsureApi) {
    DataHandlerController().tezsureApi = tezsureApi;
    return DataHandlerController();
  }

  // Data variables
  DataVariable xtzBalance = DataVariable<String>()..isUpdate = true;
  DataVariable dollarValue = DataVariable<double>()..isUpdate = true;
  DataVariable tzktTransactionModels = DataVariable<List<TzktTxsModel>>()
    ..isUpdate = true;

  DataVariable tokensModels = DataVariable<List<TokensModel>>()
    ..isUpdate = true;
  DataVariable tokenBalanceInXtz = DataVariable<int>();
  // DataVariable nftTokensModels = DataVariable<List<NFTToken>>();

  DataVariable currentTransactions = DataVariable<List<DataVariable>>()
    ..value = <DataVariable>[];

  //Isolates
  CommonIsolate xtzBalanceIsolate = CommonIsolate();
  CommonIsolate tzktTransactionModelsIsolate = CommonIsolate();
  CommonIsolate tokensModelsIsolate = CommonIsolate();
  // CommonIsolate nftTokensModelsIsolate = CommonIsolate();

  // local storage handle
  FlutterSecureStorage localStorage = new FlutterSecureStorage();

  // Timer
  Timer timer;

  restartTimerForNewAccount() async {
    String oldValue =
        await DataHandlerController().localStorage.read(key: "priceData");
    if (oldValue != null) {
      DataHandlerController().priceData = jsonDecode(oldValue);
      DataHandlerController().dollarValue.value =
          DataHandlerController().priceData['xtzusdValue'];
      updateTezToolPriceData();
    } else {
      await updateTezToolPriceData();
    }

    // First time update
    tzktTransactionModelsUpdate();
    xtzBalanceUpdate();
    tokensModelsUpdate();
  }

  startUpdates() async {
    String oldValue =
        await DataHandlerController().localStorage.read(key: "priceData");
    if (oldValue != null) {
      DataHandlerController().priceData = jsonDecode(oldValue);
      DataHandlerController().dollarValue.value =
          DataHandlerController().priceData['xtzusdValue'];
      updateTezToolPriceData();
    } else {
      await updateTezToolPriceData();
    }

    // First time update
    tzktTransactionModelsUpdate();
    xtzBalanceUpdate();
    tokensModelsUpdate();

    // Continuous updates
    DataHandlerController().timer =
        Timer.periodic(DataHandlerController().updateDuration, (_) async {
      updateTezToolPriceData();
      if (xtzBalance.isUpdate) xtzBalanceUpdate();
      if (tzktTransactionModels.isUpdate) tzktTransactionModelsUpdate();
      if (tokensModels.isUpdate) tokensModelsUpdate();
    });
  }

  updateTezToolPriceData() async {
    DataHandlerController().priceData =
        await http_helper.HttpHelper.performGetRequest(
      'https://api.teztools.io',
      'token/prices',
    );
    var xtzPriceResponse = await http_helper.HttpHelper.performGetRequest(
        "https://api.coingecko.com",
        "api/v3/simple/price?ids=tezos&vs_currencies=usd");

    var xtzPrice = xtzPriceResponse['tezos']['usd'].toString();

    DataHandlerController().priceData['xtzusdValue'] = double.parse(xtzPrice.toString());

    DataHandlerController().dollarValue.value =
        DataHandlerController().priceData['xtzusdValue'];
    await DataHandlerController().localStorage.write(
        key: "priceData", value: jsonEncode(DataHandlerController().priceData));
  }

  Future<void> xtzBalanceUpdate() async {
    // kill isolate if it's running
    // if (xtzBalance.isBusy) {
    //   xtzBalance.isBusy = false;
    //   xtzBalanceIsolate.stop();
    //   // print("Killed xtz balance");
    // }

    // Sending saved data into callback for first time
    if (DataHandlerController().xtzBalance.value == null) {
      String oldValue =
          await DataHandlerController().localStorage.read(key: "xtz_balance");
      if (oldValue != null) DataHandlerController().xtzBalance.value = oldValue;
    }

    xtzBalance.isBusy = true;
    xtzBalanceIsolate.init(updateXtzBalance, (data) async {
      DataHandlerController().xtzBalance.value = data ?? '0';
      await DataHandlerController().localStorage.write(
          key: "xtz_balance", value: DataHandlerController().xtzBalance.value);
      xtzBalance.isBusy = false;
    }, arguments: [
      DataHandlerController().accountAddress,
      DataHandlerController().rpcUrl,
      DataHandlerController().localStorage,
    ], debugName: "xtz_balance_isolate");
  }

  // xtz balance update method
  static Future<void> updateXtzBalance(List<Object> arguments) async {
    var bal;
    try {
      TezsterDart.getBalance(arguments[1], arguments[2]).then((value) {
        bal = value ?? '0';
        (arguments[0] as SendPort).send(bal);
      }).timeout(Duration(seconds: 5));
    } catch (e) {}
  }

  Future<void> tzktTransactionModelsUpdate() async {
    // kill isolate if it's running
    if (tzktTransactionModels.isBusy) {
      tzktTransactionModels.isBusy = false;
      tzktTransactionModelsIsolate.stop();
      // print("Killed xtz tx");
    }

    // Sending saved data into callback for first time
    if (DataHandlerController().tzktTransactionModels.value == null) {
      String oldValue =
          await DataHandlerController().localStorage.read(key: "tzkt_txs");
      if (oldValue != null)
        DataHandlerController().tzktTransactionModels.value =
            jsonDecode(oldValue)
                .map<TzktTxsModel>((e) => TzktTxsModel.fromJson(
                    e, DataHandlerController().accountAddress))
                .toList();
    }
    tzktTransactionModels.isBusy = true;
    tzktTransactionModelsIsolate.init(updatetzktTransactionModels,
        (data) async {
      DataHandlerController().tzktTransactionModels.value =
          data ?? <TzktTxsModel>[];
      await DataHandlerController().localStorage.write(
          key: "tzkt_txs",
          value:
              jsonEncode(DataHandlerController().tzktTransactionModels.value));
      tzktTransactionModels.isBusy = false;
    }, arguments: [
      DataHandlerController().accountAddress,
      DataHandlerController().provider,
      DataHandlerController().tezsureApi,
      StorageSingleton().currentSelectedNetwork,
    ], debugName: "tzkt_transaction_models_isolate");
  }

  // xtz balance update method
  static Future<void> updatetzktTransactionModels(
      List<Object> arguments) async {
    var currentSelectedNetwork = arguments[4] as String;
    var lastId = '';
    var lastData = 0;
    var data = <TzktTxsModel>[];
    do {
      var tempData = await HttpHelper.performGetRequest(
          currentSelectedNetwork.isEmpty
              ? 'https://api.tzkt.io'
              : 'https://api.$currentSelectedNetwork.tzkt.io',
          "v1/accounts/${arguments[1]}/operations?type=transaction&limit=999&sort=1&quote=usd&lastId=$lastId");
      if (tempData.length != 0) {
        tempData = tempData
            .where((e) =>
                e['parameters'] == null ||
                e['parameters']['value'].length == 0 ||
                jsonDecode(e['parameters'])['entrypoint'] == 'transfer')
            .toList();
        tempData = tempData
            .map<TzktTxsModel>((e) => TzktTxsModel.fromJson(e, arguments[1]))
            .toList();
        data.addAll(tempData);
        lastId = tempData.last.id.toString();
        lastData = data.length;
      } else {
        lastData = 0;
      }
    } while (lastData != 0);
    (arguments[0] as SendPort).send(data);
  }

  // tokens balances update method
  Future<void> tokensModelsUpdate() async {
    // kill isolate if it's running
    if (tokensModels.isBusy) {
      tokensModels.isBusy = false;
      tokensModelsIsolate.stop();
      // print("Killed token");
    }

    // Sending saved data into callback for first time
    if (DataHandlerController().tokensModels.value == null) {
      String oldValue = await DataHandlerController()
          .localStorage
          .read(key: "tokens_balance");
      if (oldValue != null) {
        var _tokenXtzv = 0;
        var result = jsonDecode(oldValue).map<TokensModel>((e) {
          var model = TokensModel.fromJsonBase(e);
          _tokenXtzv += ((double.parse(model.balance) * 1000000).round() *
                  double.parse(model.price))
              .round();
          return model;
        }).toList();

        DataHandlerController().tokensModels.value = result
            .where((TokensModel element) =>
                element.name != null &&
                element.name.isNotEmpty &&
                element.symbol != null &&
                element.symbol.isNotEmpty &&
                element.balance != "0.0" &&
                !element.balance.toString().startsWith('0.000000'))
            .toList();
        tokenBalanceInXtz.value = _tokenXtzv;
      }
    }
    tokensModels.isBusy = true;
    tokensModelsIsolate.init(updateTtokensModels, (data) async {
      var result = (data[0] as List<TokensModel>) ?? <TokensModel>[];
      DataHandlerController().tokensModels.value = result
          .where((TokensModel element) =>
              element.name != null &&
              element.name.isNotEmpty &&
              element.symbol != null &&
              element.symbol.isNotEmpty &&
              element.balance != "0.0" &&
              !element.balance.toString().startsWith('0.000000'))
          .toList();
      tokenBalanceInXtz.value = data[1] as int;
      await DataHandlerController().localStorage.write(
          key: "tokens_balance",
          value: jsonEncode(DataHandlerController().tokensModels.value));
      tokensModels.isBusy = false;
    }, arguments: [
      DataHandlerController().accountAddress,
      DataHandlerController().provider,
      DataHandlerController().priceData,
    ], debugName: "tokens_balance_models_isolate");
  }

  // &token.metadata.tags.null=true&token.metadata.creators.null=true&token.metadata.artifactUri.null=true
  static Future<void> updateTtokensModels(List<Object> arguments) async {
    SendPort sendPort = arguments[0] as SendPort;
    String accountAddress = arguments[1] as String;
    String provider = arguments[2] as String;
    Map<dynamic, dynamic> priceData = arguments[3] as Map<dynamic, dynamic>;

    var tokensData = await HttpHelper.performGetRequest('https://api.tzkt.io',
        'v1/tokens/balances?limit=999&account=$accountAddress&token.metadata.tags.null=true&token.metadata.creators.null=true&token.metadata.artifactUri.null=true');

    if (tokensData.length > 0) {
      var _tokenXtzv = 0;

      var sortPriceData = priceData['contracts'].toList();
      var data = tokensData.map<TokensModel>((e) {
        var result = TokensModel.fromJson(e);
        var t;
        if (result.tokenType != TypeModel.NFT &&
            result.symbol != null &&
            result.symbol.isNotEmpty) {
          try {
            t = sortPriceData
                .where((e) =>
                    e['symbol'].toString().toLowerCase() ==
                    result.symbol.toLowerCase())
                .toList()[0];
            if (t == null) {
              t = sortPriceData
                  .where(
                    (e) =>
                        e['contract'].toString() == result.contract &&
                        e['tokenId'] == result.tokenId,
                  )
                  .toList()[0];
            }
            result.price = t['currentPrice'].toString();
          } catch (e) {}
        }
        if (t != null)
          result.type = t['type'] == "fa2" ? TOKEN_TYPE.FA2 : TOKEN_TYPE.FA1;
        else
          result.type = null;
        // }
        if (result.tokenType == TypeModel.TOKEN &&
            double.parse(result.balance) > 0.0)
          _tokenXtzv += ((double.parse(result.balance) * 1000000).round() *
                  double.parse(result.price))
              .round();
        return result;
      }).toList();
      var token = data
          .where((e) => double.parse(e.balance) > 0.0 && e.type != null)
          .toList();
      // var nft = data.where((e) => e.tokenType == TypeModel.NFT).toList();

      data.sort(
          (a, b) => double.parse(b.balance).compareTo(double.parse(a.balance)));
      sendPort.send([token, _tokenXtzv]);
    } else {
      sendPort.send([<TokensModel>[], 0]);
    }
  }

  /// send xtz tx using isolate
  createXTZTransaction([
    keyStore,
    rpc,
    tezsureApi,
    receiver,
    amount,
    network,
    usd,
    symbol,
  ]) async {
    DataVariable statusVariable = DataVariable<Map<String, String>>();
    statusVariable.value = <String, String>{
      "receiver": receiver,
      "status": "Pending",
      "amount": symbol,
    };

    DataHandlerController().currentTransactions.value.add(statusVariable);
    DataHandlerController().currentTransactions.value =
        DataHandlerController().currentTransactions.value;
    CommonIsolate isolate = CommonIsolate();
    await isolate.init(sendXTZTransaction, (data) {
      statusVariable.value = <String, String>{
        "receiver": receiver,
        "status": data,
        "amount": symbol,
      };
    },
        arguments: [
          keyStore,
          rpc,
          tezsureApi,
          receiver,
          amount,
          network,
          usd,
        ],
        debugName:
            "xtz_tx_isolate${DataHandlerController().currentTransactions.value.length}");
  }

  static Future<void> sendXTZTransaction(List<Object> arguments) async {
    SendPort sendPort = arguments[0] as SendPort;
    sendPort.send("Pending");
    var keyStore = KeyStoreModel(
      publicKeyHash: (arguments[1] as Map)['publicKeyHash'],
      publicKey: (arguments[1] as Map)['publicKey'],
      secretKey: (arguments[1] as Map)['secretKey'],
    );
    var rpc = arguments[2];
    // var tezsureApi = arguments[3];
    var receiver = arguments[4];
    var amount = arguments[5];
    // var network = arguments[6];
    // var usd = arguments[7];
    var transactionSigner = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));
    var transactionResult = await TezsterDart.sendTransactionOperation(
      rpc,
      transactionSigner,
      keyStore,
      receiver,
      (double.parse(amount) * 1000000).ceil(),
      1500,
    );

    print("=============> $transactionResult");

    var status = await TezsterDart.getOperationStatus(
        rpc, transactionResult['operationGroupID'].replaceAll('\n', '').trim());
    if (status == 'applied') {
      sendPort.send("Confirmed");
    } else {
      sendPort.send("Failed");
    }

    // var errors = [];
    // while (errors.isEmpty) {
    //   var res = await HttpHelper.performGetRequest("https://api.tzkt.io",
    //       "v1/operations/${transactionResult['operationGroupID'].replaceAll('\n', '').trim()}");
    //   for (var i = 0; i < res.length; i++) {
    //     if (res[i].containsKey('errors') && res[i]['errors'].length > 0) {
    //       errors.addAll(res[i]['errors']);
    //       sendPort.send("Failed");
    //       break;
    //     }
    //   }
    //   if (errors.length > 0) break;
    //   if (res.length > 0 && res[res.length - 1]['status'] == "applied") {
    //     sendPort.send("Confirmed");
    //     break;
    //   }
    //   await Future.delayed(Duration(seconds: 3));
    // }
  }

  /// send token tx using isolate
  createTokenTransaction(
    opHash,
    amount,
    receiver,
    rpc,
  ) async {
    DataVariable statusVariable = DataVariable<Map<String, String>>();
    statusVariable.value = <String, String>{
      "receiver": receiver,
      "status": "Pending",
      "amount": amount.toString(),
    };

    DataHandlerController().currentTransactions.value.add(statusVariable);
    DataHandlerController().currentTransactions.value =
        DataHandlerController().currentTransactions.value;
    CommonIsolate isolate = CommonIsolate();
    await isolate.init(sendTokenTransaction, (data) {
      statusVariable.value = <String, String>{
        "receiver": receiver,
        "status": data,
        "amount": amount,
      };
    },
        arguments: [
          opHash,
          rpc,
        ],
        debugName:
            "xtz_tx_isolate${DataHandlerController().currentTransactions.value.length}");
  }

  static Future<void> sendTokenTransaction(List<Object> arguments) async {
    SendPort sendPort = arguments[0] as SendPort;
    sendPort.send("Pending");
    var opHash = arguments[1] as String;
    var rpc = arguments[2] as String;
    var status = await TezsterDart.getOperationStatus(
        rpc, opHash.replaceAll('\n', '').trim());
    if (status == 'applied') {
      sendPort.send("Confirmed");
    } else {
      sendPort.send("Failed");
    }

    // var errors = [];
    // while (errors.isEmpty) {
    //   var res = await HttpHelper.performGetRequest(
    //       "https://api.tzkt.io", "v1/operations/$opHash");
    //   for (var i = 0; i < res.length; i++) {
    //     if (res[i].containsKey('errors') && res[i]['errors'].length > 0) {
    //       errors.addAll(res[i]['errors']);
    //       sendPort.send("Failed");
    //       break;
    //     }
    //   }
    //   if (errors.length > 0) break;
    //   if (res.length > 0 && res[res.length - 1]['status'] == "applied") {
    //     sendPort.send("Confirmed");
    //     break;
    //   }
    //   await Future.delayed(Duration(seconds: 3));
    // }
  }

  createDelegationTransaction(keyStore, rpc, tezsureBakerAddress) async {
    DataVariable statusVariable = DataVariable<Map<String, String>>();
    statusVariable.value = <String, String>{
      "receiver": tezsureBakerAddress,
      "status": "Pending",
      "amount": "Delegation",
    };

    DataHandlerController().currentTransactions.value.add(statusVariable);
    DataHandlerController().currentTransactions.value =
        DataHandlerController().currentTransactions.value;

    CommonIsolate isolate = CommonIsolate();
    await isolate.init(sendDelegationTransaction, (data) {
      statusVariable.value = <String, String>{
        "receiver": tezsureBakerAddress,
        "status": data,
        "amount": "Delegation",
      };
    },
        arguments: [
          keyStore,
          rpc,
          tezsureBakerAddress,
        ],
        debugName:
            "xtz_tx_isolate${DataHandlerController().currentTransactions.value.length}");
  }

  static Future<void> sendDelegationTransaction(List<Object> arguments) async {
    SendPort sendPort = arguments[0] as SendPort;
    sendPort.send("Pending");
    var keyStore = KeyStoreModel(
      publicKeyHash: (arguments[1] as Map)['publicKeyHash'],
      publicKey: (arguments[1] as Map)['publicKey'],
      secretKey: (arguments[1] as Map)['secretKey'],
    );
    var rpc = arguments[2] as String;
    var bakerAddress = arguments[3] as String;

    var signer = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));

    var transactionResult = await TezsterDart.sendDelegationOperation(
      rpc,
      signer,
      keyStore,
      bakerAddress,
      10000,
    );
    var status = await TezsterDart.getOperationStatus(
        rpc, transactionResult['operationGroupID'].replaceAll('\n', '').trim());
    if (status == 'applied') {
      sendPort.send("Confirmed");
    } else {
      sendPort.send("Failed");
    }
    // var errors = [];
    // while (errors.isEmpty) {
    //   var res = await HttpHelper.performGetRequest("https://api.tzkt.io",
    //       "v1/operations/${transactionResult['operationGroupID'].replaceAll('\n', '').trim()}");
    //   for (var i = 0; i < res.length; i++) {
    //     if (res[i].containsKey('errors') && res[i]['errors'].length > 0) {
    //       errors.addAll(res[i]['errors']);
    //       sendPort.send("Failed");
    //       break;
    //     }
    //   }
    //   if (errors.length > 0) break;
    //   if (res.length > 0 && res[res.length - 1]['status'] == "applied") {
    //     sendPort.send("Confirmed");
    //     break;
    //   }
    //   await Future.delayed(Duration(seconds: 3));
    // }
  }

  createBeaconTransaction(
    opHash,
    rpc,
    symbol,
  ) async {
    DataVariable statusVariable = DataVariable<Map<String, String>>();
    statusVariable.value = <String, String>{
      "receiver": symbol,
      "status": "Pending",
      "amount": symbol,
    };

    DataHandlerController().currentTransactions.value.add(statusVariable);
    DataHandlerController().currentTransactions.value =
        DataHandlerController().currentTransactions.value;
    CommonIsolate isolate = CommonIsolate();
    await isolate.init(sendBeaconTransaction, (data) async {
      statusVariable.value = <String, String>{
        "receiver": symbol,
        "status": data,
        "amount": symbol,
      };
    },
        arguments: [opHash, rpc],
        debugName:
            "beacon_tx_isolate${DataHandlerController().currentTransactions.value.length}");
  }

  static sendBeaconTransaction(List<Object> arguments) async {
    SendPort sendPort = arguments[0] as SendPort;
    sendPort.send("Pending");
    var opHash = arguments[1] as String;
    var rpc = arguments[2] as String;
    // var storage = await StorageUtils().getStorage();
    var status = await TezsterDart.getOperationStatus(
        rpc, opHash.replaceAll('\n', '').trim());
    if (status == 'applied') {
      sendPort.send("Confirmed");
    } else {
      sendPort.send("Failed");
    }
    // var errors = [];
    // while (errors.isEmpty) {
    //   var res = await HttpHelper.performGetRequest(
    //       "https://api.tzkt.io", "v1/operations/$opHash");
    //   for (var i = 0; i < res.length; i++) {
    //     if (res[i].containsKey('errors') && res[i]['errors'].length > 0) {
    //       errors.addAll(res[i]['errors']);
    //       sendPort.send("Failed");
    //       break;
    //     }
    //   }
    //   if (errors.length > 0) break;
    //   if (res.length > 0 && res[res.length - 61]['status'] == "applied") {
    //     sendPort.send("Confirmed");
    //     break;
    //   }
    //   await Future.delayed(Duration(seconds: 3));
    // }
  }
}

class DataVariable<T> {
  List<dynamic> callbacks = [];
  List<dynamic> registerVariabls = [];

  T _value;

  bool isUpdate = false;
  bool isBusy = false;

  get value => _value;

  set value(value) {
    // if (value == _value) return;
    _value = value;
    for (var i = 0; i < callbacks.length; i++) callbacks[i](_value);
    for (var i = 0; i < registerVariabls.length; i++)
      registerVariabls[i].value = _value;
  }

  void registerCallback(callback) {
    if (value != null) callback(value);
    callbacks.add(callback);
  }

  void registerVariable(rxVar) {
    if (value != null) rxVar.value = value;
    registerVariabls.add(rxVar);
  }
}
