import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/walkthrough/views/createWallet/legal.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';

import '../controllers/walkthrough_controller.dart';

class WalkthroughView extends GetView<WalkthroughController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 40.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (i) {
                    controller.pagechanged(i);
                  },
                  children: [
                    firstPage(),
                    secondPage(),
                    thirdPage(),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _getPageViewIndicator(),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: Get.height * 0.01,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => createNewWallet(context),
                            child: CustomAnimatedActionButton(
                              "Create a new wallet",
                              true,
                              () {
                                createNewWallet(context);
                              },
                              height: 60,
                              width: Get.width - 50,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              FireAnalytics()
                                  .logEvent("i_aleady_have_a_wallet", param: {
                                "intro_page_id":
                                    controller.index.value.toString(),
                              });
                              Navigator.pushNamed(
                                      context,
                                      Routes.RECOVER_WALLET,
                                    );
                            },
                            child: Container(
                              height: 60,
                              width: Get.width - 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "I already have a wallet",
                                  style: TextStyle(
                                    color: Color(0xFF7F8489),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget firstPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/icon/naan_circular.png",
          height: 80,
          width: 80,
        ),
        SizedBox(
          height: 10,
        ),
        Image.asset(
          "assets/icon/naan_text.png",
          height: 30,
          width: 125,
        ),
        SizedBox(
          height: 4,
        ),
        GradientText(
          "Tasty Tezos Wallet",
          gradient: gradientBackground,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }

  Widget secondPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          "assets/icon/assets_logo.png",
          width: Get.width,
        ),
        SizedBox(
          height: 64,
        ),
        GradientText(
          "All your Tezos assets in one place",
          gradient: gradientBackground,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontFamily: "Poppins",
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Take control of your tokens and\ncollectibles by storing them on your\nown device",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff7F8489),
            fontSize: 14,
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }

  Widget thirdPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Opacity(
              opacity: 0,
              child: Image.asset(
                "assets/icon/assets_logo.png",
                width: Get.width,
              ),
            ),
            Positioned(
              bottom: 0,
              left: (Get.width / 2) - (116 / 2),
              // alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/icon/wert_text.png",
                height: 116,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 64, //(Get.width / 2.097),
        ),
        GradientText(
          "Buy tez with cash using your creditcard",
          gradient: gradientBackground,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            fontFamily: "Poppins",
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Thanks to Wert, a licensed virtual currency provider",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff7F8489),
            fontSize: 14,
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }

  Widget _getPageViewIndicator() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < 3; i++)
            Container(
              width: 10.0,
              height: 10.0,
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.index.value == i
                    ? Colors.white
                    : Colors.white.withOpacity(
                        0.07,
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> createNewWallet(context) async {
    FireAnalytics().logEvent("create_new_wallet", param: {
      "intro_page_id": controller.index.value.toString(),
    });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Legal(controller)));
  }
}
