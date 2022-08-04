import 'package:get/get.dart';

class WalkthroughController extends GetxController {
  final index = 0.obs;
  var isBackedUp = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void pagechanged(i) => index.value = i;
}
