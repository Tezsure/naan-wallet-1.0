import 'package:get/get.dart';

import '../controllers/send_assets_controller.dart';

class SendAssetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendAssetsController>(
      () => SendAssetsController(),
    );
  }
}
