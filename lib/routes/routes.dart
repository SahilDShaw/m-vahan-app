import 'package:flutter/material.dart';

import '../screens/sign_in.screen.dart';
import '../screens/download_pdf.screen.dart';
import '../screens/qr_scanner.screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  // sign in screen
  SignInScreen.routeName: (BuildContext ctx) => const SignInScreen(),
  // qr scanner screen
  QRScannerScreen.routeName: (BuildContext ctx) => const QRScannerScreen(),
  // upload pdf screen
  DownloadPdfScreen.routeName: (BuildContext ctx) => const DownloadPdfScreen(),
};
