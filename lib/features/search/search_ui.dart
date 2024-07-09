import 'package:cineconnect/features/drama/drama_ui.dart';
import 'package:cineconnect/features/search/search_controller.dart';
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
  KDramaSearchController searchController = Get.put(KDramaSearchController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 77, 121, 1),
                  Color.fromRGBO(0, 31, 64, 1),
                  Color.fromRGBO(0, 31, 64, 1),
                  Color.fromRGBO(80, 22, 57, 1),
                ],
                stops: [
                  0,
                  0.2,
                  0.6,
                  1
                ]),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              "Hi, Prajakta",
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
                    searchController.onSearchChanged();
                    setState(() {});
                  },
                  controller: searchController.searchTextController,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        searchController.searchTextController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.searchTextController.clear();
                                  setState(() {});
                                  searchController.onSearchChanged();
                                },
                              ),
                  ),
                ),
              ),
              Obx(
                () => searchController.isLoading.value
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[900]!,
                        highlightColor: Colors.grey[600]!,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.87,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.7,
                              crossAxisCount: 2,
                            ),
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.87,
                          child: GridView.builder(
                            itemCount:
                                searchController.searchResults.value.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DramaScreen(
                                      id: searchController
                                              .searchResults.value[index].id ??
                                          0,
                                      bgImage: searchController.searchResults
                                          .value[index].thumbnail!,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          searchController.searchResults
                                              .value[index].thumbnail!,
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
                                          searchController.searchResults
                                                  .value[index].title ??
                                              "",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
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
                      ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
