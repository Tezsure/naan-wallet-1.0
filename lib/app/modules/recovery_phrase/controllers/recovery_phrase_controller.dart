import 'package:get/get.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

class RecoveryPhraseController extends GetxController {

  /// 0 => Recovery Phrase Detail screen
  ///
  /// 1 => Recovery Phrase screen
  final viewIndex = 0.obs;
  final isCheckBoxChecked = false.obs;
  var recoveryPhrase = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    // var model = await StorageUtils().getStorage();
    recoveryPhrase =
        tempModel.accounts[tempModel.provider][0]["seed"].split(" ");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
