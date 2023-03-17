import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/HomeScreen/coins_list.dart';
import 'package:crypto_wallet/Screens/HomeScreen/menu.dart';
import 'package:crypto_wallet/widgets/iconButton.dart';
import 'package:crypto_wallet/widgets/lightBox.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kDarkBlack,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              color: kBlack,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child:
                  LayoutBuilder(builder: (BuildContext context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        iconButtons(
                          image: "assets/images/icons/Deposit.png",
                          height: constraints.maxHeight * 0.4,
                          width: constraints.maxWidth / 5,
                          text: "Deposit",
                          onTap: () {},
                        ),
                        iconButtons(
                          image: "assets/images/icons/savings.png",
                          height: constraints.maxHeight * 0.4,
                          width: constraints.maxWidth / 5,
                          text: "Savings",
                          onTap: () {},
                        ),
                        iconButtons(
                          image: "assets/images/icons/swap.png",
                          height: constraints.maxHeight * 0.4,
                          width: constraints.maxWidth / 5,
                          text: "Liquid Swap",
                          onTap: () {},
                        ),
                        iconButtons(
                          image: "assets/images/icons/more.png",
                          height: constraints.maxHeight * 0.4,
                          width: constraints.maxWidth / 5,
                          text: "More",
                          onTap: () {
                            Nav().goTo(const MenuScreen(), context);
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    )
                  ],
                );
              }),
            ),
            const SizedBox(
              height: 12,
            ),

            const CoinsList(),
            // Container(
            //   color: kWhite,
            //   padding: const EdgeInsets.all(16),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       lighBox(
            //         height: height / 12,
            //         width: width,
            //         backgroundImage: "assets/images/icons/box.png",
            //         image: "assets/images/icons/rocket.png",
            //         heading: "P2P Trading",
            //         subHeading: "Bank Transfer, Paypal",
            //         onTap: () {},
            //       ),
            //       const SizedBox(
            //         height: 15,
            //       ),
            //       lighBox(
            //         height: height / 12,
            //         width: width,
            //         backgroundImage: "assets/images/icons/box.png",
            //         image: "assets/images/icons/credit.png",
            //         heading: "Credit/Debit card",
            //         subHeading: "Visa, Mastercard",
            //         onTap: () {},
            //       ),
            //     ],
            //   ),
            // ),

            // Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Image.asset('assets/images/Content.png')),
            // ElevatedButton(
            //     onPressed: () {
            //       // context.read<FirebaseAuthMethods>().signOut(context);
            //       // Navigator.pushNamedAndRemoveUntil(
            //       //     context, AppRoutes.signInScreenRoute, (route) => false);
            //     },
            //     child: const Text("Sign out")),
            const SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }

  topMenu() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          chip("Watchlist", 0),
          chip("Assets", 1),
          chip("Top Gainers", 2),
          chip("Top Losers", 3)
        ]),
      ),
    );
  }

  Widget chip(String catergory, int id) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: ZoomTapAnimation(
        onTap: () {
          setState(() {
            selected = id;
          });
        },
        child: Chip(
          side: BorderSide.none,
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0),
            child: Text(
              catergory,
              style: TextStyle(
                color: id == selected ? kBlack : kGreen,
              ),
            ),
          ),
          backgroundColor: id == selected ? kGreen : kBlack,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          // :
        ),
      ),
    );
  }
}
