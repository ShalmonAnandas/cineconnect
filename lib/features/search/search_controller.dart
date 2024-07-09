import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cineconnect/models/search.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KDramaSearchController extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  Rx<List<Search>> searchResults = Rx([]);
  RxBool isLoading = false.obs;
  Timer? _debounce;

  @override
  void onInit() {
    getRecommended();
    super.onInit();
  }

  void getRecommended() async {
    String response = await APIHandler()
        .sendRequest(APIConstants.searchUrl(searchString: ""));
    for (var result in jsonDecode(response)) {
      searchResults.value.add(Search.fromJson(result));
    }
    isLoading.value = false;
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      getSearchResults();
    });
  }

  void getSearchResults() async {
    isLoading.value = true;

    searchResults.value.clear();
    String response = await APIHandler().sendRequest(
        APIConstants.searchUrl(searchString: searchTextController.text));

    print(response);
    for (var result in jsonDecode(response)) {
      searchResults.value.add(Search.fromJson(result));
    }
    isLoading.value = false;
  }
}
