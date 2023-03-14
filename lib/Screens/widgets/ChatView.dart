import 'dart:developer';

import 'package:crypto_wallet/Models/MessageModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/widgets/MessageBubble.dart';
import 'package:crypto_wallet/controllers/SocialController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  String? chatId;

  ChatView({super.key, this.chatId});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  SocialController controller = Get.find();
  late Stream<List<MessageModel>> stream;
  final ScrollController messageController = ScrollController();
  final now = DateTime.now();
  late DateTime today, yesterday;
  @override
  void initState() {
    stream = controller.getMessages(id: widget.chatId!, isGroup: false);

    today = DateTime(now.year, now.month, now.day);
    yesterday = DateTime(now.year, now.month, now.day - 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, message) {
        if (message.connectionState == ConnectionState.waiting) {
          return SizedBox(width: 100, child: showLoading());
        }
        if (!message.hasData) {
          return SizedBox(width: 100, child: showLoading());
        }
        return GroupedListView(
          reverse: true,
          floatingHeader: true,
          order: GroupedListOrder.DESC,
          elements: message.data!,
          groupBy: (element) => DateTime(element.timeSent!.year,
              element.timeSent!.month, element.timeSent!.day),
          groupHeaderBuilder: (element) {
            var date = DateTime(element.timeSent!.year, element.timeSent!.month,
                element.timeSent!.day);
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    today == date
                        ? "Today"
                        : yesterday == date
                            ? "Yesterday"
                            : DateFormat.yMMMMd('en_US')
                                .format(element.timeSent!),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
          itemBuilder: (context, element) {
            controller.addSeen(
                docId: controller.chatId.value,
                uid: controller.currentUser.value.uid!);

            return Row(
              mainAxisAlignment:
                  element.senderId == controller.currentUser.value.uid
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [
                MessageBubble(
                    message: element,
                    sender:
                        element.senderId == controller.currentUser.value.uid),
              ],
            );
          },
        );
      },
    );
  }
}
