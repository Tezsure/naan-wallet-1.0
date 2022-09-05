import 'dart:convert';

import 'package:bs58check/bs58check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:majascan/majascan.dart';
import 'package:tezster_dart/helper/http_helper.dart';
import 'package:tezster_wallet/app/custom_packges/image_cache_manager/image_cache_widget.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/animateUsingOpacity.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_loading_animated_action_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/modules/home_page/views/commonWidget/widgets.dart';
import 'package:tezster_wallet/app/modules/home_page/views/wallet_page/bottom_dialog/multiple_account_dialog.dart';
import 'package:tezster_wallet/app/modules/success_page/views/success_page_view.dart';
import 'package:tezster_wallet/app/modules/tx_history_items/views/tx_history_items_view.dart';
import 'package:tezster_wallet/app/modules/usdt/nft_usdt.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/apis_handler/http_helper.dart';
import 'package:tezster_wallet/app/utils/shimmer/custom_shimmer_widget.dart';
import 'package:tezster_wallet/beacon/beacon_plugin.dart';
import 'dart:math' as math;
import 'package:tezster_wallet/app/utils/apis_handler/http_helper.dart'
    as http_helper;

// ignore: must_be_immutable
class WalletPageView extends StatefulWidget {
  HomePageController controller;

  WalletPageView({@required this.controller});

  @override
  _WalletPageViewState createState() => _WalletPageViewState();
}

class _WalletPageViewState extends State<WalletPageView>
    with TickerProviderStateMixin {
  initState() {
    super.initState();
    widget.controller.animController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this, value: 0.1);
    widget.controller.animation = CurvedAnimation(
        parent: widget.controller.animController, curve: Curves.easeInOut);
    widget.controller.animController.forward(from: 1.0);
    widget.controller.scrollControllerHomePage.value
        .addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.controller.opacityHomePage.value = 0;
    widget.controller.fontSizeHomePage.value = 24;
    super.dispose();
  }

  // tz1XPAqaxaentpo8e295W7hjr696sq9XHzHj

  void _scrollListener() {
    if (widget.controller.scrollControllerHomePage.value.offset ==
        widget.controller.scrollControllerHomePage.value.position
            .maxScrollExtent) {
      if (widget.controller.scrollControllerHomePage.value.position.pixels >
          85) {
        if (widget.controller.scrollControllerHomePage.value.position.pixels -
                85 >
            39) {
          widget.controller.opacityHomePage.value = 1;
        } else {
          widget.controller.opacityHomePage.value = 0 +
              (widget.controller.scrollControllerHomePage.value.position
                          .pixels -
                      85) *
                  (1 - 0) /
                  (125 - 85);
        }
      } else {
        widget.controller.opacityHomePage.value = 0;
      }

      if (widget.controller.scrollControllerHomePage.value.position.pixels <=
          0) {
        widget.controller.fontSizeHomePage.value = 24;
      } else if (widget
              .controller.scrollControllerHomePage.value.position.pixels <
          125) {
        widget.controller.fontSizeHomePage.value = 24 -
            (widget.controller.scrollControllerHomePage.value.position.pixels -
                    0) *
                (24 - 18) /
                (124 - 0);
      } else {
        widget.controller.fontSizeHomePage.value = 18;
      }
    } else {
      if (widget.controller.scrollControllerHomePage.value.position.pixels >
          85) {
        if (widget.controller.scrollControllerHomePage.value.position.pixels -
                85 >
            39) {
          widget.controller.opacityHomePage.value = 1;
        } else {
          widget.controller.opacityHomePage.value = 0 +
              (widget.controller.scrollControllerHomePage.value.position
                          .pixels -
                      85) *
                  (1 - 0) /
                  (125 - 85);
        }
      } else {
        widget.controller.opacityHomePage.value = 0;
      }
      if (widget.controller.scrollControllerHomePage.value.position.pixels <=
          0) {
        widget.controller.fontSizeHomePage.value = 24;
      } else if (widget
              .controller.scrollControllerHomePage.value.position.pixels <
          125) {
        widget.controller.fontSizeHomePage.value = 24 -
            (widget.controller.scrollControllerHomePage.value.position.pixels -
                    0) *
                (24 - 18) /
                (124 - 0);
      } else {
        widget.controller.fontSizeHomePage.value = 18;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        controller: widget.controller.scrollControllerHomePage.value,
        slivers: [
          Obx(
            () => SliverAppBar(
              leading: SizedBox(),
              backgroundColor: backgroundColor,
              elevation: 0,
              snap: false,
              pinned: true,
              floating: false,
              expandedHeight: 145,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.controller.opacityHomePage.value == 0
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Opacity(
                              opacity: widget.controller.opacityHomePage.value,
                              child: Text(
                                widget.controller.accoutnName.value ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () async {
                            widget.controller.animController.reverse();
                            await Future.delayed(Duration(milliseconds: 350));
                            widget.controller.isShowingInXtz.value =
                                !widget.controller.isShowingInXtz.value;
                            widget.controller.animController.forward();
                          },
                          child: widget.controller.isHomePageLoading.value
                              ? CustomShimmerWidget(
                                  child: Container(
                                    height: widget
                                        .controller.fontSizeHomePage.value,
                                    width: Get.width * 0.2,
                                    decoration: BoxDecoration(
                                      color: Color(0xff1E1E1E),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                )
                              : Obx(
                                  () => ScaleTransition(
                                    scale: widget.controller.animation,
                                    alignment: Alignment.center,
                                    child: GradientText(
                                      (widget.controller.isShowingInXtz.value
                                              ? ""
                                              : r"$") +
                                          "${widget.controller.isShowingInXtz.value ? CommonFunction.roundUpTokenOrXtz((int.parse(widget.controller.balance.value) + widget.controller.tokenXtzBalance.value) / 1000000) + " tez" : CommonFunction.roundUpDollar((((int.parse(widget.controller.balance.value) + widget.controller.tokenXtzBalance.value) / 1000000) * widget.controller.dollerValue.value))}",
                                      gradient: gradientBackground,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: widget
                                            .controller.fontSizeHomePage.value,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    widget.controller.opacityHomePage.value == 0
                        ? SizedBox()
                        : Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, top: 12),
                            child: Opacity(
                              opacity: 0,
                              child: Text(
                                widget.controller.accoutnName.value ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        widget.controller.accoutnName.value ?? '',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => MultipleAccountDialog(
                          widget.controller,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Obx(
                          () => Container(
                            padding: EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xff6C6D70).withOpacity(0.2),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  6.0,
                                ),
                              ),
                            ),
                            child: Text(
                              widget.controller.pkH.isNotEmpty
                                  ? widget.controller.pkH.substring(0, 3) +
                                      "...." +
                                      widget.controller.pkH.substring(
                                          widget.controller.pkH.value.length -
                                              4)
                                  : '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff7F8489),
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 28,
                          color: Color(
                            0xFF6C6D70,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Center(
                  child: Container(
                    width: Get.width * 0.55,
                    height: 39,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          6.0,
                        ),
                      ),
                      color: Color(0xff6C6D70).withOpacity(0.2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Obx(
                            () => GestureDetector(
                              onTap: () {
                                if (int.parse(widget.controller.balance.value) >
                                    0) {
                                  Navigator.pushNamed(
                                      context, Routes.SEND_ASSETS);
                                  // Get.toNamed(Routes.SEND_ASSETS);
                                }
                              },
                              child: Container(
                                height: 31,
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    "Send",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: int.parse(widget
                                                    .controller.balance.value) >
                                                0
                                            ? Colors.white
                                            : Colors.white30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.white.withOpacity(
                            0.1,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, Routes.RECEIVE_FUNDS),
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  "Receive",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 28,
                          color: Colors.white.withOpacity(
                            0.1,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () async {
                              // if (int.parse(widget.controller.balance.value) >
                              //     0) {
                              BeaconPlugin.isCameraOpen = true;
                              String reciverPkHash = await MajaScan.startScan(
                                  title: "Scan address",
                                  flashlightEnable: true,
                                  scanAreaScale: 0.7);
                              if (CommonFunction.isValidTzOrKTAddress(
                                      reciverPkHash) &&
                                  reciverPkHash.isNotEmpty) {
                                Navigator.pushNamed(context, Routes.SEND_ASSETS,
                                    arguments: reciverPkHash);
                                return;
                                // Navigator.of(context).pushNamed(
                                //   Routes.SEND_XTZ,
                                //   arguments: reciverPkHash,
                                // )̃;
                              } else if (reciverPkHash.startsWith('tezos://')) {
                                reciverPkHash = reciverPkHash.substring(
                                    reciverPkHash.indexOf("data=") + 5,
                                    reciverPkHash.length);
                              } else if (reciverPkHash
                                  .startsWith('https://objkt.com/asset/')) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NftUsdt(reciverPkHash)));
                              }
                              // FireAnalytics()
                              //     .logEvent("beacon_used", addTz1: true);
                              try {
                                var data = String.fromCharCodes(
                                    base58.decode(reciverPkHash));
                                if (!data.endsWith("}"))
                                  data = data.substring(
                                      0, data.lastIndexOf('}') + 1);
                                var baseData = jsonDecode(data);
                                if (baseData.containsKey('relayServer')) {
                                  await BeaconPlugin.pair(
                                      baseData['name'], reciverPkHash);
                                  // await BeaconPlugin.addPeer(
                                  //   baseData['id'],
                                  //   baseData['name'],
                                  //   baseData['publicKey'],
                                  //   baseData['relayServer'],
                                  //   baseData['version'] ?? "2",
                                  // );
                                } else if (baseData.containsKey('tokenId')) {
                                  await showGetNftPopup(baseData);
                                }
                              } catch (e) {}
                            },
                            child: Container(
                              height: 31,
                              color: Colors.transparent,
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/send_xtz/qr_code.svg",
                                  color: Colors.white,
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Obx(
                  () => widget.controller.currentBackGroundTx.value != null &&
                          widget.controller.currentBackGroundTx.isNotEmpty
                      ? AnimateUsingOpacity(
                          widget.controller.currentBackGroundTx['status'] !=
                                  "Pending"
                              ? 0
                              : 1,
                          Duration(seconds: 5),
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 32.0,
                              right: 32.0,
                            ),
                            padding: EdgeInsets.only(
                              top: 13.0,
                              left: 20.0,
                              right: 20.0,
                              bottom: 13.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10.0,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 5.0,
                                      ),
                                      child: Transform.rotate(
                                        angle: -math.pi / 1.3,
                                        child: Image.asset(
                                          "assets/send_xtz/send_down_arrow.png",
                                          width: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                            widget
                                                .controller
                                                .currentBackGroundTx
                                                .value['amount'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Sent to: " +
                                                    (CommonFunction.isValidTzOrKTAddress(widget
                                                            .controller
                                                            .currentBackGroundTx
                                                            .value['receiver'])
                                                        ? CommonFunction()
                                                            .getShortTz1(
                                                            widget
                                                                .controller
                                                                .currentBackGroundTx
                                                                .value['receiver'],
                                                          )
                                                        : widget
                                                            .controller
                                                            .currentBackGroundTx
                                                            .value['receiver']),
                                                style: TextStyle(
                                                  color: Color(0xFF7F8489),
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.0,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                      text: widget
                                                          .controller
                                                          .currentBackGroundTx
                                                          .value['receiver']));
                                                  Fluttertoast.showToast(
                                                    msg: "Copied",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        backgroundColor,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.copy,
                                                  color: Color(
                                                    0xFF7F8489,
                                                  ),
                                                  size: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            top: 4.0,
                                            bottom: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(
                                              0xFF2C2E33,
                                            ),
                                            // shape: BoxShape.circle,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                100.0,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            widget
                                                .controller
                                                .currentBackGroundTx
                                                .value['status'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            right: 5.0,
                                            top: 7.5,
                                          ),
                                          child: widget
                                                      .controller
                                                      .currentBackGroundTx
                                                      .value['status']
                                                      .toLowerCase() ==
                                                  "pending"
                                              ? Image.asset(
                                                  "assets/send_xtz/loader.gif",
                                                  width: 20.0,
                                                )
                                              : widget
                                                          .controller
                                                          .currentBackGroundTx
                                                          .value['status']
                                                          .toLowerCase() ==
                                                      "confirmed"
                                                  ? Icon(
                                                      Icons.done,
                                                      size: 20.0,
                                                      color: Colors.white,
                                                    )
                                                  : Icon(
                                                      Icons.close,
                                                      size: 20.0,
                                                      color: Colors.red,
                                                    ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ),
                Obx(
                  () {
                    if (int.parse(widget.controller.balance.value) / 1000000 ==
                        0) {
                      widget.controller.isWalletEmpty.value = true;
                    } else {
                      widget.controller.isWalletEmpty.value = false;
                    }
                    widget.controller.tokensModel.forEach((element) {
                      if (double.parse(element.price ?? "0.0") *
                              widget.controller.dollerValue.value >
                          0) {
                        widget.controller.isWalletEmpty.value = false;
                      }
                    });
                    return widget.controller.isWalletEmpty.value ||
                            widget.controller.isHomePageLoading.value
                        ? widget.controller.isHomePageLoading.value
                            ? Container(
                                height: 250,
                                padding: EdgeInsets.only(
                                    top: 24, left: 24, right: 24),
                                child: ListView.builder(
                                  itemCount: 3,
                                  itemBuilder: (_, index) => Column(
                                    children: [
                                      index > 0
                                          ? Center(
                                              child: Container(
                                                height: 0.5,
                                                width: Get.width * 0.78,
                                                color: Color(0xff6B6D70)
                                                    .withOpacity(0.1),
                                              ),
                                            )
                                          : SizedBox(),
                                      CustomShimmerWidget(
                                        child: Container(
                                          height: 60,
                                          padding: EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff1E1E1E),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                      150,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: 31,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12.0,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 12,
                                                      width: Get.width * 0.2,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff1E1E1E),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Container(
                                                      height: 12,
                                                      width: Get.width * 0.15,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff1E1E1E),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    height: 12,
                                                    width: Get.width * 0.15,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1E1E1E),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Container(
                                                    height: 12,
                                                    width: Get.width * 0.1,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff1E1E1E),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Shimmer.fromColors(
                                      //   baseColor: Color(0xff1E1E1E),
                                      //   highlightColor: Colors.grey[600],
                                      //   enabled: true,
                                      //   child: Container(
                                      //     height: 60,
                                      //     padding: EdgeInsets.only(
                                      //       left: 20.0,
                                      //       right: 20.0,
                                      //     ),
                                      //     child: Row(
                                      //       children: [
                                      //         Container(
                                      //           decoration: BoxDecoration(
                                      //             shape: BoxShape.circle,
                                      //             color: Color(0xff1E1E1E),
                                      //           ),
                                      //           child: ClipRRect(
                                      //             borderRadius:
                                      //                 BorderRadius.all(
                                      //               Radius.circular(
                                      //                 150,
                                      //               ),
                                      //             ),
                                      //             child: Container(
                                      //               width: 31,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         SizedBox(
                                      //           width: 12.0,
                                      //         ),
                                      //         Expanded(
                                      //           child: Column(
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment.center,
                                      //             crossAxisAlignment:
                                      //                 CrossAxisAlignment.start,
                                      //             children: [
                                      //               Container(
                                      //                 height: 12,
                                      //                 width: Get.width * 0.2,
                                      //                 decoration: BoxDecoration(
                                      //                   color:
                                      //                       Color(0xff1E1E1E),
                                      //                   borderRadius:
                                      //                       BorderRadius
                                      //                           .circular(6),
                                      //                 ),
                                      //               ),
                                      //               SizedBox(
                                      //                 height: 3,
                                      //               ),
                                      //               Container(
                                      //                 height: 12,
                                      //                 width: Get.width * 0.15,
                                      //                 decoration: BoxDecoration(
                                      //                   color:
                                      //                       Color(0xff1E1E1E),
                                      //                   borderRadius:
                                      //                       BorderRadius
                                      //                           .circular(6),
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //         Column(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment.center,
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment.end,
                                      //           children: [
                                      //             Container(
                                      //               height: 12,
                                      //               width: Get.width * 0.15,
                                      //               decoration: BoxDecoration(
                                      //                 color: Color(0xff1E1E1E),
                                      //                 borderRadius:
                                      //                     BorderRadius.circular(
                                      //                         6),
                                      //               ),
                                      //             ),
                                      //             SizedBox(
                                      //               height: 3,
                                      //             ),
                                      //             Container(
                                      //               height: 12,
                                      //               width: Get.width * 0.1,
                                      //               decoration: BoxDecoration(
                                      //                 color: Color(0xff1E1E1E),
                                      //                 borderRadius:
                                      //                     BorderRadius.circular(
                                      //                         6),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              )
                            : noTokenFoundUI()
                        : NotificationListener<ScrollNotification>(
                            onNotification: _onScroll,
                            child: Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: Column(
                                children: [
                                  Obx(
                                    () => AnimatedContainer(
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.easeIn,
                                      margin: EdgeInsets.only(
                                          top: widget.controller
                                                  .isMainPageListScrolling.value
                                              ? (7).toDouble()
                                              : 0.0),
                                      child: GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                          new MaterialPageRoute(
                                            builder: (_) => TxHistoryItemsView(
                                              controller: widget.controller,
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          height: 60,
                                          color: Colors.transparent,
                                          padding: EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 31,
                                                width: 31,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(
                                                    0xFF346EC5,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    "assets/wallet/tezos_logo.png",
                                                    color: Colors.white,
                                                    height: 16,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12.0,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Tez",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      "Tezos",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF6B6D70),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Obx(
                                                () => Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      (CommonFunction
                                                          .roundUpTokenOrXtz(
                                                              int.parse(widget
                                                                      .controller
                                                                      .balance
                                                                      .value) /
                                                                  1000000)),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      r"$" +
                                                          CommonFunction.roundUpDollar(
                                                              (int.parse(widget
                                                                          .controller
                                                                          .balance
                                                                          .value) /
                                                                      1000000) *
                                                                  widget
                                                                      .controller
                                                                      .dollerValue
                                                                      .value),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF6B6D70),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  for (var i = 0;
                                      i <
                                              widget.controller.tokensModel
                                                  .length ??
                                          0;
                                      i++)
                                    Obx(
                                      () => AnimatedContainer(
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.easeIn,
                                        margin: EdgeInsets.only(
                                            top: widget
                                                    .controller
                                                    .isMainPageListScrolling
                                                    .value
                                                ? (7).toDouble()
                                                : 0.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              TxHistoryItemsView(
                                                controller: widget.controller,
                                              ),
                                              arguments: widget
                                                  .controller.tokensModel[i],
                                            );
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Center(
                                                  child: Container(
                                                    height: 0.5,
                                                    width: Get.width * 0.78,
                                                    color: Color(0xff6B6D70)
                                                        .withOpacity(0.1),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Container(
                                                  height: 60,
                                                  padding: EdgeInsets.only(
                                                    left: 20.0,
                                                    right: 20.0,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Color(
                                                            0xFF346EC5,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                              150,
                                                            ),
                                                          ),
                                                          child: Container(
                                                            width: 31,
                                                            child:
                                                                CacheImageBuilder(
                                                              imageUrl: widget
                                                                  .controller
                                                                  .tokensModel[
                                                                      i]
                                                                  .iconUrl,
                                                            ),
                                                          ),
                                                          // Image
                                                          //     .network(
                                                          //   widget
                                                          //       .controller
                                                          //       .tokensModel[
                                                          //           i]
                                                          //       .iconUrl,
                                                          //   width: 31,
                                                          // ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 12.0,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              widget
                                                                          .controller
                                                                          .tokensModel[
                                                                              i]
                                                                          .symbol !=
                                                                      null
                                                                  ? widget
                                                                      .controller
                                                                      .tokensModel[
                                                                          i]
                                                                      .symbol
                                                                  : widget.controller.tokensModel[i].name !=
                                                                          null
                                                                      ? widget
                                                                          .controller
                                                                          .tokensModel[
                                                                              i]
                                                                          .name
                                                                      : "",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Obx(
                                                              () => Tooltip(
                                                                message:
                                                                    getTokenBalance(
                                                                            i)
                                                                        .toString(),
                                                                child: Text(
                                                                  widget.controller.tokensModel[i].name !=
                                                                          null
                                                                      ? widget
                                                                          .controller
                                                                          .tokensModel[
                                                                              i]
                                                                          .name
                                                                      : widget.controller.tokensModel[i].symbol !=
                                                                              null
                                                                          ? widget
                                                                              .controller
                                                                              .tokensModel[i]
                                                                              .symbol
                                                                          : "",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xFF6B6D70),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Obx(
                                                        () => Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              (getTokenBalance(
                                                                              i)
                                                                          .toString()
                                                                          .length >=
                                                                      8
                                                                  ? getTokenBalance(
                                                                          i)
                                                                      .toString()
                                                                      .substring(
                                                                          0, 8)
                                                                  : getTokenBalance(
                                                                          i)
                                                                      .toString()),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                              (widget
                                                                          .controller
                                                                          .tokensModel[
                                                                              i]
                                                                          .balance ==
                                                                      '0.0'
                                                                  ? 'NaN'
                                                                  : r"$" +
                                                                      CommonFunction.roundUpDollar((double.parse(widget.controller.tokensModel[i].balance ?? "0.0") * double.parse(widget.controller.tokensModel[i].price)) *
                                                                          widget
                                                                              .controller
                                                                              .dollerValue
                                                                              .value)),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xFF6B6D70),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<Widget> showGetNftPopup(baseData) {
    Widget webView;
    webView = CacheImageBuilder(
      imageUrl: baseData['image'],
      fit: BoxFit.fill,
      showLoading: true,
    );
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              backgroundColor: Colors.transparent,
              content: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: gradientBackground,
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xff1e1e1e),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        webView,
                        SizedBox(
                          height: 20,
                        ),
                        CustomLoadingAnimatedActionButton(
                          "Claim NFT",
                          true,
                          () async {
                            //api call to add token to wallet
                            var response =
                                await http_helper.HttpHelper.performPostRequest(
                                    http_helper.HttpHelper.apiUrl,
                                    http_helper.HttpHelper.nftEndPoint, {
                              "tokenId": baseData['tokenId'],
                              "userAddress": widget.controller.pkH.toString(),
                            });
                            var res = jsonDecode(response);
                            if (res.containsKey('message')) {
                              if (res.containsKey('status') &&
                                  res['status'] == 'success') {
                                Navigator.of(context).pop();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Routes.SUCCESS_PAGE,
                                  (route) => false,
                                  arguments: SuccessPageViewArguments(
                                    mainTitle: res['message'],
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: res['message'],
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.of(context).pop();
                              }
                            }
                            // Navigator.pop(context);
                          },
                          loadingAnimationDuration: Duration(seconds: 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget noTokenFoundUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: Get.height * 0.15,
        ),
        Image.asset(
          "assets/emojis/monkey.png",
          height: 24,
          width: 24,
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "No tokens found",
          style: TextStyle(
            fontSize: 14,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            color: Color(0xffFDFDFD),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          "Buy or Transfer tokens from\nanother wallet or elsewhere",
          style: TextStyle(
            fontSize: 12,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            color: Color(0xff7F8489),
          ),
        ),
        SizedBox(
          height: 28,
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) =>
                  swapBottomSheet(widget.controller, context),
            );
          },
          child: GradientText(
            "Get tokens",
            gradient: gradientBackground,
            textStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.idle) {
        widget.controller.isMainPageListScrolling.value = false;
      } else {
        widget.controller.isMainPageListScrolling.value = true;
      }
    }
    return false;
  }

  getTokenBalance(i) {
    var amount = CommonFunction.roundUpTokenOrXtz(
        widget.controller.tokensModel[i].balance);
    return amount;
  }
}
