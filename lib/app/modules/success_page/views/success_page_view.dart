import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

import '../controllers/success_page_controller.dart';

class SuccessPageViewArguments {
  String title;
  String mainTitle = "";
  bool isFromCreateNewWallet;
  bool isFromMultiAccountPopup;
  String buttonText = "Continue";

  SuccessPageViewArguments({
    this.title,
    this.isFromCreateNewWallet = false,
    this.isFromMultiAccountPopup = false,
    this.mainTitle = "",
    this.buttonText = "Continue",
  });
}

class SuccessPageView extends GetView<SuccessPageController> {
  @override
  Widget build(BuildContext context) {
    final SuccessPageViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/success_page/success_image.png",
                    height: 44,
                    width: 24,
                  ),
                  GradientText(
                    args != null && args.mainTitle != ""
                        ? args.mainTitle
                        : "Success!",
                    gradient: gradientBackground,
                    align: TextAlign.center,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: args.title != null && args.title.length > 0 ? 4 : 0,
                  ),
                  args.title != null && args.title.length > 0
                      ? Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Get.width * 0.2),
                          child: Text(
                            args.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xff7F8489),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: Platform.isIOS ? 30.0 : Get.height * 0.01,
                    left: 28,
                    right: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomAnimatedActionButton(
                      args.buttonText,
                      true,
                      () {
                        if (args.buttonText == "Close") {
                          Navigator.pop(context);
                        } else if (args.isFromMultiAccountPopup) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.HOME_PAGE,
                            (route) => false,
                          );
                        }
                      },
                      height: 56,
                      fontSize: 16,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  mnemonicScreenView(context) async {
    var storage = await StorageUtils().getStorage();
    if (storage.accounts[storage.provider][storage.currentAccountIndex]
                ['seed'] ==
            null ||
        storage.accounts[storage.provider][storage.currentAccountIndex]['seed']
            .toString()
            .isEmpty) {
      Navigator.pushNamed(
        context,
        Routes.HOME_PAGE,
      );
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.RECOVERY_PHRASE,
    );
  }
}
