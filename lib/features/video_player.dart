// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:cineconnect/networking/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:srt_parser_2/srt_parser_2.dart' as srt;

class VideoPlayer extends StatefulWidget {
  const VideoPlayer(
      {super.key, required this.videoUrl, required this.subtitleUrl});

  final String videoUrl;
  final String subtitleUrl;
  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  Subtitles? _subtitles;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer(widget.videoUrl);
    if (widget.subtitleUrl != "") {
      _loadSubtitles(widget.subtitleUrl);
    }
  }

  Future<void> _initializeVideoPlayer(String videoUrl) async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      httpHeaders: const {
        "User-Agent":
            "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Mobile Safari/537.36 EdgA/115.0.1901.196"
      },
    );

    await _videoPlayerController!.initialize();

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: true,
        subtitle: _subtitles,
        allowFullScreen: false,
        hideControlsTimer: const Duration(milliseconds: 1500),
        // fullScreenByDefault: true,
        subtitleBuilder: (context, subtitle) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                shadows: [
                  Shadow(
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

  List<srt.Subtitle> parseSrt(String srtData) {
    final List<srt.Subtitle> result = [];

    final List<String> split = srt.splitIntoLines(srtData);
    final List<List<String>> splitChunk = srt.splitByEmptyLine(split);

    splitChunk.removeWhere((chunk) => chunk == []);

    for (List<String> chunk in splitChunk) {
      try {
        final range = srt.parseBeginEnd(chunk[1]);
        if (range == null) continue;
        final srt.Subtitle subtitle = srt.Subtitle(
          id: int.parse(chunk[0]),
          range: range,
          rawLines: chunk.sublist(2),
        );
        result.add(subtitle);
      } catch (e, s) {
        log(e.toString());
        log(s.toString());
        log(chunk.toString());
        log(splitChunk.indexOf(chunk).toString());
      }
    }

    return result;
  }

  Future<void> _loadSubtitles(String subtitleUrl) async {
    final srtContent = await APIHandler().sendRequest(subtitleUrl);

    final srtSubtitles = parseSrt(srtContent);

    final subtitles = srtSubtitles.map((srtSubtitle) {
      return Subtitle(
        index: srtSubtitle.id,
        start: Duration(milliseconds: srtSubtitle.range.begin),
        end: Duration(milliseconds: srtSubtitle.range.end),
        text: srtSubtitle.rawLines.join("\n"),
      );
    }).toList();

    setState(() {
      _subtitles = Subtitles(subtitles);
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to stop watching?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized
        ? Material(
            color: Colors.black,
            child: Theme(
              data: ThemeData.dark().copyWith(
                platform: TargetPlatform.iOS,
              ),
              child: Chewie(
                controller: _chewieController!,
              ),
            ),
          )
        : Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: Lottie.asset("assets/video_load_anim.json"),
            ),
          );
  }
}
