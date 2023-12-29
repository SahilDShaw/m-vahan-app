import 'package:flutter/material.dart';

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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(QRScannerScreen.routeName);
              },
              child: const Text('QR Scanner'),
            ),
          ],
        ),
      ),
    );
  }
}
