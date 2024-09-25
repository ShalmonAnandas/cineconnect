import 'dart:convert';

import 'package:cineconnect/models/media_details.dart';
import 'package:cineconnect/models/stream_model.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class MediaController extends GetxController {
  MediaModel? dramaDetails;
  RxBool isLoading = true.obs;
  List<List<Episode>> seasons = [];

  Future<MediaModel> getDramaDetails(String id, String provider) async {
    isLoading.value = true;
    String fetchKey = "media_details_${id}_$provider";

    var box = await Hive.openBox('mediaBox');

    var mediaDetails = box.get(fetchKey);

    if (mediaDetails != null) {
      dramaDetails = MediaModel.fromJson(jsonDecode(jsonEncode(mediaDetails)));
    } else {
      String response = await APIHandler().makeGetRequest(
          url: APIConstants.dramaDetailsUrl(provider: provider, dramaID: id));

      Map<String, dynamic> updatedResponse = jsonDecode(response);

      updatedResponse["recommendations"] = [];

      dramaDetails = MediaModel.fromJson(updatedResponse);
      box.put(fetchKey, updatedResponse);
    }
    getSeasons();
    isLoading.value = false;
    return dramaDetails!;
  }

  getSeasons() {
    seasons.clear();
    int numberOfSeasons = dramaDetails!.episodes
        .map((episode) => episode.season)
        .toSet()
        .toList()
        .length;
    for (int i = 1; i <= numberOfSeasons; i++) {
      List<Episode> tempSeasonList = [];
      for (Episode episode in dramaDetails!.episodes) {
        if (episode.season == i) {
          tempSeasonList.add(episode);
        }
      }
      seasons.add(tempSeasonList);
    }
  }

  Future<StreamModel> getStreams(
      String provider, String episodeID, String mediaID) async {
    DateTime today = DateTime.now();
    String fetchKeyDate = "${today.day}_${today.month}_${today.year}";
    String fetchKey =
        "stream_detailsModel_${episodeID}_${mediaID}_$fetchKeyDate";

    var box = await Hive.openBox('streamsBox');

    var streamDetails = box.get(fetchKey);

    if (streamDetails != null) {
      return StreamModel.fromJson(jsonDecode(streamDetails));
    } else {
      final response = await APIHandler().makeGetRequest(
          url: APIConstants.streamUrl(
              provider: provider, episodeID: episodeID, dramaID: mediaID));
      Map<String, dynamic> responseMap = jsonDecode(response);
      box.put(fetchKey, response);
      return StreamModel.fromJson(responseMap);
    }
  }
}
