import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';

class StorageSingleton {
  static final StorageSingleton _singleton = StorageSingleton._internal();

  factory StorageSingleton() {
    return _singleton;
  }

  StorageSingleton._internal();

  StorageModel storage;
  String currentSelectedNode;
  String currentSelectedNetwork = "";
  bool isTestNetSelected;

  bool isFxHashFlow = false;
  String eventUri = "";

  updateStorage(StorageModel model) => this.storage = model;
}
