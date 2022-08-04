import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';

import '../controllers/receive_funds_controller.dart';
import 'package:share/share.dart';

class ReceiveFundsView extends GetView<ReceiveFundsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: EdgeInsets.only(
          top: Get.height * 0.075,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: Get.width * 0.055,
                right: Get.width * 0.055,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  backButton(context),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: Get.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GradientText(
                    'Receive',
                    gradient: gradientBackground,
                    textStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFDFDFD),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              width: Get.width - 56,
              decoration: BoxDecoration(
                color: Color(0xff1E1E1E),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    6.0,
                  ),
                ),
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Obx(
                      () => Text(
                        controller.name.value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: Get.height * 0.01,
                        ),
                        child: Obx(
                          () => Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              controller.phHash.value == ""
                                  ? Container()
                                  : QrImage(
                                      data: controller.storage.accounts[
                                                  controller.storage.provider][
                                              controller
                                                  .storage.currentAccountIndex]
                                          ['publicKeyHash'],
                                      version: QrVersions.auto,
                                      size: 180.0,
                                      gapless: false,
                                      foregroundColor: Color(0xFFF5F5F5),
                                    ),
                              SizedBox(
                                height: Get.height * 0.03,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  // await Clipboard.setData(ClipboardData(
                                  //     text: controller.storage.accounts[
                                  //                 controller.storage.provider][
                                  //             controller
                                  //                 .storage.currentAccountIndex]
                                  //         ['publicKeyHash']));
                                  // Fluttertoast.showToast(
                                  //   msg: "Copied",
                                  //   toastLength: Toast.LENGTH_SHORT,
                                  //   gravity: ToastGravity.BOTTOM,
                                  //   timeInSecForIosWeb: 1,
                                  //   backgroundColor: Colors.red,
                                  //   textColor: Colors.white,
                                  //   fontSize: 16.0,
                                  // );
                                },
                                child: Text(
                                  controller.storage != null
                                      ? controller.storage.accounts[
                                                  controller.storage.provider][
                                              controller
                                                  .storage.currentAccountIndex]
                                          ['publicKeyHash']
                                      : '',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(
                                      0xFF7F8489,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.03,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 30,
              width: Get.width - 56,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Color(0xff1E1E1E),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error,
                    size: 16,
                    color: Color(0xff616161),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Please only use Tezos based assets.",
                    style: TextStyle(
                      color: Color(0xff616161),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: controller.storage.accounts[
                                              controller.storage.provider][
                                          controller
                                              .storage.currentAccountIndex]
                                      ['publicKeyHash']));
                              Fluttertoast.showToast(
                                msg: "Copied",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: Color(0xFF1C1F22),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white10,
                                      offset: Offset(-4, -4),
                                      blurRadius: 12),
                                  BoxShadow(
                                      color: Color(0xFF1C1F22),
                                      offset: Offset(4, 4),
                                      blurRadius: 12),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.copy_rounded,
                                  size: 16,
                                  color: Color(0xff7F8489),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Copy",
                            style: TextStyle(
                              fontSize: 8,
                              color: Color(0xff7F8489),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Share.share(
                                controller.storage.accounts[
                                            controller.storage.provider]
                                        [controller.storage.currentAccountIndex]
                                    ['publicKeyHash'],
                              );
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: Color(0xFF1C1F22),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white10,
                                      offset: Offset(-4, -4),
                                      blurRadius: 12),
                                  BoxShadow(
                                      color: Color(0xFF1C1F22),
                                      offset: Offset(4, 4),
                                      blurRadius: 12),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.share,
                                  size: 16,
                                  color: Color(0xff7F8489),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Share",
                            style: TextStyle(
                              fontSize: 8,
                              color: Color(0xff7F8489),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Obx(
            //   () => controller.phHash.value == ""
            //       ? Container()
            //       : GestureDetector(
            //           onTap: () {},
            //           child: Center(
            //             child: GradientText(
            //               "Which assets can I use?",
            //               gradient: gradientBackground,
            //               textStyle: TextStyle(
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.w700,
            //                 fontSize: 12,
            //               ),
            //             ),
            //           ),
            //         ),
            // ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
