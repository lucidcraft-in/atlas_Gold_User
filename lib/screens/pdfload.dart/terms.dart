import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TermsAndCondition extends StatefulWidget {
  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  String? filePath;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    final ByteData bytes = await DefaultAssetBundle.of(context)
        .load('assets/pdf/Terms & Conditions.pdf');
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/refund_policy.pdf';
    final File file = File(path);
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    setState(() {
      filePath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Terms And Conditions',
        ),
      ),
      body: filePath != null
          ? PDFView(
              filePath: filePath!,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
