import 'dart:developer';
import 'dart:io';

import 'package:crypto_wallet/Models/MessageModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/controllers/SocialController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ChatTextFeild extends StatefulWidget {
  Function(String) onSend;
  bool isGroup;
  String id;
  ChatTextFeild(
      {super.key,
      required this.onSend,
      this.isGroup = false,
      required this.id});

  @override
  State<ChatTextFeild> createState() => _ChatTextFeildState();
}

class _ChatTextFeildState extends State<ChatTextFeild> {
  final ImagePicker imagePicker = ImagePicker();
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();

  SocialController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _messageController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.send,
                  onFieldSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      widget.onSend(val);
                      _messageController.text = '';
                      isShowSendButton = false;
                    }
                  },
                  onChanged: (val) {
                    if (val.trim().isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
                  },
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  cursorRadius: const Radius.circular(20),
                  // cursorHeight: 24,
                  cursorColor: kGreen,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: kBlack,
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 6,
                        ),
                        profilePic(
                            height: 40,
                            url: controller.currentUser.value.profileUrl!),
                        const SizedBox(
                          width: 8,
                        )
                      ],
                    ),
                    suffixIcon: isShowSendButton
                        ? ZoomTapAnimation(
                            onTap: () {
                              widget.onSend(_messageController.text.trim());
                              setState(() {
                                _messageController.text = '';
                                isShowSendButton = false;
                              });
                            },
                            child: SizedBox(
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  "Send",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: kGreen),
                                )),
                              ),
                            ),
                          )
                        : IconButton(
                            onPressed: () async {
                              final XFile? selectedImage = await imagePicker
                                  .pickImage(source: ImageSource.gallery);
                              if (selectedImage != null) {
                                var link = await controller
                                    .uploadChatMedia(File(selectedImage.path));
                                var messageId = const Uuid().v1();
                                log(widget.isGroup.toString());
                                controller.sendText(
                                    message: MessageModel(
                                      text: link,
                                      messageId: messageId,
                                      repliedMessageType: MessageType.text,
                                      type: MessageType.image,
                                      timeSent: DateTime.now(),
                                      senderId:
                                          controller.currentUser.value.uid,
                                      recieverid: "",
                                    ),
                                    chatId: widget.id);
                              }
                            },
                            icon: const Icon(
                              Icons.image_outlined,
                              size: 24,
                              color: Colors.grey,
                            ),
                          ),
                    hintText: 'Type a message!',
                    hintStyle: TextStyle(color: kGrey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
