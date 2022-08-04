import 'package:get/get.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

class ReceiveFundsController extends GetxController {
  StorageModel storage;
  var phHash = "".obs;
  var name = "".obs;

  @override
  void onInit() {
    super.onInit();
    StorageUtils().getStorage().then((value) {
      storage = value;
      phHash.value = value.accounts[value.provider][storage.currentAccountIndex]
          ['publicKeyHash'];
      name.value = value.accounts[value.provider][storage.currentAccountIndex]
          ['name'];
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
