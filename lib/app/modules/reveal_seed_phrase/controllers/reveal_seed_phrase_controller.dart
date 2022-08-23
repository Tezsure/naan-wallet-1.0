import 'dart:async';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

class RevealSeedPhraseController extends GetxController {
  var recoveryPhrase = [].obs;
  var privateKey = "".obs;
  var derivationPath = "".obs;
  var storage = StorageModel().obs;
  var closeTime = 30.obs;
  Timer timer;

  @override
  Future<void> onInit() async {
    super.onInit();
    storage.value = await StorageUtils().getStorage();
    privateKey.value = storage.value.accounts[storage.value.provider]
        [storage.value.currentAccountIndex]['secretKey'];
    recoveryPhrase.value = storage
        .value
        .accounts[storage.value.provider][storage.value.currentAccountIndex]
            ["seed"]
        .split(" ");
    derivationPath.value = storage.value.accounts[storage.value.provider]
        [storage.value.currentAccountIndex]['derivationPath'];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    timer.cancel();
  }
}
