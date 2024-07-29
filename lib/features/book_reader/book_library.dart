import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineconnect/features/book_reader/book_controller.dart';
import 'package:cineconnect/features/readers_and_players/epub_reader.dart';
import 'package:cineconnect/features/readers_and_players/pdf_reader.dart';
import 'package:cineconnect/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BookLibrary extends StatefulWidget {
  const BookLibrary({super.key, required this.controller});

  final BookController controller;

  @override
  State<BookLibrary> createState() => _BookLibraryState();
}

class _BookLibraryState extends State<BookLibrary> {
  @override
  void initState() {
    widget.controller.getLibrary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => widget.controller.libraryLoading.value
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: widget.controller.library.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.7,
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                double leftPadding = index % 2 == 0 ? 16 : 8;
                double rightPadding = index % 2 != 0 ? 16 : 8;
                return Padding(
                  padding: EdgeInsets.fromLTRB(leftPadding, 8, rightPadding, 8),
                  child: InkWell(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Remove from Library",
                            style: GoogleFonts.quicksand(),
                          ),
                          content: Text(
                              widget.controller.library[index].book!.title!),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            ElevatedButton(
                                onPressed: () {
                                  File("/storage/emulated/0/Download/${widget.controller.library[index].fileName!}")
                                      .delete();
                                  widget.controller.removeFromLibrary(widget
                                      .controller.library[index].fileName!);
                                  Navigator.pop(context);
                                },
                                child: const Text("Remove"))
                          ],
                        ),
                      );
                    },
                    onTap: () async {
                      if (await File(
                              "/storage/emulated/0/Download/${widget.controller.library[index].fileName!}")
                          .exists()) {
                        if (widget.controller.library[index].book!.entension! ==
                            "epub") {
                          Navigator.push(
                            navigatorKey.currentContext!,
                            MaterialPageRoute(
                              builder: (context) => BookReader(
                                filePath:
                                    "/storage/emulated/0/Download/${widget.controller.library[index].fileName!}",
                              ),
                            ),
                          );
                        } else if (widget
                                .controller.library[index].book!.entension! ==
                            "pdf") {
                          Navigator.push(
                            navigatorKey.currentContext!,
                            MaterialPageRoute(
                              builder: (context) => PdfReader(
                                filePath:
                                    "/storage/emulated/0/Download/${widget.controller.library[index].fileName!}",
                              ),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(navigatorKey.currentContext!)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              "File Not Found. Redownloading",
                              style: GoogleFonts.quicksand(),
                            ),
                          ),
                        );
                        widget.controller.download(
                          widget.controller.library[index].link!,
                          widget.controller.library[index].book!,
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: context.theme.primaryColorDark,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl:
                              widget.controller.library[index].book!.poster!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
