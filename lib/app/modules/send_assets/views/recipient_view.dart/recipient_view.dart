import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:majascan/majascan.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_icon.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/send_assets/controllers/send_assets_controller.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/models/contact_model.dart';

class RecipientView extends StatefulWidget {
  SendAssetsController controller;

  RecipientView(this.controller);

  @override
  _RecipientViewState createState() => _RecipientViewState();
}

class _RecipientViewState extends State<RecipientView>
    with SingleTickerProviderStateMixin {
  SendAssetsController controller;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (controller.currentRecepientPageSelected.value !=
          tabController.index) {
        controller.currentRecepientPageSelected.value = tabController.index;
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20.0,
        left: 25.0,
        right: 25.0,
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [],
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: Container(),
            toolbarHeight: 55,
            bottom: TabBar(
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
                    0,
                    controller.currentRecepientPageSelected.value,
                    "Enter address",
                  ),
                )),
                Tab(
                    child: Obx(
                  () => controller.getTabText(
                    1,
                    controller.currentRecepientPageSelected.value,
                    "Select contact",
                  ),
                )),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  controller: tabController,
                  children: [
                    _getEnterAddressWidget(context),
                    _getContactAddressList(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getContactAddressList(context) {
    return Obx(
      () => Container(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            controller.rebuildAllContactList.value ? Container() : Container(),
            Expanded(
              flex: 6,
              child: ListView.builder(
                itemCount: controller
                    .storage.contacts[controller.storage.provider].length,
                itemBuilder: (BuildContext context, int index) {
                  var contact = controller
                      .storage.contacts[controller.storage.provider][index];
                  return Container(
                    padding: EdgeInsets.only(
                      top: 2.5,
                      bottom: 2.5,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.contactAddressController.value =
                                    TextEditingController()
                                      ..text = contact["pkHash"];
                                controller.contactNameController.value =
                                    TextEditingController()
                                      ..text = contact["name"];
                                controller.editContactIndex.value = index;
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        AddContactDialog(controller));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 18.0,
                                  color: Color(
                                    0xFF7F8489,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Fluttertoast.showToast(
                                    msg: "contact ${contact["name"]} selected",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  controller.receiverAddress.value =
                                      contact["pkHash"];
                                  controller.currentStateList[1] =
                                      PROGRESS_STATE.COMPLETED;
                                  controller.currentStateList[2] =
                                      PROGRESS_STATE.ACTIVE;
                                },
                                child: Text(
                                  contact["name"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              CommonFunction().getShortTz1(contact["pkHash"]),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(
              color: Colors.white.withOpacity(0.05),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => AddContactDialog(controller));
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GradientText(
                        "Add Contact",
                        gradient: gradientBackground,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Save a Tezos address for easy usage",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getEnterAddressWidget(context) {
    return Column(
      children: [
        SizedBox(
          height: 12.0,
        ),
        Container(
          padding: EdgeInsets.only(
            top: 11.0,
            left: 15.0,
            right: 15.0,
            bottom: 11.0,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Save your contacts",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Color(
                        0xFF8E8E95,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RotatedBox(
                    quarterTurns: 2,
                    child: Icon(
                      Icons.info,
                      size: 19.0,
                      color: Color(
                        0xFF8E8E95,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: Text(
                      "Save addresses that are used often in the “Select contact” tab.",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(
                          0.3,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            // top: 11.0,
            left: 15.0,
            right: 15.0,
            // bottom: 11.0,
          ),
          margin: EdgeInsets.only(
            top: 12.0,
          ),
          height: 50.0,
          decoration: BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.all(
              Radius.circular(
                10.0,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.addressController,
                  onChanged: (s) {
                    if (s.isNotEmpty &&
                        s.isNotEmpty &&
                        CommonFunction.isValidTzOrKTAddress(s)) {
                      controller.receiverAddress.value = s;
                    }
                  },
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    color: Color(
                      0xFF8E8E95,
                    ),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter a Tezos address",
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(
                        0xFF8E8E95,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  String reciverPkHash = await MajaScan.startScan(
                      title: "Scan address",
                      flashlightEnable: true,
                      scanAreaScale: 0.7);
                  if (reciverPkHash.isNotEmpty &&
                      CommonFunction.isValidTzOrKTAddress(reciverPkHash)) {
                    controller.addressController.text = reciverPkHash;
                    controller.receiverAddress.value =
                        controller.addressController.text;
                  }
                },
                child: SvgPicture.asset(
                  "assets/send_xtz/qr_code.svg",
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Obx(() {
          return CommonFunction.isValidTzOrKTAddress(
                  controller.receiverAddress.value)
              ? CustomAnimatedActionButton(
                  "Continue",
                  CommonFunction.isValidTzOrKTAddress(
                      controller.receiverAddress.value),
                  () {
                    controller.currentStateList[1] = PROGRESS_STATE.COMPLETED;
                    controller.currentStateList[2] = PROGRESS_STATE.ACTIVE;
                  },
                  height: 56,
                  backgroudColor: backgroundColor,
                  width: Get.width - 90,
                )
              // GestureDetector(
              //     onTap: () {
              //       controller.currentStateList[1] = PROGRESS_STATE.COMPLETED;
              //       controller.currentStateList[2] = PROGRESS_STATE.ACTIVE;
              //     },
              //     child: Container(
              //       height: 60,
              //       width: Get.width - 50,
              //       decoration: BoxDecoration(
              //         gradient: gradientBackground,
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       child: Center(
              //         child: Text(
              //           "Continue",
              //           style: TextStyle(
              //             color: Color(0xffFDFDFD),
              //             fontWeight: FontWeight.w600,
              //             fontSize: 16,
              //           ),
              //         ),
              //       ),
              //     ),
              //   )
              : Container();
        }),
      ],
    );
  }
}

class AddContactDialog extends StatefulWidget {
  SendAssetsController controller;

  AddContactDialog(this.controller);

  @override
  _AddContactDialogState createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  SendAssetsController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  void dispose() {
    super.dispose();
    controller.isAddContactIsValid.value = false;
    controller.contactAddressController.value.text = "";
    controller.contactNameController.value.text = "";
    controller.editContactIndex.value = -1;
  }

  @override
  Widget build(BuildContext context) {
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
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: GradientIcon(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 25.0,
                        ),
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
                            controller.editContactIndex.value == -1
                                ? "Add contact"
                                : "Edit contact",
                            gradient: gradientBackground,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Enter a name and a Tezos address",
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
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: Color(0xff8E8E95),
                        size: 16,
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
                  height: 20.0,
                ),
                TextField(
                  autofocus: true,
                  controller: controller.contactNameController.value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter name...",
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
                    validateAddContact();
                  },
                ),
                Container(
                  height: 1,
                  width: Get.width,
                  color: Colors.white.withOpacity(0.04),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => TextField(
                          autofocus: true,
                          controller: controller.contactAddressController.value,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter address...",
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
                            validateAddContact();
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (int.parse(widget.controller.balance.value) > 0) {
                          String reciverPkHash = await MajaScan.startScan(
                              title: "Scan address",
                              flashlightEnable: true,
                              scanAreaScale: 0.7);
                          if (CommonFunction.isValidTzOrKTAddress(
                                  reciverPkHash) &&
                              reciverPkHash.isNotEmpty) {
                            controller.contactAddressController.value.text =
                                reciverPkHash;
                            validateAddContact();
                            return;
                          }
                        }
                      },
                      child: SvgPicture.asset(
                        "assets/send_xtz/qr_code.svg",
                        height: 15,
                        width: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Obx(
                  () => Row(
                    children: [
                      controller.editContactIndex.value != -1
                          ? Expanded(
                              child: CustomAnimatedActionButton(
                                  "Delete contact", true, () async {
                                var storage = await StorageUtils().getStorage();
                                storage.contacts[storage.provider].removeAt(
                                    controller.editContactIndex.value);
                                await StorageUtils().postStorage(storage);
                                controller.storage = storage;
                                controller.rebuildAllContactList.value =
                                    !controller.rebuildAllContactList.value;
                                Navigator.of(context).pop();
                              }),
                            )
                          : Container(),
                      controller.editContactIndex.value != -1
                          ? SizedBox(
                              width: 10.0,
                            )
                          : Container(),
                      Expanded(
                        child: CustomAnimatedActionButton(
                          controller.editContactIndex.value != -1
                              ? "Save contact"
                              : "Add contact",
                          controller.isAddContactIsValid.value,
                          () async {
                            var storage = await StorageUtils().getStorage();

                            if (storage.contacts[storage.provider] == null)
                              storage.contacts[storage.provider] = [];

                            if (controller.editContactIndex.value != -1)
                              storage.contacts[storage.provider]
                                      [controller.editContactIndex.value] =
                                  ContactModel(
                                name:
                                    controller.contactNameController.value.text,
                                pkHash: controller
                                    .contactAddressController.value.text,
                              ).toJson();
                            else
                              storage.contacts[storage.provider].add(
                                ContactModel(
                                  name: controller
                                      .contactNameController.value.text,
                                  pkHash: controller
                                      .contactAddressController.value.text,
                                ).toJson(),
                              );

                            await StorageUtils().postStorage(storage);
                            controller.storage = storage;
                            controller.rebuildAllContactList.value =
                                !controller.rebuildAllContactList.value;
                            Navigator.of(context).pop();
                          },
                          backgroudColor: Colors.black,
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
    );
  }

  validateAddContact() {
    if (controller.contactNameController.value.text.isNotEmpty &&
        CommonFunction.isValidTzOrKTAddress(
            controller.contactAddressController.value.text.toString()))
      controller.isAddContactIsValid.value = true;
    else
      controller.isAddContactIsValid.value = false;
  }
}
