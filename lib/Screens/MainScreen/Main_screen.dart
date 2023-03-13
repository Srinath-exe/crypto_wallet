import 'dart:developer';

import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/HomeScreen/home_page.dart';
import 'package:crypto_wallet/Screens/HomeScreen/home_screen.dart';
import 'package:crypto_wallet/Screens/news/news_main.dart';
import 'package:crypto_wallet/Screens/social/social_landing.dart';
import 'package:crypto_wallet/Screens/wallet/wallet_landing.dart';
import 'package:crypto_wallet/controllers/AuthController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ternav_icons/ternav_icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AuthController controller = Get.find();
  int _currentIndex = 0;
  final screens = const [
    HomePage(),
    NewsScreen(),
    SocialLanding(),
    WalletLanding(),
  ];
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (homeController.index.value != 0) {
        //   homeController.index.value -= 1;
        // }
        return !await Navigator.maybePop(
            navigatorKeys[_currentIndex]!.currentState!.context);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.01,
            backgroundColor: kDarkBlack,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: Material(
                  color: kWhite,
                  child: InkWell(
                    child: Obx(() => Container(
                          margin: const EdgeInsets.all(4.0),
                          height: 42,
                          width: 42,
                          child: Image.network(
                            controller.currentUser.value.profileUrl ??
                                "https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg",
                            height: 42,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  log(controller.currentUser.value.toJson().toString());
                },
                icon: Image.asset("assets/images/icons/search.png"),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset("assets/images/icons/scanner.png"),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset("assets/images/icons/notification.png"),
              )
            ],
          ),
          // bottomNavigationBar: _buildBottomBar(),
          body: Stack(alignment: Alignment.topCenter, children: [
            IndexedStack(
              alignment: Alignment.topCenter,
              index: _currentIndex,
              children: screens,
            ),
            Align(alignment: Alignment.bottomCenter, child: _buildBottomBar())
          ]),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 76,
      margin: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: 28,
          elevation: 5,
          enableFeedback: true,
          backgroundColor: kBlack,
          selectedItemColor: kGreen,
          selectedLabelStyle: const TextStyle(fontSize: 15),
          unselectedItemColor: kGrey,
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          items: [
            BottomNavigationBarItem(
              icon: Icon(TernavIcons.bold.home_2),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(TernavIcons.bold.copy),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(TernavIcons.bold.two_user),
              label: 'Socials',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                TernavIcons.bold.wallet,
              ),
              label: "Wallet",
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
