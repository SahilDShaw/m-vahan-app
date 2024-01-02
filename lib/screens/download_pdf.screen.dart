import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../models/pdf.model.dart';
import '../services/firebase.service.dart';

class DownloadPdfScreen extends StatefulWidget {
  const DownloadPdfScreen({super.key});

  static const routeName = '/download-pdf-screen';

  @override
  State<DownloadPdfScreen> createState() => _DownloadPdfScreenState();
}

class _DownloadPdfScreenState extends State<DownloadPdfScreen> {
  late Future<List<PDF>?> pdfListFuture;

  Future<void> _downloadPdf(PDF pdfFile) async {
    try {
      var base64 = pdfFile.base64String;

      // decoding base64String
      var bytes = base64Decode(base64);

      // fetching a temporary directory
      final output = await getTemporaryDirectory();

      // setting file name
      final path = "${output.path}/${pdfFile.name}";
      final file = File(path);

      // writing file
      await file.writeAsBytes(bytes.buffer.asUint8List());

      // opening pdf
      await OpenFilex.open(path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FirebaseProvider>(context, listen: false);
    pdfListFuture = provider.getPDFs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PDF Downloader'),
        ),
        body: FutureBuilder(
          future: pdfListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<PDF>? pdfList = snapshot.data;

              if (pdfList == null || pdfList.isEmpty) {
                return const Center(
                  child: Text('No PDFs uploaded to Firebase'),
                );
              } else {
                return ListView.builder(
                  itemCount: pdfList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Name: ${pdfList[index].name}'),
                      subtitle: Text('Size: ${pdfList[index].size}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () async {
                          await _downloadPdf(pdfList[index]);
                        },
                      ),
                    );
                  },
                );
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something Went Wrong!'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
