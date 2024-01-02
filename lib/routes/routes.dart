import 'package:flutter/material.dart';
import 'package:qr_app/screens/download_pdf.screen.dart';
import 'package:qr_app/screens/upload_pdf.screen.dart';

import '../screens/qr_scanner.screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  // qr scanner screen
  QRScannerScreen.routeName: (BuildContext ctx) => const QRScannerScreen(),
  // upload pdf screen
  UploadPdfScreen.routeName: (BuildContext ctx) => const UploadPdfScreen(),
  // upload pdf screen
  DownloadPdfScreen.routeName: (BuildContext ctx) => const DownloadPdfScreen(),
};
