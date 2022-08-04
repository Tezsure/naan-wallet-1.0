import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:majascan/majascan.dart';
import 'package:tezster_wallet/app/modules/baker_delegation/controllers/baker_delegation_controller.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/modules/home_page/views/settings_page/confirm_delegation.dart';
import 'package:url_launcher/url_launcher.dart';

bakerDelegationPopup(BuildContext context, BakerDelegationController controller,
    HomePageController homePageController, String delegate,
    {String name, String url}) {
  if (delegate != null && delegate.length == 0) delegate = null;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) =>
                AlertDialog(
              contentPadding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              content: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: gradientBackground,
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Image.asset(
                                "assets/settings/baker.png",
                                height: 14,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GradientText(
                                    "Baker delegation",
                                    gradient: gradientBackground,
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Earn interest by delegating to a baker",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.bakerAddressController.value.text =
                                    "";
                                controller.isValidAddres.value = false;
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close_rounded,
                                color: Color(0xff8E8E95),
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 1,
                          width: Get.width,
                          color: Colors.white.withOpacity(0.04),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        infoUI(
                            info:
                                "Delegating allows you to participate in staking and receive Tezos staking rewards without the necessity of maintaining a node."),
                        SizedBox(
                          height: 28,
                        ),
                        delegate != null
                            ? Column(
                                children: [
                                  Text(
                                    delegate,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Color(0xff6A6B6E),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          url,
                                          height: 12,
                                          width: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      autofocus: true,
                                      controller: controller
                                          .bakerAddressController.value,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Enter Tezos address",
                                        hintStyle: TextStyle(
                                          color: Color(0xff6B6D70),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        contentPadding: EdgeInsets.all(0),
                                        isDense: true,
                                        counter: Container(),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (s) {
                                        controller.isValidAddres.value =
                                            CommonFunction.isValidTzOrKTAddress(
                                                controller
                                                    .bakerAddressController
                                                    .value
                                                    .text);
                                      },
                                      onSubmitted: (s) async {
                                        controller.bakerAddress.value =
                                            controller.bakerAddressController
                                                .value.text;
                                        controller.isValidAddres.value =
                                            CommonFunction.isValidTzOrKTAddress(
                                                controller
                                                    .bakerAddressController
                                                    .value
                                                    .text);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        String reciverPkHash =
                                            await MajaScan.startScan(
                                                title: "Scan address",
                                                flashlightEnable: true,
                                                scanAreaScale: 0.7);
                                        if (CommonFunction.isValidTzOrKTAddress(
                                                reciverPkHash) &&
                                            reciverPkHash.isNotEmpty) {
                                          controller.bakerAddressController
                                              .value.text = reciverPkHash;
                                        }
                                      },
                                      child: SvgPicture.asset(
                                        "assets/send_xtz/qr_code.svg",
                                        color: Colors.white30,
                                        height: 18,
                                        width: 18,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                        SizedBox(
                          height: 28,
                        ),
                        Opacity(
                          opacity: delegate != null ? 0 : 1,
                          child: Obx(() => CustomAnimatedActionButton(
                                "Delegate",
                                controller.isValidAddres.value,
                                () {
                                  if (delegate != null) return;
                                  delegateToBaker(
                                      context, controller, homePageController);
                                },
                                backgroudColor: Colors.black,
                                height: 55.0,
                                width: Get.width * 0.7,
                              )),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (delegate != null) {
                              setState(() {
                                delegate = null;
                              });
                            } else {
                              launch("https://tezos-nodes.com/");
                            }
                          },
                          child: Container(
                            height: 32,
                            child: Center(
                              child: Text(
                                delegate != null
                                    ? "Change Baker"
                                    : "Reliable bakers by Tezos Nodes",
                                style: TextStyle(
                                  color: Color(0xffC4C4C4),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          onWillPop: () async {
            controller.bakerAddressController.value.text = "";
            controller.isValidAddres.value = false;
            return true;
          });
    },
  );
}

delegateToBaker(context, controller, homePageController) {
  if (controller.bakerAddressController.value.text.isEmpty) {
    Fluttertoast.showToast(
      msg: "Please enter the baker address",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return;
  } else if (!CommonFunction.isValidTzOrKTAddress(
      controller.bakerAddressController.value.text)) {
    Fluttertoast.showToast(
      msg: "Please enter the valid baker address",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return;
  }
  CommonFunction.setSystemNavigatinColor(
    backgroundColor,
  );

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              ConfirmDelegation(controller, homePageController)));
  // Navigator.pushNamed(
  //   context,
  //   Routes.LOADING_SCREEN,
  //   arguments: LoadingViewArguments(
  //     proccess: delegationProccess(controller),
  //     title: "Confirming Delegation",
  //     subTitle:
  //         "Please wait for the transaction to be confirmed on Tezos. This may take some time.",
  //     emojiImage: 'assets/emojis/confirming.png',
  //     mainSuccessTitle: "Bakery Added",
  //     buttonText: "Return to Settings",
  //     successMsg:
  //         "Rewards will be received according to the conditions of your selected bakery.",
  //   ),
  // );
}
