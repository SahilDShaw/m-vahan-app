import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  static const String routeName = '/qr-scanner-screen';

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  void _onQrViewCreated(QRViewController qrController) {
    controller = qrController;
    qrController.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  // in order to get hot reload to work we need to pause the camera
  // if the platform is android, or resume the camera if the platform is iOS
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQrViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
                child: (result != null)
                    ? Text('Barcode Type: ${describeIdentity(result!.format)} \n Data: ${result!.code}')
                    : const Text('Scan a Code')),
          ),
        ],
      ),
    );
  }
}
