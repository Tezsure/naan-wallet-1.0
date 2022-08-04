import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_gql/simple_gql.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/utils/apis_handler/http_helper.dart';
import 'package:tezster_wallet/app/utils/operations_utils/operations_utils.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/models/nft_token_model.dart';
import 'package:tezster_wallet/models/tokens_model.dart';
import 'package:tezster_wallet/models/tzkt_txs_model.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  test('Create new wallet', () async {
    StorageModel result = await OperationUtils().createNewWalletProccess(true);
    print(result.accounts[result.provider][0]);
    expect(result.accounts[result.provider].length != 0, true);
  });

  test('Send Transaction', () async {
    var keyStore = KeyStoreModel(
      publicKey: 'edpkv43KLM3mUsJdDqa8qUuumq3f5GSxHLATxfBXun4MAVWSRWLLC3',
      secretKey:
          'edskS6CCCwhLj4MT4LuEt4fJ6QoPdwPAhe2YfpkvQAU3ed1TV58gh98DcyFBL57pT9vsVCVBNgaYHaKuqiN7Uej5sRvyxjCmjJ',
      publicKeyHash: 'tz1aTFkFvJ2WvYcENr3xtCpCZUu6hf6STSfs',
    );

    var storage =
        StorageModel().fromJson(jsonDecode(jsonEncode(StorageModel())));

    var transactionResult = await OperationUtils().sendTransaction(
      keyStore,
      StorageUtils.rpc[storage.provider],
      storage.tezsureApi,
      "tz1KhnTgwoRRALBX6vRHRnydDGSBFsWtcJxc",
      '1.5',
    );
    print(transactionResult);
    expect(transactionResult != null, true);
  });

  test('Baker Delegation', () async {
    var keyStore = KeyStoreModel(
      publicKey: 'edpkv43KLM3mUsJdDqa8qUuumq3f5GSxHLATxfBXun4MAVWSRWLLC3',
      secretKey:
          'edskS6CCCwhLj4MT4LuEt4fJ6QoPdwPAhe2YfpkvQAU3ed1TV58gh98DcyFBL57pT9vsVCVBNgaYHaKuqiN7Uej5sRvyxjCmjJ',
      publicKeyHash: 'tz1aTFkFvJ2WvYcENr3xtCpCZUu6hf6STSfs',
    );

    var storage =
        StorageModel().fromJson(jsonDecode(jsonEncode(StorageModel())));

    var transactionResult = await OperationUtils().delegatBaker(
      keyStore,
      StorageUtils.rpc[storage.provider],
      'tz1aCnK45NP7CG31WMkUTP3d3V486mXwzZZt',
    );
    print(transactionResult);
    expect(transactionResult != null, true);
  });

  // https://github.com/Cryptonomic/ConseilJS/blob/fb718632d6ce47718dad5aa77c67fc514afaa0b9/src/chain/tezos/contracts/tzip12/MultiAssetTokenHelper.ts#L235

  test('Get All Tzkt Txs', () async {
    String currentAccountHash = "tz1USmQMoNCUUyk4BfeEGUyZRK2Bcc9zoK8C";
    var lastId = '';
    var lastData = 0;
    do {
      var data = await HttpHelper.performGetRequest('https://api.tzkt.io',
          "v1/accounts/$currentAccountHash/operations?type=transaction&limit=999&sort=1&quote=usd&lastId=$lastId");
      if (data.length != 0) {
        data = data
            .where((e) =>
                e['parameters'] == null ||
                jsonDecode(e['parameters'])['entrypoint'] == 'transfer')
            .toList();
        data.map<TzktTxsModel>((e) => TzktTxsModel.fromJson(e)).toList();
        lastId = data.last['id'].toString();
        lastData = data.length;
      } else {
        lastData = 0;
      }
      print(lastId);
    } while (lastData != 0);
  });

  // test('Sign Test', () {
  //   var data = jsonDecode(
  //       """{"appMetadata":{"name":"objkt.com","senderId":"4sTE15s3ujxq"},"blockchainIdentifier":"tezos","id":"78b44c35-8df6-b4d1-b328-131f0a6cd5f0","origin":{"id":"e709a0461c7538b9a0abb94980ef73dc7736db476e6427c9667b7bcd2bb571b6"},"payload":"05010000007d54657a6f73205369676e6564204d6573736167653a20436f6e6669726d696e67206d79206964656e7469747920617320747a3158504171617861656e74706f38653239355737686a7236393673713958487a486a206f6e206f626a6b742e636f6d20617420323032312d31312d33305430373a35303a30312e3835325a","senderId":"4sTE15s3ujxq","signingType":"Micheline","sourceAddress":"tz1XPAqaxaentpo8e295W7hjr696sq9XHzHj","version":"2"}""");

  // });
}
