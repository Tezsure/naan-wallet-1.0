import 'package:flutter/material.dart';

class ContactModel {
  String name;
  String pkHash;

  ContactModel({@required this.name, @required this.pkHash});

  ContactModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pkHash = json['pkHash'];
  }

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'pkHash': this.pkHash,
      };
}
