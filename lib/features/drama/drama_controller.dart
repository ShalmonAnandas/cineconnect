import 'dart:convert';
import 'dart:developer';

import 'package:cineconnect/models/drama_details.dart';
import 'package:cineconnect/models/streaming_links.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DramaController extends GetxController {
  RxBool isLoading = true.obs;
  DramaDetails? dramaDetails;

  void getDramaDetails(String id) async {
    isLoading.value = true;
    String response = await APIHandler()
        .sendRequest(APIConstants.dramaDetailsUrl(dramaID: id));
    dramaDetails = DramaDetails.fromJson(jsonDecode(response));
    isLoading.value = false;
  }

  Future<KDramaStreamingLinks?> fetchStreamingLink(
      String dramaID, String episodeID) async {
    try {
      String response = await APIHandler().sendRequest(
          APIConstants.streamUrl(episodeID: episodeID, dramaID: dramaID));
      return KDramaStreamingLinks.fromJson(jsonDecode(response));
    } catch (e) {
      return null;
    }
  }
}
