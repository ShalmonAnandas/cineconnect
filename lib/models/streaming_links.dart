import 'package:equatable/equatable.dart';

class KDramaStreamingLinks extends Equatable {
  const KDramaStreamingLinks({
    required this.sources,
  });

  final List<Source> sources;

  KDramaStreamingLinks copyWith({
    List<Source>? sources,
  }) {
    return KDramaStreamingLinks(
      sources: sources ?? this.sources,
    );
  }

  factory KDramaStreamingLinks.fromJson(Map<String, dynamic> json) {
    return KDramaStreamingLinks(
      sources: json["sources"] == null
          ? []
          : List<Source>.from(json["sources"]!.map((x) => Source.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "sources": sources.map((x) => x?.toJson()).toList(),
      };

  @override
  String toString() {
    return "$sources, ";
  }

  @override
  List<Object?> get props => [
        sources,
      ];
}

class Source extends Equatable {
  const Source({
    required this.url,
    required this.isM3U8,
  });

  final String? url;
  final bool? isM3U8;

  Source copyWith({
    String? url,
    bool? isM3U8,
  }) {
    return Source(
      url: url ?? this.url,
      isM3U8: isM3U8 ?? this.isM3U8,
    );
  }

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      url: json["url"],
      isM3U8: json["isM3U8"],
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "isM3U8": isM3U8,
      };

  @override
  String toString() {
    return "$url, $isM3U8, ";
  }

  @override
  List<Object?> get props => [
        url,
        isM3U8,
      ];
}
