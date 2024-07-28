import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';
import 'package:path_provider/path_provider.dart';

class BookReader extends StatefulWidget {
  const BookReader({super.key, required this.bookUrl});

  final String bookUrl;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  EpubController? _epubReaderController;
  final storageIO = InternetFileStorageIO();

  @override
  void initState() {
    super.initState();
    getBook();
  }

  void getBook() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${widget.bookUrl.split("/").last}';
    print("filepath ======= $filePath");
    final epubController = EpubController(
        document: EpubDocument.openData(
          await InternetFile.get(
            widget.bookUrl,
            storage: storageIO,
            storageAdditional: storageIO.additional(
              filename: filePath,
              location: '',
            ),
            progress: (receivedLength, contentLength) {
              final percentage = receivedLength / contentLength * 100;
              print(
                  'download progress: $receivedLength of $contentLength ($percentage%)');
            },
          ),
        ),
        epubCfi: "epubcfi(/6/6[chapter-2]!/4/2/1612)");

    setState(() {
      _epubReaderController = epubController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: _epubReaderController == null
              ? null
              : EpubViewActualChapter(
                  controller: _epubReaderController!,
                  builder: (chapterValue) => Text(
                    'Chapter: ${chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? ''}',
                    textAlign: TextAlign.start,
                  ),
                ),
        ),
        body: _epubReaderController == null
            ? const Center(child: CircularProgressIndicator())
            : EpubView(
                builders: EpubViewBuilders<DefaultBuilderOptions>(
                  options: const DefaultBuilderOptions(),
                  chapterDividerBuilder: (_) => const Divider(),
                ),
                controller: _epubReaderController!,
              ),
      ),
    );
  }
}
