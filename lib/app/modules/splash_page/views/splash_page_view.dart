import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';

import '../controllers/splash_page_controller.dart';

class SplashPageView extends GetView<SplashPageController> {
  @override
  Widget build(BuildContext context) {
    controller.checkAccounts();
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icon/naan_circular.png",
              height: 120,
              width: 120,
            ),
            SizedBox(
              height: 5,
            ),
            Image.asset(
              "assets/icon/naan_text.png",
              height: 40,
              width: 165,
            ),
            SizedBox(
              height: 4,
            ),
            GradientText(
              "Tasty Tezos Wallet",
              gradient: gradientBackground,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
