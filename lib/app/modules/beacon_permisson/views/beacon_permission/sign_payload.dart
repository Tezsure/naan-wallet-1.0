import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/controllers/beacon_form_controller.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/views/widgets/widget.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/common_widgets.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/beacon/beacon_plugin.dart';

class SignPayload extends StatefulWidget {
  final BeaconFormController controller;
  SignPayload({@required this.controller});

  @override
  _SignPayloadState createState() => _SignPayloadState();
}

class _SignPayloadState extends State<SignPayload> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          GradientText(
            "Confirm Sign",
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
                  "Sign request from ${widget.controller.argsModel.value.appMetadata.name}",
              info:
                  "This site is requesting access to view your account address. Always make sure you trust the sites you interact with."),
          Spacer(),
          SizedBox(
            height: 8,
          ),
          infoUI(
            headLine:
                "Payload to sign  ${CommonFunction().getShortTz1(widget.controller.argsModel.value.sourceAddress)}",
            info: shortPayload,
          ),
          Spacer(),
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

  String get shortPayload =>
      widget.controller.argsModel.value.payload.length > 5
          ? widget.controller.argsModel.value.payload.substring(0, 5) +
              "..." +
              widget.controller.argsModel.value.payload.substring(
                  widget.controller.argsModel.value.payload.length - 5,
                  widget.controller.argsModel.value.payload.length)
          : widget.controller.argsModel.value.payload;
}
