import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/utils/operations_utils/operations_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var wallet;

  test("Create new wallet", () async {
    wallet = await OperationUtils().createNewWalletProccess(true);
    expect(wallet['seed'], isNotEmpty);
    expect(wallet['publicKey'], isNotEmpty);
    expect(
        wallet['publicKeyHash'].isNotEmpty &&
            wallet['publicKeyHash'].toString().startsWith("tz1"),
        true);
    expect(wallet['secretKey'], isNotEmpty);
  });

  test('Recover wallet using secretKey', () {
    var sKeyWallet = TezsterDart.getKeysFromSecretKey(wallet['secretKey']);
    expect(sKeyWallet[1] == wallet['publicKey'], true);
    expect(sKeyWallet[2] == wallet['publicKeyHash'], true);
  });

  test('Recover wallet using mnemonic and derivation path', () async {
    var mdWallet = await TezsterDart.restoreIdentityFromDerivationPath(
        wallet['derivationPath'], wallet['seed']);
    expect(mdWallet[0] == wallet['secretKey'], true);
    expect(mdWallet[1] == wallet['publicKey'], true);
    expect(mdWallet[2] == wallet['publicKeyHash'], true);
  });

  test("Send xtz on ghost-net", () async {
    KeyStoreModel keyStore = KeyStoreModel(
      publicKeyHash: 'tz1YqR6TGzZgydiAZKBkJACko4Uzr7aK3Qi9',
      secretKey:
          'edskS6xj1n6LdRyFFbfaRLLPnPU4Q8P7odcJTFxxbtXbFhiJzFpJUXQuhYGoVK5bxYEk9CYjYeGYsLHp55hLMMsXCSPvimXV6d',
      publicKey: 'edpkuzQY9B8hcJuLpTkf2L41GQrQ7gYxfsBCHGa7NEAx7kbNbiNMSJ',
    );

    var signer = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));

    var server = 'https://rpc.tzkt.io/ghostnet';

    var result = await TezsterDart.sendTransactionOperation(
      server,
      signer,
      keyStore,
      wallet['publicKeyHash'],
      1,
      1500,
    );

    print(result['operationGroupID']);
    expect(true,
        result['operationGroupID'] != null && result['operationGroupID'] != '');
  });
}
