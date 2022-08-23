import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/send_assets/views/amount_view/amount_view.dart';
import 'package:tezster_wallet/app/modules/send_assets/views/recipient_view.dart/recipient_view.dart';
import 'package:tezster_wallet/app/modules/send_assets/views/select_asset_view/select_asset_view.dart';

import '../controllers/send_assets_controller.dart';
import 'summary_view/confirm_tx_view/confirm_tx_view.dart';

class SendAssetsView extends GetView<SendAssetsController> {
  @override
  Widget build(BuildContext context) {
    var rpkH = ModalRoute.of(context).settings.arguments;
    if (rpkH != null && (rpkH as String).isNotEmpty) {
      controller.addressController.text = rpkH;
      controller.receiverAddress.value = rpkH;
    }

    List<Widget> widgets = <Widget>[
      SelectAssetView(controller),
      RecipientView(controller),
      AmountView(controller),
      ConfirmTxView(controller),
    ];
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentStateList[3] == PROGRESS_STATE.ACTIVE &&
            controller.summaryFormController.value == 1) {
          return false;
        }

        if (controller.currentStateList[0] == PROGRESS_STATE.ACTIVE) {
          return true;
        } else {
          var activeIndex =
              controller.currentStateList.indexOf(PROGRESS_STATE.ACTIVE);
          controller.currentStateList[activeIndex - 1] = PROGRESS_STATE.ACTIVE;
          controller.currentStateList[activeIndex] = PROGRESS_STATE.PENDING;

          controller.currentStateList = controller.currentStateList.value;
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 32, left: 20, right: 20),
            child: Stack(
              children: [
                Container(
                  height: Get.height,
                  // color: Colors.red,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        leading: SizedBox(),
                        backgroundColor: backgroundColor,
                        elevation: 0,
                        snap: false,
                        pinned: true,
                        floating: false,
                        expandedHeight: 120,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          collapseMode: CollapseMode.pin,
                          title: Align(
                            alignment: Alignment.bottomCenter,
                            child: Obx(
                              () => GradientText(
                                "Send",
                                gradient: gradientBackground,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      controller.fontSizeHomePage.value - 5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          progressBarWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () => Container(
                              // SafeArea padding - padding.top+padding.bottom
                              // top padding - 32
                              // sliver app bar - 120
                              // SizedBox between progress bar and bottom content - 20
                              // progress bar - 50
                              height: controller.currentStateList.indexOf(
                                        PROGRESS_STATE.ACTIVE,
                                      ) ==
                                      0
                                  ? null
                                  : Get.height -
                                      (MediaQuery.of(context).padding.top +
                                          MediaQuery.of(context)
                                              .padding
                                              .bottom) -
                                      32 -
                                      120 -
                                      20 -
                                      50,
                              padding: EdgeInsets.only(
                                  bottom: controller.currentStateList.indexOf(
                                            PROGRESS_STATE.ACTIVE,
                                          ) ==
                                          0
                                      ? 0
                                      : 20),
                              child:
                                  widgets[controller.currentStateList.indexOf(
                                PROGRESS_STATE.ACTIVE,
                              )],
                            ),
                          )
                        ]),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: backButton(context, ontap: () async {
                    if (controller.currentStateList[3] ==
                            PROGRESS_STATE.ACTIVE &&
                        controller.summaryFormController.value == 1) {
                      return false;
                    }

                    if (controller.currentStateList[0] ==
                        PROGRESS_STATE.ACTIVE) {
                      Navigator.pop(context);
                    } else {
                      var activeIndex = controller.currentStateList
                          .indexOf(PROGRESS_STATE.ACTIVE);
                      controller.currentStateList[activeIndex - 1] =
                          PROGRESS_STATE.ACTIVE;
                      controller.currentStateList[activeIndex] =
                          PROGRESS_STATE.PENDING;

                      controller.currentStateList.value =
                          controller.currentStateList.value;
                      return false;
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appBar(context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8),
              child: Center(
                child: backButton(context),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 25.0,
        ),
        GradientText(
          "Send",
          gradient: gradientBackground,
          textStyle: TextStyle(
            fontSize: 28.0,
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }

  Widget progressBarWidget() {
    return Container(
      height: 50.0,
      width: Get.width * 0.85,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < controller.currentStateList.value.length; i++)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: gradientBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: 16.0,
                          height: 16.0,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(
                            1.5,
                          ),
                          decoration: BoxDecoration(
                            color: controller.currentStateList[i] ==
                                    PROGRESS_STATE.PENDING
                                ? backgroundColor
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: controller.currentStateList[i] ==
                                  PROGRESS_STATE.COMPLETED
                              ? Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 10,
                                )
                              : Text(
                                  (i + 1).toString(),
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      controller.currentStateList[i] != PROGRESS_STATE.ACTIVE
                          ? Text(
                              controller.stateNames[i],
                              style: TextStyle(
                                color: Color(0xFF8E8E95),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            )
                          : GradientText(
                              controller.stateNames[i],
                              gradient: gradientBackground,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                    ],
                  ),
                  i != (controller.currentStateList.length - 1)
                      ? Container(
                          width: Get.width * 0.106,
                          height: 1.5,
                          margin: EdgeInsets.only(
                            left: i == 0
                                ? 9.0
                                : i == 2
                                    ? 7.0
                                    : 3.0,
                            right: i == 1 ? 5.0 : 3.0,
                            top: 10.5,
                          ),
                          decoration: controller.currentStateList[i] ==
                                  PROGRESS_STATE.COMPLETED
                              ? BoxDecoration(gradient: gradientBackground)
                              : BoxDecoration(
                                  color: Color(0xFF4F4F4F),
                                ),
                        )
                      : Container()
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget getStateCircleAndTextWidget(int index, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: gradientBackground,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 16.0,
            height: 16.0,
            alignment: Alignment.center,
            margin: EdgeInsets.all(
              1.5,
            ),
            decoration: BoxDecoration(
              color:
                  controller.currentStateList[index] == PROGRESS_STATE.PENDING
                      ? backgroundColor
                      : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              (index + 1).toString(),
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        controller.currentStateList[index] == PROGRESS_STATE.PENDING
            ? Text(
                text,
                style: TextStyle(
                  color: Color(0xFF8E8E95),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              )
            : GradientText(
                text,
                gradient: gradientBackground,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
      ],
    );
  }
}
