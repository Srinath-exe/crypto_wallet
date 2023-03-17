import 'dart:developer';

import 'package:crypto_wallet/Models/MessageModel.dart';
import 'package:crypto_wallet/Models/User_model.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/widgets/ChatTextFeild.dart';
import 'package:crypto_wallet/Screens/widgets/ChatView.dart';
import 'package:crypto_wallet/controllers/SocialController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  UserModel user;
  String? chatId;
  ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SocialController controller = Get.find();
  late Stream<List<MessageModel>> stream;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlack,
      appBar: AppBar(
        foregroundColor: kWhite,
        backgroundColor: kDarkBlack,
        elevation: 0,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 20,
          ),
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: false,
        title: Container(
          width: Config().deviceWidth(context) * 0.6,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profilePic(
                  url: widget.user.profileUrl!,
                  padding: const EdgeInsets.all(0)),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  "${widget.user.name}",
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Container(
        child: Obx(() => Column(
              children: [
                Expanded(
                    child: isNewConverstation()
                        ? newConversation()
                        : ChatView(
                            chatId: controller.chatId.value,
                          )),
                ChatTextFeild(
                  id: controller.chatId.value,
                  onSend: (text) {
                    var messageId = const Uuid().v1();

                    if (isNewConverstation()) {
                      controller.startConversation(
                          userId: widget.user.uid!,
                          firstMessage: MessageModel(
                            messageId: messageId,
                            text: text,
                            type: MessageType.text,
                            timeSent: DateTime.now(),
                            senderId: controller.currentUser.value.uid,
                            recieverid: widget.user.uid,
                            repliedMessageType: MessageType.text,
                          ));
                    } else {
                      controller.sendText(
                          chatId: controller.chatId.value,
                          message: MessageModel(
                            messageId: messageId,
                            text: text,
                            repliedMessageType: MessageType.text,
                            type: MessageType.text,
                            timeSent: DateTime.now(),
                            senderId: controller.currentUser.value.uid,
                            recieverid: widget.user.uid,
                          ));
                    }
                  },
                )
              ],
            )),
      ),
    );
  }

  Widget newConversation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          elevation: 10,
          shape: const CircleBorder(),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: kGreen,
            child: SvgPicture.asset(
              "assets/images/chat_rounded.svg",
              color: kWhite,
              width: 60,
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Say Hi 👋",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          "Start a new Conversation",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: kGreen),
        ),
      ],
    );
  }

  bool isNewConverstation() {
    for (int index = 0; index < controller.chats.length; index++) {
      if (controller.chats[index].users!.contains(widget.user.uid)) {
        controller.chatId.value = controller.chats[index].chatId!;
        return false;
      }
    }
    return true;
  }
}
