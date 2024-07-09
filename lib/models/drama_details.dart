import 'package:cineconnect/models/subtitle.dart';
import 'package:equatable/equatable.dart';

class DramaDetails extends Equatable {
  const DramaDetails({
    required this.description,
    required this.releaseDate,
    required this.trailer,
    required this.country,
    required this.status,
    required this.type,
    required this.nextEpDateId,
    required this.episodes,
    required this.episodesCount,
    required this.label,
    required this.favoriteId,
    required this.thumbnail,
    required this.id,
    required this.title,
  });

  final String? description;
  final DateTime? releaseDate;
  final String? trailer;
  final String? country;
  final String? status;
  final String? type;
  final int? nextEpDateId;
  final List<Episode> episodes;
  final int? episodesCount;
  final dynamic label;
  final int? favoriteId;
  final String? thumbnail;
  final int? id;
  final String? title;

  DramaDetails copyWith({
    String? description,
    DateTime? releaseDate,
    String? trailer,
    String? country,
    String? status,
    String? type,
    int? nextEpDateId,
    List<Episode>? episodes,
    int? episodesCount,
    dynamic label,
    int? favoriteId,
    String? thumbnail,
    int? id,
    String? title,
  }) {
    return DramaDetails(
      description: description ?? this.description,
      releaseDate: releaseDate ?? this.releaseDate,
      trailer: trailer ?? this.trailer,
      country: country ?? this.country,
      status: status ?? this.status,
      type: type ?? this.type,
      nextEpDateId: nextEpDateId ?? this.nextEpDateId,
      episodes: episodes ?? this.episodes,
      episodesCount: episodesCount ?? this.episodesCount,
      label: label ?? this.label,
      favoriteId: favoriteId ?? this.favoriteId,
      thumbnail: thumbnail ?? this.thumbnail,
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  factory DramaDetails.fromJson(Map<String, dynamic> json) {
    return DramaDetails(
      description: json["description"],
      releaseDate: DateTime.tryParse(json["releaseDate"] ?? ""),
      trailer: json["trailer"],
      country: json["country"],
      status: json["status"],
      type: json["type"],
      nextEpDateId: json["nextEpDateID"],
      episodes: json["episodes"] == null
          ? []
          : List<Episode>.from(
              json["episodes"]!.map((x) => Episode.fromJson(x))),
      episodesCount: json["episodesCount"],
      label: json["label"],
      favoriteId: json["favoriteID"],
      thumbnail: json["thumbnail"],
      id: json["id"],
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "releaseDate": releaseDate?.toIso8601String(),
        "trailer": trailer,
        "country": country,
        "status": status,
        "type": type,
        "nextEpDateID": nextEpDateId,
        "episodes": episodes.map((x) => x.toJson()).toList(),
        "episodesCount": episodesCount,
        "label": label,
        "favoriteID": favoriteId,
        "thumbnail": thumbnail,
        "id": id,
        "title": title,
      };

  @override
  String toString() {
    return "$description, $releaseDate, $trailer, $country, $status, $type, $nextEpDateId, $episodes, $episodesCount, $label, $favoriteId, $thumbnail, $id, $title, ";
  }

  @override
  List<Object?> get props => [
        description,
        releaseDate,
        trailer,
        country,
        status,
        type,
        nextEpDateId,
        episodes,
        episodesCount,
        label,
        favoriteId,
        thumbnail,
        id,
        title,
      ];
}

// ignore: must_be_immutable
class Episode extends Equatable {
  Episode({
    required this.id,
    required this.number,
    required this.sub,
  });

  final int? id;
  final double? number;
  final int? sub;

  Episode copyWith({
    int? id,
    double? number,
    int? sub,
  }) {
    return Episode(
      id: id ?? this.id,
      number: number ?? this.number,
      sub: sub ?? this.sub,
    );
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json["id"],
      number: json["number"],
      sub: json["sub"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "sub": sub,
      };

  @override
  String toString() {
    return "$id, $number, $sub, ";
  }

  @override
  List<Object?> get props => [
        id,
        number,
        sub,
      ];
}
