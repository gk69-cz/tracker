import 'package:expensetracker/pages/pdflayout.dart';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportsState();
}

void generatePdf() async {
  await PdfGenerator.generatePdfAndSave();
}

class _ReportsState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Reports"),
        ),
        body: const Center(
            child: TextButton(
          onPressed: generatePdf,
          child: Text('Download report ',
          style: TextStyle(fontSize: 25),),
          
        )));
  }
}
