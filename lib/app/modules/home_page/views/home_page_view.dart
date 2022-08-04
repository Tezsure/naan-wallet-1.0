import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/home_page/views/commonWidget/widgets.dart';
import 'package:tezster_wallet/app/modules/home_page/views/dapp/dapp_widget.dart';
import 'package:tezster_wallet/app/modules/home_page/views/nft/nft_view.dart';
import 'package:tezster_wallet/app/modules/home_page/views/wallet_page/wallet_page_view.dart';

import '../controllers/home_page_controller.dart';
import 'settings_page/settings_page_view.dart';

import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';

class HomePageView extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    controller.index.listen((int value) {
      if (controller.indexStack.length > 2) {
        controller.indexStack.removeAt(1);
      }
      if (!controller.indexStack.contains(value)) {
        controller.indexStack.add(value);
      }
    });
    CommonFunction.setSystemNavigatinColor(backgroundColor);

    List<Widget> _bottomNavigationWidget = [
      WalletPageView(
        controller: controller,
      ),
      Container(),
      NftView(
        controller: controller,
      ),
      Container(),
      SettingsPageView(
        controller: controller,
      ),
    ];
    controller.parentKeyContext = context;
    return WillPopScope(
      onWillPop: () async {
        if (controller.indexStack.length > 1) {
          controller.indexStack.removeLast();
          controller.index.value = controller.indexStack.last;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: Platform.isAndroid ? 12.0 : 28.0),
          child: bottomNavBar(context),
        ),
        body: SafeArea(
          child: Container(
            height: Get.height,
            width: Get.width,
            child: Obx(
              () => IndexedStack(
                index: controller.index.value,
                children: _bottomNavigationWidget,
              ),
              // _bottomNavigationWidget[controller.index.value],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomNavBar(BuildContext context) {
    return Obx(() {
      // if nft is selected then do not show bottom nav bar
      return controller.isNftSelected.value
          ? SizedBox()
          : Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    bottomNavItem(0, "assets/home/wallet.svg", "Wallet", () {
                      if (controller.index.value == 0) return;
                      controller.index.value = 0;
                    }),
                    bottomNavItem(
                        1,
                        "assets/home/swap.svg",
                        "Swap",
                        () => showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) =>
                                  swapBottomSheet(controller, context),
                            )),
                    bottomNavItem(2, "assets/home/nft.svg", "Gallery", () {
                      if (controller.index.value == 2) return;
                      controller.getNftForPkh(controller.pkH.value);
                      FireAnalytics()
                          .logEvent("gallery_navigation_clicked", addTz1: true);
                      controller.index.value = 2;
                    }),
                    bottomNavItem(3, "assets/home/grid_on.svg", "Dapp", () {
                      if (controller.index.value == 3) return;
                      controller.index.value = 3;
                    }),
                    bottomNavItem(4, "assets/home/settings.svg", "Settings",
                        () {
                      // if (controller.index.value == 3) return;
                      // controller.index.value = 3;
                      if (controller.index.value == 4) return;
                      controller.index.value = 4;
                    }),
                  ],
                ),
              ),
            );
    });
  }

  Widget bottomNavItem(
      int index, String imageAsset, String name, Function ontap) {
    return Obx(
      () => GestureDetector(
        onTap: ontap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: 40,
          width: controller.index.value == index ? 100 : 40,
          padding: EdgeInsets.symmetric(
              horizontal: controller.index.value == index
                  ? controller.index.value == 0
                      ? 20
                      : controller.index.value == 2
                          ? 16
                          : 12
                  : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: controller.index.value == index ? null : Color(0xFF1C1F22),
            gradient: controller.index.value == index
                ? LinearGradient(colors: [Color(0xffE0C3FC), Color(0xff8EC5FC)])
                : null,
            boxShadow: [
              BoxShadow(
                  color: controller.index.value == index
                      ? Colors.white12
                      : Colors.white10,
                  offset: Offset(-4, -4),
                  blurRadius: 12),
              BoxShadow(
                  color: Color(0xFF1C1F22),
                  offset: Offset(4, 4),
                  blurRadius: 12),
            ],
          ),
          child: Stack(
            children: [
              Align(
                alignment: controller.index.value == index
                    ? Alignment.centerLeft
                    : Alignment.center,
                child: Transform.translate(
                  offset: Offset(
                      controller.index.value == index
                          ? (index - 3).toDouble()
                          : 0.0,
                      0),
                  child: imageAsset.endsWith('.png')
                      ? Image.asset(
                          imageAsset,
                          width: 17.5,
                          color: controller.index.value == index
                              ? Colors.white
                              : Colors.white54,
                        )
                      : SvgPicture.asset(
                          imageAsset,
                          color: controller.index.value == index
                              ? Colors.white
                              : Colors.white54,
                        ),
                ),
              ),
              controller.index.value == index
                  ? Align(
                      alignment: controller.index.value == 3
                          ? Alignment.center
                          : Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: controller.index.value == 3 ? 8.0 : 00),
                        child: Transform.translate(
                          offset: Offset((5 - index).toDouble(), 0.0),
                          child: Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _getBottomNavigationIcon(String image, int index, int selectedIndex) {
    return InkWell(
      onTap: () => controller.setBottomNavigationIndex(index),
      child: Transform.translate(
        offset: Offset(0, index == selectedIndex ? 1.5 : 3.0),
        child: ClayContainer(
          width: kBottomNavigationBarHeight - 20,
          height: kBottomNavigationBarHeight - 20,
          depth: 30,
          spread: 2.0,
          emboss: index != selectedIndex,
          color: index != selectedIndex
              ? Color(0xFF22252A).withOpacity(.2)
              : Color(0xFF1C1F22),
          borderRadius: 100.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              image,
              color: Color(0xFF74797D),
            ),
          ),
        ),
      ),
    );
  }
}
