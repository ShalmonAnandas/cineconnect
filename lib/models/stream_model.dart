import 'package:equatable/equatable.dart';

class StreamModel extends Equatable {
  const StreamModel({
    required this.headers,
    required this.sources,
    required this.subtitles,
  });

  final Headers? headers;
  final List<Source> sources;
  final List<SubtitleLinks> subtitles;

  StreamModel copyWith({
    Headers? headers,
    List<Source>? sources,
    List<SubtitleLinks>? subtitles,
  }) {
    return StreamModel(
      headers: headers ?? this.headers,
      sources: sources ?? this.sources,
      subtitles: subtitles ?? this.subtitles,
    );
  }

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      headers:
          json["headers"] == null ? null : Headers.fromJson(json["headers"]),
      sources: json["sources"] == null
          ? []
          : List<Source>.from(json["sources"]!.map((x) => Source.fromJson(x))),
      subtitles: json["subtitles"] == null
          ? []
          : List<SubtitleLinks>.from(
              json["subtitles"]!.map((x) => SubtitleLinks.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "headers": headers?.toJson(),
        "sources": sources.map((x) => x.toJson()).toList(),
        "subtitles": subtitles.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$headers, $sources, $subtitles, ";
  }

  @override
  List<Object?> get props => [
        headers,
        sources,
        subtitles,
      ];
}

class Headers extends Equatable {
  const Headers({
    required this.referer,
  });

  final String? referer;

  Headers copyWith({
    String? referer,
  }) {
    return Headers(
      referer: referer ?? this.referer,
    );
  }

  factory Headers.fromJson(Map<String, dynamic> json) {
    return Headers(
      referer: json["Referer"],
    );
  }

  Map<String, dynamic> toJson() => {
        "Referer": referer,
      };

  @override
  String toString() {
    return "$referer, ";
  }

  @override
  List<Object?> get props => [
        referer,
      ];
}

class Source extends Equatable {
  const Source({
    required this.url,
    required this.quality,
    required this.isM3U8,
  });

  final String? url;
  final String? quality;
  final bool? isM3U8;

  Source copyWith({
    String? url,
    String? quality,
    bool? isM3U8,
  }) {
    return Source(
      url: url ?? this.url,
      quality: quality ?? this.quality,
      isM3U8: isM3U8 ?? this.isM3U8,
    );
  }

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      url: json["url"],
      quality: json["quality"],
      isM3U8: json["isM3U8"],
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "quality": quality,
        "isM3U8": isM3U8,
      };

  @override
  String toString() {
    return "$url, $quality, $isM3U8, ";
  }

  @override
  List<Object?> get props => [
        url,
        quality,
        isM3U8,
      ];
}

class SubtitleLinks extends Equatable {
  const SubtitleLinks({
    required this.url,
    required this.lang,
  });

  final String? url;
  final String? lang;

  SubtitleLinks copyWith({
    String? url,
    String? lang,
  }) {
    return SubtitleLinks(
      url: url ?? this.url,
      lang: lang ?? this.lang,
    );
  }

  factory SubtitleLinks.fromJson(Map<String, dynamic> json) {
    return SubtitleLinks(
      url: json["url"],
      lang: json["lang"],
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "lang": lang,
      };

  @override
  String toString() {
    return "$url, $lang, ";
  }

  @override
  List<Object?> get props => [
        url,
        lang,
      ];
}
