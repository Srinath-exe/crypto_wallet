import 'dart:io';

import 'package:crypto_wallet/Screens/Constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrCodeScreen extends StatefulWidget {
  Function(String) onScanned;
  ScanQrCodeScreen({super.key, required this.onScanned});

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Future<void> reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBlack,
        foregroundColor: kWhite,
      ),
      backgroundColor: kBlack,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: kGreen,
                  borderLength: 20,
                  borderRadius: 20,
                  borderWidth: 10,
                  cutOutSize: Config().deviceWidth(context) * 0.8),
            ),
          ),
          Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(barcode == null ? 'Scan a code' : "${barcode!.code}"),
                    SizedBox(
                      height: 12,
                    ),
                    barcode == null
                        ? const SizedBox()
                        : TextButton(
                            onPressed: () {
                              widget.onScanned(barcode!.code!);
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.done,
                                  color: kGreen,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                const Text(
                                  "Done",
                                  style: TextStyle(color: kWhite, fontSize: 16),
                                )
                              ],
                            ))
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void onQRViewCreated(QRViewController p1) {
    setState(() {
      controller = p1;
    });

    p1.scannedDataStream.listen((event) {
      setState(() {
        barcode = event;
      });
    });
  }
}
