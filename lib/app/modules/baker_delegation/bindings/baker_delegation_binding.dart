import 'package:get/get.dart';

import '../controllers/baker_delegation_controller.dart';

class BakerDelegationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BakerDelegationController>(
      () => BakerDelegationController(),
    );
  }
}
