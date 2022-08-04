import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';

// ignore: must_be_immutable
class RecoveryPhrase extends StatefulWidget {
  var controller;

  RecoveryPhrase({this.controller});
  @override
  _RecoveryPhraseState createState() => _RecoveryPhraseState();
}

class _RecoveryPhraseState extends State<RecoveryPhrase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: 40.0,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                  bottom: Get.height * 0.3,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Reveal Seed Phrase",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Color(
                          0xFFFDFDFD,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.075,
                    ),
                    Container(
                      // height: Get.height * 0.4,
                      width: Get.width * 0.8,
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 15.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: [
                          for (var i = 0;
                              i < widget.controller.recoveryPhrase.length;
                              i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.8 / 4,
                                ),
                                ClayContainer(
                                  // co
                                  // // width: Get.width * 0.85 / 3 - 15,
                                  // height: 25.0,
                                  spread: 1.5,
                                  depth: 15,
                                  // decoration: BoxDecoration(
                                  //   color: Color(0xFF31343C),
                                  //   borderRadius: BorderRadius.circular(10.0),
                                  // ),
                                  color: Color(0xFF31343C),
                                  borderRadius: 20.0,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 18.0,
                                      top: 7.0,
                                      bottom: 7.0,
                                      right: 18.0,
                                    ),
                                    child: Text(
                                      widget.controller.recoveryPhrase[i],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.075,
                    ),
                    Container(
                      width: Get.width * 0.8,
                      child: Text(
                        "you can view your reveal seed phrase again later in the settings",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Color(
                            0xFF7F8489,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                    Container(
                      width: Get.width - 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: GestureDetector(
                              onTap: () => widget
                                      .controller.isCheckBoxChecked.value =
                                  !widget.controller.isCheckBoxChecked.value,
                              child: Obx(
                                () => ClayContainer(
                                  width: 22.0,
                                  height: 22.0,
                                  depth: 18,
                                  emboss: true,
                                  spread: 1.5,
                                  borderRadius: 4.0,
                                  color: Color(0xFF22252A).withOpacity(0.2),
                                  child: widget
                                          .controller.isCheckBoxChecked.value
                                      ? Icon(
                                          Icons.done,
                                          color: Colors.white.withOpacity(0.6),
                                          size: 16,
                                        )
                                      : Container(),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: Get.width * 0.72,
                            margin: EdgeInsets.only(
                              left: 12.0,
                            ),
                            child: Text(
                              "I understand that if i lose my reveal seed phrase, i will not be able to regain access to my wallet if i lose or unpair my device",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color(
                                  0xFF7F8489,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    GestureDetector(
                      onTap: () => widget.controller.isCheckBoxChecked.value
                          ? Navigator.pushNamedAndRemoveUntil(
                              context,
                              Routes.HOME_PAGE,
                              (route) => false,
                            )
                          : null,
                      // Navigator.pushNamed(
                      //   context,
                      //   Routes.LOGIN_WITH_PINCODE,
                      //   arguments: LoginWithPincodeViewArguments(isNew: true),
                      // ),
                      child: ClayContainer(
                        width: Get.width - 50,
                        height: 55.0,
                        color: Color(
                          0xFF323840,
                        ),
                        surfaceColor: Color(0xFF262b30),
                        borderRadius: 22,
                        depth: 20,
                        spread: 2,
                        child: Center(
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   width: Get.width - 50,
                      //   height: 55.0,
                      //   decoration: CommonWidgets.buttonDecoration,
                      //   alignment: Alignment.center,
                      //   child: Text(
                      //     "Continue",
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w500,
                      //       fontSize: 18,
                      //     ),
                      //   ),
                      // ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
