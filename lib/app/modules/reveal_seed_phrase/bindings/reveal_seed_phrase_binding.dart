import 'package:get/get.dart';

import '../controllers/reveal_seed_phrase_controller.dart';

class RevealSeedPhraseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RevealSeedPhraseController>(
      () => RevealSeedPhraseController(),
    );
  }
}
