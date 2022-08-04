import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_loading_animated_action_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/recover_wallet/controllers/recover_wallet_controller.dart';
import 'package:tezster_wallet/app/modules/success_page/views/success_page_view.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/app/utils/utils.dart';

class ImportUsingPrivateKey extends StatefulWidget {
  final RecoverWalletController controller;
  ImportUsingPrivateKey(this.controller);

  @override
  _ImportUsingPrivateKeyState createState() => _ImportUsingPrivateKeyState();
}

class _ImportUsingPrivateKeyState extends State<ImportUsingPrivateKey> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.controller.isPrivateKeyValid.value = false;
        widget.controller.privateKeyController.value.text = "";
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: Get.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                children: [
                  // SizedBox(
                  //   height: 24,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        backButton(context, ontap: () {
                          Navigator.pop(context);
                          widget.controller.isPrivateKeyValid.value = false;
                          widget.controller.privateKeyController.value.text =
                              "";
                        }),
                      ],
                    ),
                  ),
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
                      headLine: "Sign in with a private key",
                      info:
                          "Use the private key of the account you want to import."),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 60,
                      width: Get.width * 0.9,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                                controller: widget
                                    .controller.privateKeyController.value,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: "Insert private key...",
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
                                    widget.controller.isPrivateKeyValid.value =
                                        true;
                                  else
                                    widget.controller.isPrivateKeyValid.value =
                                        false;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Obx(
                          () => CustomLoadingAnimatedActionButton(
                            "Import account",
                            widget.controller.isPrivateKeyValid.value,
                            () {
                              recoverWalletProccess();
                            },
                            height: 56,
                            fontSize: 16,
                            backgroudColor: backgroundColor,
                            loadingAnimationDuration: Duration(seconds: 2),
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

  recoverWalletProccess() async {
    bool isSameAccount = false;
    var _identity;
    var seeds = widget.controller.mnemonicController.value.text.trim();
    var derivationPath =
        widget.controller.derivationPathController.value.text.trim();
    var password = widget.controller.passwordController.value.text.trim();
    var privateKey = widget.controller.privateKeyController.value.text.trim();
    if (privateKey.isNotEmpty) {
      try {
        _identity = TezsterDart.getKeysFromSecretKey(privateKey);
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Wrong private key",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
    } else {
      Fluttertoast.showToast(
        msg: "Wrong private key",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    StorageModel _storgeModel = await StorageUtils().getStorage();
    _storgeModel.accounts[_storgeModel.provider].forEach((acc) {
      if (acc['publicKeyHash'] == _identity[2]) {
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
    var account = {
      "seed": seeds,
      "derivationPath": derivationPath ?? '',
      "publicKey": _identity[1],
      "secretKey": _identity[0],
      "publicKeyHash": _identity[2],
      "password": "",
      "name": await getValidAccountName(),
    };
    var keys = _storgeModel.accounts.keys.toList();
    keys.forEach((element) {
      _storgeModel.accounts[element].add(account);
    });
    _storgeModel.currentAccountIndex =
        _storgeModel.accounts[_storgeModel.provider].length - 1;

    tempModel = _storgeModel;
    await StorageUtils().postStorage(tempModel);
    // var result = await StorageUtils().postStorage(_storgeModel, true);
    FireAnalytics()
        .logEvent("import_account_confirmed_private_key", addTz1: true, param: {
      "tz1": account['publicKeyHash'],
    });
    //reseting the text controller and button state
    widget.controller.isPrivateKeyValid.value = false;
    widget.controller.privateKeyController.value.text = "";
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.SUCCESS_PAGE,
      (route) => false,
      arguments: SuccessPageViewArguments(
        mainTitle: "Import complete!",
        title: "A new account has been imported in your Naan Wallet.",
      ),
    );
  }
}
