import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'generate_pdf.screen.dart';
import '../api/secure_string.api.dart';
import '../models/qr_scan_result.model.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  static const String routeName = '/qr-scanner-screen';

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  late String _keyStr;

  @override
  void initState() {
    super.initState();

    // encryption key
    _keyStr = SecureStringApi.getFernetKey();
  }

  // scanning for QR and if found, decrypting the plain text
  // to see for any valid data
  void _onQrViewCreated(QRViewController qrController) {
    _controller = qrController;
    qrController.scannedDataStream.listen((scanData) async {
      try {
        // string from QR
        String qrPlainText = scanData.code.toString();

        // encrypter
        final keyFernet = encrypt.Key.fromUtf8(_keyStr);
        final fernet = encrypt.Fernet(keyFernet);
        final encrypterFernet = encrypt.Encrypter(fernet);

        // string decryption
        String decrypted = encrypterFernet.decrypt(
          encrypt.Encrypted.fromBase64(qrPlainText),
        );
        log('Decrypted String: $decrypted');

        // processing decrypted string
        QRScanResult qrResult = QRScanResult.fromJSON(
          json.decode(decrypted),
        );

        // navigate to pdf generator if the result is valid
        if (!mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GeneratePDFScreen(
              qrResult: qrResult,
            ),
          ),
        );
      } catch (e) {
        log('Error: $e');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  // in order to get hot reload to work we need to pause the camera
  // if the platform is android, or resume the camera if the platform is iOS
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: _qrKey,
              onQRViewCreated: _onQrViewCreated,
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a Valid Code'),
            ),
          ),
        ],
      ),
    );
  }
}
