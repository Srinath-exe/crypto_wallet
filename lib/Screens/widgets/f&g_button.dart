import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:flutter/material.dart';

InkWell FGButtom({
  required double height,
  required double width,
  required String text,
  required String image,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: width,
      height: height,
      decoration:
          BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10)),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          image,
          height: 26,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: const TextStyle(color: kBlack, fontSize: 16),
        )
      ]),
    ),
  );
}
