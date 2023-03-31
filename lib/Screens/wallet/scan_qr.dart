import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/widgets/buttons.dart';
import 'package:crypto_wallet/controllers/walletController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ternav_icons/ternav_icons.dart';

class ScanQr extends StatefulWidget {
  bool? scan;
  ScanQr({super.key, this.scan = false});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  WalletController controller = Get.find();
  @override
  late bool scan;
  @override
  void initState() {
    scan = widget.scan!;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlack,
      body: SafeArea(child: switcher(child: scan ? scanQR() : qrCode())),
    );
  }

  qrCode() {
    return Padding(
      key: const Key('1'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Text(
          //   "BTC 40,2398",
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          // ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "My QR code",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset("assets/images/qrcode.png"),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "ADDRESS",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: kLightGrey),
          ),
          copyAddress(context, controller.controller.currentUser.value.uid!),
          const SizedBox(
            height: 40,
          ),
          ThemeButton(
            outlineButton: true,
            text: "text",
            onTap: () {
              setState(() {
                scan = !scan;
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

  scanQR() {
    return Padding(
        key: const Key('0'),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  TernavIcons.lightOutline.scan,
                  color: kGreen,
                ),
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  "Scan QR code",
                  style: TextStyle(color: kWhite),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Scan the QR code and it automatically \nrecognize it.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: kLightGrey),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset("assets/images/scan.png"),
            const SizedBox(
              height: 20,
            ),
            ThemeButton(
              text: "",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    TernavIcons.lightOutline.scan,
                    color: kBlack,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    "Scan QR code",
                    style: TextStyle(color: kBlack),
                  )
                ],
              ),
            ),
            ThemeButton(
              text: "",
              bgColor: kGrey,
              child: const Text("Cancel"),
              onTap: () {
                setState(() {
                  scan = !scan;
                });
              },
            )
          ],
        ));
  }
}

copyAddress(BuildContext context, String id) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      clipBehavior: Clip.hardEdge,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: kBlack),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(id),
          ),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: id)).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Copied to your clipboard !')));
              });
            },
            child: Container(
              color: kWhite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(TernavIcons.lightOutline.copy),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
