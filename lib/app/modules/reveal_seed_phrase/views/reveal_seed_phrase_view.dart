import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';

import '../controllers/reveal_seed_phrase_controller.dart';

class RevealSeedPhraseView extends GetView<RevealSeedPhraseController> {
  @override
  Widget build(BuildContext context) {
    var isPrivateKey = ModalRoute.of(context).settings.arguments as bool;
    controller.timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      if (controller.closeTime.value == 0) {
        controller.timer.cancel();
        Navigator.of(context).pop();
      } else
        controller.closeTime.value--;
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: Platform.isIOS ? 60.0 : 40.0,
        ),
        child: SingleChildScrollView(
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
              SizedBox(
                height: Get.height * 0.05,
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientText(
                    // "Recovery Phrase",
                    isPrivateKey ? "Private Key" : "Recovery Phrase",
                    gradient: gradientBackground,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      color: Color(
                        0xFFFDFDFD,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * (isPrivateKey ? 0.04 : 0.075),
                  ),
                  isPrivateKey
                      ? infoUI(
                          info:
                              "DO NOT share this set of chars with anyone! It can be used to steal your current account.",
                          headLine: "Attention!")
                      : Column(
                          children: [
                            Container(
                              width: Get.width * 0.9,
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Color(0xff1E1E1E),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Obx(
                                () => GridView.count(
                                  padding: EdgeInsets.zero,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  childAspectRatio: 2.5,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: List.generate(
                                      controller.recoveryPhrase.value.length,
                                      (index) {
                                    return Center(
                                      child: Text(
                                        controller.recoveryPhrase[index],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            Obx(
                              () => controller.derivationPath.value.isNotEmpty
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        infoUI(
                                            info:
                                                controller.derivationPath.value,
                                            headLine: "Derivation Path"),
                                      ],
                                    )
                                  : SizedBox(),
                            ),
                          ],
                        ),
                ],
              ),

              SizedBox(
                height: 8,
              ),
              isPrivateKey
                  ? Obx(
                      () => Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            controller
                                        .storage
                                        .value
                                        .accounts[
                                            controller.storage.value.provider]
                                        .length >
                                    0
                                ? controller.storage.value.accounts[
                                        controller.storage.value.provider][
                                    controller.storage.value
                                        .currentAccountIndex]["name"]
                                : "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            controller
                                        .storage
                                        .value
                                        .accounts[
                                            controller.storage.value.provider]
                                        .length >
                                    0
                                ? controller.storage.value.accounts[
                                        controller.storage.value.provider][
                                    controller.storage.value
                                        .currentAccountIndex]["publicKeyHash"]
                                : "",
                            style: TextStyle(
                              color: Color(0xff7F8489),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: Get.width * 0.9,
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xff1e1e1e),
                            ),
                            child: Text(
                              controller.privateKey.value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : infoUI(
                      info:
                          "These 12 words are the keys to your wallet.\nBack it up on the cloud or back it up\nmanually. Do not share this with anyone."),
              SizedBox(
                height: Get.height * 0.05,
              ),
              GestureDetector(
                onTap: () async {
                  if (!isPrivateKey) {
                    String _seedPhrase = "";
                    controller.recoveryPhrase.value.forEach((element) {
                      _seedPhrase = _seedPhrase + element + " ";
                    });
                    _seedPhrase = _seedPhrase.trim();
                    await Clipboard.setData(ClipboardData(
                      text: _seedPhrase,
                    ));
                  } else {
                    await Clipboard.setData(ClipboardData(
                      text: controller.privateKey.value,
                    ));
                  }
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
                      Icons.content_copy,
                      color: Color(0xff7F8489),
                      size: 16,
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
                  color: Color(0xff7F8489),
                  fontSize: 8,
                ),
              ),
              // Obx(
              //   () => Align(
              //     alignment: Alignment.bottomCenter,
              //     child: Container(
              //       margin: EdgeInsets.only(
              //         top: 15.0,
              //         bottom: 30.0,
              //       ),
              //       decoration: BoxDecoration(
              //         color: Color(
              //           0xFFFFFFFF,
              //         ).withOpacity(0.05),
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(
              //             20.0,
              //           ),
              //         ),
              //       ),
              //       child: Padding(
              //         padding: EdgeInsets.only(
              //           left: 9.0,
              //           bottom: 7.0,
              //           top: 7.0,
              //           right: 9.0,
              //         ),
              //         child: Text(
              //           "This screen will timeout in " +
              //               controller.closeTime.value.toString() +
              //               " seconds",
              //           style: TextStyle(
              //             fontSize: 12,
              //             fontFamily: 'Inter',
              //             fontWeight: FontWeight.w400,
              //             color: Color(0xFF7F8489),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
