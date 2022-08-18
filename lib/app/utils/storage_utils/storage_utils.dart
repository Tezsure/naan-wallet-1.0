import 'dart:convert';
import 'dart:io';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tezster_wallet/app/data/data_handler_controller.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_singleton.dart';
import 'package:tezster_wallet/app/utils/storage_utils/tezster_databse.dart';

var id;
// String _userPinCode = r"Jb$9LKv*-$9m55HRDcwWkWxf6*EkVJ7m";
StorageModel tempModel;
String authType;

String authROUTE = Routes.BEACON_PERMISSON;

TezsterDatabase databse = TezsterDatabase();

class StorageUtils {
  static final Map<String, String> rpc = {
    "edonet": 'https://edonet-tezos.giganode.io',
    "delphinet": 'https://ithacanet.ecadinfra.com',
    "mainnet": 'https://mainnet.smartpy.io',
  };

  static final List<String> mainNodes = [
    "https://mainnet-node.madfish.solutions",
    "https://mainnet-tezos.giganode.io",
    "https://mainnet.smartpy.io",
    "https://rpc.tzbeta.net",
    "https://mainnet.api.tez.ie",
  ];

  static final Map<String, String> testNodes = {
    "ghostnet": "https://rpc.tzkt.io/ghostnet",
    "jakartanet": "https://rpc.tzkt.io/jakartanet",
  };

  init() async {
    var data = await databse.getTezsterDatabase();
    var result = data != null &&
        data.length > 0 &&
        (data['accounts']['mainnet'].length > 0 ||
            data['accounts']['delphinet'].length > 0);

    if (result) {
      final localAuth = LocalAuthentication();
      if (await localAuth.isDeviceSupported()) {
        var didAuthenticate;
        try {
          didAuthenticate = await localAuth.authenticate(
              localizedReason: 'Please authenticate');
        } catch (e) {
          didAuthenticate = true;
        }
        if (!didAuthenticate) {
          _getOutOfApp();
        }
      }
    }

    //fetch current selected rpc
    var storage = await getStorage();
    await getCurrentSelectedNode(storage.provider != "mainnet");
    rpc['mainnet'] = StorageSingleton().currentSelectedNode;
    return result;
  }

  void _getOutOfApp() {
    if (Platform.isIOS) {
      try {
        exit(0);
      } catch (e) {
        SystemNavigator.pop();
      }
    } else {
      try {
        SystemNavigator.pop();
      } catch (e) {
        exit(0);
      }
    }
  }

  Future<bool> postStorage(StorageModel model,
      [isCreateNewWallet = false]) async {
    // try {
    StorageSingleton().storage = model;
    var _modelData = jsonEncode(model);
    await databse.postTezsterDatabase(_modelData);

    return true;
  }

  Future<StorageModel> getStorage([callback]) async {
    if (StorageSingleton().storage != null) return StorageSingleton().storage;
    var data = await databse.getTezsterDatabase();
    if (data == null || data.length == 0) {
      data = StorageModel().fromJson(jsonDecode(jsonEncode(StorageModel())));
    } else {
      data = StorageModel().fromJson(data);
    }
    StorageSingleton().storage = data;
    return data;
  }

  Future<void> getCurrentSelectedNode(bool isTestNet) async {
    if (isTestNet) {
      StorageSingleton().currentSelectedNode =
          await TezsterDatabase().getFromStorage("test_node");
      if (StorageSingleton().currentSelectedNode == null) {
        StorageSingleton().currentSelectedNode =
            testNodes[testNodes.keys.toList()[0]];
      }
      setCurrentSelectedNode(StorageSingleton().currentSelectedNode, true);
    } else {
      StorageSingleton().currentSelectedNode =
          await TezsterDatabase().getFromStorage("main_node");
      if (StorageSingleton().currentSelectedNode == null) {
        StorageSingleton().currentSelectedNode = mainNodes[0];
      }
      setCurrentSelectedNode(StorageSingleton().currentSelectedNode, false);
    }
  }

  void setCurrentSelectedNode(String node, [bool isTestNet]) async {
    StorageSingleton().currentSelectedNode = node;
    DataHandlerController().updaterpcUrl(node);
    if (isTestNet) {
      TezsterDatabase().setInStorage("test_node", node);
      rpc['delphinet'] = node;
      var nodes = testNodes.keys
          .toList()
          .where((element) => testNodes[element] == node)
          .toList();
      if (nodes.isEmpty) {
        StorageSingleton().currentSelectedNetwork = testNodes.keys.toList()[0];
      } else {
        StorageSingleton().currentSelectedNetwork = nodes[0];
      }
    } else {
      TezsterDatabase().setInStorage("main_node", node);
      StorageSingleton().currentSelectedNetwork = "";
      rpc['mainnet'] = node;
    }
  }
}
