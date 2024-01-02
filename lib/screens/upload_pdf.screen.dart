import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import '../models/pdf.model.dart';
import '../services/firebase.service.dart';

class UploadPdfScreen extends StatefulWidget {
  const UploadPdfScreen({super.key});

  static const routeName = '/upload-pdf-screen';

  @override
  State<UploadPdfScreen> createState() => _UploadPdfScreenState();
}

class _UploadPdfScreenState extends State<UploadPdfScreen> {
  String? _fileName;
  String? _fileSize;
  String? _filePath;
  File? _pdfFile;

  // pick pdf from the device
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf'],
      allowMultiple: false,
      type: FileType.custom,
    );

    if (result != null && result.files.single.path != null) {
      // Load result
      PlatformFile file = result.files.first;
      File pdf = File(result.files.single.path!);
      setState(() {
        _fileName = file.name;
        _filePath = file.path;
        _pdfFile = pdf;

        int bytes = file.size;
        if (bytes <= 0) {
          _fileSize = "0 B";
        } else {
          const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
          var i = (log(bytes) / log(1024)).floor();
          _fileSize = '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
        }
      });
    }
  }

  // uploading pdf to firebase
  Future<void> _uploadFile() async {
    final provider = Provider.of<FirebaseProvider>(context, listen: false);
    final bytes = _pdfFile!.readAsBytesSync();

    final PDF pdf = PDF(
      name: _fileName!,
      base64String: base64Encode(bytes),
      size: _fileSize!,
    );

    String? id = await provider.savePDF(pdf);

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
        child: Column(
          children: [
            // file name
            if (_fileName != null) Text('File Name: ${_fileName!}'),
            // file size
            if (_fileSize != null) Text('File Size: ${_fileSize!}'),
            // file path
            if (_filePath != null)
              Text(
                'File Path: ${_filePath!}',
                textAlign: TextAlign.center,
              ),
            // pick pdf button
            ElevatedButton(
              onPressed: () async {
                await _pickFile();
              },
              child: const Text('Pick PDF'),
            ),
            // pick pdf button
            ElevatedButton(
              onPressed: () async {
                if (_fileName == null || _pdfFile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pick PDF first!!'),
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
