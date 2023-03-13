import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/Models/User_model.dart';
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

List<UserModel> users = [
  UserModel(
    uid: "0",
    name: "Skylar Blankenship",
    mail: "Skylar_Blankenship@gmail.com",
    phone: "9037503232",
    profileUrl:
        "https://images.pexels.com/photos/1040879/pexels-photo-1040879.jpeg?auto=compress&cs=tinysrgb&w=300",
  ),
  UserModel(
      uid: "1",
      name: "Susan Navarro",
      mail: "Susan_Navarro@gmail.com",
      phone: "9037503232",
      profileUrl:
          "https://images.pexels.com/photos/12183266/pexels-photo-12183266.jpeg?auto=compress&cs=tinysrgb&w=300"),
  UserModel(
      uid: "2",
      name: "Litzy Cisneros",
      mail: "Litzy_Cisneros@gmail.com",
      phone: "9037503232",
      profileUrl:
          "https://images.pexels.com/photos/1040881/pexels-photo-1040881.jpeg?auto=compress&cs=tinysrgb&w=600"),
  UserModel(
      uid: "3",
      name: "Jayson Robertson",
      mail: "Jayson_Robertson@gmail.com",
      phone: "9037503232",
      profileUrl:
          "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&w=600"),
  UserModel(
      uid: "4",
      name: "Alec Marquez",
      mail: "Alec_Marquez@gmail.com",
      phone: "9037503232",
      profileUrl:
          "https://images.pexels.com/photos/2726111/pexels-photo-2726111.jpeg?auto=compress&cs=tinysrgb&w=600"),
  UserModel(
      uid: "5",
      name: "Aarav Suarez",
      mail: "Aarav_Suarez@gmail.com",
      phone: "9037503232",
      profileUrl:
          "https://images.pexels.com/photos/947639/pexels-photo-947639.jpeg?auto=compress&cs=tinysrgb&w=300"),
  UserModel(
      uid: "6",
      name: "Marquise Wright",
      mail: "Marquise_Wright@gmail.com",
      phone: "9037503232",
      profileUrl:
          "https://images.pexels.com/photos/2080383/pexels-photo-2080383.jpeg?auto=compress&cs=tinysrgb&w=300"),
  UserModel(
      uid: "7",
      name: "Natalia Anthony",
      mail: "Natalia_Anthony@gmail.com",
      phone: "9037503232",
      profileUrl:
          "https://images.pexels.com/photos/3785077/pexels-photo-3785077.jpeg?auto=compress&cs=tinysrgb&w=300"),
];

Map<int, GlobalKey> navigatorKeys = {
  0: GlobalKey(),
  1: GlobalKey(),
  2: GlobalKey(),
  3: GlobalKey(),
};
