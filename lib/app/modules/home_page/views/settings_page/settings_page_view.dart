import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:tezster_wallet/app/modules/baker_delegation/views/baker_delegation_view.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/baker_delegation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/common/widgets/loading_widget.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/modules/home_page/views/commonWidget/widgets.dart';
import 'package:tezster_wallet/app/modules/home_page/views/wallet_page/bottom_dialog/multiple_account_dialog.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class SettingsPageView extends StatefulWidget {
  HomePageController controller;
  SettingsPageView({@required this.controller});

  @override
  _SettingsPageViewState createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  @override
  void initState() {
    super.initState();
    widget.controller.scrollControllerSettings.value
        .addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.controller.opacitySettings.value = 0;
    widget.controller.fontSizeSettings.value = 24;
    super.dispose();
  }

  void _scrollListener() {
    if (widget.controller.scrollControllerSettings.value.offset ==
        widget.controller.scrollControllerSettings.value.position
            .maxScrollExtent) {
      if (widget.controller.scrollControllerSettings.value.position.pixels >
          85) {
        if (widget.controller.scrollControllerSettings.value.position.pixels -
                85 >
            39) {
          widget.controller.opacitySettings.value = 1;
        } else {
          widget.controller.opacitySettings.value = 0 +
              (widget.controller.scrollControllerSettings.value.position
                          .pixels -
                      85) *
                  (1 - 0) /
                  (125 - 85);
        }
      } else {
        widget.controller.opacitySettings.value = 0;
      }

      if (widget.controller.scrollControllerSettings.value.position.pixels <=
          0) {
        widget.controller.fontSizeSettings.value = 24;
      } else if (widget
              .controller.scrollControllerSettings.value.position.pixels <
          125) {
        widget.controller.fontSizeSettings.value = 24 -
            (widget.controller.scrollControllerSettings.value.position.pixels -
                    0) *
                (24 - 18) /
                (124 - 0);
      } else {
        widget.controller.fontSizeSettings.value = 18;
      }
    } else {
      if (widget.controller.scrollControllerSettings.value.position.pixels >
          85) {
        if (widget.controller.scrollControllerSettings.value.position.pixels -
                85 >
            39) {
          widget.controller.opacitySettings.value = 1;
        } else {
          widget.controller.opacitySettings.value = 0 +
              (widget.controller.scrollControllerSettings.value.position
                          .pixels -
                      85) *
                  (1 - 0) /
                  (125 - 85);
        }
      } else {
        widget.controller.opacitySettings.value = 0;
      }
      if (widget.controller.scrollControllerSettings.value.position.pixels <=
          0) {
        widget.controller.fontSizeSettings.value = 24;
      } else if (widget
              .controller.scrollControllerSettings.value.position.pixels <
          125) {
        widget.controller.fontSizeSettings.value = 24 -
            (widget.controller.scrollControllerSettings.value.position.pixels -
                    0) *
                (24 - 18) /
                (124 - 0);
      } else {
        widget.controller.fontSizeSettings.value = 18;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      widget.controller.privateKey_SeedPhrase.value = widget.controller.storage
                          .accounts[widget.controller.storage.provider]
                      [widget.controller.storage.currentAccountIndex]['seed'] ==
                  null ||
              widget
                  .controller
                  .storage
                  .accounts[widget.controller.storage.provider]
                      [widget.controller.storage.currentAccountIndex]['seed']
                  .toString()
                  .isEmpty
          ? "Private Key"
          : "Recovery Phrase";
    } catch (e) {
      widget.controller.privateKey_SeedPhrase.value = "Private Key";
      print(e);
      FirebaseCrashlytics.instance.log("SettingsPage: ${e.toString()}");
    }
    return CustomScrollView(
      controller: widget.controller.scrollControllerSettings.value,
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
                  widget.controller.opacitySettings.value == 0
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Opacity(
                            opacity: widget.controller.opacitySettings.value,
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
                        child: GradientText(
                          "Settings",
                          gradient: gradientBackground,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: widget.controller.fontSizeSettings.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                  widget.controller.opacitySettings.value == 0
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(right: 20.0, top: 12),
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
                                MultipleAccountDialog(widget.controller))
                        .then((value) {
                      widget.controller.getDeligator();
                      widget.controller.privateKey_SeedPhrase.value = widget
                                          .controller
                                          .storage
                                          .accounts[widget.controller.storage.provider]
                                      [widget.controller.storage
                                          .currentAccountIndex]['seed'] ==
                                  null ||
                              widget
                                  .controller
                                  .storage
                                  .accounts[widget.controller.storage.provider]
                                      [widget.controller.storage.currentAccountIndex]
                                      ['seed']
                                  .toString()
                                  .isEmpty
                          ? "Private Key"
                          : "Recovery Phrase";
                    });
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
            delegate: SliverChildListDelegate(
          [
            SizedBox(
              height: 20.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => _getContainerBox(
                      child: _getItemContainerWithSubTitle("Baker Delegation",
                          "delatorLoading", "assets/settings/baker.png"),
                      onTap: () {
                        if (widget.controller.isFetchingDelegate.value) return;
                        bakerDelegationPopup(context, bakerController,
                            widget.controller, widget.controller.delegate.value,
                            name: widget.controller.name.value,
                            url: widget.controller.imageUrl.value);
                      }),
                ),
                SizedBox(
                  height: 13.0,
                ),
                _getContainerBox(
                  child: _getItemContainerWithSubTitle(
                      "Private Key", "", "assets/settings/seed_phrase.png"),
                  onTap: () async {
                    final localAuth = LocalAuthentication();
                    if (await localAuth.isDeviceSupported()) {
                      final didAuthenticate = await localAuth.authenticate(
                          localizedReason: 'Please authenticate');
                      if (didAuthenticate) {
                        Navigator.of(context).pushNamed(
                          Routes.REVEAL_SEED_PHRASE,
                          arguments: true,
                        );
                      }
                    } else {
                      Navigator.of(context).pushNamed(Routes.REVEAL_SEED_PHRASE,
                          arguments: widget.controller.storage
                                          .accounts[widget.controller.storage.provider]
                                      [widget.controller.storage
                                          .currentAccountIndex]['seed'] ==
                                  null ||
                              widget
                                  .controller
                                  .storage
                                  .accounts[widget.controller.storage.provider]
                                      [widget.controller.storage.currentAccountIndex]
                                      ['seed']
                                  .toString()
                                  .isEmpty);
                    }
                  },
                ),
                Obx(() {
                  if (widget.controller.privateKey_SeedPhrase.value ==
                      "Recovery Phrase")
                    return Column(
                      children: [
                        SizedBox(
                          height: 13,
                        ),
                        _getContainerBox(
                          child: _getItemContainerWithSubTitle(
                              widget.controller.privateKey_SeedPhrase.value,
                              "",
                              "assets/settings/seed_phrase.png"),
                          onTap: () async {
                            final localAuth = LocalAuthentication();
                            if (await localAuth.isDeviceSupported()) {
                              final didAuthenticate =
                                  await localAuth.authenticate(
                                      localizedReason: 'Please authenticate');
                              if (didAuthenticate) {
                                Navigator.of(context).pushNamed(
                                  Routes.REVEAL_SEED_PHRASE,
                                  arguments: false,
                                );
                              }
                            } else {
                              Navigator.of(context).pushNamed(Routes.REVEAL_SEED_PHRASE,
                                  arguments: widget.controller.storage.accounts[
                                                      widget.controller.storage
                                                          .provider]
                                                  [widget.controller.storage.currentAccountIndex]
                                              ['seed'] ==
                                          null ||
                                      widget
                                          .controller
                                          .storage
                                          .accounts[widget.controller.storage.provider]
                                              [widget.controller.storage.currentAccountIndex]
                                              ['seed']
                                          .toString()
                                          .isEmpty);
                            }
                          },
                        )
                      ],
                    );
                  else
                    return SizedBox();
                }),
                SizedBox(
                  height: 13.0,
                ),
                _getContainerBox(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) =>
                            changeNetworkBottomSheet(
                          controller: widget.controller,
                          index: widget.controller.storage.provider == "mainnet"
                              ? 0
                              : 1,
                        ),
                      );
                    },
                    child: _getItemContainerWithSubTitle(
                        "Change Network",
                        widget.controller.storage.provider == "mainnet"
                            ? "Mainnet"
                            : "Testnet",
                        "assets/settings/network.png"),
                  ),
                ),
                SizedBox(
                  height: 13.0,
                ),
                _getContainerBox(
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) =>
                            changeNodeBottomSheet(widget.controller),
                      );
                    },
                    child: _getItemContainerWithSubTitle(
                        "Node Selector",
                        widget.controller.storage.provider == "mainnet"
                            ? "Mainnet"
                            : "Testnet",
                        "assets/settings/network.png"),
                  ),
                ),
                SizedBox(
                  height: 13.0,
                ),
                _getHeader(
                  "Social",
                ),
                SizedBox(
                  height: 13.0,
                ),
                _getContainerBox(
                  child: _getItemContainerWithSubTitle(
                      "Share naan", "", "assets/walkthrough/logo.png"),
                  onTap: () {
                    Share.share(
                        "👋 Hey friend! You should download naan, it's my favorite Tezos wallet to buy Tez, send transactions, connecting to Dapps and exploring NFT gallery of anyone. https://naanwallet.com");
                  },
                ),
                SizedBox(
                  height: 13.0,
                ),
                _getContainerBox(
                  child: _getItemContainerWithSubTitle(
                      "Follow us on Twitter", "", "assets/wallet/twitter.png"),
                  onTap: () async {
                    launch("https://twitter.com/Naanwallet");
                  },
                ),
                SizedBox(
                  height: 13.0,
                ),
                _getContainerBox(
                  child: _getItemContainerWithSubTitle(
                      "Join our Discord", "", "assets/wallet/discord.png"),
                  onTap: () async {
                    launch("https://discord.gg/wpcNRsBbxy");
                  },
                ),
                SizedBox(
                  height: 13.0,
                ),
                _getContainerBox(
                  child: _getItemContainerWithSubTitle(
                      "Feedback & support", "", "assets/wallet/feedback.png"),
                  onTap: () async {
                    launch("mailto:naan-support@tezsure.com");
                  },
                ),
                SizedBox(
                  height: 13.0,
                ),
                _getHeader(
                  "About",
                ),
                SizedBox(
                  height: 13.0,
                ),
                GestureDetector(
                  onTap: () => CommonFunction.launchURL(
                    "https://www.naanwallet.com/privacy-policy.html",
                  ),
                  child: _getContainerBox(
                    child: _getItemContainerWithIcon(
                      "Privacy Policy",
                    ),
                  ),
                ),
                SizedBox(
                  height: 13.0,
                ),
                GestureDetector(
                  onTap: () => CommonFunction.launchURL(
                    "https://www.naanwallet.com/terms.html",
                  ),
                  child: _getContainerBox(
                    child: _getItemContainerWithIcon(
                      "Terms & Conditions",
                    ),
                  ),
                ),
                SizedBox(
                  height: 13.0,
                ),
                _getHeader(
                  "Other",
                ),
                SizedBox(
                  height: 13.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.RECOVER_WALLET);
                  },
                  child: infoUI(
                      info:
                          "Import an account using a recovery phrase, private key, or Cloud backup.",
                      headLine: "Import account"),
                ),
                SizedBox(
                  height: 13.0,
                ),
                GestureDetector(
                  onTap: () {
                    unpairAccountPopup(context, widget.controller, true);
                  },
                  child: infoUI(
                      info:
                          "Your funds will not be lost, but you will need to import your recovery phrase or any other device to restore access.",
                      headLine: "Unpair your wallet from this device"),
                ),
                SizedBox(
                  height: 13.0,
                ),
              ],
            ),
          ],
        )),
      ],
    );
  }

  showBottomSheetDialog(context) async {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) =>
          EnterBakerDelgationDialog(widget.controller.delegate.value ?? ""),
    );
  }

  Widget _getHeader(String s) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: Get.width * 0.9,
        child: Text(
          s,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(
              0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getContainerBox({Widget child, onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: Get.width * 0.9,
        decoration: BoxDecoration(
          color: Color(0xff1E1E1E),
          borderRadius: BorderRadius.all(
            Radius.circular(
              10.0,
            ),
          ),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _getItemContainerWithIcon(String text) {
    return Container(
      margin: EdgeInsets.only(
        left: 20.0,
      ),
      height: 55.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 25.0,
            ),
            SvgPicture.asset(
              "assets/settings/share.svg",
            ),
          ],
        ),
      ),
    );
  }

  Widget _getItemContainerWithSubTitle(
      String text, String text1, String image) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 46.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Image.asset(
              image,
              height: 20,
              width: 20,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ),
            (text1 == "delatorLoading" &&
                    widget.controller.isFetchingDelegate.value)
                ? LoaderWidget(
                    height: 40.0,
                  )
                : text1 == "delatorLoading" &&
                        widget.controller.name.value.length > 0 &&
                        widget.controller.storage.provider == "mainnet"
                    ? Row(
                        children: [
                          Text(
                            widget.controller.name.value,
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Color(0xff6A6B6E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              widget.controller.imageUrl.value,
                              height: 12,
                              width: 12,
                            ),
                          ),
                        ],
                      )
                    : text1 == "delatorLoading" &&
                            widget.controller.delegate.value.length > 0 &&
                            widget.controller.name.value.length == 0 &&
                            widget.controller.storage.provider == "mainnet"
                        ? Text(
                            widget.controller.delegate.value.substring(0, 3) +
                                "..." +
                                widget.controller.delegate.value.substring(
                                    widget.controller.delegate.value.length - 3,
                                    widget.controller.delegate.value.length),
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Color(0xff6A6B6E),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : Text(
                            text1 == "delatorLoading" ? "" : text1,
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff6A6B6E),
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}
