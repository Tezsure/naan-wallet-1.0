import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

Future<String> getValidAccountName() async {
  StorageModel _storage = await StorageUtils().getStorage();
  int accountNumber = 1;
  bool isNamePresent;
  Map<String, bool> accountNameMap = {};
  _storage.accounts[_storage.provider].forEach((e) {
    accountNameMap[e['name']] = true;
  });
  do {
    isNamePresent = false;
    if (accountNameMap.containsKey("Account $accountNumber")) {
      isNamePresent = true;
      accountNumber++;
    }
  } while (isNamePresent);
  return "Account $accountNumber";
}
