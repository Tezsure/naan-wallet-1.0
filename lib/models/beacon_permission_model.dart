import 'dart:convert';

import 'package:tezster_dart/tezster_dart.dart';
import 'package:tezster_dart/types/tezos/tezos_chain_types.dart';

class BeaconPermissionModel {
  AppMetadata appMetadata;
  String id;
  Network network;
  List<OperationDetails> operationDetails;
  Origin origin;
  String senderId;
  String sourceAddress;
  String version;
  String payload;

  BeaconPermissionModel(
      {this.appMetadata,
      this.id,
      this.network,
      this.operationDetails,
      this.origin,
      this.senderId,
      this.sourceAddress,
      this.version});

  BeaconPermissionModel.fromJson(Map<String, dynamic> json) {
    appMetadata = json['appMetadata'] != null
        ? new AppMetadata.fromJson(json['appMetadata'])
        : null;
    id = json['id'];
    network =
        json['network'] != null ? new Network.fromJson(json['network']) : null;
    if (json['operationDetails'] != null) {
      operationDetails = <OperationDetails>[];
      json['operationDetails'].forEach((v) {
        operationDetails.add(new OperationDetails.fromJson(v));
      });
    }
    origin =
        json['origin'] != null ? new Origin.fromJson(json['origin']) : null;
    senderId = json['senderId'];
    sourceAddress = json['sourceAddress'];
    payload = json['payload'] ?? null;
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appMetadata != null) {
      data['appMetadata'] = this.appMetadata.toJson();
    }
    data['id'] = this.id;
    if (this.network != null) {
      data['network'] = this.network.toJson();
    }
    if (this.operationDetails != null) {
      data['operationDetails'] =
          this.operationDetails.map((v) => v.toJson()).toList();
    }
    if (this.origin != null) {
      data['origin'] = this.origin.toJson();
    }
    data['senderId'] = this.senderId;
    data['sourceAddress'] = this.sourceAddress;
    data['version'] = this.version;
    return data;
  }
}

class AppMetadata {
  String icon;
  String name;
  String senderId;

  AppMetadata({this.icon, this.name, this.senderId});

  AppMetadata.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    name = json['name'];
    senderId = json['senderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['senderId'] = this.senderId;
    return data;
  }
}

class Network {
  String identifier;

  Network({this.identifier});

  Network.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    return data;
  }
}

class OperationDetails {
  String amount;
  String destination;
  String kind;
  Parameters parameters;
  Map<String,dynamic> script;

  OperationDetails({this.amount, this.destination, this.kind, this.parameters,this.script});

  OperationDetails.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    destination = json['destination'];
    kind = json['kind'];
    parameters = json['parameters'] != null
        ? new Parameters.fromJson(json['parameters'])
        : null;
    script = json['script'] ?? null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['destination'] = this.destination;
    data['kind'] = this.kind;
    if (this.parameters != null) {
      data['parameters'] = this.parameters.toJson();
    }
    data['script'] = this.script;
    return data;
  }
}

class Parameters {
  String entrypoint;
  String value;
  TezosParameterFormat format = TezosParameterFormat.Michelson;

  Parameters({this.entrypoint, this.value});

  Parameters.fromJson(Map<String, dynamic> json) {
    entrypoint = json['entrypoint'];
    // if (json['value'] is List) {
    //   value = jsonEncode(json['value']);
    //   format = TezosParameterFormat.Micheline;
    // } else {
    value = TezsterDart.normalizePrimitiveRecordOrder(
        formatParameters(jsonEncode(json['value'] is List
            ? json['value']
            : json['value'].containsKey("expressions")
                ? json['value']['expressions']
                : json['value'])));
    // value = getParameters(json['value']);
    format = TezosParameterFormat.Micheline;
    // }
  }

  formatParameters(String data) {
    var baseData = jsonDecode(data);
    if(!(baseData is Map))
      return data;
    if (!baseData.containsKey("args") && baseData.containsKey("bytes")) {
      if (baseData['bytes'].toString().startsWith("0x")) {
        baseData['bytes'] = baseData['bytes'].toString().substring(2);
        return jsonEncode(baseData);
      }
    }
    if (!baseData.containsKey("args") || !(baseData['args'] is List) || !(baseData['args'][0] is Map)) {
      return data;
    }
    for (var key in baseData['args'][0].keys) {
      if (key == 'expressions') {
        baseData['args'][0] = baseData['args'][0][key];
      }
    }
    return jsonEncode(baseData);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entrypoint'] = this.entrypoint;
    if (this.value != null) {
      data['value'] = this.value;
    }
    return data;
  }

  String getParameters(Map<String, dynamic> data) {
    // var keys = data.keys.toList();
    var key;
    var finalString = "";
    var closeCount = 0;
    var closerStatement = <Map<int, String>>[];
    while ((key = isThereValueTypeListinMap(data)) != "") {
      if (data.containsKey('prim')) {
        finalString += "(" + data['prim'];
        if (data[key].length > 1 && data[key][0].containsKey('prim')) {
          closerStatement.add(
              {closeCount: " " + data[key][1][data[key][1].keys.toList()[0]]});
        }
      }

      if (data[key][0].containsKey('prim')) {
      } else {
        closerStatement = closerStatement
            .map(
              (e) => e[e.keys.toList()[0]].trim().startsWith('tz') ||
                      e[e.keys.toList()[0]].trim().startsWith('KT1')
                  ? {e.keys.toList()[0]: ' "${e[e.keys.toList()[0]].trim()}"'}
                  : e,
            )
            .toList();
        finalString += data[key].toList().fold(
            '',
            (t, e) =>
                t +
                ' ' +
                (e.values.toList()[0].startsWith('tz1') ||
                        e.values.toList()[0].startsWith('KT1')
                    ? '"${e.values.toList()[0]}"'
                    : e.values.toList()[0]));
        for (var i = 0; i <= closeCount; i++) {
          if (closerStatement
              .where((element) => element[closeCount - i] != null)
              .toList()
              .isNotEmpty) {
            finalString += closerStatement
                .where((element) => element[closeCount - i] != null)
                .toList()[0][closeCount - i]
                .toString();
          }
          finalString += ")";
        }
      }
      data = data[key][0];
      closeCount++;
    }
    return finalString.isEmpty ? data[data.keys.toList()[0]] : finalString;
  }

  String isThereValueTypeListinMap(Map<String, dynamic> data) {
    var k = '';
    data.forEach((key, value) {
      if (value is List) k = key;
    });
    return k;
  }
}

// class Value {
//   List<Args> args;
//   String prim;

//   Value({this.args, this.prim});

//   Value.fromJson(Map<String, dynamic> json) {
//     if (json['args'] != null) {
//       args = <Args>[];
//       json['args'].forEach((v) {
//         args.add(new Args.fromJson(v));
//       });
//     }
//     prim = json['prim'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.args != null) {
//       data['args'] = this.args.map((v) => v.toJson()).toList();
//     }
//     data['prim'] = this.prim;
//     return data;
//   }
// }

// class Args {
//   String int;
//   String string;

//   Args({this.int, this.string});

//   Args.fromJson(Map<String, dynamic> json) {
//     int = json['int'];
//     string = json['string'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['int'] = this.int;
//     data['string'] = this.string;
//     return data;
//   }
// }

class Origin {
  String id;

  Origin({this.id});

  Origin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
