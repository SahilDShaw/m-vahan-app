import 'package:flutter/material.dart';

import '../screens/qr_scanner.screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  // qr scanner screen
  QRScannerScreen.routeName: (BuildContext ctx) => const QRScannerScreen(),
};
