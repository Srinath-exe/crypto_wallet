import 'package:crypto_wallet/Models/wallet/walletModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/Constants/generate.dart';
import 'package:crypto_wallet/Screens/widgets/buttons.dart';
import 'package:crypto_wallet/controllers/walletController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CreateWalletScreen extends StatefulWidget {
  const CreateWalletScreen({super.key});

  @override
  State<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  WalletController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: kBlack,
        foregroundColor: kWhite,
        title: const Text("My Wallet"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            LottieBuilder.network(
                'https://assets1.lottiefiles.com/packages/lf20_O1b0iWuPju.json'),
            title("Wallet Id"),
            id(controller.wallet.value.docId!),
            title("Public Key"),
            id(controller.wallet.value.publicKey!),
            title("Private Key"),
            id(controller.wallet.value.privateKey!),
            SizedBox(
              height: 120,
            )
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ThemeButton(onTap: () {}, text: "Create Wallet"),
            // )
          ],
        ),
      )),
    );
  }

  title(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4, left: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: kLightGrey),
          )
        ],
      ),
    );
  }

  id(String id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: kDarkBlack, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            SizedBox(
              width: 12,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                id,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: kWhite),
              ),
            )),
            IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: id)).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Copied to your clipboard !')));
                  });
                },
                icon: Icon(Icons.copy_rounded))
          ],
        ),
      ),
    );
  }
}
