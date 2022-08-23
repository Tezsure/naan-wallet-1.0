import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/walkthrough/controllers/walkthrough_controller.dart';
import 'package:tezster_wallet/app/modules/walkthrough/views/createWallet/recovery_phrase_view.dart';

import 'dart:math' as math;

class LoadingViewArguments {
  var proccess;
  String title;
  String subTitle;
  String emojiImage;
  String buttonText;
  String successMsg;
  bool isFromCreateNewWallet;
  String mainSuccessTitle;
  WalkthroughController controller;

  LoadingViewArguments({
    @required this.proccess,
    this.controller,
    this.title,
    this.subTitle,
    this.emojiImage,
    this.buttonText,
    this.successMsg,
    this.isFromCreateNewWallet = false,
    this.mainSuccessTitle = "",
  });
}

class LoadingScreenView extends StatefulWidget {
  @override
  _LoadingScreenViewState createState() => _LoadingScreenViewState();
}

class _LoadingScreenViewState extends State<LoadingScreenView>
    with SingleTickerProviderStateMixin {
  LoadingViewArguments args;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat();

    Future.delayed(Duration(seconds: 1), () async {
      // ignore: unused_local_variable
      Map<dynamic, dynamic> result = await args.proccess();
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => RecoveryPhraseView(
                    result,
                    args.controller,
                  )));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    // proccess = args.proccess;
    // msg = args.successMsg;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        margin: EdgeInsets.only(
          top: Get.height * 0.075,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: Get.height * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: Get.height * 0.10),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (_, child) {
                          return Transform.rotate(
                            angle: _controller.value * 2 * math.pi,
                            child: child,
                          );
                        },
                        child: Image.asset(
                          'assets/login/loader.png',
                          width: Get.width * 0.43,
                        ),
                      ),
                    ],
                  ),
                ),
                args != null && args.title != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          args.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: Get.width * 0.8,
                    child: Text(
                      args != null && args.subTitle != null
                          ? args.subTitle
                          : "We are creating your wallet, this may take a moment.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7F8489),
                      ),
                    ),
                  ),
                ),
                args != null && args.emojiImage != null
                    ? Container(
                        child: Image.asset(
                          args.emojiImage,
                          width: 55.0,
                        ),
                      )
                    : Container(),
              ],
            ),
            args != null && args.buttonText != null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: Platform.isIOS ? 40.0 : 20.0,
                      ),
                      child: GestureDetector(
                        onTap: () => null,
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
                              args.buttonText,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
