import 'package:get/get.dart';

import '../controllers/recover_wallet_controller.dart';

class RecoverWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecoverWalletController>(
      () => RecoverWalletController(),
    );
  }
}
