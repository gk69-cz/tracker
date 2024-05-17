import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:permission_handler/permission_handler.dart';

class PdfGenerator {
  static Future<void> generatePdfAndSave() async {
    // Request WRITE_EXTERNAL_STORAGE permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Permission denied for storage.');
    }

    // Get the directory for saving files
    final Directory? directory = await getDownloadsDirectory();
    final String? path = directory?.path;

    if (path != null) {
      final pdf = pw.Document();

      // Add content to the PDF document
      pdf.addPage(
  pw.Page(
    build: (context) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text('Expense Report', style: pw.TextStyle(fontSize: 24)),
          ),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Title', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              // Add dummy data rows
              pw.TableRow(
                children: [
                  pw.Text('2024-05-16'),
                  pw.Text('Expense 1'),
                  pw.Text('\$100.00'),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text('2024-05-17'),
                  pw.Text('Expense 2'),
                  pw.Text('\$150.00'),
                ],
              ),
              // Add more dummy data rows as needed
            ],
          ),
        ],
      );
    },
  ),
);


      // Save the PDF document to a file
      final File file = File('$path/example444.pdf');
      await file.writeAsBytes(await pdf.save());
    } else {
      throw Exception('Failed to get the downloads directory.');
    }
  }
}
