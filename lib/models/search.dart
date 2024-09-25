import 'package:equatable/equatable.dart';

class Search extends Equatable {
  Search({
    required this.backdropPath,
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.adult,
    required this.originalLanguage,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.firstAirDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.originCountry,
  });

  final String? backdropPath;
  final int? id;
  final String? title;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final String? mediaType;
  final bool? adult;
  final String? originalLanguage;
  final List<int> genreIds;
  final double? popularity;
  final DateTime? releaseDate;
  final DateTime? firstAirDate;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;
  final List<String> originCountry;

  Search copyWith({
    String? backdropPath,
    int? id,
    String? title,
    String? originalTitle,
    String? overview,
    String? posterPath,
    String? mediaType,
    bool? adult,
    String? originalLanguage,
    List<int>? genreIds,
    double? popularity,
    DateTime? releaseDate,
    DateTime? firstAirDate,
    bool? video,
    double? voteAverage,
    int? voteCount,
    List<String>? originCountry,
  }) {
    return Search(
      backdropPath: backdropPath ?? this.backdropPath,
      id: id ?? this.id,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      mediaType: mediaType ?? this.mediaType,
      adult: adult ?? this.adult,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      genreIds: genreIds ?? this.genreIds,
      popularity: popularity ?? this.popularity,
      releaseDate: releaseDate ?? this.releaseDate,
      firstAirDate: firstAirDate ?? this.firstAirDate,
      video: video ?? this.video,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      originCountry: originCountry ?? this.originCountry,
    );
  }

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      backdropPath:
          "https://image.tmdb.org/t/p/original${json["backdrop_path"]}",
      id: json["id"],
      title: json["title"] ?? json["name"] ?? "",
      originalTitle: json["original_title"] ?? json["original_name"] ?? "",
      overview: json["overview"],
      posterPath: "https://image.tmdb.org/t/p/original${json["poster_path"]}",
      mediaType: json["media_type"],
      adult: json["adult"],
      originalLanguage: json["original_language"],
      genreIds: json["genre_ids"] == null
          ? []
          : List<int>.from(json["genre_ids"]!.map((x) => x)),
      popularity: json["popularity"],
      releaseDate: DateTime.tryParse(json["release_date"] ?? ""),
      firstAirDate: DateTime.tryParse(json["first_air_date"] ?? ""),
      video: json["video"],
      voteAverage: json["vote_average"],
      voteCount: json["vote_count"],
      originCountry: json["origin_country"] == null
          ? []
          : List<String>.from(json["origin_country"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "id": id,
        "title": title,
        "original_title": originalTitle,
        "overview": overview,
        "poster_path": posterPath,
        "media_type": mediaType,
        "adult": adult,
        "original_language": originalLanguage,
        "genre_ids": genreIds.map((x) => x).toList(),
        "popularity": popularity,
        "release_date":
            "${releaseDate?.year.toString().padLeft(4, '0')}-${releaseDate?.month.toString().padLeft(2, '0')}-${releaseDate?.day.toString().padLeft(2, '0')}",
        "first_air_date":
            "${firstAirDate?.year.toString().padLeft(4, '0')}-${firstAirDate?.month.toString().padLeft(2, '0')}-${firstAirDate?.day.toString().padLeft(2, '0')}",
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "origin_country": originCountry.map((x) => x).toList(),
      };

  @override
  String toString() {
    return "$backdropPath, $id, $title, $originalTitle, $overview, $posterPath, $mediaType, $adult, $originalLanguage, $genreIds, $popularity, $releaseDate, $firstAirDate, $video, $voteAverage, $voteCount, $originCountry, ";
  }

  @override
  List<Object?> get props => [
        backdropPath,
        id,
        title,
        originalTitle,
        overview,
        posterPath,
        mediaType,
        adult,
        originalLanguage,
        genreIds,
        popularity,
        releaseDate,
        firstAirDate,
        video,
        voteAverage,
        voteCount,
        originCountry,
      ];
}
