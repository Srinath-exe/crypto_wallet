import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/HomeScreen/menu.dart';
import 'package:crypto_wallet/widgets/iconButton.dart';
import 'package:crypto_wallet/widgets/lightBox.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: height / 4,
            color: kBlack,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: LayoutBuilder(builder: (BuildContext context, constraints) {
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
                        image: "assets/images/icons/referal.png",
                        height: constraints.maxHeight * 0.4,
                        width: constraints.maxWidth / 5,
                        text: "Referal",
                        onTap: () {},
                      ),
                      iconButtons(
                        image: "assets/images/icons/Grid.png",
                        height: constraints.maxHeight * 0.4,
                        width: constraints.maxWidth / 5,
                        text: "Grid Trading",
                        onTap: () {},
                      ),
                      iconButtons(
                        image: "assets/images/icons/margin.png",
                        height: constraints.maxHeight * 0.4,
                        width: constraints.maxWidth / 5,
                        text: "Margin",
                        onTap: () {},
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      iconButtons(
                        image: "assets/images/icons/launchpad.png",
                        height: constraints.maxHeight * 0.4,
                        width: constraints.maxWidth / 5,
                        text: "Launchpad",
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
                          Nav().goTo(MenuScreen(), context);
                          // Navigator.pushNamed(
                          //     context, AppRoutes.menuScreenRoute);
                        },
                      )
                    ],
                  )
                ],
              );
            }),
          ),
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

          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('assets/images/Content.png')),
          ElevatedButton(
              onPressed: () {
                // context.read<FirebaseAuthMethods>().signOut(context);
                // Navigator.pushNamedAndRemoveUntil(
                //     context, AppRoutes.signInScreenRoute, (route) => false);
              },
              child: const Text("Sign out")),
          SizedBox(
            height: 200,
          )
        ],
      ),
    );
  }
}
