import 'package:get/get.dart';

import '../controllers/beacon_form_controller.dart';

class BeaconPermissonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeaconFormController>(
      () => BeaconFormController(),
    );
  }
}
