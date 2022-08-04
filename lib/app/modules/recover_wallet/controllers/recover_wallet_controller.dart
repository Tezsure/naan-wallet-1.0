import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RecoverWalletController extends GetxController {
  final viewController = 0.obs;

  var mnemonicController = TextEditingController().obs;
  var derivationPathController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var privateKeyController = TextEditingController().obs;

  var derrivationIndex = 1.obs;

  var isMnemonicValid = false.obs;
  var isPrivateKeyValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (mnemonicController.value.text.length > 0)
      isMnemonicValid.value = true;
    else
      isMnemonicValid.value = false;

    if (privateKeyController.value.text.length > 0)
      isPrivateKeyValid.value = true;
    else
      isPrivateKeyValid.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
