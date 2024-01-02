import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_app/models/pdf.model.dart';

class FirebaseProvider extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  // uploading 1 pdf
  Future<String?> savePDF(PDF pdf) async {
    try {
      String? pdfId;

      await _db.collection('PDFs').add(pdf.toJSON()).then((docSnapshot) {
        pdfId = docSnapshot.id;
      });

      return pdfId;
    } catch (e) {
      return null;
    }
  }

  // retrieving pdfs
  Future<List<PDF>?> getPDFs() async {
    try {
      List<PDF> pdfList = [];

      await _db.collection('PDFs').get().then((querySnapshot) {
        for (final doc in querySnapshot.docs) {
          pdfList.add(
            PDF(
              name: doc.data()['Name'],
              base64String: doc.data()['base64String'],
              size: doc.data()['size'],
            ),
          );
        }
      });

      return pdfList;
    } catch (e) {
      return null;
    }
  }
}
