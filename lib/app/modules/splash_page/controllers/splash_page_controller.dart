import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:tezster_wallet/app/routes/app_pages.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_singleton.dart';
import 'package:tezster_wallet/app/utils/storage_utils/storage_utils.dart';
import 'package:uni_links/uni_links.dart';

class SplashPageController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    // _testAsyncErrorOnInit();
  }

  checkAccounts() async {
    final initialUri = await getInitialUri();
    print(initialUri.toString());

    if (initialUri.toString().startsWith("fxhash://")) {
      print("Fxhash flow");
      StorageSingleton().isFxHashFlow = true;
    }
    StorageUtils().init().then((isUserLogedIn) {
      isUserLogedIn = isUserLogedIn ?? false;
      if (isUserLogedIn)
        StorageUtils()
            .getStorage()
            .then((value) => StorageSingleton().storage = value);
      Future.delayed(
          Duration(
            seconds: 1,
          ), () async {
        Get.offAndToNamed(isUserLogedIn ? Routes.HOME_PAGE : AppPages.INITIAL);
      });
    });
  }

  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      // FirebaseCrashlytics.instance.crash();
      // final List<int> list = <int>[];
      // print(list[100]);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
