// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/Constants/localNotification.dart';
import 'package:crypto_wallet/Screens/HomeScreen/home_page.dart';
import 'package:crypto_wallet/Screens/HomeScreen/chart.dart';
import 'package:crypto_wallet/Screens/news/news_main.dart';
import 'package:crypto_wallet/Screens/profile/CreateProfileScree.dart';
import 'package:crypto_wallet/Screens/social/social_landing.dart';
import 'package:crypto_wallet/Screens/transaction/recievedPayment.dart';
import 'package:crypto_wallet/Screens/transaction/send.dart';
import 'package:crypto_wallet/Screens/wallet/wallet_landing.dart';
import 'package:crypto_wallet/controllers/AuthController.dart';
import 'package:crypto_wallet/controllers/CoinController.dart';
import 'package:crypto_wallet/controllers/SocialController.dart';
import 'package:crypto_wallet/controllers/walletController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  CoinController coinController = Get.put(CoinController());

  SocialController socialController = Get.put(SocialController());
  WalletController walletController = Get.put(WalletController());
  AuthController authController = Get.find();
  int _currentIndex = 0;
  final screens = const [
    HomePage(),
    NewsScreen(),
    SocialLanding(),
    WalletLanding(),
  ];

  @override
  void initState() {
    super.initState();
    notificationReceiver();
  }

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
                    onTap: () {
                      Nav().goTo(const EditProfile(), context);
                    },
                    child: Obx(() => Container(
                          clipBehavior: Clip.hardEdge,
                          margin: const EdgeInsets.all(0.0),
                          height: 42,
                          width: 42,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: Image.network(
                            authController.currentUser.value.profileUrl ??
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
                  log(authController.currentUser.value.toJson().toString());
                },
                icon: Image.asset("assets/images/icons/search.png"),
              ),
              IconButton(
                onPressed: () {
                  Nav().goTo(SendScreen(), context);
                },
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

  void notificationReceiver() async {
    try {
      // when app is terminated
      FirebaseMessaging.instance.getInitialMessage().then((message) async {
        if (message != null) {
          log('Notification received: ${message.data['uid']}');
          if (message.data['type'] == 'transaction') {
            var strs = message.data['id'].toString().split(',');
            var user = await socialController.getUserReturn(userId: strs[1]);
            showDialog(
              barrierDismissible: false,
              builder: (context) {
                return RecievedScreen(
                  user: user,
                  value: strs[0],
                );
              },
              context: context,
            );
          }
        }
      });

      //in App
      FirebaseMessaging.onMessage.listen((message) async {
        if (message.notification != null) {
          log(message.notification!.title!);
          log(message.notification!.body!);
          if (message.data['type'] == 'transaction') {
            var strs = message.data['id'].toString().split(',');
            var user = await socialController.getUserReturn(userId: strs[1]);
            showDialog(
              barrierDismissible: false,
              builder: (context) {
                return RecievedScreen(
                  user: user,
                  value: strs[0],
                );
              },
              context: context,
            );
          } else {
            LocalNotificationService.display(message);
          }
        }
      });

      //when app running in Background
      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        if (message.data['type'] == 'transaction') {
          var strs = message.data['id'].toString().split(',');
          var user = await socialController.getUserReturn(userId: strs[1]);
          showDialog(
            barrierDismissible: false,
            builder: (context) {
              return RecievedScreen(
                user: user,
                value: strs[0],
              );
            },
            context: context,
          );
        }
      });
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
