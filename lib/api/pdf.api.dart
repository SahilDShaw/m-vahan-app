import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:qr_app/enums/qr_type.enum.dart';

class PdfApi {
  static Future<File> generatePDF({
    required QRType qrType,
    required Map<String, String> displayData,
  }) async {
    final pdf = Document();

    // nic logo
    final img = await rootBundle.load('assets/images/nic.png');
    final imageBytes = img.buffer.asUint8List();
    Image image = Image(MemoryImage(imageBytes));

    // table content
    List<TableRow> tableRows = [];
    displayData.forEach((key, value) {
      tableRows.add(
        TableRow(children: [
          Text(
            key,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      );
    });

    pdf.addPage(
      MultiPage(
        build: (context) => <Widget>[
          // heading
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: PdfColors.blue,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // heading text
                Text(
                  '${(qrType == QRType.driver) ? 'Driver' : 'Vehicle'} Details',
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),
                // logo
                Container(
                  alignment: Alignment.center,
                  width: 5 * PdfPageFormat.cm,
                  child: image,
                ),
              ],
            ),
          ),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          // content table
          Table(
            children: tableRows,
          ),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          // a headline
          Header(child: Text('My Headline')),
          // a paragraph
          Paragraph(text: LoremText().paragraph(60)),
        ],
        footer: (context) {
          final text = 'Page ${context.pageNumber} of ${context.pagesCount}';

          return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(
              top: 1 * PdfPageFormat.cm,
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: PdfColors.black,
              ),
            ),
          );
        },
      ),
    );

    return saveDocument(
      name: '${(qrType == QRType.driver) ? displayData['DL No.'] : displayData['Vehicle No.']}.pdf',
      pdf: pdf,
    );
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFilex.open(url);
  }
}
