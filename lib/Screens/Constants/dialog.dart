import 'package:crypto_wallet/Screens/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

successGif(
  BuildContext context,
) {
  return Lottie.asset("assets/lottie/success.json",
      width: Config().deviceWidth(context) * 0.8, repeat: true);
}

Dialog successDialog(BuildContext context, String title) {
  return Dialog(
    backgroundColor: Colors.black.withOpacity(0.8),
    insetPadding: const EdgeInsets.all(30),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: kDarkBlack),
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
                  width: Config().deviceWidth(context) * 0.8,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Text(
                        "Transaction completed Successfully",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: kWhite),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        "$title",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: kWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
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
          Positioned(top: -120, child: successGif(context)),
          Positioned(
              top: 30,
              right: 20,
              child:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.share))),
        ],
      ),
    ),
  );
}
