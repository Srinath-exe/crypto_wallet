import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserModel {
  String? uid;
  String? name;
  String? mail;
  String? phone;
  String? profileUrl;
  List<String>? friends;
  List<String>? token;
  DateTime? lastSeen;
  bool? isOnline;

  UserModel(
      {this.uid,
      this.name,
      this.mail,
      this.phone,
      this.profileUrl,
      this.friends,
      this.isOnline,
      this.lastSeen,
      this.token});

  factory UserModel.fromMap(DocumentSnapshot data) {
    return UserModel(
      uid: data['uid'],
      name: data['name'].toString().capitalize,
      mail: data['email'],
      phone: data['phone'],
      profileUrl: data['photo_url'],
      friends: data['friends'] == null
          ? []
          : List<String>.from(data['friends']!.map((x) => x)),
      isOnline: data["isOnline"] ?? false,
      lastSeen: data["lastSeen"] == null || data["lastSeen"] == ""
          ? DateTime.parse(DateTime.now.toString())
          : DateTime.parse(data["lastSeen"].toString()),
      token: data['token'] == null
          ? []
          : List<String>.from(data['token']!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "email": mail,
        "phone": phone,
        "photo_url": profileUrl,
        "friends":
            friends == null ? [] : List<dynamic>.from(friends!.map((x) => x)),
        "token": token == null ? [] : List<dynamic>.from(token!.map((x) => x)),
        "lastSeen": lastSeen == null
            ? DateTime.now().toIso8601String()
            : lastSeen!.toIso8601String(),
        "isOnline": isOnline,
      };
}

List<UserModel> UserModels = [
  UserModel(
      uid: "",
      name: "",
      mail: "",
      phone: "",
      profileUrl: "",
      friends: [],
      token: [])
];
