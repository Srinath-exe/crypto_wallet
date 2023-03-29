// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

WalletModel walletModelFromJson(String str) =>
    WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
  WalletModel({
    this.total,
    this.token,
    this.publicKey,
    this.privateKey,
    this.docId,
  });
  String? docId;
  int? total;
  double? token;
  String? publicKey;
  String? privateKey;

  factory WalletModel.fromJson(dynamic json) => WalletModel(
        docId: json.id,
        total: json["total"],
        token: json["token"]?.toDouble(),
        publicKey: json["publicKey"],
        privateKey: json["privateKey"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "token": token,
        "publicKey": publicKey,
        "privateKey": privateKey,
      };
}

var wallet = {
  "total": 650,
  "token": 6520.416,
  "publicKey": "",
  "privateKey": "",
};
