import 'dart:ui';

import 'package:cineconnect/features/drama/drama_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class DramaScreen extends StatefulWidget {
  const DramaScreen({super.key, required this.id, required this.bgImage});

  final int id;
  final String bgImage;
  @override
  State<DramaScreen> createState() => _DramaScreenState();
}

class _DramaScreenState extends State<DramaScreen> {
  DramaController controller = Get.put(DramaController());

  @override
  void initState() {
    controller.getDramaDetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
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
                  stops: [0.1, 0.9],
                ),
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.white,
                )),
          ),
          body: Obx(
            () => controller.isLoading.value
                ? Shimmer.fromColors(
                    baseColor: Colors.black,
                    highlightColor: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.withOpacity(0.1),
                                    ),
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.withOpacity(0.1),
                                    ),
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black38, blurRadius: 24)
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                controller.dramaDetails!.thumbnail!,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Text(
                            controller.dramaDetails!.title!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ExpansionTile(
                            shape: const RoundedRectangleBorder(
                                side: BorderSide.none),
                            title: Text(
                              "Synopsis",
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Text(
                                  controller.dramaDetails!.description!,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: controller.dramaDetails!.episodes.reversed
                              .map((episode) {
                            return InkWell(
                              onTap: () {},
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      "Episode ${episode.number!.toInt().toString()}",
                                      style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (episode.sub != 0)
                                      Container(
                                        margin: const EdgeInsets.only(left: 16),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.black.withOpacity(0.3),
                                        ),
                                        child: Text(
                                          "Subs Available",
                                          style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                trailing: const Icon(Icons.play_arrow),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
