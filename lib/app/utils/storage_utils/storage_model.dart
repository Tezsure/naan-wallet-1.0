class StorageModel {
  Map userInfo;
  String version;
  String provider;
  String storagename;
  String tezsureApi;
  int currentAccountIndex = 0;
  Map<dynamic, dynamic> accounts;
  List networks;
  Map<dynamic, dynamic> tzkt;
  Map<dynamic, dynamic> transactions;
  Map<dynamic, dynamic> rpc;
  Map<dynamic, dynamic> contacts;
  String authType;

  StorageModel({
    this.userInfo = const {},
    this.version = "1.0",
    this.provider = "mainnet",
    this.storagename = 'tezsure-wallet-storage-v1.0.0',
    this.tezsureApi = 'https://dev.api.tezsure.com',
    this.currentAccountIndex = 0,
    this.accounts,
    this.networks = const [
      'edonet',
      'delphinet',
      'mainnet',
    ],
    this.tzkt = const {
      "edonet": 'https://api.edonet.tzkt.io',
      "delphinet": 'https://api.delphinet.tzkt.io',
      "mainnet": 'https://api.tzkt.io',
    },
    this.transactions = const {
      "edonet": [],
      "delphinet": [],
      "mainnet": [],
    },
    this.rpc = const {
      "edonet": 'https://edonet-tezos.giganode.io',
      "delphinet": 'https://ithacanet.ecadinfra.com/',
      "mainnet": 'https://tezos-prod.cryptonomic-infra.tech:443',
    },
    this.authType = "",
    this.contacts = const {
      "edonet": [],
      "delphinet": [],
      "mainnet": [],
    },
  }) {
    if (this.accounts == null) {
      this.accounts = {
        "edonet": [],
        "delphinet": [],
        "mainnet": [],
      };
    }
  }

  Map<String, dynamic> toJson() => {
        "userInfo": this.userInfo,
        "currentAccountIndex": this.currentAccountIndex,
        "version": this.version,
        "provider": this.provider,
        "storagename": this.storagename,
        "tezsureApi": this.tezsureApi,
        "accounts": this.accounts,
        "networks": this.networks,
        "tzkt": this.tzkt,
        "transactions": this.transactions,
        "rpc": this.rpc,
        "authType": this.authType,
        "contacts": this.contacts,
      };

  StorageModel fromJson(Map<dynamic, dynamic> parse) {
    return StorageModel(
      userInfo: parse["userInfo"],
      version: parse["version"],
      provider: parse["provider"],
      currentAccountIndex: parse['currentAccountIndex'] ?? 0,
      storagename: parse["storagename"],
      tezsureApi: parse["tezsureApi"],
      accounts: parse["accounts"],
      networks: parse["networks"],
      tzkt: parse["tzkt"],
      transactions: parse["transactions"],
      rpc: parse["rpc"],
      authType: parse["authType"],
      contacts: parse["contacts"],
    );
  }
}
