import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_dart/models/key_store_model.dart';
import 'package:tezster_wallet/app/data/data_handler_controller.dart';
import 'package:tezster_wallet/app/modules/baker_delegation/controllers/baker_delegation_controller.dart';
import 'package:tezster_wallet/app/modules/baker_delegation/views/baker_delegation_view.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_loading_animated_action_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';
import 'package:tezster_wallet/app/utils/operations_utils/operations_utils.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

class ConfirmDelegation extends StatefulWidget {
  final BakerDelegationController controller;
  final HomePageController homePageController;
  ConfirmDelegation(this.controller, this.homePageController);

  @override
  _ConfirmDelegationState createState() => _ConfirmDelegationState();
}

class _ConfirmDelegationState extends State<ConfirmDelegation> {
  @override
  void initState() {
    super.initState();
    widget.controller.fetchBakerName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Platform.isAndroid ? 60 : 80,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      backButton(context),
                    ],
                  ),
                  SizedBox(
                    height: 42,
                  ),
                  GradientText(
                    "Confirm Delegation",
                    gradient: gradientBackground,
                    textStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  infoUI(
                      info:
                          "Your funds are not locked or frozen and do not move anywhere. You can spend them at any time and without any delay. You are only delegating your baking rights."),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 82,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color(0xff1e1e1e),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Account:",
                              style: TextStyle(
                                color: Color(0xff8E8E95),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Image.asset(
                                "assets/wallet/XTZ_logo.png",
                                height: 26,
                                width: 26,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GradientText(
                                        "0 tez",
                                        gradient: gradientBackground,
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        r".00",
                                        style: TextStyle(
                                          color: Color(0xff8E8E95),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(0.04),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Fee: 0.000413 tez",
                                      style: TextStyle(
                                        color: Color(0xff8E8E95),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.08,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Delegeate:",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff8E8E95),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.05,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.homePageController.accoutnName.value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${widget.homePageController.accounts[widget.homePageController.storage.currentAccountIndex]['publicKeyHash']}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff8E8E95),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/wallet/gradient_arrow.png",
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "    Baker:    ",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff8E8E95),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.05,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => widget.controller.bakerName.value !=
                                              null &&
                                          widget.controller.bakerName.value
                                                  .length >
                                              0
                                      ? Text(
                                          widget.controller.bakerName.value,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                                Text(
                                  "${widget.controller.bakerAddressController.value.text}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff8E8E95),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CustomLoadingAnimatedActionButton(
                    "Confirm",
                    true,
                    () async {
                      if (!bakerController.isDelegationLoading.value) {
                        bakerController.isDelegationLoading.value = true;
                      }
                      await DataHandlerController().createDelegationTransaction(
                          bakerController.storage
                              .accounts[bakerController.storage.provider][0],
                          StorageUtils.rpc[bakerController.storage.provider],
                          widget.controller.bakerAddressController.value.text);
                      // redirecting the user to homePage, transaction tab be shown there
                      widget.homePageController.index.value = 0;
                      FireAnalytics().logEvent("delegate_added", addTz1: true);
                      Future.delayed(
                        Duration(milliseconds: 2000),
                        () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    height: 56,
                    fontSize: 16,
                  ),
                  SizedBox(
                    height: Platform.isAndroid ? 20 : 40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  delegationProccess(controller) async {
    var keyStore = KeyStoreModel(
      publicKeyHash: controller.storage.accounts[controller.storage.provider][0]
          ['publicKeyHash'],
      publicKey: controller.storage.accounts[controller.storage.provider][0]
          ['publicKey'],
      secretKey: controller.storage.accounts[controller.storage.provider][0]
          ['secretKey'],
    );

    var result = await OperationUtils().delegatBaker(
      keyStore,
      StorageUtils.rpc[controller.storage.provider],
      controller.bakerAddressController.value.text,
    );

    print("Applied operation ===> $result['appliedOp']");
    print("Operation groupID ===> $result['operationGroupID']");
  }
}
