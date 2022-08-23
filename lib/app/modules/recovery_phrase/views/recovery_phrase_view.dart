import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/recovery_phrase/views/recovery_phrase.dart';

import '../controllers/recovery_phrase_controller.dart';

class RecoveryPhraseView extends GetView<RecoveryPhraseController> {
  @override
  Widget build(BuildContext context) {
    // var views = [
    //   RecoveryPhraseDetailView(controller: controller),
    //   RecoveryPhrase(controller: controller)
    // ];
    return Scaffold(
      body: RecoveryPhrase(controller: controller),
    );
  }
}
