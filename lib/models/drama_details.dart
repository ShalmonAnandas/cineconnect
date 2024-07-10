import 'package:equatable/equatable.dart';

class DramaDetails extends Equatable {
  const DramaDetails({
    required this.id,
    required this.title,
    required this.status,
    required this.genres,
    required this.otherNames,
    required this.image,
    required this.description,
    required this.releaseDate,
    required this.episodes,
  });

  final String? id;
  final String? title;
  final String? status;
  final List<String> genres;
  final List<String> otherNames;
  final String? image;
  final String? description;
  final String? releaseDate;
  final List<Episode> episodes;

  DramaDetails copyWith({
    String? id,
    String? title,
    String? status,
    List<String>? genres,
    List<String>? otherNames,
    String? image,
    String? description,
    String? releaseDate,
    List<Episode>? episodes,
  }) {
    return DramaDetails(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      genres: genres ?? this.genres,
      otherNames: otherNames ?? this.otherNames,
      image: image ?? this.image,
      description: description ?? this.description,
      releaseDate: releaseDate ?? this.releaseDate,
      episodes: episodes ?? this.episodes,
    );
  }

  factory DramaDetails.fromJson(Map<String, dynamic> json) {
    return DramaDetails(
      id: json["id"],
      title: json["title"],
      status: json["status"],
      genres: json["genres"] == null
          ? []
          : List<String>.from(json["genres"]!.map((x) => x)),
      otherNames: json["otherNames"] == null
          ? []
          : List<String>.from(json["otherNames"]!.map((x) => x)),
      image: json["image"],
      description: json["description"],
      releaseDate: json["releaseDate"],
      episodes: json["episodes"] == null
          ? []
          : List<Episode>.from(
              json["episodes"]!.map((x) => Episode.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "genres": genres.map((x) => x).toList(),
        "otherNames": otherNames.map((x) => x).toList(),
        "image": image,
        "description": description,
        "releaseDate": releaseDate,
        "episodes": episodes.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$id, $title, $status, $genres, $otherNames, $image, $description, $releaseDate, $episodes, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        status,
        genres,
        otherNames,
        image,
        description,
        releaseDate,
        episodes,
      ];
}

class Episode extends Equatable {
  const Episode({
    required this.id,
    required this.title,
    required this.episode,
    required this.subType,
    required this.releaseDate,
    required this.url,
  });

  final String? id;
  final String? title;
  final double? episode;
  final String? subType;
  final DateTime? releaseDate;
  final String? url;

  Episode copyWith({
    String? id,
    String? title,
    double? episode,
    String? subType,
    DateTime? releaseDate,
    String? url,
  }) {
    return Episode(
      id: id ?? this.id,
      title: title ?? this.title,
      episode: episode ?? this.episode,
      subType: subType ?? this.subType,
      releaseDate: releaseDate ?? this.releaseDate,
      url: url ?? this.url,
    );
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json["id"],
      title: json["title"],
      episode: double.parse(json["episode"].toString()),
      subType: json["subType"],
      releaseDate: DateTime.tryParse(json["releaseDate"] ?? ""),
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "episode": episode,
        "subType": subType,
        "releaseDate": releaseDate?.toIso8601String(),
        "url": url,
      };

  @override
  String toString() {
    return "$id, $title, $episode, $subType, $releaseDate, $url, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        episode,
        subType,
        releaseDate,
        url,
      ];
}
