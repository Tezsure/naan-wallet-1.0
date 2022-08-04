import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/loading_screen/views/loading_screen_view.dart';
import 'package:tezster_wallet/app/modules/walkthrough/controllers/walkthrough_controller.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/operations_utils/operations_utils.dart';

class Legal extends StatefulWidget {
  WalkthroughController controller;
  Legal(this.controller);

  @override
  _LegalState createState() => _LegalState();
}

class _LegalState extends State<Legal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        height: Get.height,
        padding: EdgeInsets.only(
          top: Platform.isIOS ? 60.0 : 40.0,
          bottom: Platform.isIOS ? 40.0 : 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                  children: [
                    GradientText(
                      "Legal",
                      gradient: gradientBackground,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.04,
                    ),
                    infoUI(
                      info:
                          "Please review the naan Wallet Terms of service and privacy policy.",
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    CommonFunction.launchURL(
                      "https://www.naanwallet.com/privacy-policy.html",
                    );
                  },
                  child: Container(
                    height: 46,
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                      color: Color(0xff1E1E1E),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10.0,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 20.0,
                        ),
                        height: 55.0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                "Privacy policy",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 25.0,
                              ),
                              SvgPicture.asset(
                                "assets/settings/share.svg",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    CommonFunction.launchURL(
                      "https://www.naanwallet.com/terms.html",
                    );
                  },
                  child: Container(
                    height: 46,
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                      color: Color(0xff1E1E1E),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10.0,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 20.0,
                        ),
                        height: 55.0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                "Terms & Conditions",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 25.0,
                              ),
                              SvgPicture.asset(
                                "assets/settings/share.svg",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                CustomAnimatedActionButton(
                  "Accept",
                  true,
                  () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.LOADING_SCREEN, (route) => false,
                        arguments: LoadingViewArguments(
                          proccess: OperationUtils().createNewWalletProccess,
                          controller: widget.controller,
                          mainSuccessTitle: "Wallet Created!",
                          successMsg: "Welcome to Tezos",
                          emojiImage: 'assets/emojis/confirming.png',
                          isFromCreateNewWallet: true,
                        ));
                  },
                  height: 56,
                  width: Get.width * 0.9,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
