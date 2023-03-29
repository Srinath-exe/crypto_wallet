import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_wallet/Models/wallet/transactionModel.dart';
import 'package:crypto_wallet/Models/wallet/walletModel.dart';
import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:crypto_wallet/controllers/AuthController.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  AuthController controller = Get.find();
  late CollectionReference walletCollection;
  late CollectionReference transcationCollection;
  Rx<WalletModel> wallet = Rx<WalletModel>(WalletModel());
  RxList<TransactionModel> transactions = RxList<TransactionModel>([]);

  @override
  void onInit() {
    walletCollection = firebaseFirestore.collection('wallets');
    transcationCollection = firebaseFirestore.collection('transactions');
    wallet.bindStream(getWallet());
    transactions.bindStream(getAllTransactions());
    super.onInit();
  }

  Stream<WalletModel> getWallet() {
    try {
      return walletCollection
          .doc(controller.firebaseUser.value!.uid)
          .snapshots()
          .map((event) => WalletModel.fromJson(event));
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<TransactionModel>> getAllTransactions() {
    try {
      return transcationCollection
          .where('members', arrayContains: controller.firebaseUser.value!.uid)
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => TransactionModel.fromJson(e)).toList());
    } catch (e) {
      rethrow;
    }
  }
}
