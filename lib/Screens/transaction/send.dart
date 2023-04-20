import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/Models/MessageModel.dart';
import 'package:crypto_wallet/Models/User_model.dart';
import 'package:crypto_wallet/Models/transactions/wallet_models.dart';
import 'package:crypto_wallet/Models/wallet/transactionModel.dart';
import 'package:crypto_wallet/Screens/Constants/DropDown.dart';
import 'package:crypto_wallet/Screens/Constants/Notification.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/Constants/dialog.dart';
import 'package:crypto_wallet/Screens/wallet/ScanQRCodeScreen.dart';
import 'package:crypto_wallet/Screens/wallet/qrCodeScreen.dart';
import 'package:crypto_wallet/Screens/widgets/buttons.dart';
import 'package:crypto_wallet/Screens/widgets/text_field.dart';
import 'package:crypto_wallet/controllers/SocialController.dart';
import 'package:crypto_wallet/controllers/walletController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SendScreen extends StatefulWidget {
  String? id;
  SendScreen({super.key, this.id});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  late TextEditingController toAddress;
  TextEditingController amt = TextEditingController();
  WalletController controller = Get.find();
  SocialController socialController = Get.find();
  String errorText = '';

  @override
  void initState() {
    super.initState();
    toAddress = TextEditingController(text: widget.id ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: kBlack,
        foregroundColor: kWhite,
        title: const Text("Send"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    textField(
                        controller: toAddress,
                        hint: "To Address",
                        onChanged: (s) {
                          setState(() {
                            toAddress.text = s;
                          });
                        }),
                    if (toAddress.text.isNotEmpty)
                      FutureBuilder(
                        future: socialController.getUserReturn(
                            userId: toAddress.text),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return userTile(snapshot.data!);
                          }
                          return SizedBox();
                        },
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("OR"),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ThemeButton(
                      text: "Send",
                      onTap: () {
                        Nav().goTo(ScanQrCodeScreen(
                          onScanned: (s) {
                            setState(() {
                              toAddress.text = s;
                            });
                            return true;
                          },
                        ), context);
                      },
                      height: 46,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.qr_code,
                            size: 16,
                            color: kDarkBlack,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Scan QR",
                            style: TextStyle(color: kDarkBlack, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    dropDown(),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Wallet",
                          style: TextStyle(
                              color: kWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Total balance",
                      style: TextStyle(
                          color: kWhite.withOpacity(0.5), fontSize: 12),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/bnb-logo.png",
                            width: 50,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Text(
                              "${controller.wallet.value.token}",
                              style: const TextStyle(
                                  color: kWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "My Wallet",
                              style: TextStyle(color: kLightGrey, fontSize: 12),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: kWhite),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Text(
                                  controller.wallet.value.docId!,
                                  style: const TextStyle(
                                      color: kGrey, fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Image.asset(
                          "assets/images/PNL.png",
                          height: 20,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    textField(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/bnb-logo.png",
                            width: 50,
                          ),
                        ),
                        controller: amt,
                        hint: "BNB Cryptocurrency",
                        keybordType: TextInputType.number),
                    const SizedBox(
                      height: 20,
                    ),
                    errorText == ''
                        ? SizedBox()
                        : Text(
                            errorText,
                            style: TextStyle(fontSize: 16, color: kRed),
                          )
                  ],
                ),
              ),
            ),
            ThemeButton(
              text: "Send",
              onTap: () async {
                if (toAddress.text.isEmpty) {
                  setState(() {
                    errorText = 'Enter reciever Address';
                  });
                } else if (amt.text.isEmpty) {
                  setState(() {
                    errorText = 'Enter number of BNB';
                  });
                } else if (controller.wallet.value.token! <=
                    double.parse(amt.text)) {
                  errorText = 'Insufficient Balance';
                } else {
                  setState(() {
                    errorText = '';
                  });

                  var user = await socialController.getUserReturn(
                      userId: toAddress.text);

                  firebaseFirestore
                      .collection('wallets')
                      .doc(controller.controller.firebaseUser.value!.uid)
                      .update({
                    'token': FieldValue.increment(-double.parse(amt.text))
                  });
                  var messageId = const Uuid().v1();

                  await socialController
                      .findChatId(toAddress.text)
                      .then((chatID) {
                    if (chatID != null) {
                      socialController.sendText(
                          message: MessageModel(
                              text: amt.text,
                              messageId: messageId,
                              repliedMessageType: MessageType.text,
                              type: MessageType.payment,
                              timeSent: DateTime.now(),
                              senderId:
                                  controller.controller.firebaseUser.value!.uid,
                              recieverid: toAddress.text,
                              data: PaymentType.paid.type),
                          chatId: chatID);
                    } else {
                      socialController.startConversation(
                        userId: toAddress.text,
                        firstMessage: MessageModel(
                            text: amt.text,
                            messageId: messageId,
                            repliedMessageType: MessageType.text,
                            type: MessageType.payment,
                            timeSent: DateTime.now(),
                            senderId:
                                controller.controller.firebaseUser.value!.uid,
                            recieverid: toAddress.text,
                            data: PaymentType.paid.type),
                      );
                    }
                  });

                  controller.transcationCollection
                      .add(TransactionModel(
                              dateTime: DateTime.now(),
                              sender:
                                  controller.controller.firebaseUser.value!.uid,
                              senderAddress:
                                  controller.controller.firebaseUser.value!.uid,
                              recieverAddress: toAddress.text,
                              reciever: toAddress.text,
                              members: [
                                controller.controller.firebaseUser.value!.uid,
                                toAddress.text
                              ],
                              value: double.tryParse(amt.text),
                              gasFees: double.tryParse(amt.text)! * 0.01,
                              status: "completed")
                          .toJson())
                      .then((value) {});

                  await sendNotification(
                      title: "${amt.text} BNB Recieved in Wallet",
                      body:
                          "${controller.controller.firebaseUser.value!.displayName} has sent you ${amt.text} BNB",
                      token: user.token!,
                      dataMap: {
                        'type': 'transaction',
                        'id':
                            "${amt.text},${controller.controller.firebaseUser.value!.uid}",
                      });

                  await firebaseFirestore
                      .collection('wallets')
                      .doc(toAddress.text)
                      .update({
                    'token': FieldValue.increment(double.parse(amt.text))
                  });
                  // ignore: use_build_context_synchronously
                  await showDialog<void>(
                      context: context,
                      barrierColor: kGrey.withOpacity(0.6),
                      builder: (BuildContext context) {
                        return successDialog(context,
                            "${amt.text} BNB was sent to ${toAddress.text}");
                      });
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              height: 60,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Send",
                    style: TextStyle(color: kDarkBlack, fontSize: 20),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.send,
                    size: 16,
                    color: kDarkBlack,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  text(String txt) {
    return Text(
      txt,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: kBlack),
    );
  }

  dropDown() {
    return Container(
        width: Config().deviceWidth(context) * 0.9,
        height: 50,
        decoration: BoxDecoration(
            color: kWhite, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustDropDown(
            maxListHeight: 200,
            items: [
              CustDropdownMenuItem(
                value: 0,
                child: text(
                  "BNB Network",
                ),
              ),
              // CustDropdownMenuItem(
              //   value: 1,
              //   child: text(
              //     "Eth Classic",
              //   ),
              // ),
            ],
            hintText: "Select Network",
            defaultSelectedIndex: 0,
            borderRadius: 5,
            onChanged: (val) {
              setState(() {
                // index = val;
              });
            },
          ),
        ));
  }

  Widget userTile(UserModel userModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: kDarkBlack, borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          profilePic(url: userModel.profileUrl, height: 60),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.name!,
                  style: const TextStyle(
                      letterSpacing: 0.6,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kWhite),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  userModel.uid!,
                  style: const TextStyle(
                      letterSpacing: 0.6,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: kWhite),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<void> addToChat() async {}
}
