import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const kBlack = Color(0xff1B232A);
const kDarkBlack = Color(0xff161C22);
const kGreen = Color(0xff5ed5a8);
const kRed = Color(0xffDD4B4B);
const kGrey = Color(0xff777777);
const kLightGrey = Color(0xffA7AFB7);
const kWhite = Color(0xffffffff);

class Config {
  double deviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double deviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

// firebase consts

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

// navigators

class Nav {
  goTo(Widget child, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return child;
    }));
  }
}

// animations

Widget switcher({required Widget child}) {
  return AnimatedSwitcher(
      switchInCurve: Curves.bounceInOut,
      duration: const Duration(milliseconds: 200),
      child: child,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
            // alwaysIncludeSemantics: true,
            scale: animation,
            child: child);
      });
}

Widget showLoading() {
  return Lottie.network("assets/lottie/loading.json");
}
