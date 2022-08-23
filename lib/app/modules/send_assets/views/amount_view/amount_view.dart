import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tezster_wallet/app/custom_packges/image_cache_manager/image_cache_widget.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_action_button_animation.dart';
import 'package:tezster_wallet/app/modules/send_assets/controllers/send_assets_controller.dart';
import 'package:tezster_wallet/models/nft_token_model.dart';
import 'package:tezster_wallet/models/tokens_model.dart';

class AmountView extends StatefulWidget {
  SendAssetsController controller;

  AmountView(this.controller);

  @override
  _AmountViewState createState() => _AmountViewState();
}

class _AmountViewState extends State<AmountView> {
  SendAssetsController controller;

  TextEditingController xtzOrTokenAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20.0,
        left: 25.0,
        right: 25.0,
      ),
      child: Column(
        children: [
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
                      controller.selectedAssestType == 2
                          ? "Enter quantity"
                          : "Enter an amount",
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
                        controller.selectedAssestType == 2
                            ? "Fill in the number of collectibles you wish to send."
                            : "Fill in the token amount you wish to send. The fiat value auto-populates.",
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
          SizedBox(
            height: 10.0,
          ),
          controller.selectedAssestType == 0
              ? _getTokenORXtzWidget()
              : controller.selectedAssestType == 1
                  ? _getTokenORXtzWidget(controller.selectedToken)
                  : _getTokenORXtzWidget(controller.selectedNFT),
          _getEnterAmountWidget(),
          Obx(
            () => controller.enteredAmount.isNotEmpty
                ? CustomAnimatedActionButton(
                    "Continue",
                    true,
                    () {
                      controller.currentStateList[2] = PROGRESS_STATE.COMPLETED;
                      controller.currentStateList[3] = PROGRESS_STATE.ACTIVE;
                    },
                    height: 56,
                    width: Get.width - 90,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _getTokenORXtzWidget([selectedToken]) {
    if (selectedToken is NFTToken) {
      int myTokenCount = (selectedToken.holders.isNotEmpty
              ? selectedToken.holders[0].quantity
              : 0),
          totalTokenCount = selectedToken.supply;
      xtzOrTokenAmountController.text = '1';
      controller.enteredAmount.value = xtzOrTokenAmountController.text;
      return Container(
        height: 60,
        color: Colors.transparent,
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "hic et nunc",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  selectedToken != null
                      ? Text(
                          selectedToken.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B6D70),
                          ),
                        )
                      : Text(
                          "tez",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B6D70),
                          ),
                        ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // selectedToken != null
                Text(
                  myTokenCount.toString() + "/" + totalTokenCount.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B6D70),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      height: 60,
      color: Colors.transparent,
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        children: [
          selectedToken != null
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(
                      0xFF346EC5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        150,
                      ),
                    ),
                    child: Container(
                      width: 31,
                      child: CacheImageBuilder(
                        imageUrl: selectedToken.iconUrl,
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 31,
                  width: 31,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(
                      0xFF346EC5,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/wallet/tezos_logo.png",
                      color: Colors.white,
                      height: 16,
                    ),
                  ),
                ),
          SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                selectedToken != null
                    ? Text(
                        selectedToken.name != null
                            ? selectedToken.name
                            : selectedToken.symbol != null
                                ? selectedToken.symbol
                                : "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Tezos",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                SizedBox(
                  height: 8,
                ),
                selectedToken != null
                    ? Text(
                        selectedToken.symbol != null
                            ? selectedToken.symbol
                            : selectedToken.name != null
                                ? selectedToken.name
                                : "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B6D70),
                        ),
                      )
                    : Text(
                        "tez",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B6D70),
                        ),
                      ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              selectedToken != null
                  ? Text(
                      (getTokenBalance(selectedToken).toString().length >= 8
                          ? getTokenBalance(selectedToken)
                              .toString()
                              .substring(0, 8)
                          : getTokenBalance(selectedToken).toString()),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      (CommonFunction.roundUpTokenOrXtz(
                          int.parse(controller.balance.value) / 1000000)),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              SizedBox(
                height: 8,
              ),
              selectedToken != null
                  ? Text(
                      (selectedToken.balance == '0.0'
                          ? 'NaN'
                          : r"$" +
                              CommonFunction.roundUpDollar((double.parse(
                                          selectedToken.balance ?? "0.0") *
                                      double.parse(selectedToken.price)) *
                                  controller.dollerValue.value)),
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B6D70),
                      ),
                    )
                  : Text(
                      r"$" +
                          CommonFunction.roundUpDollar(
                              (int.parse(controller.balance.value) / 1000000) *
                                  controller.dollerValue.value),
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B6D70),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  getTokenBalance(TokensModel selectedToken) {
    var amount = CommonFunction.roundUpTokenOrXtz(selectedToken.balance);
    return amount;
  }

  Widget _getEnterAmountWidget() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
          ),
          ShaderMask(
            shaderCallback: (bounds) => gradientBackground.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: TextField(
              cursorColor: Colors.white,
              // showCursor: false,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 43.0,
              ),
              cursorWidth: 1.0,
              textAlign: TextAlign.center,
              controller: xtzOrTokenAmountController,
              onChanged: (s) {
                var text =
                    xtzOrTokenAmountController.text.toString().replaceAll(
                          RegExp(r'[^0-9,.]+'),
                          '',
                        );
                if (text.startsWith(".") || text.startsWith(","))
                  xtzOrTokenAmountController.text =
                      controller.selectedAssestType == 2 ? "0" : "0.00";
                if (controller.selectedToken != null &&
                    text.substring(text.indexOf('.') + 1).length >
                        controller.selectedToken.decimals)
                  text = text.substring(
                      0,
                      text.length -
                          (text
                                  .substring(text.indexOf('.') == -1
                                      ? controller.selectedToken.decimals
                                      : text.indexOf('.') + 1)
                                  .length -
                              controller.selectedToken.decimals));
                else if (controller.selectedToken == null &&
                    text.substring(text.indexOf('.') + 1).length > 6)
                  text = text.substring(
                      0,
                      text.length -
                          (text
                                  .substring(text.indexOf('.') == -1
                                      ? 6
                                      : text.indexOf('.') + 1)
                                  .length -
                              6));
                xtzOrTokenAmountController.text = text;
                if (xtzOrTokenAmountController.text.isNotEmpty &&
                    controller.selectedAssestType != 0 &&
                    controller.selectedToken != null &&
                    double.parse(controller.selectedToken.balance) <
                        double.parse(xtzOrTokenAmountController.text)) {
                  xtzOrTokenAmountController.text =
                      double.parse(controller.selectedToken.balance)
                          .toStringAsFixed(6);
                }
                if (xtzOrTokenAmountController.text.isNotEmpty &&
                    controller.selectedAssestType == 2 &&
                    controller.selectedNFT != null) {
                  try {
                    int.parse(xtzOrTokenAmountController.text);
                  } catch (e) {
                    xtzOrTokenAmountController.text =
                        double.parse(xtzOrTokenAmountController.text)
                            .round()
                            .toString();
                  }
                }
                if (xtzOrTokenAmountController.text.isNotEmpty &&
                    controller.selectedAssestType == 0 &&
                    (double.parse(controller.balance.toString()) / 1000000) <
                        double.parse(xtzOrTokenAmountController.text)) {
                  xtzOrTokenAmountController.text =
                      (double.parse(controller.balance.toString()) / 1000000)
                          .toStringAsFixed(4);
                }
                xtzOrTokenAmountController.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: xtzOrTokenAmountController.text.length));
                controller.enteredAmount.value =
                    xtzOrTokenAmountController.text;
                try {
                  if (controller.selectedToken != null) {
                    controller.dollarValueOfCurrentAmount.value =
                        (double.parse(xtzOrTokenAmountController.text) *
                                double.parse(controller.selectedToken.price) *
                                controller.dollerValue.value)
                            .toStringAsFixed(2);
                  } else {
                    controller.dollarValueOfCurrentAmount.value =
                        (double.parse(xtzOrTokenAmountController.text) *
                                controller.dollerValue.value)
                            .toStringAsFixed(2);
                  }
                } catch (e) {}
                if (s.isEmpty)
                  controller.dollarValueOfCurrentAmount.value =
                      controller.selectedAssestType == 2 ? "0" : "0.00";
              },
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(0.0),
                border: InputBorder.none,
                hintText: controller.selectedAssestType == 2 ? "0" : "0.00",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w700,
                  fontSize: 43.0,
                ),
              ),
            ),
          ),
          controller.selectedAssestType == 2
              ? Container()
              : Obx(
                  () => Text(
                    r"$" +
                        controller.dollarValueOfCurrentAmount.value.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Color(0xFFC4C4C4),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
