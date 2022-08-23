import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:majascan/majascan.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/loading_screen/views/loading_screen_view.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/operations_utils/operations_utils.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

import '../controllers/baker_delegation_controller.dart';

BakerDelegationController bakerController = new BakerDelegationController()
  ..onInit();

class EnterBakerDelgationDialog extends StatefulWidget {
  final String delegate;
  EnterBakerDelgationDialog(this.delegate);

  @override
  _EnterBakerDelgationDialogState createState() =>
      _EnterBakerDelgationDialogState();
}

class _EnterBakerDelgationDialogState extends State<EnterBakerDelgationDialog> {
  @override
  void dispose() {
    CommonFunction.setSystemNavigatinColor(
      backgroundColor,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommonFunction.setSystemNavigatinColor(
      dialogBackgroundColor,
    );
    return Material(
      color: dialogBackgroundColor,
      elevation: 10.0,
      shadowColor: Colors.grey[300].withOpacity(
        0.3,
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(
          35.0,
        ),
        topRight: Radius.circular(
          35.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Get.width * 0.8,
            margin: EdgeInsets.only(
              top: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: Get.width * 0.3,
                    height: 3.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF17181C),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          50.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.05),
                widget.delegate.length > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current baker",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Text(
                            widget.delegate,
                            style: TextStyle(
                              color: Colors.white38,

                              // fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.03),
                        ],
                      )
                    : SizedBox(),
                Text(
                  "Enter a baker address",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClayContainer(
                        height: 50.0,
                        borderRadius: 20.0,
                        spread: 2,
                        emboss: true,
                        depth: 20,
                        color: backgroundColor,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: Obx(
                            () => TextField(
                              controller:
                                  bakerController.bakerAddressController.value,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Color(0xFF7F8489).withOpacity(
                                  0.8,
                                ),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                              onSubmitted: (s) {
                                bakerController.bakerAddress.value = bakerController
                                    .bakerAddressController.value.text;
                                // Navigator.of(context).pop();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(
                                  10.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        // top: 20.0,
                        left: 10.0,
                        right: 5.0,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          // Scan QR
                          String reciverPkHash = await MajaScan.startScan(
                              title: "Scan address",
                              // barColor: Colors.red,
                              // titleColor: Colors.green,
                              // qRCornerColor: Colors.blue,
                              // qRScannerColor: Colors.deepPurple,
                              flashlightEnable: true,
                              scanAreaScale: 0.7

                              /// value 0.0 to 1.0
                              );
                          if (reciverPkHash.isNotEmpty) {
                            bakerController.bakerAddress.value =
                                bakerController.bakerAddressController.value.text;
                            // Navigator.of(context).pop();
                          }
                          // print(reciverPkHash);
                        },
                        child: ClayContainer(
                          color: backgroundColor,
                          width: 30.0,
                          height: 30.0,
                          depth: 30,
                          spread: 3,
                          borderRadius: 50.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "assets/send_xtz/scan_qr.svg",
                              // scale: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: Get.height * 0.04,
                  ),
                  child: Center(
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => delegateToBaker(context),
                  child: ClayContainer(
                    width: Get.width - 50,
                    height: 55.0,
                    color: Color(
                      0xFF323840,
                    ),
                    surfaceColor: Color(0xFF262b30),
                    borderRadius: 22,
                    depth: 20,
                    spread: 2,
                    child: Center(
                      child: Text(
                        "Confirm Baker Selection",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  delegateToBaker(context) {
    if (bakerController.bakerAddressController.value.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter the baker address",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    } else if (!CommonFunction.isValidTzOrKTAddress(
        bakerController.bakerAddressController.value.text)) {
      Fluttertoast.showToast(
        msg: "Please enter the valid baker address",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    CommonFunction.setSystemNavigatinColor(
      backgroundColor,
    );
    Navigator.pushNamed(
      context,
      Routes.LOADING_SCREEN,
      arguments: LoadingViewArguments(
        proccess: delegationProccess,
        title: "Confirming Delegation",
        subTitle:
            "Please wait for the transaction to be confirmed on Tezos. This may take some time.",
        emojiImage: 'assets/emojis/confirming.png',
        mainSuccessTitle: "Bakery Added",
        buttonText: "Return to Settings",
        successMsg:
            "Rewards will be received according to the conditions of your selected bakery.",
        controller: null,
      ),
    );
  }

  delegationProccess() async {
    var keyStore = KeyStoreModel(
      publicKeyHash: bakerController.storage.accounts[bakerController.storage.provider][0]
          ['publicKeyHash'],
      publicKey: bakerController.storage.accounts[bakerController.storage.provider][0]
          ['publicKey'],
      secretKey: bakerController.storage.accounts[bakerController.storage.provider][0]
          ['secretKey'],
    );

    var result = await OperationUtils().delegatBaker(
      keyStore,
      StorageUtils.rpc[bakerController.storage.provider],
      bakerController.bakerAddressController.value.text,
    );

    print("Applied operation ===> $result['appliedOp']");
    print("Operation groupID ===> $result['operationGroupID']");
  }
}
