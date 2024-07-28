import 'dart:async';
import 'dart:convert';

import 'package:cineconnect/models/search.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaSearchController extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  List<Search> searchResults = [];
  RxBool isLoading = false.obs;
  Timer? _debounce;
  String provider = "";

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (searchTextController.text.isNotEmpty) {
        getSearchResults();
      } else {
        isLoading.value = true;
        searchResults = [];
        isLoading.value = false;
      }
    });
  }

  void getSearchResults() async {
    isLoading.value = true;

    String response = await APIHandler().sendRequest(APIConstants.urlGenerator(
        provider: provider, searchString: searchTextController.text));

    List searchresponse = jsonDecode(response)["results"];

    searchResults = [];

    for (Map<String, dynamic> data in searchresponse) {
      searchResults.add(Search.fromJson(data));
    }

    isLoading.value = false;
  }
}
