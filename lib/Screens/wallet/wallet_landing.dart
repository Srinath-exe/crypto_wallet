import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/wallet/scan_qr.dart';
import 'package:crypto_wallet/Screens/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:ternav_icons/ternav_icons.dart';

class WalletLanding extends StatefulWidget {
  const WalletLanding({super.key});

  @override
  State<WalletLanding> createState() => _WalletLandingState();
}

class _WalletLandingState extends State<WalletLanding> {
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
                  child: Container(
                      width: Config().deviceWidth(context),
                      child: Column(
                        children: [
                          walletInfo(),
                          assets(),
                        ],
                      ))),
            );
          },
        );
      },
    );
  }
  // switcher(child: scan ? scanQR() : qrCode()

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
            const Text(
              "\$ 2,004.23",
              style: TextStyle(
                  color: kWhite, fontWeight: FontWeight.w600, fontSize: 40),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/walletadd.png",
                  height: 16,
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
                    Nav().goTo(
                        ScanQr(
                          scan: true,
                        ),
                        context);
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
                    Nav().goTo(ScanQr(), context);
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
}
