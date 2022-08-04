import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tezster_wallet/app/modules/send_assets/controllers/send_assets_controller.dart';
import 'package:tezster_wallet/app/modules/send_assets/views/summary_view/confirm_tx_view/confirm_tx_view.dart';

class SummaryView extends StatefulWidget {
  SendAssetsController controller;

  SummaryView(this.controller);

  @override
  _SummaryViewState createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[
      ConfirmTxView(widget.controller),
    ];

    return Container(
      child: Obx(() => widgets[widget.controller.summaryFormController.value]),
    );
  }
}
