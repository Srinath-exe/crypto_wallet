import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/Models/wallet/transactionModel.dart';
import 'package:crypto_wallet/Screens/Constants/DropDown.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/Constants/dialog.dart';
import 'package:crypto_wallet/Screens/wallet/ScanQRCodeScreen.dart';
import 'package:crypto_wallet/Screens/wallet/qrCodeScreen.dart';
import 'package:crypto_wallet/Screens/widgets/buttons.dart';
import 'package:crypto_wallet/Screens/widgets/text_field.dart';
import 'package:crypto_wallet/controllers/walletController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  TextEditingController toAddress = TextEditingController();
  TextEditingController amt = TextEditingController();
  WalletController controller = Get.find();
  String errorText = '';
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
              child: Column(
                children: [
                  textField(controller: toAddress, hint: "To Address"),
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
                } else {
                  setState(() {
                    errorText = '';
                  });

                  firebaseFirestore
                      .collection('wallets')
                      .doc(controller.controller.firebaseUser.value!.uid)
                      .update({
                    'token': FieldValue.increment(-double.parse(amt.text))
                  });

                  firebaseFirestore
                      .collection('wallets')
                      .doc(toAddress.text)
                      .update({
                    'token': FieldValue.increment(double.parse(amt.text))
                  });
                  controller.transcationCollection.add(TransactionModel(
                          dateTime: DateTime.now(),
                          sender: controller.controller.firebaseUser.value!.uid,
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
                      .toJson());
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
        width: Config().deviceWidth(context) * 0.8,
        height: 50,
        decoration: BoxDecoration(
            color: kLightGrey, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustDropDown(
            maxListHeight: 200,
            items: [
              CustDropdownMenuItem(
                value: 0,
                child: text(
                  "BNB",
                ),
              ),
              CustDropdownMenuItem(
                value: 1,
                child: text(
                  "Eth Classic",
                ),
              ),
            ],
            hintText: "Select Network",
            borderRadius: 5,
            onChanged: (val) {
              setState(() {
                // index = val;
              });
            },
          ),
        ));
  }
}
