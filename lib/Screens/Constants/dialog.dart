import 'package:crypto_wallet/Screens/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

successGif(
  BuildContext context,
) {
  return Lottie.asset("assets/lottie/success.json",
      width: Config().deviceWidth(context) * 0.8, repeat: false);
}

Dialog successDialog(BuildContext context, String title) {
  return Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.all(30),
    child: Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(40), color: kWhite),
      width: double.infinity,
      height: Config().deviceHeight(context) * 0.4,
      child: Stack(
        alignment: AlignmentDirectional.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 20,
            child: Column(
              children: [
                Container(
                  width: Config().deviceWidth(context) * 0.7,
                  alignment: Alignment.center,
                  child: Text(
                    "$title",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: kBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Transaction completed Successfully",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600, color: kBlack),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: kGreen,
                        foregroundColor: kBlack,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 36),
                      child: Text(
                        "Okay",
                        style: TextStyle(fontSize: 18),
                      ),
                    ))
              ],
            ),
          ),
          Positioned(top: -160, child: successGif(context)),
          Positioned(
              top: 20,
              right: 20,
              child:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.share))),
        ],
      ),
    ),
  );
}
