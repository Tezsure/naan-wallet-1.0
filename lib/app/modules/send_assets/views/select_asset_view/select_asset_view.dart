import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/custom_packges/image_cache_manager/image_cache_widget.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/send_assets/controllers/send_assets_controller.dart';
import 'package:tezster_wallet/models/nft_token_model.dart';
import 'package:video_player/video_player.dart';

class SelectAssetView extends StatefulWidget {
  final SendAssetsController controller;

  SelectAssetView(this.controller);

  @override
  _SelectAssetViewState createState() => _SelectAssetViewState();
}

class _SelectAssetViewState extends State<SelectAssetView>
    with SingleTickerProviderStateMixin {
  SendAssetsController controller;
  TabController tabController;
  Map<String, VideoPlayerController> _controller = {};

  @override
  void dispose() {
    _controller.forEach((key, value) {
      value.dispose();
    });
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (controller.currentAssetPageSelected.value != tabController.index) {
        setState(() {
          controller.currentAssetPageSelected.value = tabController.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      margin: EdgeInsets.only(
        top: 20.0,
        left: 15.0,
        right: 15.0,
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              indicatorPadding: EdgeInsets.all(0),
              labelPadding: EdgeInsets.all(0),
              indicatorWeight: 5.0,
              indicator: ShapeDecoration(
                  shape: UnderlineInputBorder(), gradient: gradientBackground),
              indicatorColor: backgroundColor,
              tabs: [
                Tab(
                    child: Obx(
                  () => controller.getTabText(
                      0, controller.currentAssetPageSelected.value, "Tokens"),
                )),
                Tab(
                    child: Obx(
                  () => controller.getTabText(
                      1,
                      controller.currentAssetPageSelected.value,
                      "Collectibles"),
                )),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            tabController.index == 0
                ? _getAllTokensWidget(context)
                : _getAllNFTsWidget(context),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAllNFTsWidget(context) {
    return Column(
      children: [
        Obx(
          () => controller.nftsModel.length != 0
              ? Obx(
                  () => GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: (((Get.width - 50 - 12) / 2) /
                        (((Get.width - 70 - 12) / 2) + 32)),
                    addAutomaticKeepAlives: true,
                    addRepaintBoundaries: true,
                    shrinkWrap: true,
                    children: List.generate(controller.nftsModel.length,
                        (index) => getNftView(controller.nftsModel[index])),
                  ),
                )
              : Container(
                  height: Get.height / 2 - 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/nft/no_nft.png",
                        width: 24,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "No collectibles yet!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Explore new collectibles on\nobjkt",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff7F8489),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }


  getNftView(NFTToken value) {
    int myTokenCount =
            (value.holders.isNotEmpty ? value.holders[0].quantity : 0),
        totalTokenCount = value.supply;
    Widget webView = CacheImageBuilder(
      imageUrl:
          "https://assets.objkt.media/file/assets-003/${value.faContract}/${value.tokenId.toString()}/thumb400",
      fit: BoxFit.cover,
    );

    return GestureDetector(
      onTap: () {
        if (!controller.isKeyRevealed.value) {
          Fluttertoast.showToast(
            msg: "Send some tez first to start using your account",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return;
        }
        controller.selectedAssestType = 2;
        controller.selectedNFT = value;
        controller.currentStateList[0] = PROGRESS_STATE.COMPLETED;
        controller.currentStateList[1] = PROGRESS_STATE.ACTIVE;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff1E1E1E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              height: (Get.width - 120) / 2,
              width: double.infinity, //(Get.width - 100) / 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: webView,
              ),
              // child: ClipRRect(
              //   borderRadius: BorderRadius.circular(10),
              //   child: webView,
              // ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hic et nunc",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 8,
                          color: Color(0xff8E8E95),
                        ),
                      ),
                      Text(
                        "$myTokenCount/$totalTokenCount",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 8,
                          color: Color(0xff8E8E95),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    value.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAllTokensWidget(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Obx(
          () {
            if (int.parse(controller.balance.value) / 1000000 == 0) {
              controller.isWalletEmpty.value = true;
            } else {
              controller.isWalletEmpty.value = false;
            }
            return controller.isWalletEmpty.value
                ? noTokenFoundUI()
                : Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                          margin: EdgeInsets.only(
                            top: 0.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              controller.selectedAssestType = 0;
                              controller.currentStateList[0] =
                                  PROGRESS_STATE.COMPLETED;
                              controller.currentStateList[1] =
                                  PROGRESS_STATE.ACTIVE;
                            },
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
                                          "Tezos",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "tez",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF6B6D70),
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
                                          (CommonFunction.roundUpTokenOrXtz(
                                              int.parse(controller
                                                      .balance.value) /
                                                  1000000)),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          r"$" +
                                              CommonFunction.roundUpDollar(
                                                  (int.parse(controller
                                                              .balance.value) /
                                                          1000000) *
                                                      controller
                                                          .dollerValue.value),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF6B6D70),
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
                        for (var i = 0;
                            i < controller.tokensModel.length ?? 0;
                            i++)
                          Obx(
                            () => AnimatedContainer(
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeIn,
                              margin: EdgeInsets.only(top: 0.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (!controller.isKeyRevealed.value) {
                                    Fluttertoast.showToast(
                                      msg:
                                          "Send some tez first to start using your account",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    return;
                                  }
                                  controller.selectedAssestType = 1;
                                  controller.selectedToken =
                                      controller.tokensModel[i];
                                  controller.currentStateList[0] =
                                      PROGRESS_STATE.COMPLETED;
                                  controller.currentStateList[1] =
                                      PROGRESS_STATE.ACTIVE;
                                },
                                // onTap: () => Get.toNamed(
                                //     Routes.TOKEN_TRANSACTION_HISTORY,
                                //     arguments: controller.tokensModel[i]),
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Center(
                                        child: Container(
                                          height: 1,
                                          width: Get.width * 0.78,
                                          color: Color(0xff6B6D70)
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                        height: 60,
                                        // color: Colors.red,
                                        padding: EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(
                                                  0xFF346EC5,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    150,
                                                  ),
                                                ),
                                                child: Image.network(
                                                  controller
                                                      .tokensModel[i].iconUrl,
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
                                                  Obx(
                                                    () => Tooltip(
                                                      message:
                                                          getTokenBalance(i)
                                                              .toString(),
                                                      child: Text(
                                                        widget
                                                                    .controller
                                                                    .tokensModel[
                                                                        i]
                                                                    .name !=
                                                                null
                                                            ? widget
                                                                .controller
                                                                .tokensModel[i]
                                                                .name
                                                            : widget
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
                                                                : "",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    widget
                                                                .controller
                                                                .tokensModel[i]
                                                                .symbol !=
                                                            null
                                                        ? controller
                                                            .tokensModel[i]
                                                            .symbol
                                                        : widget
                                                                    .controller
                                                                    .tokensModel[
                                                                        i]
                                                                    .name !=
                                                                null
                                                            ? widget
                                                                .controller
                                                                .tokensModel[i]
                                                                .name
                                                            : "",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF6B6D70),
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
                                                    (getTokenBalance(i)
                                                                .toString()
                                                                .length >=
                                                            8
                                                        ? getTokenBalance(i)
                                                            .toString()
                                                            .substring(0, 8)
                                                        : getTokenBalance(i)
                                                            .toString()),
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
                                                    (widget
                                                                .controller
                                                                .tokensModel[i]
                                                                .balance ==
                                                            '0.0'
                                                        ? 'NaN'
                                                        : r"$" +
                                                            CommonFunction.roundUpDollar((double.parse(widget
                                                                            .controller
                                                                            .tokensModel[
                                                                                i]
                                                                            .balance ??
                                                                        "0.0") *
                                                                    double.parse(widget
                                                                        .controller
                                                                        .tokensModel[
                                                                            i]
                                                                        .price)) *
                                                                widget
                                                                    .controller
                                                                    .dollerValue
                                                                    .value)),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF6B6D70),
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
                  );
          },
        )
      ],
    );
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
            // showModalBottomSheet<void>(
            //   context: context,
            //   isScrollControlled: true,
            //   builder: (BuildContext context) =>
            //       swapBottomSheet(controller, context),
            // );
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

  getTokenBalance(i) {
    var amount = CommonFunction.roundUpTokenOrXtz(
        widget.controller.tokensModel[i].balance);
    return amount;
  }
}
