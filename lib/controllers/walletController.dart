import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/Models/wallet/walletModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/controllers/AuthController.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  AuthController controller = Get.find();
  late CollectionReference walletCollection;

  Rx<WalletModel> wallet = Rx<WalletModel>(WalletModel());

  @override
  void onInit() {
    walletCollection = firebaseFirestore.collection('wallets');
    wallet.bindStream(getWallet());
    super.onInit();
  }

  Stream<WalletModel> getWallet() {
    try {
      return walletCollection
          .doc(controller.currentUser.value.uid)
          .snapshots()
          .map((event) => WalletModel.fromJson(event));
    } catch (e) {
      rethrow;
    }
  }
}
