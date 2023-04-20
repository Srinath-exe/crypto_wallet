// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  TransactionModel(
      {this.transactionId,
      this.sender,
      this.reciever,
      this.token,
      this.value,
      this.blockChainNetwork,
      this.gasFees,
      this.dateTime,
      this.recieverAddress,
      this.senderAddress,
      this.senderPublicKey,
      this.recieverPublicKey,
      this.status,
      this.members});

  String? transactionId;
  String? sender;
  String? reciever;
  String? token;
  double? value;
  String? blockChainNetwork;
  double? gasFees;
  DateTime? dateTime;
  String? recieverAddress;
  String? senderAddress;
  String? senderPublicKey;
  String? recieverPublicKey;
  String? status;
  List<String>? members;

  factory TransactionModel.fromJson(DocumentSnapshot json) {
    String data = json.data().toString();

    return TransactionModel(
      transactionId: json.id,
      sender: json["sender"],
      reciever: json["reciever"],
      token: json["token"],
      value: json["value"]?.toDouble(),
      blockChainNetwork: json["blockChainNetwork"],
      gasFees: json["gasFees"]?.toDouble(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
      recieverAddress: json["RecieverAddress"],
      senderAddress: json["senderAddress"],
      senderPublicKey: json["senderPublicKey"],
      recieverPublicKey: json["recieverPublicKey"],
      status: json["status"],
      members: data.contains('members')
          ? json.get("members") == null
              ? []
              : List<String>.from(json.get("members").map((x) => x))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "transactionId": transactionId,
        "sender": sender,
        "reciever": reciever,
        "token": token,
        "value": value,
        "blockChainNetwork": blockChainNetwork,
        "gasFees": gasFees,
        "dateTime": dateTime!.millisecondsSinceEpoch,
        "RecieverAddress": recieverAddress,
        "senderAddress": senderAddress,
        "senderPublicKey": senderPublicKey,
        "recieverPublicKey": recieverPublicKey,
        "status": status,
        "members":
            members == null ? [] : List<dynamic>.from(members!.map((x) => x)),
      };
}

var transactions = {
  "transactionId": "",
  "sender": "",
  "reciever": "",
  "token": "",
  "value": 5410.01,
  "blockChainNetwork": "",
  "gasFees": 432.34,
  "dateTime": "",
  "RecieverAddress": "",
  "senderAddress": "",
  "senderPublicKey": "",
  "recieverPublicKey": "",
  "status": ""
};

enum TransactionStatus {
  pending("pending"),
  completed("completed"),
  waiting("waiting"),
  failed("failed");

  const TransactionStatus(this.type);
  final String type;
}

Map<String, TransactionStatus> mapStr = {
  "pending": TransactionStatus.pending,
  "completed": TransactionStatus.completed,
  "waiting": TransactionStatus.waiting,
  "failed": TransactionStatus.failed,
};
