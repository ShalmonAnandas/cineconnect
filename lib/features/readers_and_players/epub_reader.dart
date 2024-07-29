import 'dart:io';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookReader extends StatefulWidget {
  const BookReader({super.key, required this.filePath});

  final String filePath;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  EpubController? _epubReaderController;

  @override
  void initState() {
    super.initState();
    getBook();
  }

  void getBook() async {
    final prefs = await Hive.openBox("LastPositionBox");
    final lastLocation = await prefs.get('lastLocation_${widget.filePath}');

    final epubController = EpubController(
      document: EpubDocument.openFile(File(widget.filePath)),
      epubCfi: lastLocation,
    );

    setState(() {
      _epubReaderController = epubController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        saveLastLocation();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: _epubReaderController == null
                ? null
                : EpubViewActualChapter(
                    controller: _epubReaderController!,
                    builder: (chapterValue) => Text(
                      'Chapter: ${chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? ''}',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.quicksand(),
                    ),
                  ),
          ),
          body: _epubReaderController == null
              ? const Center(child: CircularProgressIndicator())
              : EpubView(
                  builders: EpubViewBuilders<DefaultBuilderOptions>(
                    options: DefaultBuilderOptions(
                        textStyle: GoogleFonts.quicksand()),
                    chapterDividerBuilder: (_) => const Divider(),
                  ),
                  controller: _epubReaderController!,
                ),
        ),
      ),
    );
  }

  void saveLastLocation() async {
    if (_epubReaderController != null) {
      final prefs = await Hive.openBox("LastPositionBox");
      final lastLocation = _epubReaderController!.generateEpubCfi();
      prefs.put('lastLocation_${widget.filePath}', lastLocation!);
    }
  }
}
