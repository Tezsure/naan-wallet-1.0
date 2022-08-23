import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/custom_packges/image_cache_manager/image_cache_widget.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';
import 'package:tezster_wallet/models/nft_token_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NftDetails extends StatefulWidget {
  final NFTToken value;
  final Widget nftWidget;
  final int myTokenCount, totalTokenCount;
  final HomePageController controller;
  NftDetails(this.value, this.nftWidget, this.myTokenCount,
      this.totalTokenCount, this.controller);

  @override
  _NftDetailsState createState() => _NftDetailsState();
}

class _NftDetailsState extends State<NftDetails> {

  

  @override
  void dispose() {
    widget.controller.nftDetailSelectedTab.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Platform.isAndroid ? 20 : 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      backButton(context),
                      // GestureDetector(
                      //   onTap: () {
                      //     Share.share(
                      //         "https://objkt.com/asset/${widget.value.fa2Id}/${widget.value.id}");
                      //   },
                      //   child: Container(
                      //     height: 40,
                      //     width: 40,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(32),
                      //       color: Color(0xFF1C1F22),
                      //       boxShadow: [
                      //         BoxShadow(
                      //             color: Colors.white.withOpacity(0.04),
                      //             offset: Offset(-2, -2),
                      //             blurRadius: 8),
                      //         BoxShadow(
                      //             color: Color(0xFF1C1F22),
                      //             offset: Offset(2, 2),
                      //             blurRadius: 8),
                      //       ],
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(12.0),
                      //       child: SvgPicture.asset(
                      //         "assets/tran_history/share.svg",
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: Get.width - 56,
                        width: Get.width - 56,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: widget.nftWidget,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  widget.controller.nftDetailSelectedTab.value =
                                      0;
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: GradientText(
                                      "Information",
                                      gradient: widget.controller
                                                  .nftDetailSelectedTab.value ==
                                              0
                                          ? gradientBackground
                                          : LinearGradient(colors: [
                                              Color(0xff8E8E95),
                                              Color(0xff8E8E95)
                                            ]),
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  FireAnalytics().logEvent("activity_clicked",
                                      addTz1: true);
                                  widget.controller.nftDetailSelectedTab.value =
                                      1;
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: GradientText(
                                      "Activity",
                                      gradient: widget.controller
                                                  .nftDetailSelectedTab.value ==
                                              1
                                          ? gradientBackground
                                          : LinearGradient(colors: [
                                              Color(0xff8E8E95),
                                              Color(0xff8E8E95)
                                            ]),
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Obx(
                        () => Container(
                          height: 2,
                          child: Row(
                            children: [
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: widget.controller.nftDetailSelectedTab
                                            .value ==
                                        0
                                    ? 1
                                    : 0.2,
                                child: Container(
                                  height: 2,
                                  width: (Get.width / 2) - 28,
                                  decoration: BoxDecoration(
                                    gradient: widget.controller
                                                .nftDetailSelectedTab.value ==
                                            0
                                        ? gradientBackground
                                        : LinearGradient(colors: [
                                            Color(0xff4F4F4F),
                                            Color(0xff4F4F4F)
                                          ]),
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: widget.controller.nftDetailSelectedTab
                                            .value ==
                                        1
                                    ? 1
                                    : 0.2,
                                child: Container(
                                  height: 2,
                                  width: (Get.width / 2) - 28,
                                  decoration: BoxDecoration(
                                      gradient: widget.controller
                                                  .nftDetailSelectedTab.value ==
                                              1
                                          ? gradientBackground
                                          : LinearGradient(colors: [
                                              Color(0xff4F4F4F),
                                              Color(0xff4F4F4F)
                                            ])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Obx(() =>
                          widget.controller.nftDetailSelectedTab.value == 0
                              ? informationUI()
                              : activity()),
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

  Widget informationUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.value.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          widget.value.description == null ? '' : widget.value.description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
            // fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.myTokenCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "Owned",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff8E8E95),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.value.supply.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "Owners",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff8E8E95),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 24,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.totalTokenCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "Editions",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff8E8E95),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 24,
        ),
        Container(
          height: 62,
          width: Get.width - 56,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xff1E1E1E),
            borderRadius: BorderRadius.circular(10),
          ),
          //0470
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: backgroundColor,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: CacheImageBuilder(
                            imageUrl:
                                "https://services.tzkt.io/v1/avatars/${widget.value.creators.last.creatorAddress}")),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Created by",
                        style: TextStyle(
                          color: Color(0xff8E8E95),
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            CommonFunction().getShortTz1(
                                widget.value.creators.last.creatorAddress),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              String url =
                                  "https://tzkt.io/${widget.value.creators.last.creatorAddress}/operations/";
                              if (await canLaunch(url)) {
                                launch(url);
                              }
                            },
                            child: SvgPicture.asset(
                                "assets/tran_history/share_nft.svg"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              widget.value.lowestAsk != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Price",
                          style: TextStyle(
                            color: Color(0xff8E8E95),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${(widget.value.lowestAsk / 1e6).toStringAsFixed(2)}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "\$(${(((widget.value.lowestAsk / 1e6) * widget.controller.dollerValue.value).toStringAsFixed(2))})",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff8E8E95),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
        // SizedBox(
        //   height: 28,
        // ),
        // CustomAnimatedActionButton(
        //   "View on objkt.com",
        //   true,
        //   () async {
        //     String url =
        //         "https://objkt.com/asset/${widget.value.fa2Id}/${widget.value.id}";
        //     if (await canLaunch(url)) {
        //       launch(url);
        //     }
        //   },
        //   height: 60,
        //   fontSize: 16,
        // ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget activity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: List.generate(widget.value.events.length, (index) {
          var date =
              DateTime.parse(widget.value.events[index].timestamp).toLocal();
          Duration diff = DateTime.now().difference(date);
          String time;
          if (diff.inDays >= 1) {
            time = '${diff.inDays} day ago';
          } else if (diff.inHours >= 1) {
            time = '${diff.inHours} hour ago';
          } else if (diff.inMinutes >= 1) {
            time = '${diff.inMinutes} minute ago';
          } else if (diff.inSeconds >= 1) {
            time = '${diff.inSeconds} second ago';
          } else {
            time = 'just now';
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.value.events[index].eventType.camelCase} ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 4,
                        ),
                        Text(
                          " " +
                              widget.value.events[index].creator.address
                                  .substring(0, 3) +
                              "..." +
                              widget.value.events[index].creator.address
                                  .substring(
                                      widget.value.events[index].creator.address
                                              .length -
                                          4,
                                      widget.value.events[index].creator.address
                                          .length) +
                              " ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 4,
                        ),
                        Text(
                          " " +
                              widget.value.events[index].recipientAddress
                                  .substring(0, 3) +
                              "..." +
                              widget
                                  .value.events[index].recipientAddress
                                  .substring(
                                      widget.value.events[index]
                                              .recipientAddress.length -
                                          4,
                                      widget.value.events[index]
                                          .recipientAddress.length) +
                              " ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 4,
                        ),
                        Text(
                          " ${(double.parse((widget.value.events[index].price ?? 0.0).toString()) / 1e6).toStringAsFixed(0)} tez",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: Color(0xff8E8E95),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                height: 1,
                width: Get.width,
                color: Colors.white.withOpacity(0.04),
              ),
            ],
          );
        }).reversed.toList(),
      ),
    );
  }
}
