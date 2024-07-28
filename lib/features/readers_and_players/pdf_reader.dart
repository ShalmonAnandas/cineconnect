import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PdfReader extends StatefulWidget {
  const PdfReader({super.key, required this.url});

  final String url;
  @override
  State<PdfReader> createState() => _PdfReaderState();
}

class _PdfReaderState extends State<PdfReader> {
  File? file;
  String? path;
  @override
  void initState() {
    download().then((filepath) => setState(() => path = filepath));
    super.initState();
  }

  Future<String> download() async {
    final directory = await getExternalStorageDirectories();
    File file = File(
        "${directory!.first.path}/${widget.url.split("/").last.replaceAll("%20", " ")}");
    bool fileExists = await file.exists();
    if (fileExists) {
      return file.path;
    } else {
      await FlutterDownloader.enqueue(
        url: widget.url,
        headers: {},
        savedDir: directory.first.path,
        saveInPublicStorage: true,
        showNotification: true,
      );
      return "${directory.first.path}/${widget.url.split("/").last.replaceAll("%20", " ")}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (path == null)
          ? Container()
          : PDFView(
              filePath: path,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              // onRender: (_pages) {
              //   setState(() {
              //     pages = _pages;
              //     isReady = true;
              //   });
              // },
              // onError: (error) {
              //   print(error.toString());
              // },
              // onPageError: (page, error) {
              //   print('$page: ${error.toString()}');
              // },
              // onViewCreated: (PDFViewController pdfViewController) {
              //   _controller.complete(pdfViewController);
              // },
              // onPageChanged: (int page, int total) {
              //   print('page change: $page/$total');
              // },
            ),
    );
  }
}
