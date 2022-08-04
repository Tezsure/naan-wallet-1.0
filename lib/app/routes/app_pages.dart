import 'package:get/get.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/bindings/beacon_permisson_binding.dart';
import 'package:tezster_wallet/app/modules/beacon_permisson/views/beacon_form_view.dart';
import 'package:tezster_wallet/app/modules/home_page/bindings/home_page_binding.dart';
import 'package:tezster_wallet/app/modules/home_page/views/home_page_view.dart';
import 'package:tezster_wallet/app/modules/loading_screen/views/loading_screen_view.dart';
import 'package:tezster_wallet/app/modules/receive_funds/bindings/receive_funds_binding.dart';
import 'package:tezster_wallet/app/modules/receive_funds/views/receive_funds_view.dart';
import 'package:tezster_wallet/app/modules/recover_wallet/bindings/recover_wallet_binding.dart';
import 'package:tezster_wallet/app/modules/recover_wallet/views/recover_wallet_view.dart';
import 'package:tezster_wallet/app/modules/recovery_phrase/bindings/recovery_phrase_binding.dart';
import 'package:tezster_wallet/app/modules/recovery_phrase/views/recovery_phrase_view.dart';
import 'package:tezster_wallet/app/modules/reveal_seed_phrase/bindings/reveal_seed_phrase_binding.dart';
import 'package:tezster_wallet/app/modules/reveal_seed_phrase/views/reveal_seed_phrase_view.dart';
import 'package:tezster_wallet/app/modules/send_assets/bindings/send_assets_binding.dart';
import 'package:tezster_wallet/app/modules/send_assets/views/send_assets_view.dart';
import 'package:tezster_wallet/app/modules/splash_page/bindings/splash_page_binding.dart';
import 'package:tezster_wallet/app/modules/splash_page/views/splash_page_view.dart';
import 'package:tezster_wallet/app/modules/success_page/bindings/success_page_binding.dart';
import 'package:tezster_wallet/app/modules/success_page/views/success_page_view.dart';
import 'package:tezster_wallet/app/modules/walkthrough/bindings/walkthrough_binding.dart';
import 'package:tezster_wallet/app/modules/walkthrough/views/walkthrough_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.WALKTHROUGH;

  static final routes = [
    GetPage(
      name: _Paths.HOME_PAGE,
      page: () => HomePageView(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: _Paths.WALKTHROUGH,
      page: () => WalkthroughView(),
      binding: WalkthroughBinding(),
    ),
    GetPage(
      name: _Paths.SUCCESS_PAGE,
      page: () => SuccessPageView(),
      binding: SuccessPageBinding(),
    ),
    GetPage(
      name: _Paths.RECOVERY_PHRASE,
      page: () => RecoveryPhraseView(),
      binding: RecoveryPhraseBinding(),
    ),
    GetPage(
      name: _Paths.LOADING_SCREEN,
      page: () => LoadingScreenView(),
      // binding: LoadingScreenBinding(),
    ),
    GetPage(
      name: _Paths.RECOVER_WALLET,
      page: () => RecoverWalletView(),
      binding: RecoverWalletBinding(),
    ),
    GetPage(
      name: _Paths.RECEIVE_FUNDS,
      page: () => ReceiveFundsView(),
      binding: ReceiveFundsBinding(),
    ),
    GetPage(
      name: _Paths.REVEAL_SEED_PHRASE,
      page: () => RevealSeedPhraseView(),
      binding: RevealSeedPhraseBinding(),
    ),
    GetPage(
      name: _Paths.BEACON_PERMISSON,
      page: () => BeaconFormView(),
      binding: BeaconPermissonBinding(),
    ),
    GetPage(
      name: _Paths.SEND_ASSETS,
      page: () => SendAssetsView(),
      binding: SendAssetsBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_PAGE,
      page: () => SplashPageView(),
      binding: SplashPageBinding(),
    ),
  ];
}
