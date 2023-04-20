import 'package:crypto_wallet/Models/User_model.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/transaction/send.dart';
import 'package:crypto_wallet/Screens/wallet/qrCodeScreen.dart';
import 'package:crypto_wallet/Screens/wallet/scan_qr.dart';
import 'package:crypto_wallet/Screens/widgets/buttons.dart';
import 'package:crypto_wallet/controllers/walletController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ternav_icons/ternav_icons.dart';

class RecievedScreen extends StatefulWidget {
  UserModel user;
  String value;
  RecievedScreen({super.key, required this.user, required this.value});

  @override
  State<RecievedScreen> createState() => _RecievedScreenState();
}

class _RecievedScreenState extends State<RecievedScreen> {
  WalletController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlack,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LottieBuilder.asset(
                'assets/lottie/celebration.json',
                width: Config().deviceWidth(context),
                height: Config().deviceHeight(context) * 0.8,
                onLoaded: (comp) {},
                addRepaintBoundary: true,
                repeat: false,
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              userprofile(),
              const SizedBox(
                height: 60,
              ),
              Row()
            ],
          ),
          Obx(() => Positioned(
              top: 20,
              child: walletInfo().animate().shimmer(
                    delay: const Duration(seconds: 2),
                  ))),
        ],
      )),
    );
  }

  Widget amount() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/bnb-logo.png",
                width: 50,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                widget.value,
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    color: Colors.amber),
              )
            ],
          ),
          //   Text(
          //   widget.value,
          //   style: const TextStyle(
          //       fontSize: 32,
          //       fontWeight: FontWeight.w600,
          //       letterSpacing: 0.8,
          //       color: Colors.amber),
          // )
        ],
      ),
    );
  }

  userprofile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Transaction with :",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: kLightGrey),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            profilePic(url: widget.user.profileUrl),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(widget.user.mail!,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400))
              ],
            )
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        copyAddress(context, widget.user.uid!)
      ],
    );
  }

  Widget walletInfo() {
    return Container(
      width: Config().deviceWidth(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: kWhite,
                    )),
                const Text(
                  "Wallet",
                  style: TextStyle(
                      color: kWhite, fontWeight: FontWeight.w600, fontSize: 16),
                ),
                IconButton(
                  onPressed: () {
                    Nav().goTo(SendScreen(), context);
                  },
                  icon: Icon(
                    TernavIcons.lightOutline.scan,
                    color: kGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "Total balance",
              style: TextStyle(color: kWhite.withOpacity(0.5), fontSize: 12),
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
                    width: 30,
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
                          style: const TextStyle(color: kGrey, fontSize: 10),
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
            const SizedBox(
              height: 80,
            ),
            amount()
                .animate()
                .scale(
                    delay: const Duration(seconds: 1),
                    begin: const Offset(1.5, 1.5),
                    end: const Offset(1, 1))
                .shimmer(
                  color: kDarkBlack,
                  delay: const Duration(seconds: 2),
                ),
            const SizedBox(
              height: 60,
            ),
            LottieBuilder.asset(
              'assets/lottie/a1.json',
              width: Config().deviceWidth(context) * 0.6,
            ),
          ],
        ),
      ),
    );
  }
}
