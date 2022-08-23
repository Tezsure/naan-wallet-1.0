import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tezster_wallet/models/tokens_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonFunction {
  static getAmountValueUsingBigInt(String amount, int decimals) {
    return (BigInt.parse(amount ?? '0') /
            BigInt.parse(pow(10, decimals ?? 6).toString()))
        .toStringAsFixed(6);
  }

  static String normalizeMichelineWhiteSpace(String fragment) {
    return fragment
        .replaceAll(new RegExp(r'\n/g'), ' ')
        .replaceAll(new RegExp(r' +'), ' ')
        .replaceAll(new RegExp(r'\[{'), '[ {')
        .replaceAll(new RegExp(r'}\]'), '} ]')
        .replaceAll(new RegExp(r'},{'), '}, {')
        .replaceAll(new RegExp(r'\]}'), '] }')
        .replaceAll(new RegExp(r'":"'), '": "')
        .replaceAll(new RegExp(r'":\['), '": [')
        .replaceAll(new RegExp(r'{"'), '{ "')
        .replaceAll(new RegExp(r'"}'), '" }')
        .replaceAll(new RegExp(r',"'), ', "')
        .replaceAll(new RegExp(r'","'), '", "')
        .replaceAll(new RegExp(r'\[\['), '[ [')
        .replaceAll(new RegExp(r'\]\]'), '] ]')
        .replaceAll(new RegExp(r'\["'), '[ "')
        .replaceAll(new RegExp(r'"\]'), '" ]')
        .replaceAll(new RegExp(r'\[ +\]'), '\[\]')
        .trim();
  }

  static bool isValidTzOrKTAddress(String address) {
    return (address.startsWith('tz') || address.startsWith('KT')) &&
        address.length == 36;
  }

  static getStatusBadgeColor(status) {
    switch (status) {
      case "applied":
        return Colors.green;
        break;
      case "pending":
        return Color(0xFFE1D34F);
        break;
      case "lost":
        return Color(0xFFE1D34F);
        break;
      default:
        return Colors.green;
    }
  }

  static setSystemNavigatinColor(backgroundColor) {
    SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: backgroundColor,
    );
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  }

  static void launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  static String roundUpDollar(var value) {
    if (double.parse(value.toString()) >= 100) {
      value = value.round();
      value = double.parse(value.toString()).toStringAsFixed(0);
    } else {
      value = double.parse(value.toString()).toStringAsFixed(2);
    }
    return value;
  }

  static roundUpTokenOrXtz(var value) {
    value = value.toString();
    value =
        double.parse(value).toStringAsFixed(10).replaceAll(RegExp(r'0*$'), '');
    if (value.endsWith('.')) value = value.substring(0, value.length - 1);
    return value;
  }

  static get allTokens => {
        'wAAVE': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1Lvtxpg4MiT2Bs38XGxwh3LGi5MkCENp4v',
          'tokenId': 0,
          'type': TOKEN_TYPE.FA2,
        },
        'wBUSD': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1UMAE2PBskeQayP5f2ZbGiVYF7h8bZ2gyp',
          'tokenId': 1,
          'type': TOKEN_TYPE.FA2,
        },
        'wCEL': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1KuV43iebbbrkBMGov2QMgAbsnAksx6ncW',
          'tokenId': 2,
          'type': TOKEN_TYPE.FA2,
        },
        'wCOMP': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1DA8NH6UqCiSZhEg5KboxosMqLghwwvmTe',
          'tokenId': 3,
          'type': TOKEN_TYPE.FA2,
        },
        'wCRO': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1GSjkSg6MFmEMnTJSk6uyYpWXaEYFahrS4',
          'tokenId': 4,
          'type': TOKEN_TYPE.FA2,
        },
        'wDAI': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1PQ8TMzGMfViRq4tCMFKD2QF5zwJnY67Xn',
          'tokenId': 5,
          'type': TOKEN_TYPE.FA2,
        },
        'wFTT': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1SzCtZYesqXt57qHymr3Hj37zPQT47JN6x',
          'tokenId': 6,
          'type': TOKEN_TYPE.FA2,
        },
        'wHT': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1GsTjbWkTgtsWenM6oWuTuft3Qb46p2x4c',
          'tokenId': 7,
          'type': TOKEN_TYPE.FA2,
        },
        'wHUSD': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1AN7BBmeSUN5eDDQLEhWmXv1gn4exc5k8R',
          'tokenId': 8,
          'type': TOKEN_TYPE.FA2,
        },
        'wLEO': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1MpRQvn2VRR26VJFPYUGcB8qqxBbXgk5xe',
          'tokenId': 9,
          'type': TOKEN_TYPE.FA2,
        },
        'wLINK': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1Lpysr4nzcFegC9ci9kjoqVidwoanEmJWt',
          'tokenId': 10,
          'type': TOKEN_TYPE.FA2,
        },
        'wMATIC': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1RsfuBee5o7GtYrdB7bzQ1M6oVgyBnxY4S',
          'tokenId': 11,
          'type': TOKEN_TYPE.FA2,
        },
        'wMKR': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1MaefGJRtu57DiVhQNEjYgTYok3X71iEDj',
          'tokenId': 12,
          'type': TOKEN_TYPE.FA2,
        },
        'wOKB': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1NQyNPXmjYktNBDhYkBKyTGYcJSkNbYXuh',
          'tokenId': 13,
          'type': TOKEN_TYPE.FA2,
        },
        'wPAX': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1Ca5FGSeFLH3ugstc5p56gJDMPeraBcDqE',
          'tokenId': 14,
          'type': TOKEN_TYPE.FA2,
        },
        'wSUSHI': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1Lotcahh85kp878JCEc1TjetZ2EgqB24vA',
          'tokenId': 15,
          'type': TOKEN_TYPE.FA2,
        },
        'wUNI': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1Ti3nJT85vNn81Dy5VyNzgufkAorUoZ96q',
          'tokenId': 16,
          'type': TOKEN_TYPE.FA2,
        },
        'wUSDC': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1U2hs5eNdeCpHouAvQXGMzGFGJowbhjqmo',
          'tokenId': 17,
          'type': TOKEN_TYPE.FA2,
        },
        'wUSDT': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1T4pfr6NL8dUiz8ibesjEvH2Ne3k6AuXgn',
          'tokenId': 18,
          'type': TOKEN_TYPE.FA2,
        },
        'wWBTC': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1DksKXvCBJN7Mw6frGj6y6F3CbABWZVpj1',
          'tokenId': 19,
          'type': TOKEN_TYPE.FA2,
        },
        'wWETH': {
          'contractAddress': 'KT18fp5rcTW7mbWDmzFwjLDUhs5MeJmagDSZ',
          'dexContractAddress': 'KT1DuYujxrmgepwSDHtADthhKBje9BosUs1w',
          'tokenId': 20,
          'type': TOKEN_TYPE.FA2,
        },
      };

  getShortTz1(String address) =>
      address.substring(0, 5) + "..." + address.substring(address.length - 3);
}
