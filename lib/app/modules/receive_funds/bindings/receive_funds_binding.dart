import 'package:get/get.dart';

import '../controllers/receive_funds_controller.dart';

class ReceiveFundsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiveFundsController>(
      () => ReceiveFundsController(),
    );
  }
}
