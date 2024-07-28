import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineconnect/features/book_reader/book_controller.dart';
import 'package:cineconnect/features/readers_and_players/epub_reader.dart';
import 'package:cineconnect/features/readers_and_players/pdf_reader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class BookSearch extends StatefulWidget {
  const BookSearch({super.key});

  @override
  State<BookSearch> createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  BookController controller = Get.put(BookController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Books",
          style: GoogleFonts.quicksand(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: TextField(
              onChanged: (string) {
                controller.onSearchChanged();
                setState(() {});
              },
              onTapOutside: (event) =>
                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
              autofocus: false,
              controller: controller.searchController,
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
                suffixIcon: controller.searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.searchController.clear();
                          controller.onSearchChanged();
                          setState(() {});
                        },
                      ),
              ),
            ),
          ),
          Obx(
            () => controller.isLoading.value
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
                : controller.searchResults.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            controller.searchController.text.isNotEmpty
                                ? "No Results Found"
                                : "Start Searching Libgen",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: controller.searchResults.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            child: InkWell(
                              onTap: () async {
                                controller
                                    .getDownloadLinks(controller
                                        .searchResults[index].downloadLinks!)
                                    .then((linkModel) {
                                  if (controller
                                          .searchResults[index].entension ==
                                      "pdf") {
                                    print(controller
                                        .searchResults[index].downloadLinks!);
                                    if (linkModel?.bookLinkModelGet != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfReader(
                                              url:
                                                  linkModel!.bookLinkModelGet!),
                                        ),
                                      );
                                    }
                                  } else if (controller
                                          .searchResults[index].entension ==
                                      "epub") {
                                    if (linkModel?.bookLinkModelGet != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BookReader(
                                              bookUrl:
                                                  linkModel!.bookLinkModelGet!),
                                        ),
                                      );
                                    }
                                  }
                                });
                              },
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: controller
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
                                                controller.searchResults[index]
                                                    .title!,
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
                                                controller.searchResults[index]
                                                    .author!,
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
                                                  if (controller
                                                          .searchResults[index]
                                                          .pages! !=
                                                      "0")
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: Colors.blueGrey
                                                              .withOpacity(
                                                                  0.2)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 3,
                                                                horizontal: 6),
                                                        child: Center(
                                                          child: Text(
                                                            "Pages ${(controller.searchResults[index].pages!.split("/").length > 1) ? controller.searchResults[index].pages!.split("/")[1] : controller.searchResults[index].pages!}",
                                                            style: GoogleFonts
                                                                .quicksand(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (controller
                                                          .searchResults[index]
                                                          .releaseDate! !=
                                                      "")
                                                    const SizedBox(width: 3),
                                                  if (controller
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
                                                              .withOpacity(
                                                                  0.2)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 3,
                                                                horizontal: 6),
                                                        child: Center(
                                                          child: Text(
                                                            controller
                                                                .searchResults[
                                                                    index]
                                                                .releaseDate!,
                                                            style: GoogleFonts
                                                                .quicksand(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (controller
                                                          .searchResults[index]
                                                          .entension! !=
                                                      "")
                                                    const SizedBox(width: 3),
                                                  if (controller
                                                          .searchResults[index]
                                                          .entension! !=
                                                      "")
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: Colors
                                                              .deepOrange
                                                              .shade200
                                                              .withOpacity(
                                                                  0.2)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 3,
                                                                horizontal: 6),
                                                        child: Center(
                                                          child: Text(
                                                            controller
                                                                .searchResults[
                                                                    index]
                                                                .entension!,
                                                            style: GoogleFonts
                                                                .quicksand(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
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
      ),
    );
  }
}
