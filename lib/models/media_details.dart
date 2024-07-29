import 'package:equatable/equatable.dart';

class MediaModel extends Equatable {
  const MediaModel({
    required this.id,
    required this.title,
    required this.url,
    required this.cover,
    required this.image,
    required this.description,
    required this.type,
    required this.releaseDate,
    required this.genres,
    required this.casts,
    required this.tags,
    required this.production,
    required this.country,
    required this.duration,
    required this.rating,
    required this.recommendations,
    required this.episodes,
  });

  final String? id;
  final String? title;
  final String? url;
  final String? cover;
  final String? image;
  final String? description;
  final String? type;
  final DateTime? releaseDate;
  final List<String> genres;
  final List<String> casts;
  final List<String> tags;
  final String? production;
  final String? country;
  final String? duration;
  final String? rating;
  final List<Recommendation> recommendations;
  final List<Episode> episodes;

  MediaModel copyWith({
    String? id,
    String? title,
    String? url,
    String? cover,
    String? image,
    String? description,
    String? type,
    DateTime? releaseDate,
    List<String>? genres,
    List<String>? casts,
    List<String>? tags,
    String? production,
    String? country,
    String? duration,
    String? rating,
    List<Recommendation>? recommendations,
    List<Episode>? episodes,
  }) {
    return MediaModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      cover: cover ?? this.cover,
      image: image ?? this.image,
      description: description ?? this.description,
      type: type ?? this.type,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      casts: casts ?? this.casts,
      tags: tags ?? this.tags,
      production: production ?? this.production,
      country: country ?? this.country,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      recommendations: recommendations ?? this.recommendations,
      episodes: episodes ?? this.episodes,
    );
  }

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json["id"],
      title: json["title"],
      url: json["url"],
      cover: json["cover"],
      image: json["image"],
      description: json["description"],
      type: json["type"],
      releaseDate: DateTime.tryParse(json["releaseDate"] ?? ""),
      genres: json["genres"] == null
          ? []
          : List<String>.from(json["genres"]!.map((x) => x)),
      casts: json["casts"] == null
          ? []
          : List<String>.from(json["casts"]!.map((x) => x)),
      tags: json["tags"] == null
          ? []
          : List<String>.from(json["tags"]!.map((x) => x)),
      production: json["production"],
      country: json["country"].toString(),
      duration: json["duration"],
      rating: json["rating"].toString(),
      recommendations: json["recommendations"] == null
          ? []
          : List<Recommendation>.from(
              json["recommendations"]!.map((x) => Recommendation.fromJson(x))),
      episodes: json["episodes"] == null
          ? []
          : List<Episode>.from(
              json["episodes"]!.map((x) => Episode.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url": url,
        "cover": cover,
        "image": image,
        "description": description,
        "type": type,
        "releaseDate":
            "${releaseDate!.year.toString().padLeft(4)}-${releaseDate!.month.toString().padLeft(2)}-${releaseDate!.day.toString().padLeft(2)}",
        "genres": genres.map((x) => x).toList(),
        "casts": casts.map((x) => x).toList(),
        "tags": tags.map((x) => x).toList(),
        "production": production,
        "country": country,
        "duration": duration,
        "rating": rating,
        "recommendations": recommendations.map((x) => x.toJson()).toList(),
        "episodes": episodes.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$id, $title, $url, $cover, $image, $description, $type, $releaseDate, $genres, $casts, $tags, $production, $country, $duration, $rating, $recommendations, $episodes, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        url,
        cover,
        image,
        description,
        type,
        releaseDate,
        genres,
        casts,
        tags,
        production,
        country,
        duration,
        rating,
        recommendations,
        episodes,
      ];
}

class Episode extends Equatable {
  const Episode({
    required this.id,
    required this.title,
    required this.number,
    required this.season,
    required this.url,
  });

  final String? id;
  final String? title;
  final int? number;
  final int? season;
  final String? url;

  Episode copyWith({
    String? id,
    String? title,
    int? number,
    int? season,
    String? url,
  }) {
    return Episode(
      id: id ?? this.id,
      title: title ?? this.title,
      number: number ?? this.number,
      season: season ?? this.season,
      url: url ?? this.url,
    );
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json["id"],
      title: json["title"],
      number: json["number"],
      season: json["season"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "number": number,
        "season": season,
        "url": url,
      };

  @override
  String toString() {
    return "$id, $title, $number, $season, $url, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        number,
        season,
        url,
      ];
}

class Recommendation extends Equatable {
  const Recommendation({
    required this.id,
    required this.title,
    required this.image,
    required this.duration,
    required this.type,
  });

  final String? id;
  final String? title;
  final String? image;
  final String? duration;
  final String? type;

  Recommendation copyWith({
    String? id,
    String? title,
    String? image,
    String? duration,
    String? type,
  }) {
    return Recommendation(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      duration: duration ?? this.duration,
      type: type ?? this.type,
    );
  }

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json["id"],
      title: json["title"],
      image: json["image"],
      duration: json["duration"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "duration": duration,
        "type": type,
      };

  @override
  String toString() {
    return "$id, $title, $image, $duration, $type, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        image,
        duration,
        type,
      ];
}
