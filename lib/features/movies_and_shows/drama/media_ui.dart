import 'dart:convert';
import 'dart:ui';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineconnect/custom_error_screen.dart';
import 'package:cineconnect/features/movies_and_shows/drama/episode_select/episode_select.dart';
import 'package:cineconnect/features/movies_and_shows/drama/media_controller.dart';
import 'package:cineconnect/features/readers_and_players/video_player.dart';
import 'package:cineconnect/models/media_details.dart';
import 'package:cineconnect/models/stream_model.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
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
      required this.mediaType,
      this.base64Image,
      required this.provider});

  final String id;
  final String bgImage;
  final String mediaType;
  final String? base64Image;
  final String provider;

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  MediaController mediaController = Get.put(MediaController());
  MediaModel? mediaDetails;
  bool isDownload = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mediaDetails =
          await mediaController.getDramaDetails(widget.id, widget.provider);
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
                image: widget.provider == "dramacool"
                    ? CachedNetworkImageProvider(
                        widget.bgImage,
                      )
                    : CachedMemoryImageProvider(
                        "${widget.provider}_${widget.id}",
                        bytes: base64Decode(
                          widget.base64Image!
                              .replaceAll("data:image/jpeg;base64,", ''),
                        ),
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
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width: MediaQuery.of(context).size.width,
                                  child: widget.provider == "dramacool"
                                      ? CachedNetworkImage(
                                          imageUrl: mediaDetails!.cover!,
                                        )
                                      : Image.memory(
                                          base64Decode(
                                            mediaDetails!.cover!.replaceAll(
                                                "data:image/jpeg;base64,", ''),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 16),
                              child: Text(
                                mediaDetails?.title ?? "",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.bebasNeue(
                                  height: 1,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  shadows: [
                                    const Shadow(
                                      blurRadius: 5,
                                      color: Colors.black,
                                      offset: Offset(1.0, 1.0),
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
                                                    widget.provider,
                                                    mediaDetails!
                                                        .episodes.first.id!,
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
                                                      mediaController.seasons,
                                                  title:
                                                      mediaDetails?.title ?? "",
                                                  controller: mediaController,
                                                  mediaId:
                                                      mediaDetails?.id ?? "",
                                                  provider: widget.provider,
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
                                        onPressed: () async {
                                          StreamModel model =
                                              await mediaController.getStreams(
                                                  widget.provider,
                                                  mediaDetails!
                                                      .episodes.first.id!,
                                                  mediaDetails!.id!);

                                          if (isDownload) {
                                            FFmpegKitConfig
                                                    .selectDocumentForWrite(
                                                        'video.mp4', 'video/*')
                                                .then((uri) {
                                              FFmpegKitConfig
                                                      .getSafParameterForWrite(
                                                          uri!)
                                                  .then((safUrl) {
                                                FFmpegKit.executeAsync(
                                                    "-i ${model.sources.first.url} -c copy -bsf:a aac_adtstoasc ${safUrl}",
                                                    (Session session) async {
                                                  final returnCode =
                                                      await session
                                                          .getReturnCode();

                                                  print(
                                                      "session state  ===== ${await session.getState()}");

                                                  if (ReturnCode.isSuccess(
                                                      returnCode)) {
                                                    print("success");
                                                  } else if (ReturnCode
                                                      .isCancel(returnCode)) {
                                                    print("dailure");
                                                  } else {
                                                    final logs =
                                                        await session.getLogs();
                                                    print(
                                                        "error ${logs.map((element) => element.getMessage().toString())}");
                                                  }
                                                }, (Log log) {
                                                  print(
                                                      "LOGS :::: ${log.getMessage()}");
                                                }, (Statistics statistics) {
                                                  print(
                                                      "STATS ::::: ${statistics.getSize()}");
                                                });
                                              });
                                            });
                                            isDownload = false;
                                          } else {
                                            FFmpegKit.cancel();
                                            isDownload = true;
                                          }
                                          // FFmpegKit.execute(
                                          //         '-i ${model.sources.first.url} -c copy -bsf:a aac_adtstoasc output.mp4')
                                          //     .then((session) async {
                                          //   final returnCode =
                                          //       await session.getReturnCode();

                                          //   if (ReturnCode.isSuccess(
                                          //       returnCode)) {
                                          //     print("success");
                                          //   } else if (ReturnCode.isCancel(
                                          //       returnCode)) {
                                          //     print("dailure");
                                          //   } else {
                                          //     final logs =
                                          //         await session.getLogs();
                                          //     print(
                                          //         "error ${logs.map((element) => element.getMessage().toString())}");
                                          //   }
                                          // });
                                        },
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
                            // MovieSection(
                            //     mediaModel: mediaDetails,
                            //     provider: widget.provider),
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
  const MovieSection(
      {super.key, required this.mediaModel, required this.provider});

  final MediaModel? mediaModel;
  final String provider;

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
        SimilarAndRecommended(
          similar: widget.mediaModel?.recommendations ?? [],
          provider: widget.provider,
        ),
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
          similar: widget.mediaModel?.recommendations ?? [],
          provider: widget.provider,
        ),
      ],
    );
  }
}

class SimilarAndRecommended extends StatefulWidget {
  const SimilarAndRecommended(
      {super.key, required this.similar, required this.provider});

  final List<Recommendation> similar;
  final String provider;

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
                    provider: widget.provider,
                  ),
                ),
              ),
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
