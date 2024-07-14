import 'package:chewie/chewie.dart';
import 'package:cineconnect/models/stream_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:subtitle/subtitle.dart' as st;
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    super.key,
    required this.streamModel,
  });

  final StreamModel streamModel;
  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  st.SubtitleController? subtitleController;
  Subtitles? _subtitles;
  String? referer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    referer = widget.streamModel.headers?.referer ?? "";
    if (widget.streamModel.subtitles.isNotEmpty) {
      _loadSubtitles(widget.streamModel.subtitles
          .where((element) => element.lang!.contains("English"))
          .first
          .url!);
    } else {
      _initializeVideoPlayer(widget.streamModel.sources.first.url!);
    }
  }

  Future<void> _initializeVideoPlayer(String videoUrl) async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      httpHeaders: {
        "User-Agent":
            "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Mobile Safari/537.36 EdgA/115.0.1901.196",
        "Referrer": referer!,
      },
    );

    await _videoPlayerController!.initialize();

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        autoPlay: true,
        subtitle: _subtitles,
        allowFullScreen: false,
        hideControlsTimer: const Duration(milliseconds: 1500),
        zoomAndPan: true,
        // fullScreenByDefault: true,
        subtitleBuilder: (context, subtitle) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              subtitle,
              style: GoogleFonts.quicksand(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                shadows: [
                  const Shadow(
                    blurRadius: 2.0,
                    color: Colors.black,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Future<void> _loadSubtitles(String subtitleUrl) async {
    final url = Uri.parse(subtitleUrl);

    subtitleController = st.SubtitleController(
        provider: st.NetworkSubtitle(url, type: st.SubtitleType.vtt));

    await subtitleController!.initial();

    final subtitles = subtitleController!.subtitles.map((element) {
      return Subtitle(
          index: element.index,
          start: element.start,
          end: element.end,
          text: element.data);
    }).toList();

    setState(() {
      _subtitles = Subtitles(subtitles);
      _initializeVideoPlayer(widget.streamModel.sources[0].url!);
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized
        ? Material(
            color: Colors.black,
            child: Chewie(
              controller: _chewieController!,
            ),
          )
        : Material(
            color: Colors.black,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Lottie.asset("assets/video_load_anim.json"),
              ),
            ),
          );
  }
}
