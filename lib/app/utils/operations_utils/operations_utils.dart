import 'dart:convert';

import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/utils/apis_handler/http_helper.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/models/tokens_model.dart';

class OperationUtils {
  // m/44'/1729'/<account_index>'/0'
  // isNaanWallet = 0/1

  createNewWalletProccess([isTest = false, name = "Account 1"]) async {
    StorageModel _storgeModel =
        isTest ? StorageModel() : await StorageUtils().getStorage();

    // check if naan wallet already exists
    var accounts = _storgeModel.accounts[_storgeModel.provider] ?? [];
    var _mnemonic = "";
    var newDerivationPath = '';
    var naanAccounts = accounts
        .where((element) => element.containsKey('isNaanWallet') ? true : false)
        .toList();
    if (naanAccounts.isNotEmpty) {
      var lastAccount = naanAccounts.last;
      var lastAccountIndex = lastAccount['derivationPath']
          .split('/')[lastAccount['derivationPath'].split('/').length - 2];
      newDerivationPath =
          "m/44'/1729'/${int.parse(lastAccountIndex.replaceAll("'", "")) + 1}'/0'";
      _mnemonic = lastAccount['seed'];
    } else {
      _mnemonic = TezsterDart.generateMnemonic(strength: 128);
      newDerivationPath = "m/44'/1729'/0'/0'";
    }

    var _identity = await TezsterDart.restoreIdentityFromDerivationPath(
        newDerivationPath, _mnemonic);
    // String _mnemonic = TezsterDart.generateMnemonic(strength: 128);
    // var _identity = await TezsterDart.getKeysFromMnemonic(mnemonic: _mnemonic);
    var account = {
      "seed": _mnemonic,
      "publicKey": _identity[1],
      "secretKey": _identity[0],
      "publicKeyHash": _identity[2],
      "password": "",
      "name": name,
      "derivationPath": newDerivationPath,
      "isNaanWallet": true,
    };
    if (!isTest) {
      var keys = _storgeModel.accounts.keys.toList();
      keys.forEach((element) {
        _storgeModel.accounts[element].add(account);
        _storgeModel.currentAccountIndex =
            _storgeModel.accounts[element].length - 1;
      });
      tempModel = _storgeModel;
      await StorageUtils().postStorage(tempModel, true);
    } else {
      _storgeModel =
          StorageModel().fromJson(jsonDecode(jsonEncode(StorageModel())));
      _storgeModel.accounts[_storgeModel.provider].add(account);
    }
    if (!isTest)
      FireAnalytics().logEvent("create_new_wallet", addTz1: true, param: {
        "tz1": account['publicKeyHash'],
      });
    return account;
  }

  sendTransaction(
      [keyStore, rpc, tezsureApi, receiver, amount, network, usd]) async {
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
    print(transactionResult);
    //operationGroupID
    if (transactionResult['operationGroupID'] != '') {
      await HttpHelper.performPostRequest(
          tezsureApi, 'v1/tezsure/transactions/post', {
        "publicKeyHash": keyStore.publicKeyHash,
        "receiver": receiver,
        "timestamp": DateTime.now().toString(),
        "operationHash": transactionResult['operationGroupID']
            .toString()
            .replaceAll('\n', ''),
        "networkId": network == 'mainnet' ? 1 : 0,
        "status": "pending",
        "label": "Tezos transfer",
        "amount": amount,
        "usd": usd,
      });
      // print(result);
    }

    return transactionResult['operationGroupID'];
  }

  sendTokenTransaction(
      [keyStore,
      rpc,
      tezsureApi,
      receiver,
      contractAddress,
      amount,
      decimals,
      network,
      TokensModel token]) async {
    var transactionSigner = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));
    amount = ((amount *
            double.parse(1.toStringAsFixed(decimals ?? 0).replaceAll('.', ''))))
        .toInt();
    var parameters = token.type == TOKEN_TYPE.FA1
        ? """(Pair "${keyStore.publicKeyHash}" (Pair "$receiver" $amount))"""
        : """{Pair "${keyStore.publicKeyHash}" {Pair "$receiver" (Pair ${token.tokenId ?? 0} $amount)}}""";
    var transactionResult = await TezsterDart.sendContractInvocationOperation(
      rpc,
      transactionSigner,
      keyStore,
      [contractAddress],
      [0],
      120000,
      1000,
      100000,
      ['transfer'],
      [parameters],
      codeFormat: TezosParameterFormat.Micheline,
    );
    //operationGroupID
    if (transactionResult['operationGroupID'] != '') {
      var result = await HttpHelper.performPostRequest(
        tezsureApi, 'v1/tezsure/tokens/post',
        {
          "operationHash": transactionResult['operationGroupID']
              .toString()
              .replaceAll('\n', ''),
          "label": "token transfer",
          "status": "pending",
          "receiver": receiver,
          "sender": keyStore.publicKeyHash,
          "publicKeyHash": keyStore.publicKeyHash,
          "amount": amount,
          "timestamp": DateTime.now().toString(),
          "decimals": token.decimals,
          "contractAddress": token.contract,
          "networkId": network == 'mainnet' ? 1 : 0,
        },

        //     {
        //   "publicKeyHash": keyStore.publicKeyHash,
        //   // "tokenContractAddress": keyStore.publicKeyHash,
        //   "operationHash": transactionResult['operationGroupID']
        //       .toString()
        //       .replaceAll('\n', ''),
        //   "networkId": network == 'mainnet' ? 1 : 0,
        //   "status": "success",
        //   "label": "Tezos token transfer",
        //   "tokenName": token.symbol,
        // }
      );
      // print(result);
    }

    return transactionResult['operationGroupID'];
  }

  delegatBaker([keyStore, rpc, tezsureBakerAddress]) async {
    var signer = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));

    var result = await TezsterDart.sendDelegationOperation(
      rpc,
      signer,
      keyStore,
      tezsureBakerAddress,
      10000,
    );
    return result;
  }
}
