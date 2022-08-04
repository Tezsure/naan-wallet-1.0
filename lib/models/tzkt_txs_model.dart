class TzktTxsModel {
  String type;
  int id;
  int level;
  String timestamp;
  String block;
  String hash;
  int counter;
  Sender sender;
  int gasLimit;
  int gasUsed;
  int storageLimit;
  int storageUsed;
  int bakerFee;
  int storageFee;
  int allocationFee;
  Target target;
  int amount;
  Parameter parameter;
  String status;
  bool hasInternals;
  Quote quote;
  String parameters;
  bool isSender;

  TzktTxsModel(
      {this.type,
      this.id,
      this.level,
      this.timestamp,
      this.block,
      this.hash,
      this.counter,
      this.sender,
      this.gasLimit,
      this.gasUsed,
      this.storageLimit,
      this.storageUsed,
      this.bakerFee,
      this.storageFee,
      this.allocationFee,
      this.target,
      this.amount,
      this.parameter,
      this.status,
      this.hasInternals,
      this.quote,
      this.parameters});

  TzktTxsModel.fromJson(Map<String, dynamic> json, [String accountHash]) {
    type = json['type'];
    id = json['id'];
    level = json['level'];
    timestamp = json['timestamp'];
    block = json['block'];
    hash = json['hash'];
    counter = json['counter'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    gasLimit = json['gasLimit'];
    gasUsed = json['gasUsed'];
    storageLimit = json['storageLimit'];
    storageUsed = json['storageUsed'];
    bakerFee = json['bakerFee'];
    storageFee = json['storageFee'];
    allocationFee = json['allocationFee'];
    target =
        json['target'] != null ? new Target.fromJson(json['target']) : null;
    amount = json['amount'];
    parameter = json['parameter'] != null
        ? new Parameter.fromJson(json['parameter'])
        : null;
    status = json['status'];
    hasInternals = json['hasInternals'];
    quote = json['quote'] != null ? new Quote.fromJson(json['quote']) : null;
    parameters = json['parameters'];
    if (accountHash != null && parameter == null)
      isSender = accountHash == sender.address;
    else if (accountHash != null &&
        parameter != null &&
        parameter.value != null &&
        parameter.value.length > 0) {
      isSender = parameter.value[0].from == accountHash ||
          sender.address == accountHash;
    } else {
      isSender = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['level'] = this.level;
    data['timestamp'] = this.timestamp;
    data['block'] = this.block;
    data['hash'] = this.hash;
    data['counter'] = this.counter;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    data['gasLimit'] = this.gasLimit;
    data['gasUsed'] = this.gasUsed;
    data['storageLimit'] = this.storageLimit;
    data['storageUsed'] = this.storageUsed;
    data['bakerFee'] = this.bakerFee;
    data['storageFee'] = this.storageFee;
    data['allocationFee'] = this.allocationFee;
    if (this.target != null) {
      data['target'] = this.target.toJson();
    }
    data['amount'] = this.amount;
    if (this.parameter != null) {
      data['parameter'] = this.parameter.toJson();
    }
    data['status'] = this.status;
    data['hasInternals'] = this.hasInternals;
    if (this.quote != null) {
      data['quote'] = this.quote.toJson();
    }
    data['parameters'] = this.parameters;
    return data;
  }
}

class Sender {
  String address;

  Sender({this.address});

  Sender.fromJson(Map<String, dynamic> json) {
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    return data;
  }
}

class Target {
  String alias;
  String address;

  Target({this.alias, this.address});

  Target.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alias'] = this.alias;
    data['address'] = this.address;
    return data;
  }
}

class Parameter {
  String entrypoint;
  List<Value> value;

  Parameter({this.entrypoint, this.value});

  Parameter.fromJson(Map<String, dynamic> json) {
    entrypoint = json['entrypoint'];
    if (json['value'] != null) {
      value = <Value>[];
      if (json['value'] is List) {
        json['value'].forEach((v) {
          value.add(new Value.fromJson(v));
        });
      } else
        try {
          value.add(Value()
            ..from = json['value']['from']
            ..txs = [
              Txs()
                ..to = json['value']['to']
                ..amount = json['value']['value']
                ..tokenId = '-1'
            ]);
        } catch (e) {
          // print(value);
        }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entrypoint'] = this.entrypoint;
    if (this.value != null) {
      data['value'] = this.value.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Value {
  List<Txs> txs;
  String from;

  Value({this.txs, this.from});

  Value.fromJson(Map<String, dynamic> json) {
    if (json['txs'] != null) {
      txs = <Txs>[];
      json['txs'].forEach((v) {
        txs.add(new Txs.fromJson(v));
      });
    }
    from = json['from_'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.txs != null) {
      data['txs'] = this.txs.map((v) => v.toJson()).toList();
    }
    data['from_'] = this.from;
    return data;
  }
}

class Txs {
  String to;
  String amount;
  String tokenId;

  Txs({this.to, this.amount, this.tokenId});

  Txs.fromJson(Map<String, dynamic> json) {
    to = json['to_'];
    amount = json['amount'];
    tokenId = json['token_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to_'] = this.to;
    data['amount'] = this.amount;
    data['token_id'] = this.tokenId;
    return data;
  }
}

class Quote {
  double usd;

  Quote({this.usd});

  Quote.fromJson(Map<String, dynamic> json) {
    usd = json['usd'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usd'] = this.usd;
    return data;
  }
}
