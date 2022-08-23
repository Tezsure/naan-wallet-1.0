import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/utils/apis_handler/http_helper.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

class BakerDelegationController extends GetxController {
  var bakerAddress = "".obs;
  var bakerAddressController = TextEditingController().obs;

  var tezsureBakerAddress = "";
  var storage = StorageModel();

  var isValidAddres = false.obs;

  var isDelegationLoading = false.obs;

  var bakerName = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    storage = await StorageUtils().getStorage();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void fetchBakerName() async {
    var response = await HttpHelper.performGetRequest("https://api.tzkt.io",
        "v1/accounts/${bakerAddressController.value.text}");
    if (response != null) {
      bakerName.value = response['alias'];
    } else {
      fetchBakerName();
      return;
    }
  }
}
