import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sync_pdf;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../enums/qr_type.enum.dart';
import 'secure_string.api.dart';
import '../shared/constants.dart';

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

    // pdf content
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
        // footer - page number
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

    // saving the pdf created so far as a File
    File pdfFile = await saveDocument(
      name: '${(qrType == QRType.driver) ? displayData['DL No.'] : displayData['Vehicle No.']}.pdf',
      pdf: pdf,
    );

    // adding digital signature
    await addSignature(pdfFile);

    return pdfFile;
  }

  static Future<void> addSignature(File pdfFile) async {
    //Load the existing PDF document.
    final sync_pdf.PdfDocument document = sync_pdf.PdfDocument(
      inputBytes: pdfFile.readAsBytesSync(),
    );

    // getting the first page of the pdf
    sync_pdf.PdfPage page = document.pages[0];

    // loading certificate
    ByteData certificatesBytes = await rootBundle.load('assets/certificates/certificate.pfx');
    final ByteBuffer certificatesBuffer = certificatesBytes.buffer;

    // getting the date
    final date = DateTime.now();

    //Create signature field.
    sync_pdf.PdfSignatureField signatureField = sync_pdf.PdfSignatureField(
      page,
      'Signature',
      bounds: const Rect.fromLTWH(
        13 * PdfPageFormat.cm,
        24 * PdfPageFormat.cm,
        6 * PdfPageFormat.cm,
        2.5 * PdfPageFormat.cm,
      ),
      signature: sync_pdf.PdfSignature(
        certificate: sync_pdf.PdfCertificate(
          certificatesBuffer.asUint8List(
            certificatesBytes.offsetInBytes,
            certificatesBytes.lengthInBytes,
          ),
          SecureStringApi.getCertificatePassword(),
        ),
        contactInfo: contactInfo,
        locationInfo: locationInfo,
        reason: reason,
        signedDate: date,
        signedName: signedName,
        digestAlgorithm: sync_pdf.DigestAlgorithm.sha256,
        cryptographicStandard: sync_pdf.CryptographicStandard.cades,
      ),
    );

    // getting instance of signature's graphics
    sync_pdf.PdfGraphics graphics = signatureField.appearance.normal.graphics!;

    // loading the green check image from assets
    ByteData signBytes = await rootBundle.load('assets/images/signature-valid.png');
    final ByteBuffer signBuffer = signBytes.buffer;

    // adding green check image
    graphics.drawImage(
      sync_pdf.PdfBitmap(
        signBuffer.asUint8List(
          signBytes.offsetInBytes,
          signBytes.lengthInBytes,
        ),
      ),
      Rect.fromLTWH(
        1.25 * PdfPageFormat.cm,
        0,
        signatureField.bounds.height,
        signatureField.bounds.height,
      ),
    );

    // signature valid heading
    graphics.drawString(
      'Signature valid',
      sync_pdf.PdfStandardFont(
        sync_pdf.PdfFontFamily.helvetica,
        15,
      ),
      brush: sync_pdf.PdfBrushes.black,
      bounds: Rect.fromLTWH(
        0,
        0,
        signatureField.bounds.width,
        signatureField.bounds.height,
      ),
    );

    // signature info text
    graphics.drawString(
      'Digitally signed by $companyName \nName: $signedName \nDate: ${date.toIso8601String()} \nLocation: $locationInfo',
      sync_pdf.PdfStandardFont(
        sync_pdf.PdfFontFamily.helvetica,
        10,
      ),
      brush: sync_pdf.PdfBrushes.black,
      bounds: Rect.fromLTWH(
        0,
        20,
        signatureField.bounds.width,
        signatureField.bounds.height,
      ),
    );

    //Add the signature field to the document.
    document.form.fields.add(signatureField);

    //Save and dispose the document.
    pdfFile.writeAsBytesSync(await document.save());
    document.dispose();
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
