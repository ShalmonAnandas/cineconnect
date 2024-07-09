import 'dart:convert';

import 'package:cineconnect/features/drama/drama_ui.dart';
import 'package:cineconnect/models/drama_details.dart';
import 'package:cineconnect/models/subtitle.dart';
import 'package:cineconnect/networking/api_constants.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DramaController extends GetxController {
  RxBool isLoading = false.obs;
  DramaDetails? dramaDetails;

  void getDramaDetails(int id) async {
    dramaDetails = null;
    isLoading.value = true;
    String response = await APIHandler()
        .sendRequest(APIConstants.dramaDetailsUrl(dramaID: id));

    dramaDetails = DramaDetails.fromJson(jsonDecode(response));

    isLoading.value = false;
  }
}
