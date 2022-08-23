import 'dart:convert';
import 'dart:io';

import 'package:flutter_file_path_provider/flutter_file_path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';

enum StorageType { LOCAL, TEMP }

class TezsterDatabase {
  final fsStorage = new FlutterSecureStorage();

  StorageType storageType = StorageType.TEMP;

  TezsterDatabase();

  TezsterDatabase.setEncryptKey(key);

  Future<String> getDatabasePath() async {
    storageType = (await Permission.storage.isGranted)
        ? StorageType.LOCAL
        : StorageType.TEMP;
    if (storageType == StorageType.TEMP) return null;
    var d = Platform.isIOS
        ? await FlutterFilePathProvider.instance
            .getInternalStorageFileDirectory() // getHomeDirectory()
        : await FlutterFilePathProvider.instance
            .getExternalStorageFileDirectory();
    d.directory = Directory(d.directory.path + "tezster/")
      ..createSync(recursive: true);
    return d.directory.path + "${StorageModel().storagename}.tezster";
  }

  Future<File> checkIfExistsOrCreate() async {
    var f = File(await getDatabasePath());
    if (!f.existsSync()) f.createSync();
    return f;
  }

  Future<dynamic> getTezsterDatabase() async {
    storageType = (await Permission.storage.isGranted)
        ? StorageType.LOCAL
        : StorageType.TEMP;
    var data;
    if (storageType == StorageType.TEMP) {
      data = await fsStorage.read(key: StorageModel().storagename) ?? '';
    } else {
      var f = await checkIfExistsOrCreate();
      data = f.readAsStringSync();
    }

    return data.isEmpty ? "" : jsonDecode(await _decryptString(data));
  }

  Future<dynamic> postTezsterDatabase(String data) async {
    storageType = (await Permission.storage.isGranted)
        ? StorageType.LOCAL
        : StorageType.TEMP;
    data = await _encryptString(data);
    if (storageType == StorageType.TEMP) {
      await fsStorage.write(key: StorageModel().storagename, value: data);
      return;
    } else {
      var f = await checkIfExistsOrCreate();
      return f.writeAsStringSync(data);
    }
  }

  Future<String> _encryptString(String text) async {
    var data = '';
    for (var i = 0; (i < text.length); i++) {
      data += (text[i].codeUnits[0] + 2).toString() + " ";
    }
    data = data.substring(0, data.length - 1);
    return data;
  }

  Future<String> _decryptString(var text) async {
    var data = '';
    text = text.split(' ');
    for (var i = 0; (i < text.length); i++) {
      data += String.fromCharCode(int.parse(text[i]) - 2);
    }
    return data;
  }

  Future<String> getFromStorage(String key) async {
    String value = await fsStorage.read(key: key);
    return value;
  }

  void setInStorage(String key, String value) async {
    await fsStorage.write(key: key, value: value);
  }
}
