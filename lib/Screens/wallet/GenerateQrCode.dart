import 'package:crypto_wallet/Screens/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class GenerateQrCode extends StatefulWidget {
  String data;
  GenerateQrCode({super.key, required this.data});

  @override
  State<GenerateQrCode> createState() => _GenerateQrCodeState();
}

class _GenerateQrCodeState extends State<GenerateQrCode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: PrettyQr(
          image: AssetImage('assets/images/app_icon.png'),
          typeNumber: 3,
          size: Config().deviceWidth(context) * 0.7,
          data: widget.data,
          errorCorrectLevel: QrErrorCorrectLevel.M,
          roundEdges: true,
        ),
      ),
    );
  }
}
