import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/views/beacon_confirm_transaction/beacon_confirm_tracsaction_view.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/views/beacon_permission/beacon_permission_view.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/views/beacon_permission/sign_payload.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/models/beacon_permission_model.dart';

import '../controllers/beacon_form_controller.dart';

class BeaconFormView extends GetView<BeaconFormController> {
  @override
  Widget build(BuildContext context) {
    if (controller.argsModel.value.id == null)
      controller.argsModel.value =
          ModalRoute.of(context).settings.arguments as BeaconPermissionModel;

    List<Widget> _formWidgets = [
      BeaconPermissionView(controller: controller),
      SignPayload(controller: controller),
      BeaconConfirmTransactionView(controller: controller)
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() => _formWidgets[
          controller.argsModel.value.operationDetails == null
              ? controller.argsModel.value.payload == null ||
                      controller.argsModel.value.payload.isEmpty
                  ? 0
                  : 1
              : 2]),
    );
  }
}
