import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bs58check/bs58check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_wallet/app/modules/common/colors_utils/colors.dart';
import 'package:tezster_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_singleton.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:tezster_wallet/models/beacon_permission_model.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class BeaconPlugin {
  static var opPair = <String, Object>{}.obs;
  static const platform = const MethodChannel("com.beacon_flutter/beacon");
  static var eventChannel = "com.beacon_flutter/beaconEvent";
  static EventChannel stream;
  static bool isBeaconStarted = false;
  static bool isCameraOpen = false;
  List<dynamic> peers;

  static StreamSubscription _sub;

  static Future<void> startBeacon(account) async {
    stream = EventChannel(eventChannel);
    List<BeaconPermissionModel> oldModel = [];
    platform.invokeMethod('startBeacon', account);
    // print("startedBeacon  = $data");
    isBeaconStarted = true;

    Future.delayed(Duration(seconds: 2), () {
      BeaconPlugin.listenToChannle((data) async {
        // print("new data:-" + data);
        // platform check forr androrid and iOS

        BeaconPermissionModel model;
        if (Platform.isIOS) {
          model = BeaconPermissionModel.fromJson(
              jsonDecode(String.fromCharCodes(data.toList())));
        } else {
          model = BeaconPermissionModel.fromJson(jsonDecode(data));
          // if (oldModel.length != 0 && oldModel.last.id != model.id) {
          //   oldModel = [];
          // }
        }
        print("OLDMODEL = ${oldModel.length}");
        if (oldModel.isEmpty) {
          oldModel.add(model);
          if (model.operationDetails == null &&
              (model.payload == null || model.payload.isEmpty)) {
            var storage = await StorageUtils().getStorage();
            oldModel = [];
            await BeaconPlugin.respond({
              "result": '1',
              "opHash": storage.accounts[storage.provider]
                  [storage.currentAccountIndex]['publicKey'],
              "accountAddress": storage.accounts[storage.provider]
                  [storage.currentAccountIndex]['publicKeyHash']
            });
            if (isDialogOpen) {
              isDialogOpen = false;
              Navigator.of(Get.key.currentContext).pop();
            }
            Fluttertoast.showToast(
              msg: "connected to ${model.appMetadata.name}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff1e1e1e),
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else if (model.operationDetails == null)
            Get.toNamed(Routes.BEACON_PERMISSON, arguments: model);
          else {
            var storage = await StorageUtils().getStorage();
            if (model.operationDetails != null && model.payload == null) {
              opPair = <String, Object>{}.obs;
              var rpcNode = model.network.identifier == null ||
                      model.network.identifier == 'mainnet'
                  ? StorageUtils.rpc['mainnet']
                  : StorageUtils.rpc['delphinet'];
              var acc = storage.accounts[storage.provider]
                  .toList()
                  .where((e) => e['publicKeyHash'] == model.sourceAddress)
                  .toList();

              var _acc = acc[0];

              var keyStore = KeyStoreModel(
                publicKeyHash: _acc['publicKeyHash'],
                publicKey: _acc['publicKey'],
                secretKey: _acc['secretKey'],
              );
              if (model.operationDetails[0].kind.toLowerCase() ==
                  "origination") {
                // var transactionSigner = await TezsterDart.createSigner(
                //     TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));

                // var contractStorage = Parameters().formatParameters(
                //     jsonEncode(model.operationDetails[0].script['storage']));
                // var contractCode = Parameters().formatParameters(
                //     jsonEncode(model.operationDetails[0].script['code']));
                // TezsterDart.preapplyContractOriginationOperation(
                //   rpcNode,
                //   transactionSigner,
                //   keyStore,
                //   0,
                //   null,
                //   120000,
                //   5000,
                //   150000,
                //   contractCode,
                //   contractStorage,
                //   codeFormat: TezosParameterFormat.Micheline,
                // ).then((value) => opPair.value = value as Map<String, Object>);
              } else {
                var contracts = <String>[
                  ...model.operationDetails
                      .map<String>((e) => e.destination)
                      .toList()
                ];
                var amounts = <int>[
                  ...model.operationDetails
                      .map<int>((e) => int.parse(e.amount))
                      .toList()
                ];
                var entryPoints = <String>[
                  ...model.operationDetails
                      .map<String>((e) => e.parameters.entrypoint)
                      .toList()
                ];
                var parameters = <String>[
                  ...model.operationDetails
                      .map<String>((e) => e.parameters.value)
                      .toList()
                ];
                var codeFormets = <TezosParameterFormat>[
                  ...model.operationDetails
                      .map<TezosParameterFormat>((e) => e.parameters.format)
                      .toList()
                ];

                var transactionSigner = await TezsterDart.createSigner(
                    TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));
                TezsterDart.preapplyContractInvocationOperation(
                  rpcNode,
                  transactionSigner,
                  keyStore,
                  contracts,
                  amounts,
                  120000,
                  5000,
                  150000,
                  entryPoints,
                  parameters,
                  codeFormat: codeFormets,
                ).then((value) => opPair.value = value as Map<String, Object>);
              }
            }
            Get.toNamed(Routes.BEACON_PERMISSON, arguments: model);
          }
          oldModel = [];
        }
      });
    });
  }

  static Future<void> stopBeacon() async {
    if (!isBeaconStarted) return;
    var data = await platform.invokeMethod('stopBeacon');
    // print(data);
    stream = null;
  }

  static resumeBeacon() async {
    // var data = await platform.invokeMethod("resumeBeacon");
    // print("resumed $data");
  }

  static Future<void> pair(String name, String data) async {
    openConnectionDialog(name);
    await platform.invokeMethod('pair', <String, dynamic>{
      'uri': data,
    });
    print("addPeer = ");
  }

  static Future<void> addPeer(id, name, publicKey, server, version) async {
    openConnectionDialog(name);
    await platform.invokeMethod('addPeer', <String, dynamic>{
      'id': id,
      'name': name,
      'publicKey': publicKey,
      'relayServer': server,
      'version': version,
    });
    print("addPeer = ");
  }

  static Future<void> listenToChannle(callback) async {
    stream.receiveBroadcastStream().listen(callback);
    final initialUri = await getInitialUri();
    if (initialUri.toString().startsWith("fxhash")) {
      StorageSingleton().isFxHashFlow = true;
      StorageSingleton().eventUri = initialUri.toString().substring(9);
    } else {
      parseLinkAndaddPeer(initialUri.toString());
    }

    _sub = linkStream.listen((String link) async {
      print(link);
      if (link.toString().startsWith("fxhash")) {
        StorageSingleton().isFxHashFlow = true;
        StorageSingleton().eventUri = link.toString().substring(9);
        if (Get.currentRoute == Routes.HOME_PAGE) {
          openDeepLinkFlow();
        }
      } else {
        parseLinkAndaddPeer(link);
      }
    }, onError: (err) {
      print(err.toString());
    });
  }

  static openDeepLinkFlow() async {
    var controller = Get.find<HomePageController>();
    controller.isWertLaunched.value = true;
    String url =
        "https://dev.api.tezsure.com/v1/tezsure/wert/index.html?address=${controller.storage.accounts[controller.storage.provider][controller.storage.currentAccountIndex]['publicKeyHash']}";
    if (await canLaunch(url)) {
      await launch(url).then((value) {
        controller.isWertLaunched.value = false;
        controller.index.value = 3;
        try {
          controller.webViewController.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(Platform.isIOS
                      ? "https://" + StorageSingleton().eventUri
                      : StorageSingleton().eventUri),
                  iosAllowsExpensiveNetworkAccess: true));
        } catch (e) {
          print(e.toString());
        }
      });
    }
  }

  static parseLinkAndaddPeer(String link) async {
    if (link.isEmpty || link == "null") return;
    if (link.startsWith('tezos://') || link.startsWith('naan://')) {
      link = link.substring(link.indexOf("data=") + 5, link.length);
    }
    try {
      var data = String.fromCharCodes(base58.decode(link));
      if (!data.endsWith("}"))
        data = data.substring(0, data.lastIndexOf('}') + 1);
      var baseData = jsonDecode(data);
      await BeaconPlugin.pair(baseData['name'], link);
      //   baseData['id'],
      //   baseData['name'],
      //   baseData['publicKey'],
      //   baseData['relayServer'],
      //   "2",
      // );
    } catch (e) {}
  }

  static Future<void> respond(result) async {
    var data = await platform.invokeMethod('respond', result);
    // print("respond = " + data.toString());
  }

  static bool isDialogOpen = false;

  static openConnectionDialog(String name) {
    isDialogOpen = true;
    AlertDialog alert = AlertDialog(
      backgroundColor: dialogBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 5),
              child: Text(
                'Connecting to $name',
                style: TextStyle(
                  color: Colors.white.withOpacity(
                    0.8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    showDialog(
      // barrierDismissible: false,

      context: Get.key.currentContext,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
