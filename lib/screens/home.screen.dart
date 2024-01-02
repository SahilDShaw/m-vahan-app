import 'package:flutter/material.dart';

import 'download_pdf.screen.dart';
import 'qr_scanner.screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // scan qr button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(QRScannerScreen.routeName);
              },
              child: const Text('Scan QR'),
            ),
            // download pdf button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(DownloadPdfScreen.routeName);
              },
              child: const Text('Download PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
