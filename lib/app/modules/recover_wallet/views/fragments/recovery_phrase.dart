import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_loading_animated_action_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_icon.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/recover_wallet/controllers/recover_wallet_controller.dart';
import 'package:tezster_wallet/app/modules/success_page/views/success_page_view.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/app/utils/utils.dart';

class ImportUsingRecoverPhrase extends StatefulWidget {
  // final WalkthroughController walkThroughController;
  final RecoverWalletController controller;
  ImportUsingRecoverPhrase(this.controller);

  @override
  _ImportUsingRecoverPhraseState createState() =>
      _ImportUsingRecoverPhraseState();
}

class _ImportUsingRecoverPhraseState extends State<ImportUsingRecoverPhrase>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  List<String> derrivationText = [
    "No derivation",
    "Default account (the first one)",
    "Another account",
    "Custom derivation path",
  ];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.controller.isMnemonicValid.value = false;
        widget.controller.mnemonicController.value.text = "";
        widget.controller.derrivationIndex.value = 1;
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: Get.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: backButton(context, ontap: () {
                              widget.controller.isMnemonicValid.value = false;
                              widget.controller.mnemonicController.value.text =
                                  "";
                              widget.controller.derrivationIndex.value = 1;
                              Navigator.pop(context);
                            }),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.02,
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
                                headLine: "Sign in with a recovery phrase",
                                info:
                                    "This is a phrase you were given when you created your previous wallet."),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 60,
                              width: Get.width * 0.9,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color(0xff1e1e1e),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Obx(
                                      () => TextField(
                                        autofocus: false,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        controller: widget.controller
                                            .mnemonicController.value,
                                        decoration: InputDecoration(
                                          hintText: "Recovery phrase...",
                                          hintStyle: TextStyle(
                                            color: Color(0xff8E8E95),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          contentPadding: EdgeInsets.all(0),
                                          isDense: true,
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (s) {
                                          if (s.length > 0)
                                            widget.controller.isMnemonicValid
                                                .value = true;
                                          else
                                            widget.controller.isMnemonicValid
                                                .value = false;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            infoUI(
                                info:
                                    "Used for additional mnemonic derivation. That is NOT a wallet password."),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 40,
                              width: Get.width * 0.9,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Color(0xff1e1e1e),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      autofocus: false,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      controller: widget
                                          .controller.passwordController.value,
                                      decoration: InputDecoration(
                                        hintText: "Password (optional)",
                                        hintStyle: TextStyle(
                                          color: Color(0xff8E8E95),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        contentPadding: EdgeInsets.all(0),
                                        isDense: true,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            infoUI(
                                info:
                                    "By default derivation isn't used. Click on 'Custom derivation path' to add it."),
                            SizedBox(
                              height: 8,
                            ),
                            Obx(
                              () => Container(
                                width: Get.width * 0.9,
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  gradient: widget.controller.derrivationIndex
                                              .value >=
                                          0
                                      ? gradientBackground
                                      : LinearGradient(colors: [
                                          Colors.transparent,
                                          Colors.transparent
                                        ]),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xff1e1e1e),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (_controller.value == 1) {
                                            _controller.reverse();
                                            return;
                                          }
                                          _controller.forward();
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                widget
                                                            .controller
                                                            .derrivationIndex
                                                            .value ==
                                                        -1
                                                    ? "Derivation (optional)"
                                                    : derrivationText[widget
                                                        .controller
                                                        .derrivationIndex
                                                        .value],
                                                style: TextStyle(
                                                  color: Color(0xff8E8E95),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              GradientIcon(
                                                child: Icon(
                                                  Icons.arrow_drop_down_sharp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizeTransition(
                                        sizeFactor: _animation,
                                        axis: Axis.vertical,
                                        axisAlignment: -1,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 8,
                                            ),
                                            customCircularCheckBox(
                                                widget
                                                        .controller
                                                        .derrivationIndex
                                                        .value ==
                                                    0, () {
                                              if (widget.controller
                                                      .derrivationIndex.value ==
                                                  0) {
                                                widget
                                                    .controller
                                                    .derrivationIndex
                                                    .value = -1;
                                              } else {
                                                widget.controller
                                                    .derrivationIndex.value = 0;
                                              }
                                            }, "No Derivation"),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            customCircularCheckBox(
                                                widget
                                                        .controller
                                                        .derrivationIndex
                                                        .value ==
                                                    1, () {
                                              if (widget.controller
                                                      .derrivationIndex.value ==
                                                  1) {
                                                widget
                                                    .controller
                                                    .derrivationIndex
                                                    .value = -1;
                                              } else {
                                                widget.controller
                                                    .derrivationIndex.value = 1;
                                              }
                                            }, "Default account (the first one)"),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            customCircularCheckBox(
                                                widget
                                                        .controller
                                                        .derrivationIndex
                                                        .value ==
                                                    2, () {
                                              if (widget.controller
                                                      .derrivationIndex.value ==
                                                  2) {
                                                widget
                                                    .controller
                                                    .derrivationIndex
                                                    .value = -1;
                                              } else {
                                                widget.controller
                                                    .derrivationIndex.value = 2;
                                              }
                                            }, "Another account"),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            customCircularCheckBox(
                                                widget
                                                        .controller
                                                        .derrivationIndex
                                                        .value ==
                                                    3, () {
                                              if (widget.controller
                                                      .derrivationIndex.value ==
                                                  3) {
                                                widget
                                                    .controller
                                                    .derrivationIndex
                                                    .value = -1;
                                              } else {
                                                widget.controller
                                                    .derrivationIndex.value = 3;
                                              }
                                            }, "Custom derivation path"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Obx(
                              () => widget.controller.derrivationIndex > 1
                                  ? Container(
                                      height: 40,
                                      width: Get.width,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Color(0xff1e1e1e),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              keyboardType: widget
                                                          .controller
                                                          .derrivationIndex
                                                          .value ==
                                                      2
                                                  ? TextInputType.number
                                                  : TextInputType.text,
                                              autofocus: false,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              ),
                                              maxLines: 1,
                                              controller: widget
                                                  .controller
                                                  .derivationPathController
                                                  .value,
                                              decoration: InputDecoration(
                                                hintText: derrivationText[widget
                                                    .controller
                                                    .derrivationIndex
                                                    .value],
                                                hintStyle: TextStyle(
                                                  color: Color(0xff8E8E95),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                contentPadding:
                                                    EdgeInsets.all(0),
                                                isDense: true,
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Obx(
                          () => CustomLoadingAnimatedActionButton(
                            "Import account",
                            widget.controller.isMnemonicValid.value,
                            () async {
                              if (widget.controller.mnemonicController.value
                                  .text.isEmpty) return;
                              bool isSameAccount = false;
                              var account;
                              var derivationPath = '';
                              switch (
                                  widget.controller.derrivationIndex.value) {
                                case 1:
                                  derivationPath = r"m/44'/1729'/0'/0'";
                                  break;
                                case 2:
                                  if (widget.controller.derivationPathController
                                      .value.text.isNotEmpty)
                                    derivationPath =
                                        "m/44'/1729'/${widget.controller.derivationPathController.value.text}'/0'";
                                  break;
                                case 3:
                                  if (widget.controller.derivationPathController
                                      .value.text.isNotEmpty)
                                    derivationPath = widget.controller
                                        .derivationPathController.value.text;
                                  break;
                                default:
                                  break;
                              }
                              if (widget.controller.mnemonicController.value.text.isNotEmpty &&
                                  widget.controller.passwordController.value
                                      .text.isNotEmpty &&
                                  widget.controller.derrivationIndex.value !=
                                      -1) {
                                account = await TezsterDart
                                    .restoreIdentityFromDerivationPath(
                                        derivationPath.trim(),
                                        widget.controller.mnemonicController
                                            .value.text
                                            .trim(),
                                        password: widget.controller
                                            .passwordController.value.text
                                            .trim());
                              } else if (widget.controller.mnemonicController
                                      .value.text.isNotEmpty &&
                                  widget.controller.derrivationIndex.value !=
                                      -1) {
                                account = await TezsterDart
                                    .restoreIdentityFromDerivationPath(
                                  derivationPath.trim(),
                                  widget
                                      .controller.mnemonicController.value.text
                                      .trim(),
                                );
                              } else if (widget.controller.mnemonicController
                                      .value.text.isNotEmpty &&
                                  widget.controller.passwordController.value
                                      .text.isNotEmpty) {
                                account = await TezsterDart
                                    .getKeysFromMnemonicAndPassphrase(
                                        mnemonic: widget.controller
                                            .mnemonicController.value.text
                                            .trim(),
                                        passphrase: widget.controller
                                            .passwordController.value.text
                                            .trim());
                              } else if (widget.controller.mnemonicController
                                  .value.text.isNotEmpty) {
                                account = await TezsterDart.getKeysFromMnemonic(
                                  mnemonic: widget
                                      .controller.mnemonicController.value.text
                                      .trim(),
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Wrong credentials",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }
                              StorageModel _storgeModel =
                                  await StorageUtils().getStorage();
                              _storgeModel.accounts[_storgeModel.provider]
                                  .forEach((acc) {
                                if (acc['publicKeyHash'] == account[2]) {
                                  isSameAccount = true;
                                  return;
                                }
                              });
                              if (isSameAccount) {
                                Fluttertoast.showToast(
                                  msg: "Same account can't be imported again",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }
                              var accountDeatils = {
                                "seed": widget
                                    .controller.mnemonicController.value.text,
                                "derivationPath": derivationPath ?? '',
                                "publicKey": account[1],
                                "secretKey": account[0],
                                "publicKeyHash": account[2],
                                "password": widget.controller.passwordController
                                        .value.text ??
                                    "",
                                "name": await getValidAccountName(),
                              };
                              _storgeModel.accounts[_storgeModel.provider]
                                  .add(accountDeatils);
                              _storgeModel.currentAccountIndex = _storgeModel
                                      .accounts[_storgeModel.provider].length -
                                  1;
                              tempModel = _storgeModel;
                              await StorageUtils().postStorage(tempModel);
                              FireAnalytics().logEvent(
                                  "import_account_confirmed_recovery_phrase",
                                  param: {
                                    "tz1": accountDeatils['publicKeyHash'],
                                    "password_entered": widget
                                                .controller
                                                .passwordController
                                                .value
                                                .text
                                                .length <
                                            1
                                        ? "no"
                                        : "yes",
                                    "derivation_type": widget.controller
                                                .derrivationIndex.value ==
                                            -1
                                        ? "Derivation (optional)"
                                        : derrivationText[widget
                                            .controller.derrivationIndex.value],
                                  });
                              ////reseting the text controller and button state
                              widget.controller.isMnemonicValid.value = false;
                              widget.controller.mnemonicController.value.text =
                                  "";
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.SUCCESS_PAGE,
                                (route) => false,
                                arguments: SuccessPageViewArguments(
                                  mainTitle: "Import complete!",
                                  title:
                                      "A new account has been imported in your Naan Wallet.",
                                ),
                              );
                            },
                            height: 56,
                            fontSize: 16,
                            loadingAnimationDuration: Duration(seconds: 2),
                            backgroudColor: backgroundColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
