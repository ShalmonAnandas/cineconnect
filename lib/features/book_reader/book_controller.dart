import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cineconnect/main.dart';
import 'package:cineconnect/models/book_search_result.dart';
import 'package:cineconnect/models/library_model.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class BookController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;
  List<BookSearchResult> searchResults = [];
  Timer? _debounce;

  List<LibraryModel> library = [];
  RxBool libraryLoading = false.obs;

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
      String response = await APIHandler().makeGetRequest(
          url: APIConstants.searchBookUrl(searchController.text));

      for (Map<String, dynamic> book in jsonDecode(response)) {
        searchResults.add(BookSearchResult.fromJson(book));
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<List?> getDownloadLinks(String mirror) async {
    try {
      String? response = await APIHandler().postRequest(
        url: "${APIConstants.baseBookUrl}/dl",
        body: json.encode({"mirror": mirror}),
      );
      return jsonDecode(response!).values.toList();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  void download(List url, BookSearchResult book, {int index = 0}) async {
    Directory directory = Directory('/storage/emulated/0/Download');
    try {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            "Starting Download, Please don't close the app",
            style: GoogleFonts.quicksand(),
          ),
        ),
      );
      String? taskid = await FlutterDownloader.enqueue(
        url: url[index],
        headers: {},
        savedDir: directory.path,
        saveInPublicStorage: true,
        showNotification: true,
      );
      getTaskStatus(taskid!, book, url, index);
    } catch (e) {
      if (e.toString().contains("RangeError")) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(
              'Download Link Unavailable, Try Another Edition.',
              style: GoogleFonts.quicksand(),
            ),
          ),
        );
      }
    }
  }

  void getTaskStatus(String taskId, BookSearchResult book, List downloadLink,
      int index) async {
    final tasks = await FlutterDownloader.loadTasks();
    final task = tasks!.where((task) => task.taskId == taskId).toList().first;
    await Future.delayed(const Duration(seconds: 1));
    if (task.status == DownloadTaskStatus.failed) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            "Download failed, trying another link",
            style: GoogleFonts.quicksand(),
          ),
        ),
      );
      if (index < downloadLink.length) {
        download(downloadLink, book, index: index + 1);
      } else {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(
              "Download failed",
              style: GoogleFonts.quicksand(),
            ),
          ),
        );
      }
    } else if (task.progress < 10) {
      getTaskStatus(taskId, book, downloadLink, index);
    } else {
      addBookToLibrary(taskId, task.filename!, book, downloadLink);
    }
  }

  void addBookToLibrary(String taskid, String filename, BookSearchResult book,
      List downloadLink) async {
    var box = await Hive.openBox('libraryBox');

    var bookDetails = box.get(filename);
    final allData = box.toMap();

    if (bookDetails == null) {
      box.put(filename, {
        "taskID": taskid,
        "book": book.toJson(),
        "fileName": filename,
        "link": downloadLink
      });
    } else {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            "Already in library",
            style: GoogleFonts.quicksand(),
          ),
        ),
      );
      log(allData.toString());
    }
  }

  removeFromLibrary(String fileName) async {
    var box = await Hive.openBox('libraryBox');
    box.delete(fileName);
    getLibrary();
  }

  Future<bool> checkInLibrary(List downloadLink) async {
    var box = await Hive.openBox('libraryBox');

    final allData = box.toMap();

    bool existsInLibrary = false;

    for (var book in allData.values) {
      if (book["link"] == downloadLink) {
        existsInLibrary = true;
        break;
      } else {
        existsInLibrary = false;
      }
    }

    return existsInLibrary;
  }

  void getLibrary() async {
    libraryLoading.value = true;
    library.clear();
    var box = await Hive.openBox('libraryBox');
    final allData = box.toMap();
    List values = allData.values.toList();
    for (var book in values) {
      library.add(LibraryModel.fromJson(jsonDecode(jsonEncode(book))));
    }
    libraryLoading.value = false;
  }
}
