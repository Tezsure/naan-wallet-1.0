import 'package:flutter/material.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/data/data_handler_controller.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/common/widgets/custom_loading_animated_action_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_text.dart';
import 'package:tezster_wallet/app/modules/send_assets/controllers/send_assets_controller.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/models/tokens_model.dart';
import 'package:get/get.dart';

class ConfirmTxView extends StatefulWidget {
  SendAssetsController controller;

  ConfirmTxView(this.controller);

  @override
  _ConfirmTxViewState createState() => _ConfirmTxViewState();
}

class _ConfirmTxViewState extends State<ConfirmTxView> {
  var opPair = <String, Object>{}.obs;

  @override
  void initState() {
    super.initState();
    startTx();
  }

  startTx() async {
    // pre apply function
    StorageModel model = widget.controller.storage;
    var _acc = model.accounts[model.provider][model.currentAccountIndex];

    var keyStore = KeyStoreModel(
      publicKeyHash: _acc['publicKeyHash'],
      publicKey: _acc['publicKey'],
      secretKey: _acc['secretKey'],
    );
    var rpcNode = StorageUtils.rpc[model.provider];
    var _amount = double.parse(widget.controller.enteredAmount.value);
    var receiver = widget.controller.receiverAddress.value;

    // tx signer
    var transactionSigner = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));

    if (widget.controller.selectedAssestType == 1) {
      var decimals = widget.controller.selectedToken.decimals;
      int amount = ((_amount *
              double.parse(
                  1.toStringAsFixed(decimals ?? 0).replaceAll('.', ''))))
          .toInt();
      var tokenType = widget.controller.selectedToken.type == TOKEN_TYPE.FA1
          ? "FA1"
          : "FA2";
      var parameters = tokenType == "FA1"
          ? """(Pair "${keyStore.publicKeyHash}" (Pair "$receiver" $amount))"""
          : """{Pair "${keyStore.publicKeyHash}" {Pair "$receiver" (Pair ${widget.controller.selectedToken.tokenId ?? 0} $amount)}}""";
      TezsterDart.preapplyContractInvocationOperation(
        rpcNode,
        transactionSigner,
        keyStore,
        [widget.controller.selectedToken.contract],
        [0],
        120000,
        1000,
        100000,
        ['transfer'],
        [parameters],
        codeFormat: TezosParameterFormat.Michelson,
      ).then((value) => opPair.value = value as Map<String, Object>);
    }

    if (widget.controller.selectedAssestType == 2) {
      var amount = int.parse(widget.controller.enteredAmount.value);
      var parameters =
          """{Pair "${keyStore.publicKeyHash}" {Pair "$receiver" (Pair ${int.parse(widget.controller.selectedNFT.tokenId) ?? 0} $amount)}}""";
      TezsterDart.preapplyContractInvocationOperation(
        rpcNode,
        transactionSigner,
        keyStore,
        [widget.controller.selectedNFT.faContract],
        [0],
        120000,
        1000,
        100000,
        ['transfer'],
        [parameters],
        codeFormat: TezosParameterFormat.Michelson,
      ).then((value) => opPair.value = value as Map<String, Object>);
    }
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
            height: 94,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                    Container(
                      height: 31,
                      width: 31,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(
                          0xFF346EC5,
                        ),
                      ),
                      child: Center(
                        child: widget.controller.selectedAssestType == 0
                            ? Image.asset(
                                "assets/wallet/tezos_logo.png",
                                color: Colors.white,
                                height: 16,
                              )
                            : widget.controller.selectedAssestType == 1
                                ? Image.network(
                                    widget.controller.selectedToken.iconUrl,
                                    width: 31,
                                  )
                                : Container(),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GradientText(
                                widget.controller.enteredAmount.value +
                                    (widget.controller.selectedAssestType == 0
                                        ? " tez"
                                        : widget.controller
                                                    .selectedAssestType ==
                                                1
                                            ? " ${widget.controller.selectedToken.symbol}"
                                            : ""),
                                gradient: gradientBackground,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                r"$" +
                                    widget.controller.dollarValueOfCurrentAmount
                                        .value,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  color: Color(
                                    0xFF8E8E95,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Fee: 0.000413 tez",
                              style: TextStyle(
                                color: Color(
                                  0xFF8E8E95,
                                ),
                                fontWeight: FontWeight.w600,
                                fontSize: 11.0,
                              ),
                            ),
                            widget.controller.selectedAssestType != 0
                                ? Text(
                                    "Storage fee: 0.000413 tez",
                                    style: TextStyle(
                                      color: Color(
                                        0xFF8E8E95,
                                      ),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11.0,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 15.0,
              left: 25.0,
              right: 25.0,
              bottom: 15.0,
            ),
            margin: EdgeInsets.only(
              top: 20.0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        " From:",
                        style: TextStyle(
                          color: Color(
                            0xFF8E8E95,
                          ),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Text(
                              widget.controller.storage.accounts[
                                      widget.controller.storage.provider][
                                  widget.controller.storage
                                      .currentAccountIndex]['publicKeyHash'],
                              style: TextStyle(
                                color: Color(
                                  0xFF8E8E95,
                                ),
                                fontWeight: FontWeight.w600,
                                fontSize: 11.0,
                              ),
                            )
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 9.5,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/send_xtz/send_down_arrow.png",
                        width: 15.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Send To:",
                        style: TextStyle(
                          color: Color(
                            0xFF8E8E95,
                          ),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Text(
                            widget.controller.receiverAddress.value,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(
                                0xFF8E8E95,
                              ),
                              fontWeight: FontWeight.w600,
                              fontSize: 11.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          CustomLoadingAnimatedActionButton(
            "Confirm",
            true,
            () async {
              if (widget.controller.isSummaryLoading.value) return;
              widget.controller.isSummaryLoading.value = true;

              // Send Tx To Isolate Process

              if (widget.controller.selectedAssestType == 0) {
                await DataHandlerController().createXTZTransaction(
                  widget.controller.storage
                          .accounts[widget.controller.storage.provider]
                      [widget.controller.storage.currentAccountIndex],
                  StorageUtils.rpc[widget.controller.storage.provider],
                  widget.controller.storage.tezsureApi,
                  widget.controller.receiverAddress.value,
                  widget.controller.enteredAmount.value,
                  widget.controller.storage.provider,
                  widget.controller.dollerValue.value,
                  widget.controller.enteredAmount.value +
                      (widget.controller.selectedAssestType == 0
                          ? " tez"
                          : widget.controller.selectedAssestType == 1
                              ? " ${widget.controller.selectedToken.symbol}"
                              : ""),
                );
                Future.delayed(
                  Duration(milliseconds: 2000),
                  () {
                    Navigator.of(context).pop();
                    widget.controller.isSummaryLoading.value = false;
                  },
                );
              }

              if (widget.controller.selectedAssestType == 1 ||
                  widget.controller.selectedAssestType == 2) {
                var rpcNode = StorageUtils.rpc[widget.controller.storage.provider];
                if (opPair.value.isEmpty) {
                  opPair.listen((value) async {
                    var opHash = await TezsterDart.injectOperation(
                        rpcNode, opPair.value as Map<String, Object>);
                    opHash = opHash.toString().replaceAll('\n', '');
                    await DataHandlerController().createTokenTransaction(
                        opHash,
                        widget.controller.enteredAmount.value +
                            (widget.controller.selectedAssestType == 0
                                ? " tez"
                                : widget.controller.selectedAssestType == 1
                                    ? " ${widget.controller.selectedToken.symbol}"
                                    : widget.controller.selectedNFT.name),
                        widget.controller.receiverAddress.value,
                        rpcNode);
                    Navigator.pop(context);
                  });
                } else {
                  var opHash = await TezsterDart.injectOperation(
                      rpcNode, opPair.value as Map<String, Object>);
                  opHash = opHash.toString().replaceAll('\n', '');
                  await DataHandlerController().createTokenTransaction(
                      opHash,
                      widget.controller.enteredAmount.value +
                          (widget.controller.selectedAssestType == 0
                              ? " tez"
                              : widget.controller.selectedAssestType == 1
                                  ? " ${widget.controller.selectedToken.symbol}"
                                  : widget.controller.selectedNFT.name),
                      widget.controller.receiverAddress.value,
                      rpcNode);
                  Navigator.pop(context);
                }
              }

              // if (widget.controller.selectedAssestType == 2)
              // await DataHandlerController().createTokenTransaction(
              //   widget.controller.storage
              //           .accounts[widget.controller.storage.provider]
              //       [widget.controller.storage.currentAccountIndex],
              //   widget
              //       .controller.storage.rpc[widget.controller.storage.provider],
              //   widget.controller.storage.tezsureApi,
              //   widget.controller.receiverAddress.value,
              //   widget.controller.selectedNFT.fa2Id,
              //   widget.controller.enteredAmount.value,
              //   widget.controller.storage.provider,
              //   0,
              //   widget.controller.selectedNFT.id,
              //   "FA2",
              //   widget.controller.enteredAmount.value +
              //       (widget.controller.selectedAssestType == 0
              //           ? " tez"
              //           : widget.controller.selectedAssestType == 1
              //               ? " ${widget.controller.selectedToken.symbol}"
              //               : widget.controller.selectedNFT.title),
              // );
            },
            height: 55,
            fontSize: 16,
            loadingAnimationDuration: Duration(seconds: 6),
          ),
        ],
      ),
    );
  }
}
