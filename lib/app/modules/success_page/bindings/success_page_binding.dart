import 'package:get/get.dart';

import '../controllers/success_page_controller.dart';

class SuccessPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuccessPageController>(
      () => SuccessPageController(),
    );
  }
}
