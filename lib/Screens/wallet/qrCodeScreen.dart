import 'package:crypto_wallet/Screens/wallet/GenerateQrCode.dart';
import 'package:crypto_wallet/Screens/widgets/buttons.dart';
import 'package:crypto_wallet/controllers/walletController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ternav_icons/ternav_icons.dart';

import '../Constants/constants.dart';

class QrCodeScanScreen extends StatefulWidget {
  const QrCodeScanScreen({super.key});

  @override
  State<QrCodeScanScreen> createState() => _QrCodeScanScreenState();
}

class _QrCodeScanScreenState extends State<QrCodeScanScreen> {
  WalletController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: kBlack,
        foregroundColor: kWhite,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            "My QR code",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 40,
          ),
          GenerateQrCode(data: controller.controller.firebaseUser.value!.uid),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "ADDRESS",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: kLightGrey),
          ),
          copyAddress(),
          const SizedBox(
            height: 40,
          ),
          ThemeButton(
            outlineButton: true,
            text: "text",
            onTap: () {
              setState(() {
                // scan = !scan;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  TernavIcons.lightOutline.camera,
                  color: kGreen,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  "Scan QR code",
                  style: TextStyle(color: kGreen),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  copyAddress() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: kDarkBlack),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(controller.controller.firebaseUser.value!.uid),
            ),
            Container(
              color: kWhite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(TernavIcons.lightOutline.copy),
              ),
            )
          ],
        ),
      ),
    );
  }
}
