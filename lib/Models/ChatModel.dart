import 'package:crypto_wallet/Models/User_model.dart';

class ChatModel {
  final String? chatId;
  final List<String>? users;
  final List<String>? seen;
  final DateTime? timeSent;
  final String? lastMessage;
  final int? messageCount;
  UserModel? reciever;

  ChatModel(
      {this.chatId,
      this.users,
      this.seen,
      this.timeSent,
      this.lastMessage,
      this.messageCount,
      this.reciever});

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'users': users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
        'seen': seen == null ? [] : List<dynamic>.from(seen!.map((x) => x)),
        'timeSent': timeSent!.millisecondsSinceEpoch,
        'lastMessage': lastMessage,
        'messageCount': messageCount
      };

  factory ChatModel.fromJson(dynamic json) {
    return ChatModel(
      chatId: json.id,
      users: json["users"] == null
          ? []
          : List<String>.from(json["users"]!.map((x) => x)),
      timeSent: DateTime.fromMillisecondsSinceEpoch(json['timeSent']),
      seen: json["seen"] == null
          ? []
          : List<String>.from(json["seen"]!.map((x) => x)),
      lastMessage: json['lastMessage'] ?? '',
      messageCount: json['messageCount'] ?? 0,
    );
  }
}
