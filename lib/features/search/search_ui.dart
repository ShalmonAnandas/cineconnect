import 'dart:convert';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineconnect/features/drama/media_ui.dart';
import 'package:cineconnect/features/search/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.provider});

  final String provider;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  MediaSearchController searchController = Get.put(MediaSearchController());

  @override
  Widget build(BuildContext context) {
    searchController.provider = widget.provider;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: TextField(
            onChanged: (string) {
              searchController.onSearchChanged();
              setState(() {});
            },
            onTapOutside: (event) =>
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
            autofocus: false,
            controller: searchController.searchTextController,
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
              suffixIcon: searchController.searchTextController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.searchTextController.clear();
                        searchController.onSearchChanged();
                        setState(() {});
                      },
                    ),
            ),
          ),
        ),
        Obx(
          () => searchController.isLoading.value
              ? Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.7,
                      crossAxisCount: 2,
                    ),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      double leftPadding = index % 2 == 0 ? 16 : 8;
                      double rightPadding = index % 2 != 0 ? 16 : 8;
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.2),
                        highlightColor: Colors.white.withOpacity(0.4),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              leftPadding, 8, rightPadding, 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
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
              : searchController.searchResults.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          searchController.searchTextController.text.isNotEmpty
                              ? "No Results Found"
                              : "Search ${widget.provider.toUpperCase()}",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  : Expanded(
                      child: GridView.builder(
                        itemCount: searchController.searchResults.length,
                        itemBuilder: (context, index) {
                          double leftPadding = index % 2 == 0 ? 16 : 8;
                          double rightPadding = index % 2 != 0 ? 16 : 8;
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                                leftPadding, 8, rightPadding, 8),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: widget.provider != "dramacool"
                                      ? CachedMemoryImage(
                                          uniqueKey:
                                              "search_${searchController.searchTextController.text}_${searchController.provider}_${index.toString()}",
                                          // errorWidget: (context, string, obj) =>
                                          //     Image.asset(
                                          //   "assets/default_poster.jpg",
                                          //   fit: BoxFit.cover,
                                          // ),
                                          bytes: base64Decode(
                                            searchController
                                                .searchResults[index]
                                                .base64image!
                                                .replaceAll(
                                                    "data:image/jpeg;base64,",
                                                    ''),
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: searchController
                                              .searchResults[index].image!,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    searchController
                                            .searchResults[index].title ??
                                        "",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      splashFactory: InkRipple.splashFactory,
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MediaScreen(
                                            id: searchController
                                                .searchResults[index].id!,
                                            bgImage: searchController
                                                .searchResults[index].image!,
                                            mediaType: searchController
                                                .searchResults[index].type!,
                                            provider: widget.provider,
                                            base64Image: searchController
                                                .searchResults[index]
                                                .base64image!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.7,
                          crossAxisCount: 2,
                        ),
                      ),
                    ),
        )
      ],
    );
  }
}
