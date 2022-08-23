import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/data/data_handler_controller.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/controllers/beacon_form_controller.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/views/widgets/widget.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_loading_animated_action_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/beacon/beacon_plugin.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';

class BeaconConfirmTransactionView extends StatefulWidget {
  final BeaconFormController controller;
  BeaconConfirmTransactionView({@required this.controller});

  @override
  _BeaconConfirmTransactionViewState createState() =>
      _BeaconConfirmTransactionViewState();
}

class _BeaconConfirmTransactionViewState
    extends State<BeaconConfirmTransactionView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
          double height = boxConstraints.constrainHeight();
          return Container(
            height: height,
            width: Get.width,
            margin: EdgeInsets.only(
              top: height * 0.03,
              left: height * 0.03,
              right: height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(context),
                Container(
                  height: height - 40 - (height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      GradientText(
                        "Confirm Operation",
                        gradient: gradientBackground,
                        textStyle: TextStyle(
                          color: Color(0xffFDFDFD),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      getPlentyNaanConnectionUI(widget.controller,
                          showNames: false),
                      Spacer(),
                      Container(
                        height: 85,
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xff1e1e1e),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Account:",
                                  style: TextStyle(
                                    color: Color(0xff8E8E95),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Image.asset(
                                    "assets/wallet/XTZ_logo.png",
                                    height: 26,
                                    width: 26,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GradientText(
                                            "${int.parse(widget.controller.argsModel.value.operationDetails[0].amount) / 1e6} tez",
                                            gradient: gradientBackground,
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Obx(
                                            () => Text(
                                              r"$" +
                                                  "${((int.parse(widget.controller.argsModel.value.operationDetails[0].amount) / 1e6) * widget.controller.dollerValue.value).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                color: Color(0xff8E8E95),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                        height: 1,
                                        color: Colors.white.withOpacity(0.04),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Fee: ${widget.controller.fee.value}",
                                          style: TextStyle(
                                            color: Color(0xff8E8E95),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Storage fee: 0.000413 tez",
                                          style: TextStyle(
                                            color: Color(0xff8E8E95),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 48,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "  From:",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff8E8E95),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.1,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(() => Text(
                                            widget.controller
                                                .selectedAccountName.value,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          )),
                                      Text(
                                        widget.controller.argsModel.value
                                            .sourceAddress,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff8E8E95),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/wallet/gradient_arrow.png",
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Send To:   ",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff8E8E95),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.05,
                                  ),
                                  Text(
                                    widget.controller.argsModel.value
                                        .operationDetails[0].destination,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff8E8E95),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Spacer(),
                      CustomLoadingAnimatedActionButton(
                        "Confirm",
                        true,
                        () {
                          completeTransaction();
                        },
                        height: 56,
                      ),
                      GestureDetector(
                        onTap: () {
                          BeaconPlugin.respond({
                            "result": '0',
                            "opHash": "",
                            "accountAddress": ""
                          });
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  completeTransaction() async {
    var storage = await StorageUtils().getStorage();

    var rpcNode = widget.controller.argsModel.value.network.identifier ==
                null ||
            widget.controller.argsModel.value.network.identifier == 'mainnet'
        ? StorageUtils.rpc['mainnet']
        : StorageUtils.rpc['delphinet'];
    if (widget.controller.opPair.value.isEmpty) {
      widget.controller.opPair.listen((value) async {
        var opHash = await TezsterDart.injectOperation(
            rpcNode, widget.controller.opPair.value as Map<String, Object>);
        await BeaconPlugin.respond({
          "result": '1',
          "opHash": opHash.toString().replaceAll('\n', ''),
          "accountAddress": ""
        });
        await DataHandlerController().createBeaconTransaction(opHash, rpcNode,
            widget.controller.argsModel.value.appMetadata.name);
        // Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
        // });
      });
    } else {
      var opHash = await TezsterDart.injectOperation(
          rpcNode, widget.controller.opPair.value as Map<String, Object>);
      await BeaconPlugin.respond({
        "result": '1',
        "opHash": opHash.toString().replaceAll('\n', ''),
        "accountAddress": ""
      });
      await DataHandlerController().createBeaconTransaction(
          opHash, rpcNode, widget.controller.argsModel.value.appMetadata.name);
      // Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      // });
      // Navigator.pop(context);
    }
  }
}
