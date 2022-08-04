import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/success_page/views/success_page_view.dart';
import 'package:tezster_wallet/app/modules/walkthrough/controllers/walkthrough_controller.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';

class RecoveryPhraseView extends StatefulWidget {
  final Map<dynamic, dynamic> storage;
  final WalkthroughController controller;
  final bool isFromMultiAccountPopup;
  RecoveryPhraseView(this.storage, this.controller,
      {this.isFromMultiAccountPopup = false});

  @override
  _RecoveryPhraseViewState createState() => _RecoveryPhraseViewState();
}

class _RecoveryPhraseViewState extends State<RecoveryPhraseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: Get.height),
          padding: EdgeInsets.only(
            top: Platform.isIOS ? 60.0 : 40.0,
            bottom: Platform.isIOS ? 40.0 : 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  Column(
                    children: [
                      GradientText(
                        "Recovery Phrase",
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
                        height: Get.height * 0.075,
                      ),
                      Container(
                        width: Get.width * 0.9,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xff1E1E1E),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          childAspectRatio: 2.5,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                              widget.storage['seed'].split(' ').length,
                              (index) {
                            return Center(
                              child: Text(
                                widget.storage['seed'].split(' ')[index],
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
                      SizedBox(
                        height: 8,
                      ),
                      widget.storage['derivationPath'] != null
                          ? infoUI(
                              headLine: "Derivation Path",
                              info: widget.storage['derivationPath'])
                          : SizedBox(),
                      SizedBox(
                        height: 8,
                      ),
                      infoUI(
                          info:
                              "These 12 words are the keys to your wallet.\nBack it up on the cloud or back it up\nmanually. Do not share this with anyone."),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(
                            text: widget.storage['seed'],
                          ));
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
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(left: 4, right: 20),
                      child: customCheckbox(widget.controller.isBackedUp.value,
                          () {
                        widget.controller.isBackedUp.value =
                            !widget.controller.isBackedUp.value;
                      }, "I understand that if I lose my recovery phrase, I will not be able to access my account."),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Obx(
                    () => CustomAnimatedActionButton(
                      "Confirm",
                      widget.controller.isBackedUp.value,
                      () {
                        if (!widget.controller.isBackedUp.value) return;
                        widget.controller.isBackedUp.value = false;
                        if (widget.isFromMultiAccountPopup) {
                          Navigator.pushNamed(context, Routes.SUCCESS_PAGE,
                              arguments: SuccessPageViewArguments(
                                mainTitle: "Wallet created!",
                                isFromMultiAccountPopup: true,
                              )).then((value) => Navigator.pop(context));
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.SUCCESS_PAGE,
                            (route) => false,
                            arguments: SuccessPageViewArguments(
                              mainTitle: "Wallet created!",
                            ),
                          );
                        }
                      },
                      height: 56,
                      fontSize: 16,
                      backgroudColor: backgroundColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
