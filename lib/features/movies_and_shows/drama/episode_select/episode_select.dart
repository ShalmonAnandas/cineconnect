import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cineconnect/features/movies_and_shows/drama/media_controller.dart';
import 'package:cineconnect/features/readers_and_players/video_player.dart';
import 'package:cineconnect/features/movies_and_shows/drama/media_ui.dart';
import 'package:cineconnect/models/media_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EpisodeSelect extends StatefulWidget {
  const EpisodeSelect(
      {super.key,
      required this.seasons,
      required this.title,
      required this.controller,
      required this.mediaId,
      required this.provider});

  final List<List<Episode>> seasons;
  final String title;
  final MediaController controller;
  final String mediaId;
  final String provider;

  @override
  State<EpisodeSelect> createState() => _EpisodeSelectState();
}

class _EpisodeSelectState extends State<EpisodeSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: DefaultTabController(
        length: widget.seasons.length,
        child: Column(
          children: [
            ButtonsTabBar(
              labelStyle: GoogleFonts.quicksand(
                  color: Colors.white, fontWeight: FontWeight.bold),
              unselectedLabelStyle: GoogleFonts.quicksand(
                  color: Colors.white, fontWeight: FontWeight.bold),
              backgroundColor: Theme.of(context).highlightColor,
              unselectedBorderColor: Theme.of(context).highlightColor,
              borderWidth: 1,
              borderColor: Theme.of(context).highlightColor,
              unselectedBackgroundColor: Colors.transparent,
              tabs: widget.seasons
                  .map(
                    (element) => Tab(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Season ${element.first.season}",
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                  children: widget.seasons.map((season) {
                return ListView.builder(
                  itemCount: season.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  const FetchingLinkBottomSheet());
                          widget.controller
                              .getStreams(widget.provider,
                                  season[index].id.toString(), widget.mediaId)
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
                                builder: (context) => VideoPlayer(
                                  streamModel: streamModel,
                                ),
                              ),
                            ).then((val) {
                              SystemChrome
                                  .setPreferredOrientations(<DeviceOrientation>[
                                DeviceOrientation.portraitUp,
                              ]);
                              SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.manual,
                                  overlays: SystemUiOverlay.values);
                            });
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.09),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          50,
                                        ),
                                      ),
                                      child: const Center(
                                          child: Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.teal,
                                      )),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black,
                                        ],
                                        stops: [0, 0.7],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.35,
                                            child: Text(
                                              season[index].title.toString(),
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    );
                  },
                );
              }).toList()),
            ),
          ],
        ),
      ),
    );
  }
}
