import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineconnect/constants.dart';
import 'package:cineconnect/features/drama/drama_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //         begin: Alignment.topCenter,
        //         end: Alignment.bottomCenter,
        //         colors: [
        //           Color.fromRGBO(0, 77, 121, 1),
        //           Color.fromRGBO(0, 31, 64, 1),
        //           Color.fromRGBO(0, 31, 64, 1),
        //           Color.fromRGBO(80, 22, 57, 1),
        //         ],
        //         stops: [
        //           0,
        //           0.2,
        //           0.6,
        //           1
        //         ]),
        //   ),
        // ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              "Hi, User",
              style: GoogleFonts.quicksand(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: TextField(
                  onChanged: (string) {
                    AppConstants.searchController.onSearchChanged();
                    setState(() {});
                  },
                  onTapOutside: (event) => WidgetsBinding
                      .instance.focusManager.primaryFocus
                      ?.unfocus(),
                  autofocus: false,
                  controller:
                      AppConstants.searchController.searchTextController,
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
                    suffixIcon: AppConstants
                            .searchController.searchTextController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              AppConstants.searchController.searchTextController
                                  .clear();
                              AppConstants.searchController.onSearchChanged();
                              setState(() {});
                            },
                          ),
                  ),
                ),
              ),
              Obx(
                () => AppConstants.searchController.isLoading.value
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
                    : AppConstants.searchController.searchResults == null ||
                            AppConstants
                                .searchController.searchResults!.results.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                AppConstants.searchController
                                        .searchTextController.text.isNotEmpty
                                    ? "No Results Found"
                                    : "Search To Get Started",
                                style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : Expanded(
                            child: GridView.builder(
                              itemCount: AppConstants.searchController
                                  .searchResults!.results.length,
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
                                        child: CachedNetworkImage(
                                          imageUrl: AppConstants
                                              .searchController
                                              .searchResults!
                                              .results[index]
                                              .image!,
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          AppConstants
                                                  .searchController
                                                  .searchResults!
                                                  .results[index]
                                                  .title ??
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            splashFactory:
                                                InkRipple.splashFactory,
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DramaScreen(
                                                  id: AppConstants
                                                      .searchController
                                                      .searchResults!
                                                      .results[index]
                                                      .id!,
                                                  bgImage: AppConstants
                                                      .searchController
                                                      .searchResults!
                                                      .results[index]
                                                      .image!,
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
          ),
        ),
      ],
    );
  }
}
