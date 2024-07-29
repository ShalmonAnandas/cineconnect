import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfReader extends StatefulWidget {
  const PdfReader({super.key, required this.filePath});

  final String filePath;
  @override
  State<PdfReader> createState() => _PdfReaderState();
}

class _PdfReaderState extends State<PdfReader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FlutterDownloader.cancelAll();
        return true;
      },
      child: Scaffold(
        body: PDFView(
          filePath: widget.filePath,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: true,
          nightMode: true,

          // onRender: (_pages) {
          //   setState(() {
          //     pages = _pages;
          //     isReady = true;
          //   });
          // },
          onError: (error) {
            log(error.toString());
          },
          onPageError: (page, error) {
            log('$page: ${error.toString()}');
          },
          // onViewCreated: (PDFViewController pdfViewController) {
          //   _controller.complete(pdfViewController);
          // },
          onPageChanged: (int? page, int? total) {
            log('page change: $page/$total');
          },
        ),
      ),
    );
  }
}
