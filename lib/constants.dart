import 'package:cineconnect/features/drama/drama_controller.dart';
import 'package:cineconnect/features/search/search_controller.dart';
import 'package:get/get.dart';

class AppConstants {
  //controllers
  static DramaController dramaController = Get.put(DramaController());
  static KDramaSearchController searchController =
      Get.put(KDramaSearchController());
}
