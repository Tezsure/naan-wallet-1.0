# Naan - A Tasty Tezos Wallet

Naan is a fun, simple, and secure way to create a Tezos wallet, collect NFTs, and explore the new world of Web3 on Tezos.

Features:

1. Multiple account
2. Send&Receive FA1.2.FA2 token
3. Dapps for exlplore tezos
4. NFT gallery
5. Import NFT galley using publicKey
6. Delegation to bakers
7. Testnet support (Tokens are not displayed due to dependency on Teztools.io which only supports mainnet)

## Getting Started

This project is a starting point for a Flutter application. A few resources to get you started if this is your first Flutter project:

- Lab: [Write your first Flutter app](https://flutter.dev/docs/get-started/hello-world)
- Cookbook: [Useful Flutter samples](https://flutter.dev/docs/cookbook/design/useful-elements).
- API: [Flutter API reference](https://api.flutter.dev/).
- Docs: [Flutter documentation](https://flutter.dev/docs/).

For help getting started with Flutter, view our [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.´

## Requirements

- Flutter v2.0.6
- [Android Studio](https://developer.android.com/studio?gclid=CjwKCAjw3K2XBhAzEiwAmmgrAt5_YcC3ioQZtDywUHoioOSz6PQ4fG2VxJL_Sx3j7HKfaC3ZeHTo1BoCfWwQAvD_BwE&gclsrc=aw.ds#downloads)
- [Xcode](https://developer.apple.com/xcode/resources/) // To build project on macOS

## Install

Check if the version number is correct, and the version that requires flutter is 2.x.x the version.

`Flutter --version`

The recommended version of flutter here is 2.0.6, the download address is as follows:

[windows_2.0.6-stable](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_2.0.6-stable.zip)

[macos_2.0.6-stable](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_2.0.6-stable.zip)

[Note] If your flutter version is a 1.x.xversion, please upgrade your flutter version, or you will encounter errors.

```sh
Flutter upgrade
```

Run the following command to see if you need to install other dependencies to complete the installation

- To check if you have the dependencies installed

```sh
flutter doctor
```

- To get the packages

```sh
flutter pub get
```

- To run the app

```sh
flutter run // To run the app
```

- To build the app

```sh
flutter build ios // To build the app for ios
flutter build android // To build the app for android
```

- To test the app

```sh
flutter test --coverage // To test the app
```

### Build the project for iOS

Your development environment must meet the [macOS system requirements](https://docs.flutter.dev/get-started/install/macos#system-requirements) for Flutter with [Xcode installed](https://docs.flutter.dev/get-started/install/macos#install-xcode). Flutter supports iOS 9.0 and later. Additionally, you will need [CocoaPods](https://cocoapods.org/) version 1.10 or later.

Navigate to your target’s settings in Xcode:

1. Open the default Xcode workspace in your project by running open ios/Runner.xcworkspace in a terminal window from your Flutter project directory.
2. To view your app’s settings, select the Runner target in the Xcode navigator.

**Automatically manage signing**
Whether Xcode should automatically manage app signing and provisioning. This is set true by default, which should be sufficient for most apps. For more complex scenarios, see the [Code Signing Guide](https://developer.apple.com/library/content/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html).

- Installing Pods
  Use the following command to install the necessary dependencies for your project:

```sh
pod install // In your ios project directory
```

- Updating Pods

```sh
pod update // In your ios project directory
```

## Naan device compatibility report for Dapp Browser

- Click here to view [doc](https://docs.google.com/spreadsheets/d/1_YM3T2tcfbEkr9upE3RgxicZQLstixKaCu5P177XW3Q/edit?usp=sharing)
  ![Naan device compatibility report for Dapp Browser android](naan_device_compatibility_report_android.png)
  ![Naan device compatibility report for Dapp Browser ios](naan_device_compatibility_report_ios.png)

## Naan wallet testcase scenarios.
- Click here to view [doc](https://docs.google.com/spreadsheets/d/1PgiDEE6Le2kG7MtyD7SPV-0khhxqDnjdLVzIXqmf2MQ/edit?usp=sharing)
![NaanWallet Testcase Scenarios](naan_wallet_testcase_scenarios.png)

_NOTE:
This repository is open-sourced, and is under active improvements based on suggestions and bug-reports. Users are requested to double check the transaction details on their wallet's confirmation page. The authors take no responsibility for the loss of digital assets._
