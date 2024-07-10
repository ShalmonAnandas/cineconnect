import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineconnect/constants.dart';
import 'package:cineconnect/features/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class DramaScreen extends StatefulWidget {
  const DramaScreen({super.key, required this.id, required this.bgImage});

  final String id;
  final String bgImage;

  @override
  State<DramaScreen> createState() => _DramaScreenState();
}

class _DramaScreenState extends State<DramaScreen> {
  @override
  void initState() {
    AppConstants.dramaController.getDramaDetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  widget.bgImage,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => AppConstants.dramaController.isLoading.value
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 70.0),
                        child: Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.grey,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 70.0),
                          child: Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    AppConstants
                                        .dramaController.dramaDetails!.image!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 24,
                                    spreadRadius: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        ExpansionTile(
                          enableFeedback: false,
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              side: BorderSide.none),
                          title: Text(
                            "Synopsis",
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                AppConstants
                                    .dramaController.dramaDetails!.description!,
                                style: GoogleFonts.quicksand(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: AppConstants
                              .dramaController.dramaDetails!.episodes.length,
                          itemBuilder: (context, index) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isDismissible: false,
                                      builder: (context) =>
                                          const BottomSheet());
                                  AppConstants.dramaController
                                      .fetchStreamingLink(
                                          AppConstants.dramaController
                                              .dramaDetails!.id!,
                                          AppConstants
                                              .dramaController
                                              .dramaDetails!
                                              .episodes[index]
                                              .id!)
                                      .then((linkModel) {
                                    Navigator.pop(context);
                                    if (linkModel != null) {
                                      SystemChrome.setPreferredOrientations([
                                        DeviceOrientation.landscapeRight,
                                        DeviceOrientation.landscapeLeft,
                                      ]);
                                      SystemChrome.setEnabledSystemUIMode(
                                          SystemUiMode.leanBack);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoPlayer(
                                              videoUrl:
                                                  linkModel.sources[0].url!,
                                              subtitleUrl: ""),
                                        ),
                                      ).then((val) {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.portraitUp,
                                        ]);
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "No Streaming Link Found",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  });
                                },
                                child: ListTile(
                                  title: Text(AppConstants.dramaController
                                      .dramaDetails!.episodes[index].title!),
                                  trailing: const Icon(Icons.play_arrow),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/ghost_searching.json"),
          Text("Searching for Streaming Link", style: GoogleFonts.quicksand()),
        ],
      ),
    );
  }
}
