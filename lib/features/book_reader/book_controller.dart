import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cineconnect/models/book_link_model.dart';
import 'package:cineconnect/models/book_search_result.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;
  List<BookSearchResult> searchResults = [];
  Timer? _debounce;

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (searchController.text.isNotEmpty) {
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
    searchResults.clear();
    try {
      String response = await APIHandler()
          .sendRequest(APIConstants.searchBookUrl(searchController.text));

      for (Map<String, dynamic> book in jsonDecode(response)) {
        searchResults.add(BookSearchResult.fromJson(book));
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<BookLinkModel?> getDownloadLinks(String mirror) async {
    try {
      String? response = await APIHandler().postRequest(
        url: "${APIConstants.baseBookUrl}/dl",
        body: json.encode({"mirror": mirror}),
      );
      return BookLinkModel.fromJson(jsonDecode(response!));
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
