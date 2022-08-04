import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_icon.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_singleton.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

Widget swapBottomSheet(HomePageController controller, BuildContext context) {
  return Obx(
    () => Container(
      constraints: BoxConstraints(
          minHeight:
              Get.height * (controller.isWalletEmpty.value ? 0.25 : 0.16)),
      padding: EdgeInsets.only(
          top: 8,
          left: Get.height * 0.05,
          right: Get.height * 0.05,
          bottom: Get.height * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              height: 3,
              width: Get.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.03,
          ),
          GestureDetector(
            onTap: () async {
              FireAnalytics().logEvent("buy_tez_clicked", addTz1: true);
              if (controller.isWertLaunched.value) return;
              controller.isWertLaunched.value = true;
              String url =
                  "https://dev.api.tezsure.com/v1/tezsure/wert/index.html?address=${controller.storage.accounts[controller.storage.provider][controller.storage.currentAccountIndex]['publicKeyHash']}";
              if (await canLaunch(url)) {
                await launch(url)
                    .then((value) => controller.isWertLaunched.value = false);
              }
            },
            child: Container(
              color: backgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientIcon(
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        "Buy",
                        gradient: gradientBackground,
                        textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Text(
                        "Buy tez with cash",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          controller.isWalletEmpty.value
              ? Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.04),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.RECEIVE_FUNDS),
                      child: Container(
                        color: backgroundColor,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform.rotate(
                              angle: 45 * math.pi / 180,
                              child: GradientIcon(
                                child: Icon(
                                  Icons.arrow_downward_sharp,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GradientText(
                                  "Transfer",
                                  gradient: gradientBackground,
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                Text(
                                  "Transfer assets from elsewhere",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox(),
        ],
      ),
    ),
  );
}

Widget changeNetworkBottomSheet({HomePageController controller, int index}) {
  Future<void> changeNetwork(context) async {
    controller.storage.provider =
        controller.storage.provider == "mainnet" ? 'delphinet' : "mainnet";
    FireAnalytics().logEvent("network_changed_confirmed", addTz1: true, param: {
      "network": controller.storage.provider,
    });
    await StorageUtils().postStorage(controller.storage);
    await StorageUtils()
        .getCurrentSelectedNode(controller.storage.provider == "delphinet");
    controller.isHomePageLoading.value = true;
    RestartWidget.restartApp(context);
    Navigator.of(context).pop();
  }

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Container(
      constraints: BoxConstraints(
          minHeight:
              Get.height * (controller.isWalletEmpty.value ? 0.25 : 0.16)),
      padding: EdgeInsets.only(
          top: 8,
          left: Get.height * 0.05,
          right: Get.height * 0.05,
          bottom: Get.height * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              height: 3,
              width: Get.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.03,
          ),
          Container(
            color: backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Image.asset(
                    "assets/settings/network.png",
                    height: 18,
                    width: 18,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      "Select Network",
                      gradient: gradientBackground,
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Change between main net and test net",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.04),
          ),
          SizedBox(
            height: 16,
          ),
          customCircularCheckBox(index == 0, () {
            if (index == 0) return;
            setState(() {
              index = 0;
            });
            changeNetwork(context);
          }, "Main net",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              )),
          SizedBox(
            height: 16,
          ),
          customCircularCheckBox(index == 1, () {
            if (index == 1) return;
            setState(() {
              index = 1;
            });
            changeNetwork(context);
          }, "Test net",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              )),
        ],
      ),
    );
  });
}

Widget changeNodeBottomSheet(HomePageController controller) {
  Future<void> changeNode(context, int index) async {
    StorageUtils().setCurrentSelectedNode(
        controller.storage.provider == "mainnet"
            ? StorageUtils.mainNodes[index]
            : StorageUtils.testNodes[index]);
    RestartWidget.restartApp(context);
    Navigator.of(context).pop();
  }

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    List<String> nodes = controller.storage.provider == "mainnet"
        ? StorageUtils.mainNodes
        : StorageUtils.testNodes;
    int currentSelectedNodeIndex =
        nodes.indexOf(StorageSingleton().currentSelectedNode);
    currentSelectedNodeIndex =
        currentSelectedNodeIndex == -1 ? 0 : currentSelectedNodeIndex;
    return Container(
      // constraints: BoxConstraints(
      //     minHeight:
      //         Get.height * (controller.isWalletEmpty.value ? 0.25 : 0.16)),
      padding: EdgeInsets.only(
          top: 8,
          left: Get.height * 0.05,
          right: Get.height * 0.05,
          bottom: Get.height * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              height: 3,
              width: Get.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.03,
          ),
          Container(
            color: backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Image.asset(
                    "assets/settings/network.png",
                    height: 18,
                    width: 18,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GradientText(
                      "Select Node",
                      gradient: gradientBackground,
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Change between node",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.04),
          ),
          SizedBox(
            height: 16,
          ),
          ...List.generate(nodes.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: customCircularCheckBox(i == currentSelectedNodeIndex, () {
                if (i == currentSelectedNodeIndex) return;
                setState(() {
                  currentSelectedNodeIndex = i;
                });
                changeNode(context, currentSelectedNodeIndex);
              }, nodes[i],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )),
            );
          }),
          // customCircularCheckBox(index == 0, () {
          //   if (index == 0) return;
          //   setState(() {
          //     index = 0;
          //   });
          //   changeNode(context);
          // }, "Main net",
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 12,
          //       fontWeight: FontWeight.w400,
          //     )),
          // SizedBox(
          //   height: 16,
          // ),
          // customCircularCheckBox(index == 1, () {
          //   if (index == 1) return;
          //   setState(() {
          //     index = 1;
          //   });
          //   changeNode(context);
          // }, "Test net",
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 12,
          //       fontWeight: FontWeight.w400,
          //     )),
        ],
      ),
    );
  });
}
