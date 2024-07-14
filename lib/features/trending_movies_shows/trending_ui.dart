import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineconnect/features/drama/media_ui.dart';
import 'package:cineconnect/features/trending_movies_shows/trending_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  TrendingController controller = Get.put(TrendingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Trending",
          style: GoogleFonts.quicksand(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const SizedBox()
            : GridView.builder(
                itemCount: controller.trendingResults!.results.length,
                itemBuilder: (context, index) {
                  double leftPadding = index % 2 == 0 ? 16 : 8;
                  double rightPadding = index % 2 != 0 ? 16 : 8;
                  return Padding(
                    padding:
                        EdgeInsets.fromLTRB(leftPadding, 8, rightPadding, 8),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            errorWidget: (context, string, obj) => Image.asset(
                              "assets/default_poster.jpg",
                              fit: BoxFit.cover,
                            ),
                            fadeInDuration: const Duration(milliseconds: 100),
                            imageUrl: controller
                                .trendingResults!.results[index].image!,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            controller.trendingResults!.results[index].title ??
                                "",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              splashFactory: InkRipple.splashFactory,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MediaScreen(
                                    id: controller
                                        .trendingResults!.results[index].id!,
                                    bgImage: controller
                                        .trendingResults!.results[index].image!,
                                    mediaType: controller
                                        .trendingResults!.results[index].type!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.7,
                  crossAxisCount: 2,
                ),
              ),
      ),
    );
  }
}
