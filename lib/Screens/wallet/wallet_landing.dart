import 'package:crypto_wallet/Models/wallet/transactionModel.dart';
import 'package:crypto_wallet/Models/wallet/walletModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/transaction/recievedPayment.dart';
import 'package:crypto_wallet/Screens/transaction/send.dart';
import 'package:crypto_wallet/Screens/wallet/ScanQRCodeScreen.dart';
import 'package:crypto_wallet/Screens/wallet/createWalletScreen.dart';
import 'package:crypto_wallet/Screens/wallet/qrCodeScreen.dart';
import 'package:crypto_wallet/Screens/wallet/scan_qr.dart';
import 'package:crypto_wallet/Screens/widgets/buttons.dart';
import 'package:crypto_wallet/controllers/SocialController.dart';
import 'package:crypto_wallet/controllers/walletController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:ternav_icons/ternav_icons.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Constants/generate.dart';

class WalletLanding extends StatefulWidget {
  const WalletLanding({super.key});

  @override
  State<WalletLanding> createState() => _WalletLandingState();
}

class _WalletLandingState extends State<WalletLanding> {
  WalletController controller = Get.find();
  SocialController socialController = Get.find();
  bool scan = true;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKeys[3],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return Scaffold(
              backgroundColor: kDarkBlack,
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(() {
                      return Column(
                        children: [
                          controller.wallet.value.docId == null
                              ? createWallet()
                              : InkWell(
                                  onTap: () {
                                    Nav().goTo(CreateWalletScreen(), context);
                                  },
                                  child: walletInfo()),
                          transactions(),
                          assets(),
                        ],
                      );
                    }),
                  ],
                ),
              )),
            );
          },
        );
      },
    );
  }

  createWallet() {
    return Column(
      children: [
        LottieBuilder.network(
          'https://assets1.lottiefiles.com/packages/lf20_zooicwxj.json',
          width: Config().deviceWidth(context),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ThemeButton(
              onTap: () {
                controller.walletCollection
                    .doc(controller.controller.currentUser.value.uid)
                    .set(WalletModel(
                      token: 1000,
                      total: 1000,
                      publicKey: generateKey(length: 16),
                      privateKey: generateKey(length: 24),
                    ).toJson());
              },
              text: "Create Wallet"),
        )
      ],
    );
  }

  walletInfo() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  TernavIcons.lightOutline.scan,
                  color: kGreen,
                ),
                const Text(
                  "Wallet",
                  style: TextStyle(
                      color: kWhite, fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const Icon(
                  Icons.more_vert,
                  color: kWhite,
                )
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
                    width: 50,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "${controller.wallet.value.token}",
                    style: const TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 40),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: ThemeButton(
                  text: "Send",
                  onTap: () {
                    Nav().goTo(SendScreen(), context);
                  },
                  height: 46,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.send,
                        size: 16,
                        color: kDarkBlack,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Send",
                        style: TextStyle(color: kDarkBlack, fontSize: 16),
                      )
                    ],
                  ),
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ThemeButton(
                  text: "Send",
                  height: 46,
                  onTap: () {
                    Nav().goTo(const QrCodeScanScreen(), context);
                  },
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
                        "Recieve",
                        style: TextStyle(color: kDarkBlack, fontSize: 16),
                      )
                    ],
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  assets() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Assets",
                  style: TextStyle(
                      color: kWhite, fontWeight: FontWeight.w600, fontSize: 22),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Image.asset("assets/images/assets.png")
          ],
        ),
      ),
    );
  }

  transactions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              SizedBox(
                width: 12,
              ),
              Text(
                "Transcations",
                style: TextStyle(
                    color: kWhite, fontWeight: FontWeight.w600, fontSize: 22),
              ),
            ],
          ),
          controller.transactions.isEmpty
              ? Column(
                  children: [
                    const Text("No Transactions"),
                    LottieBuilder.network(
                        'https://assets7.lottiefiles.com/packages/lf20_x6xd8xxi.json'),
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    return transcationTile(controller.transactions[index]);
                  },
                ),
        ],
      ),
    );
  }

  transcationTile(TransactionModel trsc) {
    bool issender =
        controller.controller.firebaseUser.value!.uid == trsc.sender;
    return ListTile(
      onTap: () async {
        var user = await socialController.getUserReturn(
            userId: trsc.members!.firstWhere((element) =>
                controller.controller.firebaseUser.value!.uid != element));

        await showDialog(
          barrierDismissible: false,
          builder: (context) {
            return RecievedScreen(
                user: user,
                value: "${issender ? "-" : "+"}" + trsc.value.toString());
          },
          context: context,
        );
      },
      title: Text("${issender ? "-" : "+"}" + trsc.value.toString() + " BNB"),
      subtitle: Text(issender ? "Sent" : "Recieved"),
      leading: Image.asset(
        "assets/images/bnb-logo.png",
        width: 50,
      ),
      trailing: Container(
        width: Config().deviceWidth(context) * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              trsc.reciever.toString(),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              " - ${timeago.format(trsc.dateTime!, locale: 'en_short')}",
            )
          ],
        ),
      ),
    );
  }
}
