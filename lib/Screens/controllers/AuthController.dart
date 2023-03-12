import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/Models/User_model.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var showPrefix = false.obs;
  var isLogin = true;
  var phoneNo = "".obs;
  var otp = "".obs;
  var isLoading = false.obs;
  var isInvalid = false.obs;
  var isOtpSent = false.obs;
  var resendAfter = 30.obs;
  var resendOTP = false.obs;
  var firebaseVerificationId = "";

  var isLogged = false.obs;
  var uid = "".obs;

  final email = TextEditingController(text: "").obs;
  final password = TextEditingController(text: "").obs;

  var timer;

  final FirebaseAuth auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser;
  late CollectionReference _userCollection;

  Rx<UserModel> currentUser = Rx<UserModel>(UserModel());
  String? token;

  @override
  onInit() async {
    super.onInit();
  }

  void login(String email, String password) async {
    try {
      isLoading.value = true;
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      log("LOGGED IN");
      isLoading.value = false;
      // storeToken();

      Get.snackbar("Login Successful", "Welcome back", backgroundColor: kGreen);
    } catch (firebaseAuthException) {
      isLoading.value = false;
      log(firebaseAuthException.toString());
      Get.snackbar(
          "error",
          firebaseAuthException
              .toString()
              .substring(firebaseAuthException.toString().indexOf(']') + 2),
          backgroundColor: Colors.grey);
    }
  }

  void register(String email, password) async {
    isLoading.value = true;
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      isLoading.value = false;
      firebaseUser = Rx<User?>(firebaseAuth.currentUser);
      firebaseUser.bindStream(firebaseAuth.userChanges());
      token = await firebaseMessaging.getToken();
    } catch (firebaseAuthException) {
      isLoading.value = false;
      log(firebaseAuthException.toString());
      Get.snackbar(
          "error",
          firebaseAuthException
              .toString()
              .substring(firebaseAuthException.toString().indexOf(']') + 2),
          backgroundColor: kBlack);
    }
  }

  void googleLogin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    isLoading = true.obs;
    update();
    try {
      googleSignIn.disconnect();
    } catch (e) {
      log(e.toString());
    }
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;
        final crendentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(crendentials).then((value) async {
          log("Successfully logged in as ");
          var user = auth.currentUser;
          final CollectionReference userCollection =
              FirebaseFirestore.instance.collection('users');
          var doc = await userCollection.doc(user!.uid).get();
          token = await firebaseMessaging.getToken();
          if (doc.exists) {
            isLoading = false.obs;
            userCollection.doc(user.uid).update({
              "token": FieldValue.arrayUnion([token])
            });
          } else {
            isLoading = false.obs;
            if (user != null) {
              log("DATA ADDED");
              userCollection.doc(FirebaseAuth.instance.currentUser!.uid).set(
                  UserModel(
                          mail: user.email,
                          name: user.displayName,
                          phone: user.phoneNumber,
                          uid: user.uid,
                          profileUrl: user.photoURL,
                          token: [token!],
                          friends: [],
                          isOnline: true,
                          lastSeen: DateTime.now())
                      .toJson());
            }
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      log("Google Login Failed ${e.toString()}");
    } on PlatformException catch (e) {
      log("Google Login Failed ${e.toString()}");
    }
  }

  getOtp() async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${phoneNo.value}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        firebaseVerificationId = verificationId;
        isOtpSent.value = true;
        startResendOtpTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  resendOtp() async {
    resendOTP.value = false;
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${phoneNo.value}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        firebaseVerificationId = verificationId;
        isOtpSent.value = true;
        startResendOtpTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<bool> verifyOTP() async {
    isLoading.value = true;
    isInvalid.value = false;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: firebaseVerificationId, smsCode: otp.value);
      await auth.signInWithCredential(credential);
      isLoading.value = false;

      return true;
    } catch (e) {
      isLoading.value = false;
      log("LOGIN ERROR : $e");
      isInvalid.value = true;
      return false;
    }
  }

  startResendOtpTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendAfter.value != 0) {
        resendAfter.value--;
      } else {
        resendAfter.value = 30;
        resendOTP.value = true;
        timer.cancel();
      }
      update();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
