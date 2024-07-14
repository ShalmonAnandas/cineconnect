import 'dart:convert';

import 'package:cineconnect/models/search.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TrendingController extends GetxController {
  RxBool isLoading = false.obs;
  Search? trendingResults;

  @override
  void onInit() {
    getTrending();
    super.onInit();
  }

  void getTrending() async {
    DateTime today = DateTime.now();
    String fetchKey = 'trending_${today.day}_${today.month}_${today.year}';
    isLoading.value = true;

    var box = await Hive.openBox('trendingBox');

    var cacheData = box.get(fetchKey);

    if (cacheData != null) {
      trendingResults = Search.fromJson(jsonDecode(cacheData));
    } else {
      String response = await APIHandler()
          .sendRequest(APIConstants.searchUrl(searchString: "trending"));
      box.put(fetchKey, response);
      trendingResults = Search.fromJson(jsonDecode(response));
    }

    isLoading.value = false;
  }
}
