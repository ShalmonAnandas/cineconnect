import 'dart:convert';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cineconnect/features/movies_and_shows/drama/media_ui.dart';
import 'package:cineconnect/features/movies_and_shows/search/search_ui.dart';
import 'package:cineconnect/features/movies_and_shows/trending_movies_shows/trending_controller.dart';
import 'package:cineconnect/models/enums.dart';
import 'package:cineconnect/models/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TrendingController controller = Get.put(TrendingController());
  final List<String> providerList =
      MovieProviders.values.map((element) => element.name).toList();
  RxString selectedProvider = "".obs;
  RxBool toggleSearch = false.obs;
  RxBool dataNotFound = false.obs;
  List<Search> trendingResults = [];
  List<Search> recentShowsResults = [];
  List<Search> recentMovies = [];

  // hive provider
  String fetchKey = "selected_provider";
  var box;

  @override
  void initState() {
    getSelectedProvider().then((provider) =>
        getData().then((value) => controller.isLoading.value = value));
    super.initState();
  }

  Future<String> getSelectedProvider() async {
    controller.isLoading.value = true;
    box = await Hive.openBox('provider_Box');
    selectedProvider.value = await box.get(fetchKey) ?? providerList.first;
    return selectedProvider.value;
  }

  void setSelectedProvider() async {
    box = await Hive.openBox('provider_Box');
    box.put(fetchKey, selectedProvider.value);
  }

  Future<bool> getData() async {
    toggleSearch.value = false;
    dataNotFound.value = false;
    trendingResults.clear();
    recentShowsResults.clear();
    try {
      trendingResults =
          await controller.getHomepageData(selectedProvider.value, "trending");
      recentShowsResults = await controller.getHomepageData(
          selectedProvider.value, "recent-shows");
      recentMovies = await controller.getHomepageData(
          selectedProvider.value, "recent-movies");
    } catch (e) {
      toggleSearch.value = true;
      dataNotFound.value = true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Obx(
            () => (!dataNotFound.value)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: IconButton(
                      onPressed: () {
                        toggleSearch.value = !toggleSearch.value;
                      },
                      icon:
                          Icon(toggleSearch.value ? Icons.close : Icons.search),
                    ),
                  )
                : const SizedBox(),
          )
        ],
        title: Obx(
          () => Text(
            selectedProvider.value.toUpperCase(),
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.35,
        height: 50,
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: providerList.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      controller.isLoading.value = true;
                      selectedProvider.value = providerList[index];
                      setSelectedProvider();
                      getData()
                          .then((value) => controller.isLoading.value = value);
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Row(
                        children: [
                          if (selectedProvider.value == providerList[index])
                            const Icon(Icons.check),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  selectedProvider.value == providerList[index]
                                      ? 16
                                      : 40,
                            ),
                            child: Text(
                              providerList[index].toUpperCase(),
                              style: GoogleFonts.quicksand(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.keyboard_double_arrow_down_rounded),
              const SizedBox(width: 5),
              Obx(() => Text(selectedProvider.value.toUpperCase())),
            ],
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Lottie.asset("assets/cat_loader.json")),
              )
            : toggleSearch.value
                ? SearchScreen(
                    provider: selectedProvider.value,
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarouselSlider.builder(
                          itemCount: trendingResults.length,
                          itemBuilder: (context, index, realIndex) {
                            return InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MediaScreen(
                                    id: trendingResults[index].id.toString(),
                                    mediaType: trendingResults[index].type!,
                                    bgImage: trendingResults[index].image!,
                                    base64Image:
                                        trendingResults[index].base64image,
                                    provider: selectedProvider.value,
                                  ),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedMemoryImage(
                                  uniqueKey:
                                      "${selectedProvider.value}_trending://image/$index",
                                  errorBuilder: (context, string, obj) =>
                                      Image.asset(
                                    "assets/default_poster.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                  bytes: base64Decode(trendingResults[index]
                                      .base64image!
                                      .replaceAll(
                                          "data:image/jpeg;base64,", '')),
                                  isAntiAlias: true,
                                  scale: 10,
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.5,
                            padEnds: false,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.15,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Recent Shows",
                            style: GoogleFonts.quicksand(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: HorizontalScrollingWidget(
                            mediaList: recentShowsResults,
                            provider: selectedProvider.value,
                            type: TrendingType.recentshows,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Recent Movies",
                            style: GoogleFonts.quicksand(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: HorizontalScrollingWidget(
                            mediaList: recentMovies,
                            provider: selectedProvider.value,
                            type: TrendingType.recentmovies,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class HorizontalScrollingWidget extends StatefulWidget {
  const HorizontalScrollingWidget(
      {super.key,
      required this.mediaList,
      required this.provider,
      required this.type});

  final List<Search> mediaList;
  final String provider;
  final TrendingType type;

  @override
  State<HorizontalScrollingWidget> createState() =>
      _HorizontalScrollingWidgetState();
}

class _HorizontalScrollingWidgetState extends State<HorizontalScrollingWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.mediaList.length,
        itemBuilder: (context, index) {
          double firstPadding = index == 0 ? 16.0 : 8;
          double lastPadding = index == widget.mediaList.length - 1 ? 16.0 : 8;
          return Padding(
            padding: EdgeInsets.fromLTRB(firstPadding, 0, lastPadding, 0),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MediaScreen(
                    id: widget.mediaList[index].id.toString(),
                    mediaType: widget.mediaList[index].type!,
                    bgImage: widget.mediaList[index].image!,
                    base64Image: widget.mediaList[index].base64image,
                    provider: widget.provider,
                  ),
                ),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade900,
                  image: DecorationImage(
                    image: CachedMemoryImageProvider(
                      "${widget.provider}_${widget.type.name}://image/$index",
                      bytes: base64Decode(
                        widget.mediaList[index].base64image!
                            .replaceAll("data:image/jpeg;base64,", ''),
                      ),
                    ),
                    onError: (exception, stackTrace) => const AssetImage(
                      "assets/default_poster.jpg",
                    ),
                    isAntiAlias: true,
                    scale: 10,
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

enum TrendingType { trending, recentshows, recentmovies }
