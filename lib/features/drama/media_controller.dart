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

  Future<MediaModel> getDramaDetails(String id, String provider) async {
    isLoading.value = true;
    String fetchKey = "media_details_${id}_$provider";

    var box = await Hive.openBox('mediaBox');

    var mediaDetails = box.get(fetchKey);

    if (mediaDetails != null && jsonDecode(mediaDetails)["statusCode"] != 500) {
      dramaDetails = MediaModel.fromJson(jsonDecode(mediaDetails));
    } else {
      String response = await APIHandler().sendRequest(
          APIConstants.dramaDetailsUrl(provider: provider, dramaID: id));

      Map<String, dynamic> updatedResponse = jsonDecode(response);

      updatedResponse["recommendations"] = [];

      dramaDetails = MediaModel.fromJson(updatedResponse);
      box.put(fetchKey, updatedResponse);
    }
    isLoading.value = false;
    return dramaDetails!;
  }

  Future<StreamModel> getStreams(String episodeID, String mediaID) async {
    DateTime today = DateTime.now();
    String fetchKeyDate = "${today.day}_${today.month}_${today.year}";
    String fetchKey =
        "stream_detailsModel_${episodeID}_${mediaID}_$fetchKeyDate";

    var box = await Hive.openBox('streamsBox');

    var streamDetails = box.get(fetchKey);

    if (streamDetails != null) {
      return StreamModel.fromJson(jsonDecode(streamDetails));
    } else {
      final response = await APIHandler().sendRequest(
          APIConstants.streamUrl(episodeID: episodeID, dramaID: mediaID));
      Map<String, dynamic> responseMap = jsonDecode(response);
      box.put(fetchKey, response);
      return StreamModel.fromJson(responseMap);
    }
  }
}
