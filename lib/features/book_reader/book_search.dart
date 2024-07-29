import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineconnect/features/book_reader/book_controller.dart';
import 'package:cineconnect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class BookSearch extends StatefulWidget {
  const BookSearch({super.key, required this.controller});

  final BookController controller;

  @override
  State<BookSearch> createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: TextField(
            onChanged: (string) {
              widget.controller.onSearchChanged();
              setState(() {});
            },
            onTapOutside: (event) =>
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
            autofocus: false,
            controller: widget.controller.searchController,
            style: GoogleFonts.quicksand(),
            decoration: InputDecoration(
              label: Text(
                "Search",
                style: GoogleFonts.quicksand(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintStyle: GoogleFonts.quicksand(),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.controller.searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.controller.searchController.clear();
                        widget.controller.onSearchChanged();
                        setState(() {});
                      },
                    ),
            ),
          ),
        ),
        Obx(
          () => widget.controller.isLoading.value
              ? Expanded(
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.2),
                        highlightColor: Colors.white.withOpacity(0.4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : widget.controller.searchResults.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          widget.controller.searchController.text.isNotEmpty
                              ? "No Results Found"
                              : "Start Searching Libgen",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: widget.controller.searchResults.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          child: InkWell(
                            onTap: () async {
                              FlutterDownloader.cancelAll();

                              final linkModel = await widget.controller
                                  .getDownloadLinks(widget.controller
                                      .searchResults[index].downloadLinks!);

                              final existsInLib = await widget.controller
                                  .checkInLibrary(linkModel!);

                              if (existsInLib) {
                                ScaffoldMessenger.of(
                                        navigatorKey.currentContext!)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Book Already present in library!',
                                      style: GoogleFonts.quicksand(),
                                    ),
                                  ),
                                );
                              } else {
                                widget.controller.download(linkModel,
                                    widget.controller.searchResults[index]);
                              }
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorDark,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl: widget
                                                  .controller
                                                  .searchResults[index]
                                                  .poster ??
                                              "",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(
                                              widget.controller
                                                  .searchResults[index].title!,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "By",
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              widget.controller
                                                  .searchResults[index].author!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                if (widget
                                                        .controller
                                                        .searchResults[index]
                                                        .language! !=
                                                    "")
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: Colors.blueGrey
                                                            .withOpacity(0.2)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3,
                                                          horizontal: 6),
                                                      child: Center(
                                                        child: Text(
                                                          widget
                                                              .controller
                                                              .searchResults[
                                                                  index]
                                                              .language!,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (widget
                                                        .controller
                                                        .searchResults[index]
                                                        .releaseDate! !=
                                                    "")
                                                  const SizedBox(width: 3),
                                                if (widget
                                                        .controller
                                                        .searchResults[index]
                                                        .releaseDate! !=
                                                    "")
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: Colors
                                                            .brown.shade400
                                                            .withOpacity(0.2)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3,
                                                          horizontal: 6),
                                                      child: Center(
                                                        child: Text(
                                                          widget
                                                              .controller
                                                              .searchResults[
                                                                  index]
                                                              .releaseDate!,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (widget
                                                        .controller
                                                        .searchResults[index]
                                                        .entension! !=
                                                    "")
                                                  const SizedBox(width: 3),
                                                if (widget
                                                        .controller
                                                        .searchResults[index]
                                                        .entension! !=
                                                    "")
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: Colors
                                                            .deepOrange.shade200
                                                            .withOpacity(0.2)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3,
                                                          horizontal: 6),
                                                      child: Center(
                                                        child: Text(
                                                          widget
                                                              .controller
                                                              .searchResults[
                                                                  index]
                                                              .entension!,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
        )
      ],
    );
  }
}
