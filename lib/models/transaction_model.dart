class TransactionModel {
  String operationHash;
  String label;
  String status;
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
  Sender target;
  var amount;
  List<Errors> errors;
  bool hasInternals;
  Quote quote;
  bool isSender;

  TransactionModel(
      {this.operationHash,
      this.label,
      this.status,
      this.type,
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
      this.errors,
      this.hasInternals,
      this.quote,
      this.isSender});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    operationHash = json['operationHash'];
    label = json['label'];
    status = json['status'];
    type = json['type'];
    id = json['id'];
    level = json['level'];
    timestamp = json['timestamp'];
    block = json['block'];
    hash = json['hash'];
    counter = json['counter'];
    sender = json['sender'] != null && !(json['sender'] is String)
        ? new Sender.fromJson(json['sender'])
        : new Sender(address: json['sender']);
    gasLimit = json['gasLimit'];
    gasUsed = json['gasUsed'];
    storageLimit = json['storageLimit'];
    storageUsed = json['storageUsed'];
    bakerFee = json['bakerFee'];
    storageFee = json['storageFee'];
    allocationFee = json['allocationFee'];
    target = json['target'] != null
        ? new Sender.fromJson(json['target'])
        : new Sender(address: json['receiver']);
    amount = json['amount'];
    if (json['errors'] != null) {
      // ignore: deprecated_member_use
      errors = new List<Errors>();
      json['errors'].forEach((v) {
        errors.add(new Errors.fromJson(v));
      });
    }
    hasInternals = json['hasInternals'];
    quote = json['quote'] != null ? new Quote.fromJson(json['quote']) : null;
    isSender = json['isSender'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operationHash'] = this.operationHash;
    data['label'] = this.label;
    data['status'] = this.status;
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
    if (this.errors != null) {
      data['errors'] = this.errors.map((v) => v.toJson()).toList();
    }
    data['hasInternals'] = this.hasInternals;
    if (this.quote != null) {
      data['quote'] = this.quote.toJson();
    }
    data['isSender'] = this.isSender;
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

class Errors {
  String type;

  Errors({this.type});

  Errors.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
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
