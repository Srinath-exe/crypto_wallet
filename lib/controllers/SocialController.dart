import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/Models/ChatModel.dart';
import 'package:crypto_wallet/Models/MessageModel.dart';
import 'package:crypto_wallet/Models/User_model.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/controllers/AuthController.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class SocialController extends GetxController {
  late CollectionReference chatCollection;
  AuthController authController = Get.find();

  Rx<UserModel> currentUser = Rx<UserModel>(UserModel());
  late Reference postImageRef = firebaseStorage.ref("posts");
  RxList<ChatModel> chats = RxList<ChatModel>([]);
  RxMap<String, UserModel> messageUsers = RxMap<String, UserModel>({});
  RxString chatId = ''.obs;
  @override
  void onInit() {
    super.onInit();
    chatCollection = firebaseFirestore
        .collection("socialMedia")
        .doc("messages")
        .collection("chat");

    currentUser.bindStream(getCurrentUser());
    chats.bindStream(getAllChats());

    chats.listen((p0) {
      p0.forEach((element) {
        List.generate(element.users!.length, (index) async {
          if (!messageUsers.containsKey(element.users![index])) {
            messageUsers[element.users![index]] =
                await getUserReturn(userId: element.users![index]);
          }
        });
      });
    });
  }

  Future<UserModel> getUserReturn({required String userId}) async {
    try {
      log(userId);
      return firebaseFirestore
          .collection('users')
          .doc(userId)
          .get()
          .then((value) {
        return UserModel.fromMap(value);
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Stream<List<ChatModel>> getAllChats() => chatCollection
      .where('users', arrayContains: authController.firebaseUser.value!.uid)
      .orderBy('timeSent', descending: true)
      .snapshots()
      .map((query) =>
          query.docs.map((item) => ChatModel.fromJson(item)).toList());

  Stream<List<UserModel>> getAllUsers() {
    return firebaseFirestore
        .collection('users')
        .where("uid", isNotEqualTo: authController.firebaseUser.value!.uid)
        .snapshots()
        .map((query) =>
            query.docs.map((item) => UserModel.fromMap(item)).toList());
  }

  Future<String?> findChatId(String chatUsers) async {
    List<ChatModel> chat = await chatCollection
        .where('users', arrayContains: chatUsers)
        .get()
        .then((value) => value.docs.map((e) => ChatModel.fromJson(e)).toList());

    for (int index = 0; index < chat.length; index++) {
      if (chat[index].users!.contains(authController.currentUser.value.uid)) {
        return chat[index].chatId;
      }
    }

    return null;
  }

  void sendText({
    required MessageModel message,
    required String chatId,
  }) {
    try {
      chatCollection
          .doc(chatId)
          .collection('messages')
          .doc(message.messageId)
          .set(message.toJson());
      updateLastText(
        docId: chatId,
        msg: message,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> uploadChatMedia(File file) async {
    var newPath = p.join((await getTemporaryDirectory()).path,
        "${DateTime.now()}.${p.extension(file.path)}");

    File? result = file;
    if (p.extension(file.path) == "jpeg" || p.extension(file.path) == "jpg") {
      result = await FlutterImageCompress.compressAndGetFile(file.path, newPath,
          quality: 80);
    }

    final imgRef =
        postImageRef.child("${DateTime.now().toIso8601String()}.jpg");

    final res = await imgRef.putFile(File(result!.path));
    final imgUrl = await res.ref.getDownloadURL();
    return imgUrl;
  }

  Stream<List<MessageModel>> getMessages(
      {required String id, required bool isGroup}) {
    try {
      return chatCollection
          .doc(id)
          .collection("messages")
          .orderBy('timeSent', descending: false)
          .snapshots()
          .map((query) =>
              query.docs.map((item) => MessageModel.fromJson(item)).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  addSeen({required String docId, required String uid, bool isGroup = false}) {
    try {
      chatCollection.doc(docId).update({
        'seen': FieldValue.arrayUnion([uid]),
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void startConversation(
      {required String userId, required MessageModel firstMessage}) {
    try {
      chatCollection
          .add(ChatModel(
                  seen: [],
                  timeSent: DateTime.now(),
                  users: [userId, currentUser.value.uid!],
                  lastMessage: "",
                  messageCount: 0,
                  chatId: "")
              .toJson())
          .then((value) {
        chatCollection.doc(value.id).update({"chatId": value.id});

        chatCollection
            .doc(value.id)
            .collection('messages')
            .doc(firstMessage.messageId)
            .set(firstMessage.toJson());
        updateLastText(docId: value.id, msg: firstMessage);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  updateLastText({
    required String docId,
    required MessageModel msg,
  }) {
    try {
      String text = msg.text!;
      if (msg.type == MessageType.image) {
        text = "Image 📷";
      }
      if (msg.type == MessageType.date) {
        text = "Booking Date changed";
      }
      if (msg.type == MessageType.profile || msg.type == MessageType.place) {
        text = "👤 profile";
      }

      chatCollection.doc(docId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
        'seen': [msg.senderId],
        'messageCount': FieldValue.increment(1)
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<UserModel> getCurrentUser() {
    return firebaseFirestore
        .collection('users')
        .doc(authController.firebaseUser.value!.uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event));
  }
}
