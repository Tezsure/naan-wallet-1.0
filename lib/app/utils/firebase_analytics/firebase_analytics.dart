import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_model.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';

class FireAnalytics {
  static final FireAnalytics _singleton = FireAnalytics._internal();
  static FirebaseAnalytics _analytics;
  StorageModel _storage;

  factory FireAnalytics() => _singleton;

  FireAnalytics._internal() {
    _analytics = FirebaseAnalytics();
  }

  void logEvent(String name,
      {bool addTz1 = false, Map<String, dynamic> param}) async {
    if (addTz1) {
      _storage = await StorageUtils().getStorage();
      var currentAccount =
          _storage.accounts[_storage.provider][_storage.currentAccountIndex];
      if (param == null) param = {};
      param['tz1'] = currentAccount['publicKeyHash'];
      param['is_gallery'] = currentAccount['secretKey'] != null &&
              currentAccount['secretKey'].toString().length > 0
          ? "false"
          : "true";
    }
    await _analytics.logEvent(name: name, parameters: param);
    _storage = null;
  }

  FirebaseAnalytics getAnalytics() {
    return _analytics;
  }
}
