import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../api/pdf.api.dart';
import '../enums/qr_type.enum.dart';
import '../models/driver_data.model.dart';
import '../models/vehicle_data.model.dart';
import '../models/pdf.model.dart';
import '../models/qr_scan_result.model.dart';
import '../services/firebase.service.dart';

class GeneratePDFScreen extends StatefulWidget {
  final QRScanResult qrResult;
  const GeneratePDFScreen({required this.qrResult, super.key});

  static const routeName = '/generated-pdf-screen';

  @override
  State<GeneratePDFScreen> createState() => _GeneratePDFScreenState();
}

class _GeneratePDFScreenState extends State<GeneratePDFScreen> {
  late Map<String, String> _displayData;

  PDF? _pdfFile;

  @override
  void initState() {
    super.initState();

    if (widget.qrResult.qrType == QRType.driver) {
      DriverData info = widget.qrResult.data;
      _displayData = {
        'DL No.': info.dlNo,
        'Name': info.name,
        'Address': info.address,
        'DOB': DateFormat('dd-MM-yyyy').format(info.dob),
      };
    } else if (widget.qrResult.qrType == QRType.vehicle) {
      VehicleData info = widget.qrResult.data;
      _displayData = {
        'Vehicle No.': info.vehicleNo,
        'Manufacturer': info.manufacturer,
        'Model': info.model,
        'Variant': info.variant,
        'Age': '${info.age.toString()} yrs',
        'Kms. Driven': '${info.kmsDriven.toString()} kms',
        'Registration City': info.registrationCity,
      };
    } else {
      _displayData = {
        'Error': widget.qrResult.data,
      };
    }
  }

  // details widget builder
  List<Widget> _detailsWidgetBuilder() {
    List<Widget> widgetList = [];
    _displayData.forEach((key, value) {
      widgetList.add(
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '$key:    ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    });
    return widgetList;
  }

  // generate and save pdf
  Future<PDF> _generatePDF() async {
    // generate pdf and save it locally
    File pdfFile = await PdfApi.generatePDF(
      qrType: widget.qrResult.qrType,
      displayData: _displayData,
    );

    // open the file just created
    PdfApi.openFile(pdfFile);

    // getting file size
    int bytes = pdfFile.lengthSync();
    String fileSize;
    if (bytes <= 0) {
      fileSize = "0 B";
    } else {
      const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
      var i = (log(bytes) / log(1024)).floor();
      fileSize = '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
    }

    return PDF(
      name: '${(widget.qrResult.qrType == QRType.driver) ? widget.qrResult.data.dlNo : widget.qrResult.data.vehicleNo}.pdf',
      base64String: base64Encode(pdfFile.readAsBytesSync()),
      size: fileSize,
    );
  }

  // uploading pdf to firebase
  Future<void> _uploadFile() async {
    final provider = Provider.of<FirebaseProvider>(context, listen: false);

    String? id = await provider.savePDF(_pdfFile!);

    String alertMessage;
    if (id == null) {
      alertMessage = 'Something Went Wrong!!';
    } else {
      alertMessage = 'PDF Uploaded! ID: $id';
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(alertMessage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Uploader'),
      ),
      body: Center(
        child: ListView(
          children: [
            // QR type
            Text(
              '${(widget.qrResult.qrType == QRType.driver) ? 'Driver' : 'Vehicle'} Details',
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
            ..._detailsWidgetBuilder(),
            // pick pdf button
            ElevatedButton(
              onPressed: () async {
                final pdf = await _generatePDF();
                setState(() {
                  _pdfFile = pdf;
                });
              },
              child: const Text('Generate PDF'),
            ),
            // pick pdf button
            ElevatedButton(
              onPressed: () async {
                if (_pdfFile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Generate PDF first!!'),
                    ),
                  );
                } else {
                  await _uploadFile();
                }
              },
              child: const Text('Upload PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
