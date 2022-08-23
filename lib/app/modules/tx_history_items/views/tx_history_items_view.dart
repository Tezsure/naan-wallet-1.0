import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tezster_wallet/app/custom_packges/image_cache_manager/image_cache_widget.dart';
import 'dart:math' as math;
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';

import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/common/functions/common_functions.dart';
import 'package:tezster_wallet/app/modules/common/widgets/back_button.dart';
import 'package:tezster_wallet/app/modules/common/widgets/gradient_icon.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_singleton.dart';
import 'package:tezster_wallet/models/tokens_model.dart';
import 'package:tezster_wallet/models/tzkt_txs_model.dart';

// ignore: must_be_immutable
class TxHistoryItemsView extends StatefulWidget {
  HomePageController controller;

  TxHistoryItemsView({@required this.controller});

  @override
  _TxHistoryItemsViewState createState() => _TxHistoryItemsViewState();
}

class _TxHistoryItemsViewState extends State<TxHistoryItemsView> {
  List<TzktTxsModel> tzktTxs = <TzktTxsModel>[];
  TokensModel tokenModel;

  @override
  void initState() {
    super.initState();
    widget.controller.scrollControllerTx.value.addListener(scrollListener);
    tzktTxs = widget.controller.transactionModels
        .where((e) => e.parameter == null)
        .toList();
  }

  @override
  void dispose() {
    widget.controller.opacityTx.value = 0;
    widget.controller.fontSizeTx.value = 36;
    super.dispose();
  }

  void scrollListener() {
    if (widget.controller.scrollControllerTx.value.offset ==
        widget.controller.scrollControllerTx.value.position.maxScrollExtent) {
      if (widget.controller.scrollControllerTx.value.position.pixels > 85) {
        if (widget.controller.scrollControllerTx.value.position.pixels - 85 >
            39) {
          widget.controller.opacityTx.value = 1;
        } else {
          widget.controller.opacityTx.value = 0 +
              (widget.controller.scrollControllerTx.value.position.pixels -
                      85) *
                  (1 - 0) /
                  (125 - 85);
        }
      } else {
        widget.controller.opacityTx.value = 0;
      }

      if (widget.controller.scrollControllerTx.value.position.pixels <= 0) {
        widget.controller.fontSizeTx.value = 36;
      } else if (widget.controller.scrollControllerTx.value.position.pixels <
          125) {
        widget.controller.fontSizeTx.value = 36 -
            (widget.controller.scrollControllerTx.value.position.pixels - 0) *
                (36 - 18) /
                (124 - 0);
      } else {
        widget.controller.fontSizeTx.value = 18;
      }
    } else {
      if (widget.controller.scrollControllerTx.value.position.pixels > 85) {
        if (widget.controller.scrollControllerTx.value.position.pixels - 85 >
            39) {
          widget.controller.opacityTx.value = 1;
        } else {
          widget.controller.opacityTx.value = 0 +
              (widget.controller.scrollControllerTx.value.position.pixels -
                      85) *
                  (1 - 0) /
                  (125 - 85);
        }
      } else {
        widget.controller.opacityTx.value = 0;
      }
      if (widget.controller.scrollControllerTx.value.position.pixels <= 0) {
        widget.controller.fontSizeTx.value = 36;
      } else if (widget.controller.scrollControllerTx.value.position.pixels <
          125) {
        widget.controller.fontSizeTx.value = 36 -
            (widget.controller.scrollControllerTx.value.position.pixels - 0) *
                (36 - 18) /
                (124 - 0);
      } else {
        widget.controller.fontSizeTx.value = 18;
      }
    }
  }

  bool checkIfTokenIdSame(Parameter pm, tokenId) {
    if (tokenModel.type == TOKEN_TYPE.FA1) return true;
    if (pm.value == null || pm.value.length == 0)
      return true;
    else if (pm.value[0].txs == null || pm.value[0].txs.length == 0) {
      return true;
    } else {
      return (pm.value[0].txs[0].tokenId ?? '-1') == tokenId.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    tokenModel = ModalRoute.of(context).settings.arguments;
    if (tokenModel != null) {
      tzktTxs = widget.controller.transactionModels
          .where((e) =>
              e.parameter != null &&
              checkIfTokenIdSame(e.parameter, tokenModel.tokenId) &&
              (e.sender.address == tokenModel.contract ||
                  e.target.address == tokenModel.contract))
          .toList();
    }
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: Platform.isAndroid ? 20 : 0),
        child: CustomScrollView(
          controller: widget.controller.scrollControllerTx.value,
          slivers: [
            Obx(
              () => SliverAppBar(
                backgroundColor: backgroundColor,
                elevation: 0,
                snap: false,
                pinned: true,
                floating: false,
                expandedHeight: 160,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                  child: Center(
                    child: backButton(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.pin,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.controller.opacityTx.value == 0
                          ? SizedBox()
                          : AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              padding: EdgeInsets.only(
                                  right: widget.controller.opacityTx.value < 0.2
                                      ? 0
                                      : 14),
                              child: Opacity(
                                opacity: widget.controller.opacityTx.value,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      32,
                                    ),
                                  ),
                                  child: tokenModel != null
                                      ? Container(
                                          width: 32,
                                          height: 32,
                                          child: CacheImageBuilder(
                                            imageUrl: tokenModel.iconUrl,
                                          ),
                                        )
                                      : Image.asset(
                                          "assets/wallet/XTZ_logo.png",
                                          height: 32,
                                          width: 32,
                                        ),
                                ),
                              ),
                            ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: widget.controller.opacityTx.value == 0
                                ? Get.width * 0.6
                                : Get.width * 0.25,
                            child: Center(
                              child: Container(
                                child: Text(
                                  tokenModel != null
                                      ? tokenModel.name
                                      : "Tezos",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            tokenModel != null ? tokenModel.symbol : "tez",
                            style: TextStyle(
                              color: Color(0xff6B6D70),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      widget.controller.opacityTx.value == 0
                          ? SizedBox()
                          : Opacity(
                              opacity: 0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    32,
                                  ),
                                ),
                                child: tokenModel != null
                                    ? Container(
                                        width: 32,
                                        height: 32,
                                        child: CacheImageBuilder(
                                          imageUrl: tokenModel.iconUrl,
                                        ),
                                      )
                                    : Image.asset(
                                        "assets/wallet/XTZ_logo.png",
                                        height: 32,
                                        width: 32,
                                      ),
                              ),
                            ),
                    ],
                  ),
                  background: Container(
                    padding: EdgeInsets.only(top: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              32,
                            ),
                          ),
                          child: tokenModel != null
                              ? Container(
                                  width: 32,
                                  height: 32,
                                  child: CacheImageBuilder(
                                    imageUrl: tokenModel.iconUrl,
                                  ),
                                )
                              : Image.asset(
                                  "assets/wallet/XTZ_logo.png",
                                  height: 32,
                                  width: 32,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: tzktTxs.length == 0
                      ? Container(
                          margin: EdgeInsets.only(
                            top: Get.width * 0.3,
                            left: Get.width * 0.2,
                            right: Get.width * 0.2,
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                "Loading failed",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "An infrastructure issue can cause loading to fail",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF7F8489),
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        )
                      : Column(
                          children: List.generate(tzktTxs.length, (index) {
                            TzktTxsModel _model = tzktTxs[index];

                            var date =
                                DateTime.parse(_model.timestamp).toLocal();
                            if (_model.isSender) {
                              // print(_model);
                            }
                            Duration diff = DateTime.now().difference(date);

                            String time;
                            if (diff.inDays >= 1) {
                              time = '${diff.inDays} day ago';
                            } else if (diff.inHours >= 1) {
                              time = '${diff.inHours} hour ago';
                            } else if (diff.inMinutes >= 1) {
                              time = '${diff.inMinutes} min ago';
                            } else if (diff.inSeconds >= 1) {
                              time = '${diff.inSeconds} sec ago';
                            } else {
                              time = 'just now';
                            }
                            String tz1Address = _model.isSender
                                ? _model.target.address
                                : _model.sender.address;
                            if (_model.isSender) {
                              // print(_model);
                            }
                            String sentReceivedText =
                                "${_model.isSender ? "Sent" : "Received"} ${_model.isSender ? "to:" : "from:"}  ${tz1Address.substring(0, 3)}...${tz1Address.substring(tz1Address.length - 3, tz1Address.length)}";
                            double angle = _model.isSender ? 225 : 45.0;
                            return Column(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    minHeight: 74,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xff1E1E1E),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10.0,
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Transform.rotate(
                                        angle: angle * math.pi / 180,
                                        child: GradientIcon(
                                          child: Icon(
                                            Icons.arrow_downward_sharp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  tokenModel != null
                                                      ? "${(_model.parameter.value == null ? 0 : CommonFunction.getAmountValueUsingBigInt(_model.parameter.value.length > 0 && _model.parameter.value[0].txs != null && _model.parameter.value[0].txs.length > 0 ? _model.parameter.value[0].txs[0].amount : '0', tokenModel.decimals))} ${tokenModel.symbol}"
                                                      : "${(_model.amount / 1e6).toStringAsFixed(6)} tez",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Container(
                                                  height: 15,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff2C2E33),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      time,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      sentReceivedText,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff7F8489),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Clipboard.setData(
                                                            ClipboardData(
                                                                text:
                                                                    tz1Address));
                                                        Fluttertoast.showToast(
                                                          msg: "Copied",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              backgroundColor,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .content_copy_outlined,
                                                        color:
                                                            Color(0xff7F8489),
                                                        size: 12,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        CommonFunction
                                                            .launchURL(
                                                          StorageSingleton()
                                                                  .currentSelectedNetwork
                                                                  .isEmpty
                                                              ? "https://tzkt.io/${_model.hash}"
                                                              : "https://${StorageSingleton().currentSelectedNetwork}.tzkt.io/${_model.hash}",
                                                        );
                                                      },
                                                      child: SvgPicture.asset(
                                                        "assets/settings/share.svg",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                _model.status.toLowerCase() ==
                                                        'failed'
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                          right: 1.5,
                                                        ),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                          size: 15.0,
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            );
                          }),
                        ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
