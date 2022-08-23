class ListedTokenModel {
  String name;
  String contractAddress;
  String dexContractAddress;

  ListedTokenModel({this.name, this.contractAddress, this.dexContractAddress});

  ListedTokenModel.fromJson(Map<dynamic, dynamic> parse) {
    name = parse['name'];
    contractAddress = parse['contractAddress'];
    dexContractAddress = parse['dexContractAddress'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contractAddress': contractAddress,
      'dexContractAddress': dexContractAddress,
    };
  }
}
