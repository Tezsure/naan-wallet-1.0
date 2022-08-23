import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_icon.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

unpairAccountPopup(BuildContext context, HomePageController homePageController,
    bool deleteAllAccount,
    {int index}) {
  bool isSelectedOne = false;
  bool isSelectedTwo = false;
  showDialog(
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
                  color: Color(0xff1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientIcon(
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GradientText(
                                "Unpair wallet",
                                gradient: gradientBackground,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Permanently unpair your account",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: Color(0xff8E8E95),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 1,
                      width: Get.width,
                      color: Colors.white.withOpacity(0.04),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        customCheckbox(isSelectedOne, () {
                          setState(() {
                            isSelectedOne = !isSelectedOne;
                          });
                        }, "I have a secure backup of my\nrecovery phrase."),
                        SizedBox(
                          height: 20,
                        ),
                        customCheckbox(isSelectedTwo, () {
                          setState(() {
                            isSelectedTwo = !isSelectedTwo;
                          });
                        }, "I confirm that this action cannot\nbe undone."),
                      ],
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    CustomAnimatedActionButton(
                      isSelectedOne && isSelectedTwo
                          ? "Remove account"
                          : "Check both boxes",
                      isSelectedOne && isSelectedTwo,
                      () async {
                        if ((isSelectedOne &&
                                isSelectedTwo &&
                                deleteAllAccount) ||
                            (isSelectedOne &&
                                isSelectedTwo &&
                                homePageController
                                        .storage
                                        .accounts[
                                            homePageController.storage.provider]
                                        .length ==
                                    1)) {
                          FireAnalytics().logEvent("unpair_wallet_confirmed",
                              addTz1: true);
                          await StorageUtils().postStorage(StorageModel());
                          Get.offAllNamed(Routes.WALKTHROUGH);
                        } else if (isSelectedOne &&
                            isSelectedTwo &&
                            !deleteAllAccount) {
                          int newIndex =
                              homePageController.storage.currentAccountIndex;
                          if (index == newIndex) {
                            if (index != 0) {
                              newIndex = 0;
                            }
                          }
                          homePageController.storage
                              .accounts[homePageController.storage.provider]
                              .removeAt(index);
                          homePageController.accounts.value = homePageController
                              .storage
                              .accounts[homePageController.storage.provider];
                          homePageController
                              .accoutnName.value = homePageController.storage
                                  .accounts[homePageController.storage.provider]
                              [newIndex]['name'];
                          homePageController.storage.currentAccountIndex =
                              newIndex;
                          homePageController.pkH.value = homePageController
                                  .storage
                                  .accounts[homePageController.storage.provider]
                              [homePageController.storage
                                  .currentAccountIndex]['publicKeyHash'];
                          await StorageUtils()
                              .postStorage(homePageController.storage);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                      width: Get.width * 0.7,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

deleteAccountMultipleAccount(
    BuildContext context, HomePageController controller, int index) {
  bool isSelectedOne = false;
  bool isSelectedTwo = false;
  showDialog(
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
                  color: Color(0xff1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GradientIcon(
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GradientText(
                                "Unpair wallet",
                                gradient: gradientBackground,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Permanently unpair your account",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: Color(0xff8E8E95),
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 1,
                      width: Get.width,
                      color: Colors.white.withOpacity(0.04),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        customCheckbox(isSelectedOne, () {
                          setState(() {
                            isSelectedOne = !isSelectedOne;
                          });
                        }, "I have a secure backup of my\nrecovery phrase."),
                        SizedBox(
                          height: 20,
                        ),
                        customCheckbox(isSelectedTwo, () {
                          setState(() {
                            isSelectedTwo = !isSelectedTwo;
                          });
                        }, "I confirm that this action cannot\nbe undone."),
                      ],
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    CustomAnimatedActionButton(
                      isSelectedOne && isSelectedTwo
                          ? "Remove account"
                          : "Check both boxes",
                      isSelectedOne && isSelectedTwo,
                      () async {
                        if (!isSelectedOne || !isSelectedTwo) return;
                        // if user deletes curent selected account then we auto select the first account as default
                        if (controller.storage.currentAccountIndex == index &&
                            controller.storage.currentAccountIndex != 0) {
                          controller.storage.currentAccountIndex = 0;
                          controller.accoutnName.value =
                              controller.accounts[0]['name'];
                          controller.pkH.value =
                              controller.storage
                                          .accounts[controller.storage.provider]
                                      [controller.storage.currentAccountIndex]
                                  ['publicKeyHash'];

                          //if the 0th index account is a gallery account then remove bottom nav bar
                          if (controller.accounts.value.length > 0 &&
                              controller
                                      .accounts
                                      .value[controller.storage
                                          .currentAccountIndex]['secretKey']
                                      .length ==
                                  0) {
                            controller.isNftSelected.value = true;
                            //redirecting to the nft gallery tab
                            controller.index.value = 2;
                          } else {
                            // reset the nav bar visibility if normal account is selected
                            controller.isNftSelected.value = false;
                          }
                        }

                        controller.accounts.removeAt(index);
                        controller
                                .storage.accounts[controller.storage.provider] =
                            controller.accounts;

                        if (controller.storage
                                .accounts[controller.storage.provider].length ==
                            0) {
                          await StorageUtils().postStorage(StorageModel());
                          Get.offAllNamed(Routes.WALKTHROUGH);
                          return;
                        }
                        StorageUtils().postStorage(controller.storage);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      width: Get.width * 0.7,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget customCheckbox(bool isSelected, Function onTap, String text) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
          ),
          Container(
            height: 14,
            width: 14,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? gradientBackground
                  : LinearGradient(colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Center(
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? gradientBackground
                      : LinearGradient(
                          colors: [Color(0xff1E1E1E), Color(0xff1E1E1E)]),
                ),
                child: Center(
                  child: Icon(
                    Icons.done,
                    size: 12,
                    color: Color(0xff1E1E1E),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget customCircularCheckBox(bool isSelected, Function onTap, String text,
    {TextStyle style}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            height: 15,
            width: 15,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: gradientBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1e1e1e),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? gradientBackground
                      : LinearGradient(
                          colors: [Color(0xff1e1e1e), Color(0xff1e1e1e)]),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              text,
              style: style ??
                  TextStyle(
                    color: Color(0xff8E8E95),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget infoUI({String headLine, @required String info}) {
  return Container(
    width: Get.width * 0.9,
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Color(0xff1E1E1E),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headLine != null && headLine.length > 0
            ? Text(
                headLine,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              )
            : SizedBox(),
        headLine != null && headLine.length > 0
            ? SizedBox(
                height: 4,
              )
            : SizedBox(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Icon(
                Icons.error,
                color: Color(0xff616161),
                size: 12,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                info,
                style: TextStyle(
                  color: Color(0xff616161),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
