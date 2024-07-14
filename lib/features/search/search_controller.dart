import 'dart:async';
import 'dart:convert';

import 'package:cineconnect/models/search.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MediaSearchController extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  Search? searchResults;
  RxBool isLoading = false.obs;
  Timer? _debounce;

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (searchTextController.text.isNotEmpty) {
        getSearchResults();
      } else {
        isLoading.value = true;
        searchResults = null;
        isLoading.value = false;
      }
    });
  }

  void getSearchResults() async {
    isLoading.value = true;

    String response = await APIHandler().sendRequest(
        APIConstants.searchUrl(searchString: searchTextController.text));

    searchResults = Search.fromJson(jsonDecode(response));

    isLoading.value = false;
  }
}
