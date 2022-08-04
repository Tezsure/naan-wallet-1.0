import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/custom_packges/image_cache_manager/image_cache_widget.dart';
import 'package:tezster_wallet/app/data/data_handler_controller.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/modules/home_page/views/nft/nft_details.dart';
import 'package:tezster_wallet/app/modules/home_page/views/wallet_page/bottom_dialog/multiple_account_dialog.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';
import 'package:tezster_wallet/app/utils/shimmer/custom_shimmer_widget.dart';
import 'package:tezster_wallet/models/nft_token_model.dart';
import 'package:video_player/video_player.dart';

class NftView extends StatefulWidget {
  final HomePageController controller;
  NftView({@required this.controller});

  @override
  _NftViewState createState() => _NftViewState();
}

class _NftViewState extends State<NftView> {
  Map<String, VideoPlayerController> _controller = {};
  List<NFTToken> tokens;

  @override
  void initState() {
    widget.controller.nftsModel.value = [];
    widget.controller.scrollControllerNFT.value.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.opacityNFT.value = 0;
    widget.controller.fontSizeNFT.value = 24;
    _controller.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  void _scrollListener() {
    if (widget.controller.scrollControllerNFT.value.offset ==
        widget.controller.scrollControllerNFT.value.position.maxScrollExtent) {
      if (widget.controller.scrollControllerNFT.value.position.pixels > 85) {
        if (widget.controller.scrollControllerNFT.value.position.pixels - 85 >
            39) {
          widget.controller.opacityNFT.value = 1;
        } else {
          widget.controller.opacityNFT.value = 0 +
              (widget.controller.scrollControllerNFT.value.position.pixels -
                      85) *
                  (1 - 0) /
                  (125 - 85);
        }
      } else {
        widget.controller.opacityNFT.value = 0;
      }

      if (widget.controller.scrollControllerNFT.value.position.pixels <= 0) {
        widget.controller.fontSizeNFT.value = 24;
      } else if (widget.controller.scrollControllerNFT.value.position.pixels <
          125) {
        widget.controller.fontSizeNFT.value = 24 -
            (widget.controller.scrollControllerNFT.value.position.pixels - 0) *
                (24 - 18) /
                (124 - 0);
      } else {
        widget.controller.fontSizeNFT.value = 18;
      }
    } else {
      if (widget.controller.scrollControllerNFT.value.position.pixels > 85) {
        if (widget.controller.scrollControllerNFT.value.position.pixels - 85 >
            39) {
          widget.controller.opacityNFT.value = 1;
        } else {
          widget.controller.opacityNFT.value = 0 +
              (widget.controller.scrollControllerNFT.value.position.pixels -
                      85) *
                  (1 - 0) /
                  (125 - 85);
        }
      } else {
        widget.controller.opacityNFT.value = 0;
      }
      if (widget.controller.scrollControllerNFT.value.position.pixels <= 0) {
        widget.controller.fontSizeNFT.value = 24;
      } else if (widget.controller.scrollControllerNFT.value.position.pixels <
          125) {
        widget.controller.fontSizeNFT.value = 24 -
            (widget.controller.scrollControllerNFT.value.position.pixels - 0) *
                (24 - 18) /
                (124 - 0);
      } else {
        widget.controller.fontSizeNFT.value = 18;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.isNftGalleryLoading.value)
      widget.controller.getNftForPkh(widget.controller.pkH.value);
    return CustomScrollView(
      controller: widget.controller.scrollControllerNFT.value,
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
                  widget.controller.opacityNFT.value == 0
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Opacity(
                            opacity: widget.controller.opacityNFT.value,
                            child: Text(
                              widget.controller.accoutnName.value ?? '',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
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
                        child: GradientText(
                          "Gallery",
                          gradient: gradientBackground,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: widget.controller.fontSizeNFT.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget.controller.opacityNFT.value == 0
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 12, right: 20),
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
                        builder: (_) =>
                            MultipleAccountDialog(widget.controller));
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
                                        widget.controller.pkH.value.length - 4)
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
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Obx(() {
                tokens = widget.controller.nftsModel;

                return widget.controller.nftsModel.length == 0 &&
                        !widget.controller.isNftGalleryLoading.value
                    ? getNoNftFounds()
                    : widget.controller.isNftGalleryLoading.value
                        ? getLoadingUI()
                        : Container(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom -
                                  175,
                            ),
                            height: 200,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GridView.count(
                                physics: BouncingScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 15.0,
                                childAspectRatio: (((Get.width - 40 - 15) / 2) /
                                    (((Get.width - 40 - 15) / 2) + 32)),
                                addAutomaticKeepAlives: true,
                                addRepaintBoundaries: true,
                                // shrinkWrap: true,
                                children: List.generate(tokens.length,
                                    (index) => getNftView(tokens[index])),
                              ),
                            ),
                          );
              });
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  getNftView(NFTToken value) {
    int myTokenCount = value.holders.length > 0 ? value.holders[0].quantity : 0,
        totalTokenCount = value.supply;

    Widget webView = CacheImageBuilder(
      imageUrl:
          "https://assets.objkt.media/file/assets-003/${value.faContract}/${value.tokenId.toString()}/thumb400",
      fit: BoxFit.cover,
    );

    webView =
        Hero(tag: 'nft${value.faContract}_${value.tokenId}', child: webView);

    try {} catch (e) {
      print(e);
    }

    return GestureDetector(
      onTap: () {
        FireAnalytics().logEvent("nft_clicked", addTz1: true);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NftDetails(
                value,
                webView,
                value.holders.length > 0 ? value.holders[0].quantity : 0,
                value.supply,
                widget.controller,
              ),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff1E1E1E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              height: (Get.width - 40 - 15) / 2,
              width: (Get.width - 40 - 15) / 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: webView,
              ),
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
                        value.fa.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 8,
                          color: Color(0xff8E8E95),
                        ),
                      ),
                      Text(
                        "$myTokenCount/${value.supply}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 8,
                          color: Color(0xff8E8E95),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    value.name ?? "",
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

  Widget getNoNftFounds() {
    return Container(
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
          // GestureDetector(
          //   onTap: () async {
          //     CommonFunction.launchURL("https://objkt.com");
          //   },
          //   child: GradientText(
          //     "objkt.com",
          //     gradient: gradientBackground,
          //     textStyle: TextStyle(
          //       color: Colors.white,
          //       fontSize: 12,
          //       fontWeight: FontWeight.w700,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget getLoadingUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        childAspectRatio:
            (((Get.width - 40 - 15) / 2) / (((Get.width - 40 - 15) / 2) + 32)),
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        shrinkWrap: true,
        children: List.generate(
          4,
          (index) => Container(
            decoration: BoxDecoration(
              color: Color(0xff1E1E1E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                CustomShimmerWidget(
                  child: Container(
                    height: (Get.width - 40) / 2,
                    width: (Get.width - 40) / 2,
                    decoration: BoxDecoration(
                      color: Color(0xff1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6, top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomShimmerWidget(
                            child: Container(
                              height: Get.height * 0.01,
                              width: Get.width * 0.1,
                              decoration: BoxDecoration(
                                color: Color(0xff2D2F33),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            baseColor: Color(0xff2D2F33),
                          ),
                          CustomShimmerWidget(
                            child: Container(
                              height: Get.height * 0.01,
                              width: Get.width * 0.05,
                              decoration: BoxDecoration(
                                color: Color(0xff2D2F33),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            baseColor: Color(0xff2D2F33),
                          ),
                        ],
                      ),
                      CustomShimmerWidget(
                        child: Container(
                          height: Get.height * 0.01,
                          width: Get.width * 0.05,
                          decoration: BoxDecoration(
                            color: Color(0xff2D2F33),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        baseColor: Color(0xff2D2F33),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
