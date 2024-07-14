import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineconnect/custom_error_screen.dart';
import 'package:cineconnect/features/drama/episode_select/episode_select.dart';
import 'package:cineconnect/features/drama/media_controller.dart';
import 'package:cineconnect/features/video_player/video_player.dart';
import 'package:cineconnect/models/media_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen(
      {super.key,
      required this.id,
      required this.bgImage,
      required this.mediaType});

  final String id;
  final String bgImage;
  final String mediaType;

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  MediaController mediaController = Get.put(MediaController());
  MediaModel? mediaDetails;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mediaDetails =
          await mediaController.getDramaDetails(widget.id, widget.mediaType);
    });

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
                image: CachedNetworkImageProvider(
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
            () => mediaController.isLoading.value
                ? Center(
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Lottie.asset("assets/cat_loader.json")),
                  )
                : mediaDetails?.title == null
                    ? const CustomErrorScreenInFlutter(errorDetails: "")
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      width: MediaQuery.of(context).size.width,
                                      child: CachedNetworkImage(
                                        imageUrl: mediaDetails?.cover ?? "",
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Container(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16, top: 16),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: CachedNetworkImage(
                                            imageUrl: mediaDetails
                                                        ?.logos.isNotEmpty ??
                                                    false
                                                ? mediaDetails
                                                        ?.logos.first.url ??
                                                    ""
                                                : "",
                                            errorWidget: (context, url, error) {
                                              return Text(
                                                mediaDetails?.title ?? "",
                                                style: GoogleFonts.bebasNeue(
                                                  height: 1,
                                                  fontSize: 72,
                                                  fontWeight: FontWeight.w800,
                                                  shadows: [
                                                    const Shadow(
                                                      blurRadius: 5,
                                                      color: Colors.black,
                                                      offset: Offset(1.0, 1.0),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 16, 8, 8),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (widget.mediaType
                                              .toLowerCase()
                                              .contains("movie")) {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    const FetchingLinkBottomSheet());
                                            mediaController
                                                .getStreams(
                                                    mediaDetails!.episodeId!,
                                                    mediaDetails!.id!)
                                                .then((streamModel) {
                                              Navigator.pop(context);
                                              SystemChrome
                                                  .setPreferredOrientations(<DeviceOrientation>[
                                                DeviceOrientation.landscapeLeft,
                                                DeviceOrientation.landscapeRight
                                              ]);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPlayer(
                                                    streamModel: streamModel,
                                                  ),
                                                ),
                                              ).then((val) {
                                                SystemChrome
                                                    .setPreferredOrientations(<DeviceOrientation>[
                                                  DeviceOrientation.portraitUp,
                                                ]);
                                                SystemChrome
                                                    .setEnabledSystemUIMode(
                                                        SystemUiMode.manual,
                                                        overlays:
                                                            SystemUiOverlay
                                                                .values);
                                              });
                                            });
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EpisodeSelect(
                                                  seasons:
                                                      mediaDetails?.seasons ??
                                                          [],
                                                  title:
                                                      mediaDetails?.title ?? "",
                                                  controller: mediaController,
                                                  mediaId:
                                                      mediaDetails?.id ?? "",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.white,
                                              ),
                                              child: Icon(
                                                Icons.play_arrow_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            Text(
                                              "Watch now",
                                              style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 16, 16, 8),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: OutlinedButton(
                                        onPressed: () {},
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: Text(
                                          "Download",
                                          style: GoogleFonts.quicksand(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              enableFeedback: false,
                              initiallyExpanded: true,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Text(
                                    mediaDetails?.description ?? "",
                                    style: GoogleFonts.quicksand(fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            MovieSection(mediaModel: mediaDetails),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class MovieSection extends StatefulWidget {
  const MovieSection({super.key, required this.mediaModel});

  final MediaModel? mediaModel;

  @override
  State<MovieSection> createState() => _MovieSectionState();
}

class _MovieSectionState extends State<MovieSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            "Similar",
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SimilarAndRecommended(similar: widget.mediaModel?.similar ?? []),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            "Recommended",
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SimilarAndRecommended(
            similar: widget.mediaModel?.recommendations ?? []),
      ],
    );
  }
}

class SimilarAndRecommended extends StatefulWidget {
  const SimilarAndRecommended({super.key, required this.similar});

  final List<Recommendation> similar;

  @override
  State<SimilarAndRecommended> createState() => _SimilarAndRecommendedState();
}

class _SimilarAndRecommendedState extends State<SimilarAndRecommended> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.similar.length,
        itemBuilder: (context, index) {
          double firstPadding = index == 0 ? 16.0 : 8;
          double lastPadding = index == widget.similar.length - 1 ? 16.0 : 8;
          return Padding(
            padding: EdgeInsets.fromLTRB(firstPadding, 0, lastPadding, 0),
            child: InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MediaScreen(
                            id: widget.similar[index].id.toString(),
                            mediaType: widget.similar[index].type!,
                            bgImage: widget.similar[index].image!,
                          ))),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.similar[index].image!,
                    ),
                    onError: (exception, stackTrace) => const AssetImage(
                      "assets/default_poster.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FetchingLinkBottomSheet extends StatelessWidget {
  const FetchingLinkBottomSheet({super.key});

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