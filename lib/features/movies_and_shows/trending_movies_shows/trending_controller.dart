import 'dart:convert';

import 'package:cineconnect/models/search.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TrendingController extends GetxController {
  RxBool isLoading = false.obs;

  Future<List<Search>> getHomepageData(String provider, String type) async {
    DateTime today = DateTime.now();
    // String fetchKey =
    //     '${provider}_${type}_${today.day}_${today.month}_${today.year}';
    //
    List<Search> results = [];
    //
    // var box = await Hive.openBox('${type}Box');
    //
    // var cacheData = box.get(fetchKey);

    // if (cacheData != null) {
    //   for (Map<String, dynamic> data in jsonDecode(cacheData)) {
    //     results.add(Search.fromJson(data));
    //   }
    // } else {
    String response = await APIHandler().makeGetRequest(
        url:
            "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1");

    // box.put(fetchKey, response);
    for (Map<String, dynamic> data in jsonDecode(response)) {
      results.add(Search.fromJson(data));
    }
    // }
    return results;
  }
}
