import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/loading_screen/views/loading_screen_view.dart';
import 'package:tezster_wallet/app/modules/recover_wallet/controllers/recover_wallet_controller.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

// ignore: must_be_immutable
class MnemonicRecover extends StatefulWidget {
  RecoverWalletController controller;
  bool isMnemonicRecover;

  MnemonicRecover(this.controller, this.isMnemonicRecover);

  @override
  _MnemonicRecoverState createState() => _MnemonicRecoverState();
}

class _MnemonicRecoverState extends State<MnemonicRecover> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height -
          (MediaQuery.of(context).padding.top +
              MediaQuery.of(context).padding.bottom) -
          Get.height * 0.15 -
          (Platform.isIOS ? 20 : 50),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: Get.width * 0.6,
                child: Text(
                  widget.isMnemonicRecover
                      ? "Enter your recovery phrase below with a space between each word."
                      : 'Enter your private key below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF7F8489),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.06,
              ),
              Column(
                children: widget.isMnemonicRecover
                    ? [
                        ClayContainer(
                          width: Get.width * 0.8,
                          height: 50.0,
                          borderRadius: 20.0,
                          spread: 2,
                          emboss: true,
                          depth: 20,
                          color: backgroundColor,
                          child: TextField(
                            controller:
                                widget.controller.mnemonicController.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF7F8489).withOpacity(
                                0.8,
                              ),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Recovery phrase",
                              hintStyle: TextStyle(
                                color: Color(
                                  0xFF7F8489,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(
                                10.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        ClayContainer(
                          width: Get.width * 0.8,
                          height: 50.0,
                          borderRadius: 20.0,
                          spread: 2,
                          emboss: true,
                          depth: 20,
                          color: backgroundColor,
                          child: TextField(
                            controller: widget
                                .controller.derivationPathController.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF7F8489).withOpacity(
                                0.8,
                              ),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Derivation path (optional)",
                              hintStyle: TextStyle(
                                color: Color(
                                  0xFF7F8489,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(
                                10.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        ClayContainer(
                          width: Get.width * 0.8,
                          height: 50.0,
                          borderRadius: 20.0,
                          spread: 2,
                          emboss: true,
                          depth: 20,
                          color: backgroundColor,
                          child: TextField(
                            controller:
                                widget.controller.passwordController.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF7F8489).withOpacity(
                                0.8,
                              ),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password (optional)",
                              hintStyle: TextStyle(
                                color: Color(
                                  0xFF7F8489,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(
                                10.0,
                              ),
                            ),
                          ),
                        ),
                      ]
                    : [
                        ClayContainer(
                          width: Get.width * 0.8,
                          height: 50.0,
                          borderRadius: 20.0,
                          spread: 2,
                          emboss: true,
                          depth: 20,
                          color: backgroundColor,
                          child: TextField(
                            controller:
                                widget.controller.privateKeyController.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF7F8489).withOpacity(
                                0.8,
                              ),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Private key",
                              hintStyle: TextStyle(
                                color: Color(
                                  0xFF7F8489,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(
                                10.0,
                              ),
                            ),
                          ),
                        ),
                      ],
              ),
            ],
          ),
          Align(
            // bottom: 0.0,
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                bottom: 15.0,
              ),
              child: GestureDetector(
                onTap: () {
                  recoverWallet(context);
                },
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
            ),
          ),
        ],
      ),
    );
  }

  Future<void> recoverWallet(context) async {
    Navigator.pushNamed(context, Routes.LOADING_SCREEN,
        arguments: LoadingViewArguments(
          proccess: recoverWalletProccess,
          subTitle: "We are recovering your wallet, this may take a moment.",
          emojiImage: 'assets/emojis/confirming.png',
          successMsg: "Your wallet is ready to use ",
          isFromCreateNewWallet: true,
        ));
  }

  recoverWalletProccess() async {
    var _identity;
    var seeds = widget.controller.mnemonicController.value.text;
    var derivationPath = widget.controller.derivationPathController.value.text;
    var password = widget.controller.passwordController.value.text;
    var privateKey = widget.controller.privateKeyController.value.text;
    if (widget.isMnemonicRecover) {
      if (derivationPath.isNotEmpty) {
        if (password.isNotEmpty)
          _identity = await TezsterDart.restoreIdentityFromDerivationPath(
              derivationPath, seeds,
              password: password);
        else
          _identity = await TezsterDart.restoreIdentityFromDerivationPath(
              derivationPath, seeds);
      } else {
        if (password.isNotEmpty)
          _identity = await TezsterDart.getKeysFromMnemonicAndPassphrase(
              mnemonic: seeds, passphrase: password);
        else
          _identity = await TezsterDart.getKeysFromMnemonic(
            mnemonic: seeds,
          );
      }
    } else if (privateKey.isNotEmpty)
      _identity = TezsterDart.getKeysFromSecretKey(privateKey);

    StorageModel _storgeModel = await StorageUtils().getStorage();
    var account = {
      "seed": seeds,
      "derivationPath": derivationPath ?? '',
      "publicKey": _identity[1],
      "secretKey": _identity[0],
      "publicKeyHash": _identity[2],
      "password": "",
    };
    var keys = _storgeModel.accounts.keys.toList();
    keys.forEach((element) {
      _storgeModel.accounts[element].add(account);
    });
    _storgeModel.currentAccountIndex =
        _storgeModel.accounts[_storgeModel.provider].length - 1;
    tempModel = _storgeModel;
    await StorageUtils().postStorage(tempModel, true);
    // var result = await StorageUtils().postStorage(_storgeModel, true);

    return _storgeModel;
  }
}
