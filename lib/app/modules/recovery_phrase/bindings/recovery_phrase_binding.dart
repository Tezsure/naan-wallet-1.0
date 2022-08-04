import 'package:get/get.dart';

import '../controllers/recovery_phrase_controller.dart';

class RecoveryPhraseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecoveryPhraseController>(
      () => RecoveryPhraseController(),
    );
  }
}
