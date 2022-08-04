import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/controllers/beacon_form_controller.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/views/widgets/widget.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/beacon/beacon_plugin.dart';
import 'package:tezster_dart/tezster_dart.dart';

class BeaconPermissionView extends StatefulWidget {
  final BeaconFormController controller;
  BeaconPermissionView({@required this.controller});

  @override
  _BeaconPermissionViewState createState() => _BeaconPermissionViewState();
}

class _BeaconPermissionViewState extends State<BeaconPermissionView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Spacer(),
          GradientText(
            "Confirm connection",
            gradient: gradientBackground,
            textStyle: TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 24,
          ),
          getPlentyNaanConnectionUI(widget.controller),
          SizedBox(
            height: 28,
          ),
          infoUI(
              headLine:
                  "Connection request from ${widget.controller.argsModel.value.appMetadata.name}",
              info:
                  "This site is requesting access to view your account address. Always make sure you trust the sites you interact with."),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xff1e1e1e),
            ),
            child: Obx(
              () => Column(
                children: List.generate(widget.controller.accounts.value.length,
                    (index) {
                  String tz1Address =
                      widget.controller.accounts.value[index]['publicKeyHash'];

                  // widget.controller
                  //     .getAccountBalance(tz1Address, index);
                  tz1Address = tz1Address.substring(0, 3) +
                      "..." +
                      tz1Address.substring(
                          tz1Address.length - 3, tz1Address.length);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Obx(
                            () => customCircularCheckBox(
                                index ==
                                    widget.controller.selectedAccountIndex
                                        .value, () {
                              widget.controller.selectedAccountIndex.value =
                                  index;
                              widget.controller.selectedAccountPkH = widget
                                  .controller.accounts[index]['publicKey'];
                              widget.controller.selectedAccountName.value =
                                  widget.controller.accounts.value[index]
                                      ['name'];
                            }, widget.controller.accounts.value[index]['name'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                tz1Address,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: widget.controller.accounts
                                          .value[index]['publicKeyHash']));
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
                                child: Icon(
                                  Icons.copy_outlined,
                                  size: 12,
                                  color: Color(0xff7F8489),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder(
                            key: ValueKey(index),
                            initialData: '0',
                            future: TezsterDart.getBalance(
                                widget.controller.accounts.value[index]
                                    ['publicKeyHash'],
                                StorageUtils.rpc[widget.controller.storage.provider]),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${(int.parse((snapshot.data ?? 0).toString()) / 1e6)} tez" ??
                                      "0.0 tez",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          infoUI(info: "Select account to be connected"),
          Spacer(),
          CustomAnimatedActionButton(
            "Connect",
            true,
            () async {
              // print(widget.controller.selectedAccountPkH);
              if (widget.controller.argsModel.value.payload != null &&
                  widget.controller.argsModel.value.payload.isNotEmpty) {
                var storage = await StorageUtils().getStorage();
                var acc = storage.accounts[storage.provider]
                    .toList()
                    .where((e) =>
                        e['publicKeyHash'] ==
                        widget.controller.argsModel.value.sourceAddress)
                    .toList();
                var signer = TezsterDart.createSigner(
                    TezsterDart.writeKeyWithHint(acc[0]['secretKey'], 'edsk'));
                await BeaconPlugin.respond({
                  "result": '1',
                  "opHash": TezsterDart.signPayload(
                      signer: signer,
                      payload: widget.controller.argsModel.value.payload),
                  "accountAddress": ""
                });
              } else {
                await BeaconPlugin.respond({
                  "result": '1',
                  "opHash": widget.controller.selectedAccountPkH,
                  "accountAddress": ""
                });
              }
              Navigator.of(context).pop();
            },
            height: 56,
          ),
          GestureDetector(
            onTap: () async {
              await BeaconPlugin.respond(
                  {"result": '0', "opHash": "", "accountAddress": ""});
              Navigator.of(context).pop();
            },
            child: Container(
              height: 56,
              color: Colors.transparent,
              child: Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Color(0xff7F8489),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
