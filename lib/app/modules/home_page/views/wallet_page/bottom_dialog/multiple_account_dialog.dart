import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:majascan/majascan.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_icon.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/modules/walkthrough/controllers/walkthrough_controller.dart';
import 'package:tezster_wallet/app/modules/walkthrough/views/createWallet/recovery_phrase_view.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/firebase_analytics/firebase_analytics.dart';
import 'package:tezster_wallet/app/utils/operations_utils/operations_utils.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/utils/utils.dart';

class MultipleAccountDialog extends StatefulWidget {
  final HomePageController controller;

  MultipleAccountDialog(this.controller);

  @override
  _MultipleAccountDialogState createState() => _MultipleAccountDialogState();
}

class _MultipleAccountDialogState extends State<MultipleAccountDialog> {
  TextEditingController editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: 20.0, left: 24, right: 24),
        decoration: BoxDecoration(
          color: dialogBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              20,
            ),
            topRight: Radius.circular(
              20,
            ),
            bottomRight: Radius.circular(
              0,
            ),
            bottomLeft: Radius.circular(
              0,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 15.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Image.asset(
                      "assets/multiple_account/select_account.png",
                      height: 28,
                      width: 28,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GradientText(
                        "Accounts",
                        gradient: gradientBackground,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: Get.width * 0.9,
              height: 1,
              color: Colors.white.withOpacity(
                0.04,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.25,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(widget.controller.accounts.length,
                        (index) {
                      CommonFunction.roundUpDollar(
                          (((int.parse(widget.controller.balance.value) +
                                      widget.controller.tokenXtzBalance.value) /
                                  1000000) *
                              widget.controller.dollerValue.value));
                      String address =
                          widget.controller.accounts[index]['publicKeyHash'];
                      address = address.substring(0, 3) +
                          "..." +
                          address.substring(address.length - 3, address.length);
                      return GestureDetector(
                        onTap: () async {
                          widget.controller.storage.currentAccountIndex = index;
                          widget.controller.accoutnName.value = widget
                                  .controller.accounts[index]
                                  .containsKey('name')
                              ? widget.controller.accounts[index]['name']
                              : 'Account ${index + 1}';
                          widget.controller.pkH.value = widget
                                  .controller
                                  .storage
                                  .accounts[widget.controller.storage.provider][
                              widget.controller.storage
                                  .currentAccountIndex]['publicKeyHash'];

                          //when nft gallery is selected we need to redirect to the nft tab and remove bottom nav bar
                          if (widget.controller.accounts.value.length > 0 &&
                              widget
                                      .controller
                                      .accounts
                                      .value[widget.controller.storage
                                          .currentAccountIndex]['secretKey']
                                      .length ==
                                  0) {
                            widget.controller.isNftSelected.value = true;
                            //redirecting to the nft gallery tab
                            widget.controller.index.value = 2;
                          } else {
                            // reset the nav bar visibility if normal account is selected
                            widget.controller.isNftSelected.value = false;
                          }

                          // after changing account, we need to reset the sliver app bar text fonts and opacity to fix account names being shown twice on the app bar
                          //walletPage
                          widget.controller.opacityHomePage.value = 0;
                          widget.controller.fontSizeHomePage.value = 24;
                          //nftPage
                          widget.controller.opacityNFT.value = 0;
                          widget.controller.fontSizeNFT.value = 24;
                          //settingPage
                          widget.controller.opacitySettings.value = 0;
                          widget.controller.fontSizeSettings.value = 24;

                          await StorageUtils()
                              .postStorage(widget.controller.storage);
                          Navigator.pop(context);
                          // Navigator.pop(parentKeyContext);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Container(
                            height: 70,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: widget.controller.storage
                                            .currentAccountIndex ==
                                        index
                                    ? Color(0xff1e1e1e)
                                    : Colors.transparent,
                                border: Border.all(color: Color(0xff282A30))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      String prevName = widget
                                              .controller.accounts[index]
                                              .containsKey('name')
                                          ? widget.controller.accounts[index]
                                              ['name']
                                          : 'Account ${index + 1}';
                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              contentPadding: EdgeInsets.all(0),
                                              backgroundColor:
                                                  Colors.transparent,
                                              content: Container(
                                                // height: 260,
                                                width: 300,
                                                padding: EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: gradientBackground,
                                                ),
                                                child: Container(
                                                  // height: 198,
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff1E1E1E),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 4.0),
                                                            child: GradientIcon(
                                                              child: Icon(
                                                                Icons
                                                                    .edit_outlined,
                                                                size: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 12,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                GradientText(
                                                                  "Edit",
                                                                  gradient:
                                                                      gradientBackground,
                                                                  textStyle:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  "Change the name of your account",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              widget.controller
                                                                              .accounts[
                                                                          index]
                                                                      ['name'] =
                                                                  prevName;
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .close_rounded,
                                                              color: Color(
                                                                  0xff8E8E95),
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
                                                        color: Colors.white
                                                            .withOpacity(0.04),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      TextField(
                                                        autofocus: true,
                                                        maxLength: 10,
                                                        controller: editTextController
                                                          ..text = widget
                                                                  .controller
                                                                  .accounts[
                                                                      index]
                                                                  .containsKey(
                                                                      'name')
                                                              ? widget.controller
                                                                      .accounts[
                                                                  index]['name']
                                                              : 'Account ${index + 1}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.all(0),
                                                          isDense: true,
                                                          counter: Container(),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        onSubmitted: (s) async {
                                                          if (s.isEmpty) return;
                                                          var name = s;
                                                          widget.controller
                                                                      .accounts[
                                                                  index]
                                                              ['name'] = name;
                                                          widget
                                                                      .controller
                                                                      .storage
                                                                      .accounts[
                                                                  widget
                                                                      .controller
                                                                      .storage
                                                                      .provider] =
                                                              widget.controller
                                                                  .accounts;
                                                          await StorageUtils()
                                                              .postStorage(widget
                                                                  .controller
                                                                  .storage);
                                                          widget.controller
                                                                  .storage =
                                                              await StorageUtils()
                                                                  .getStorage();
                                                          if (widget
                                                                  .controller
                                                                  .storage
                                                                  .currentAccountIndex ==
                                                              index)
                                                            widget
                                                                .controller
                                                                .accoutnName
                                                                .value = name;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 28,
                                                      ),
                                                      CustomAnimatedActionButton(
                                                        "Save",
                                                        true,
                                                        () async {
                                                          var name =
                                                              editTextController
                                                                  .text;
                                                          widget.controller
                                                                      .accounts[
                                                                  index]
                                                              ['name'] = name;
                                                          widget
                                                                      .controller
                                                                      .storage
                                                                      .accounts[
                                                                  widget
                                                                      .controller
                                                                      .storage
                                                                      .provider] =
                                                              widget.controller
                                                                  .accounts;
                                                          await StorageUtils()
                                                              .postStorage(widget
                                                                  .controller
                                                                  .storage);
                                                          widget.controller
                                                                  .storage =
                                                              await StorageUtils()
                                                                  .getStorage();
                                                          if (widget
                                                                  .controller
                                                                  .storage
                                                                  .currentAccountIndex ==
                                                              index)
                                                            widget
                                                                .controller
                                                                .accoutnName
                                                                .value = name;
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        width: Get.width * 0.6,
                                                        fontSize: 14.0,
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          deleteAccountMultipleAccount(
                                                              context,
                                                              widget.controller,
                                                              index);
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          child: Center(
                                                            child: Text(
                                                              "Delete account",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xffC4C4C4),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                      setState(() {});
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              widget.controller.accounts[index]
                                                      .containsKey('name')
                                                  ? widget.controller
                                                      .accounts[index]['name']
                                                  : 'Account ${index + 1}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 6.0),
                                              child: Icon(
                                                Icons.edit_outlined,
                                                color: Color(0xff6B6D70),
                                                size: 20.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6.0,
                                        ),
                                        Row(
                                          children: [
                                            widget
                                                        .controller
                                                        .accounts[index]
                                                            ['secretKey']
                                                        .length >
                                                    0
                                                ? SvgPicture.asset(
                                                    "assets/multiple_account/dollar.svg",
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                              width: widget
                                                          .controller
                                                          .accounts[index]
                                                              ['secretKey']
                                                          .length >
                                                      0
                                                  ? 8
                                                  : 0,
                                            ),
                                            SvgPicture.asset(
                                              "assets/multiple_account/gallery.svg",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Clipboard.setData(ClipboardData(
                                        text: widget.controller.accounts[index]
                                            ['publicKeyHash'],
                                      ));
                                      Fluttertoast.showToast(
                                        msg: "Copied",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  address,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 6.0,
                                                ),
                                                widget.controller.accounts[
                                                                    index]
                                                                ['secretKey'] !=
                                                            null &&
                                                        widget
                                                            .controller
                                                            .accounts[index]
                                                                ['secretKey']
                                                            .toString()
                                                            .isNotEmpty
                                                    ? FutureBuilder(
                                                        key: ValueKey(index),
                                                        future: TezsterDart.getBalance(
                                                            widget.controller
                                                                        .accounts[
                                                                    index][
                                                                'publicKeyHash'],
                                                            StorageUtils.rpc[
                                                                widget
                                                                    .controller
                                                                    .storage
                                                                    .provider]),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                          return Text(
                                                            snapshot.data !=
                                                                    null
                                                                ? (int.parse(snapshot.data) /
                                                                            1e6)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    ' tez'
                                                                : r"0.00 tez",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12.0,
                                                              color: Color(
                                                                  0xff6B6D70),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 12.0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Icon(
                                                Icons.copy_outlined,
                                                color: Color(0xff6B6D70),
                                                size: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Container(
              width: Get.width * 0.9,
              height: 1,
              margin: EdgeInsets.only(
                top: 10,
              ),
              color: Colors.white.withOpacity(
                0.04,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () async {
                var currentAccountIndex =
                    widget.controller.storage.currentAccountIndex;
                widget.controller.createAccountEditingController.value.text =
                    await getValidAccountName();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async {
                        widget.controller.createAccountEditingController.value
                            .text = "";
                        return true;
                      },
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
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
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: GradientIcon(
                                            child: Icon(
                                              Icons.add_rounded,
                                              size: 30.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GradientText(
                                                "Create",
                                                gradient: gradientBackground,
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "Enter a name for your new account",
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
                                            Icons.close_rounded,
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
                                      height: 28,
                                    ),
                                    TextField(
                                      autofocus: true,
                                      controller: widget.controller
                                          .createAccountEditingController.value,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Enter name",
                                        hintStyle: TextStyle(
                                          color: Color(0xff6B6D70),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        contentPadding: EdgeInsets.all(0),
                                        isDense: true,
                                        counter: Container(),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (s) {
                                        setState(() {});
                                      },
                                    ),
                                    SizedBox(
                                      height: 28,
                                    ),
                                    CustomAnimatedActionButton(
                                      "Create account",
                                      widget
                                                  .controller
                                                  .createAccountEditingController
                                                  .value
                                                  .text
                                                  .length >
                                              2 &&
                                          widget
                                                  .controller
                                                  .createAccountEditingController
                                                  .value
                                                  .text
                                                  .length <
                                              11,
                                      () async {
                                        bool isSameAccountName = false;
                                        if (widget
                                                    .controller
                                                    .createAccountEditingController
                                                    .value
                                                    .text
                                                    .length <
                                                3 ||
                                            widget
                                                    .controller
                                                    .createAccountEditingController
                                                    .value
                                                    .text
                                                    .length >
                                                10) return;
                                        widget
                                            .controller
                                            .storage
                                            .accounts[widget
                                                .controller.storage.provider]
                                            .forEach((e) {
                                          if (e['name'] ==
                                              widget
                                                  .controller
                                                  .createAccountEditingController
                                                  .value
                                                  .text) {
                                            Fluttertoast.showToast(
                                              msg:
                                                  "Same account name already exists",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                            isSameAccountName = true;
                                          }
                                        });
                                        if (!isSameAccountName) {
                                          var account = await OperationUtils()
                                              .createNewWalletProccess(
                                                  false,
                                                  widget
                                                      .controller
                                                      .createAccountEditingController
                                                      .value
                                                      .text);

                                          // widget.controller.storage =
                                          //     await StorageUtils().getStorage();
                                          if (widget
                                                  .controller.storage.accounts[
                                              widget.controller.storage
                                                  .provider] is RxList) {
                                            widget.controller.accounts.value =
                                                widget
                                                    .controller
                                                    .storage
                                                    .accounts[widget.controller
                                                        .storage.provider]
                                                    .value;
                                          } else {
                                            widget.controller.accounts.value =
                                                widget.controller.storage
                                                        .accounts[
                                                    widget.controller.storage
                                                        .provider];
                                          }
                                          widget.controller.accoutnName
                                              .value = widget
                                                  .controller
                                                  .accounts[widget
                                                      .controller
                                                      .storage
                                                      .currentAccountIndex]
                                                  .containsKey('name')
                                              ? widget.controller.accounts[
                                                      widget.controller.storage
                                                          .currentAccountIndex]
                                                  ['name']
                                              : 'Account ${widget.controller.storage.currentAccountIndex + 1}';
                                          widget.controller.pkH.value =
                                              widget.controller.storage
                                                          .accounts[
                                                      widget.controller.storage
                                                          .provider][widget
                                                      .controller
                                                      .storage
                                                      .currentAccountIndex]
                                                  ['publicKeyHash'];
                                          //new account created is not a nft account, hence re-assigning isNftSelected to false
                                          widget.controller.isNftSelected
                                              .value = false;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  RecoveryPhraseView(
                                                account,
                                                Get.put(
                                                    WalkthroughController()),
                                                isFromMultiAccountPopup: true,
                                              ),
                                            ),
                                          ).then((value) {
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                      fontSize: 14.0,
                                      width: Get.width * 0.7,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(Routes.RECOVER_WALLET);
                                      },
                                      child: Container(
                                        height: 32,
                                        child: Center(
                                          child: Text(
                                            "Import account",
                                            style: TextStyle(
                                              color: Color(0xffC4C4C4),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ).then((value) {
                  widget.controller.createAccountEditingController.value.text =
                      '';
                  if (currentAccountIndex !=
                      widget.controller.storage.currentAccountIndex)
                    Navigator.pop(context);
                });
              },
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
                    width: 15.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        "Add Account",
                        gradient: gradientBackground,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Create or import a new account",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: Get.width * 0.9,
              height: 1,
              color: Colors.white.withOpacity(
                0.04,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                var currentAccountIndex =
                    widget.controller.storage.currentAccountIndex;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async {
                        widget.controller.editGalaryTextController.value.text =
                            "";
                        return true;
                      },
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
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
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: GradientIcon(
                                            child: Icon(
                                              Icons.add_rounded,
                                              size: 30.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GradientText(
                                                "Add Gallery",
                                                gradient: gradientBackground,
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "Enter the Tezos address of the gallery",
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
                                            widget
                                                .controller
                                                .editGalaryTextController
                                                .value
                                                .text = "";
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            Icons.close_rounded,
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
                                      height: 28,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            autofocus: true,
                                            controller: widget.controller
                                                .editGalaryTextController.value,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.0,
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: "e.g. tz1abc...",
                                              hintStyle: TextStyle(
                                                color: Color(0xff6B6D70),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              contentPadding: EdgeInsets.all(0),
                                              isDense: true,
                                              counter: Container(),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (s) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              String reciverPkHash =
                                                  await MajaScan.startScan(
                                                      title: "Scan address",
                                                      flashlightEnable: true,
                                                      scanAreaScale: 0.7);
                                              if (CommonFunction
                                                      .isValidTzOrKTAddress(
                                                          reciverPkHash) &&
                                                  reciverPkHash.isNotEmpty) {
                                                widget
                                                    .controller
                                                    .editGalaryTextController
                                                    .value
                                                    .text = reciverPkHash;
                                              }
                                            },
                                            child: SvgPicture.asset(
                                              "assets/send_xtz/qr_code.svg",
                                              color: Colors.white30,
                                              height: 18,
                                              width: 18,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 28,
                                    ),
                                    CustomAnimatedActionButton(
                                      "Add",
                                      CommonFunction.isValidTzOrKTAddress(widget
                                          .controller
                                          .editGalaryTextController
                                          .value
                                          .text),
                                      () async {
                                        if (!CommonFunction
                                            .isValidTzOrKTAddress(widget
                                                .controller
                                                .editGalaryTextController
                                                .value
                                                .text)) return;
                                        bool isSameAccount = false;
                                        StorageModel _storgeModel =
                                            await StorageUtils().getStorage();
                                        _storgeModel
                                            .accounts[_storgeModel.provider]
                                            .forEach((acc) {
                                          if (acc['publicKeyHash'] ==
                                              widget
                                                  .controller
                                                  .editGalaryTextController
                                                  .value
                                                  .text
                                                  .trim()) {
                                            isSameAccount = true;
                                            Navigator.pop(context);
                                            return;
                                          }
                                        });
                                        if (isSameAccount) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Same account can't be imported again",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                          return;
                                        }
                                        var account = {
                                          "seed": '',
                                          "derivationPath": '',
                                          "publicKey": '',
                                          "secretKey": '',
                                          "publicKeyHash": widget
                                              .controller
                                              .editGalaryTextController
                                              .value
                                              .text
                                              .trim(),
                                          "password": "",
                                          "name":
                                              "Account ${widget.controller.storage.accounts[widget.controller.storage.provider].length + 1}"
                                        };
                                        var keys =
                                            _storgeModel.accounts.keys.toList();
                                        keys.forEach((element) {
                                          _storgeModel.accounts[element]
                                              .add(account);
                                        });

                                        _storgeModel
                                            .currentAccountIndex = _storgeModel
                                                .accounts[_storgeModel.provider]
                                                .length -
                                            1;
                                        widget.controller.accoutnName.value =
                                            account['name'];
                                        widget.controller.pkH.value =
                                            account['publicKeyHash'];

                                        widget.controller.isNftSelected.value =
                                            true;
                                        //redirecting to the nft gallery tab
                                        widget.controller.index.value = 2;

                                        tempModel = _storgeModel;
                                        widget.controller.accounts.value =
                                            tempModel
                                                .accounts[tempModel.provider];
                                        widget.controller.storage = tempModel;
                                        FireAnalytics()
                                            .logEvent("import_gallery_clicked");
                                        await StorageUtils()
                                            .postStorage(tempModel);
                                        Navigator.pop(context);
                                      },
                                      width: Get.width * 0.7,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ).then((value) {
                  widget.controller.editGalaryTextController.value.text = '';
                  if (currentAccountIndex !=
                      widget.controller.storage.currentAccountIndex)
                    Navigator.pop(context);
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: GradientIcon(
                      child: Icon(
                        Icons.download_rounded,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        "Import Gallery",
                        gradient: gradientBackground,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Add any gallery, even of others! ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
