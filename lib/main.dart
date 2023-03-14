import 'package:crypto_wallet/Screens/Auth/LoginScreen.dart';
import 'package:crypto_wallet/Screens/Auth/OTP_screen.dart';
import 'package:crypto_wallet/Screens/Auth/PhoneVerification.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/Screens/MainScreen/Main_screen.dart';
import 'package:crypto_wallet/controllers/AuthController.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLogin = false;

  checkLogin() async {
    firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      } else {
        setState(() {
          isLogin = false;
        });
      }
    });
  }

  @override
  void initState() {
    checkLogin();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet',
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primarySwatch: Colors.blue,
        fontFamily: 'Saira',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: kWhite,
              displayColor: kWhite,
            ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: isLogin ? const MainScreen() : const SignInScreen(),
    );
  }
}
