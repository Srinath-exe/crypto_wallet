import 'package:crypto_wallet/Models/MessageModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/controllers/SocialController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatefulWidget {
  MessageModel message;
  bool sender;
  MessageBubble({super.key, required this.message, required this.sender});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  SocialController controller = Get.find();

  timeStamp() {
    return Text(
      DateFormat("KK : mm  a").format(widget.message.timeSent!),
      style: TextStyle(fontSize: 10, color: kLightGrey),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.sender
              ? const SizedBox()
              : profilePic(
                  url: controller
                      .messageUsers[widget.message.senderId]!.profileUrl!,
                  height: 30,
                  padding: const EdgeInsets.only(right: 8, top: 4)),
          Column(
            crossAxisAlignment: widget.sender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              ZoomTapAnimation(
                  onTap: () {
                    if (widget.message.type == MessageType.image) {
                      fullScreenImage();
                    }
                    if (widget.message.type == MessageType.profile) {}
                    if (widget.message.type == MessageType.place) {}
                  },
                  child: switcher(widget.message.type!)),
              timeStamp()
            ],
          ),
        ],
      ),
    );
  }

  switcher(MessageType type) {
    switch (type) {
      case MessageType.text:
        return text();
      case MessageType.image:
        return image();
        break;
      case MessageType.audio:
        // TODO: Handle this case.
        break;
      case MessageType.video:
        // TODO: Handle this case.
        break;
      case MessageType.gif:
        // TODO: Handle this case.
        break;
      case MessageType.plan:
        // TODO: Handle this case.
        break;
      case MessageType.date:
        // return showDate();
        break;
      case MessageType.post:
        // TODO: Handle this case.
        break;
      case MessageType.promotion:
        // TODO: Handle this case.
        break;
      case MessageType.place:
        // return placeCard();
        break;
      case MessageType.profile:
        // return profile();
        break;
      case MessageType.offers:
        // TODO: Handle this case.
        break;
    }
  }

  text() {
    return Container(
      constraints:
          BoxConstraints(maxWidth: Config().deviceWidth(context) * 0.8),
      decoration: BoxDecoration(
          color: widget.sender ? kBlack : kGreen,
          borderRadius: BorderRadius.only(
              topLeft: widget.sender
                  ? const Radius.circular(20)
                  : const Radius.circular(10),
              topRight: const Radius.circular(20),
              bottomLeft: const Radius.circular(20),
              bottomRight: widget.sender
                  ? const Radius.circular(10)
                  : const Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                constraints: BoxConstraints(
                    maxWidth: Config().deviceWidth(context) * 0.6),
                // alignment: Alignment.center,
                child: Text(
                  widget.message.text!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  image() {
    return Container(
      width: Config().deviceWidth(context) * 0.4,
      height: 200,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: kBlack),
      clipBehavior: Clip.hardEdge,
      child: Image.network(widget.message.text!, fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
      }),
    );
  }

  fullScreenImage() {
    return showDialog(
      context: context,
      barrierColor: kBlack.withOpacity(0.8),
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  int sensitivity = 10;
                  if (details.delta.dy > sensitivity ||
                      details.delta.dy < -sensitivity) {
                    Navigator.of(context).pop();
                  }
                },
                child: SizedBox(
                  width: Config().deviceWidth(context),
                  height: Config().deviceHeight(context) * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                        Image.network(widget.message.text!, fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }
                    }),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: kWhite,
                  )),
            ],
          ),
        );
      },
    );
  }
}
