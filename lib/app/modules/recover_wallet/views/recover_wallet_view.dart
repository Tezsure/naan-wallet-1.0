import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/recover_wallet/views/fragments/private_key.dart';
import 'package:tezster_wallet/app/modules/recover_wallet/views/fragments/recovery_phrase.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';

import '../controllers/recover_wallet_controller.dart';

class RecoverWalletView extends GetView<RecoverWalletController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      backButton(context),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  GradientText(
                    "Import account",
                    gradient: gradientBackground,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  infoUI(
                      info:
                          "Import an account using a recovery phrase, private key, or Cloud backup."),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      FireAnalytics().logEvent("recovery_phrase_clicked");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ImportUsingRecoverPhrase(controller),
                        ),
                      );
                    },
                    child: bottomButtomUi(
                        "assets/import_account/recovery_phrase.png",
                        "Recovery phrase"),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      FireAnalytics().logEvent("private_key_clicked");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ImportUsingPrivateKey(controller),
                        ),
                      );
                    },
                    child: bottomButtomUi(
                        "assets/import_account/private_key.png", "Private key"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomButtomUi(String icon, String text) {
    return Container(
      height: 46,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xff1E1E1E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            height: 24,
            width: 24,
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
