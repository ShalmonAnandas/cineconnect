import 'package:equatable/equatable.dart';

class MediaModel extends Equatable {
  const MediaModel({
    required this.id,
    required this.title,
    required this.episodeId,
    required this.translations,
    required this.image,
    required this.cover,
    required this.logos,
    required this.type,
    required this.rating,
    required this.releaseDate,
    required this.description,
    required this.genres,
    required this.totalEpisodes,
    required this.totalSeasons,
    required this.directors,
    required this.writers,
    required this.actors,
    required this.trailer,
    required this.mappings,
    required this.similar,
    required this.recommendations,
    required this.seasons,
  });

  final String? id;
  final String? title;
  final String? episodeId;
  final List<Translation> translations;
  final String? image;
  final String? cover;
  final List<Logo> logos;
  final String? type;
  final double? rating;
  final DateTime? releaseDate;
  final String? description;
  final List<String> genres;
  final int? totalEpisodes;
  final int? totalSeasons;
  final List<dynamic> directors;
  final List<dynamic> writers;
  final List<String> actors;
  final Trailer? trailer;
  final Mappings? mappings;
  final List<Recommendation> similar;
  final List<Recommendation> recommendations;
  final List<Season> seasons;

  MediaModel copyWith({
    String? id,
    String? title,
    String? episodeId,
    List<Translation>? translations,
    String? image,
    String? cover,
    List<Logo>? logos,
    String? type,
    double? rating,
    DateTime? releaseDate,
    String? description,
    List<String>? genres,
    int? totalEpisodes,
    int? totalSeasons,
    List<dynamic>? directors,
    List<dynamic>? writers,
    List<String>? actors,
    Trailer? trailer,
    Mappings? mappings,
    List<Recommendation>? similar,
    List<Recommendation>? recommendations,
    List<Season>? seasons,
  }) {
    return MediaModel(
      id: id ?? this.id,
      title: title ?? this.title,
      episodeId: episodeId ?? this.episodeId,
      translations: translations ?? this.translations,
      image: image ?? this.image,
      cover: cover ?? this.cover,
      logos: logos ?? this.logos,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      releaseDate: releaseDate ?? this.releaseDate,
      description: description ?? this.description,
      genres: genres ?? this.genres,
      totalEpisodes: totalEpisodes ?? this.totalEpisodes,
      totalSeasons: totalSeasons ?? this.totalSeasons,
      directors: directors ?? this.directors,
      writers: writers ?? this.writers,
      actors: actors ?? this.actors,
      trailer: trailer ?? this.trailer,
      mappings: mappings ?? this.mappings,
      similar: similar ?? this.similar,
      recommendations: recommendations ?? this.recommendations,
      seasons: seasons ?? this.seasons,
    );
  }

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json["id"],
      title: json["title"],
      episodeId: json["episodeId"].toString(),
      translations: json["translations"] == null
          ? []
          : List<Translation>.from(
              json["translations"]!.map((x) => Translation.fromJson(x))),
      image: json["image"],
      cover: json["cover"],
      logos: json["logos"] == null
          ? []
          : List<Logo>.from(json["logos"]!.map((x) => Logo.fromJson(x))),
      type: json["type"],
      rating: double.parse(json["rating"]?.toString() ?? "0"),
      releaseDate: DateTime.tryParse(json["releaseDate"] ?? ""),
      description: json["description"],
      genres: json["genres"] == null
          ? []
          : List<String>.from(json["genres"]!.map((x) => x)),
      totalEpisodes: json["totalEpisodes"],
      totalSeasons: json["totalSeasons"],
      directors: json["directors"] == null
          ? []
          : List<dynamic>.from(json["directors"]!.map((x) => x)),
      writers: json["writers"] == null
          ? []
          : List<dynamic>.from(json["writers"]!.map((x) => x)),
      actors: json["actors"] == null
          ? []
          : List<String>.from(json["actors"]!.map((x) => x)),
      trailer:
          json["trailer"] == null ? null : Trailer.fromJson(json["trailer"]),
      mappings:
          json["mappings"] == null ? null : Mappings.fromJson(json["mappings"]),
      similar: json["similar"] == null
          ? []
          : List<Recommendation>.from(
              json["similar"]!.map((x) => Recommendation.fromJson(x))),
      recommendations: json["recommendations"] == null
          ? []
          : List<Recommendation>.from(
              json["recommendations"]!.map((x) => Recommendation.fromJson(x))),
      seasons: json["seasons"] == null
          ? []
          : List<Season>.from(json["seasons"]!.map((x) => Season.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "translations": translations.map((x) => x.toJson()).toList(),
        "image": image,
        "cover": cover,
        "logos": logos.map((x) => x.toJson()).toList(),
        "type": type,
        "rating": rating,
        "releaseDate":
            "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "description": description,
        "genres": genres.map((x) => x).toList(),
        "totalEpisodes": totalEpisodes,
        "totalSeasons": totalSeasons,
        "directors": directors.map((x) => x).toList(),
        "writers": writers.map((x) => x).toList(),
        "actors": actors.map((x) => x).toList(),
        "trailer": trailer?.toJson(),
        "mappings": mappings?.toJson(),
        "similar": similar.map((x) => x.toJson()).toList(),
        "recommendations": recommendations.map((x) => x.toJson()).toList(),
        "seasons": seasons.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$id, $title, $translations, $image, $cover, $logos, $type, $rating, $releaseDate, $description, $genres, $totalEpisodes, $totalSeasons, $directors, $writers, $actors, $trailer, $mappings, $similar, $recommendations, $seasons, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        translations,
        image,
        cover,
        logos,
        type,
        rating,
        releaseDate,
        description,
        genres,
        totalEpisodes,
        totalSeasons,
        directors,
        writers,
        actors,
        trailer,
        mappings,
        similar,
        recommendations,
        seasons,
      ];
}

class Logo extends Equatable {
  const Logo({
    required this.url,
    required this.aspectRatio,
    required this.width,
  });

  final String? url;
  final double? aspectRatio;
  final int? width;

  Logo copyWith({
    String? url,
    double? aspectRatio,
    int? width,
  }) {
    return Logo(
      url: url ?? this.url,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      width: width ?? this.width,
    );
  }

  factory Logo.fromJson(Map<String, dynamic> json) {
    return Logo(
      url: json["url"],
      aspectRatio: double.parse(json["aspectRatio"].toString()),
      width: json["width"],
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "aspectRatio": aspectRatio,
        "width": width,
      };

  @override
  String toString() {
    return "$url, $aspectRatio, $width, ";
  }

  @override
  List<Object?> get props => [
        url,
        aspectRatio,
        width,
      ];
}

class Mappings extends Equatable {
  const Mappings({
    required this.imdb,
    required this.tmdb,
  });

  final String? imdb;
  final int? tmdb;

  Mappings copyWith({
    String? imdb,
    int? tmdb,
  }) {
    return Mappings(
      imdb: imdb ?? this.imdb,
      tmdb: tmdb ?? this.tmdb,
    );
  }

  factory Mappings.fromJson(Map<String, dynamic> json) {
    return Mappings(
      imdb: json["imdb"],
      tmdb: json["tmdb"],
    );
  }

  Map<String, dynamic> toJson() => {
        "imdb": imdb,
        "tmdb": tmdb,
      };

  @override
  String toString() {
    return "$imdb, $tmdb, ";
  }

  @override
  List<Object?> get props => [
        imdb,
        tmdb,
      ];
}

class Recommendation extends Equatable {
  const Recommendation({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
    required this.rating,
    required this.releaseDate,
  });

  final String? id;
  final String? title;
  final String? image;
  final String? type;
  final double? rating;
  final String? releaseDate;

  Recommendation copyWith({
    String? id,
    String? title,
    String? image,
    String? type,
    double? rating,
    String? releaseDate,
  }) {
    return Recommendation(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      releaseDate: releaseDate ?? this.releaseDate,
    );
  }

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json["id"],
      title: json["title"],
      image: json["image"],
      type: json["type"],
      rating: double.parse(json["rating"].toString()),
      releaseDate: json["releaseDate"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "type": type,
        "rating": rating,
        "releaseDate": releaseDate,
      };

  @override
  String toString() {
    return "$id, $title, $image, $type, $rating, $releaseDate, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        image,
        type,
        rating,
        releaseDate,
      ];
}

class Season extends Equatable {
  const Season({
    required this.season,
    required this.image,
    required this.episodes,
    required this.isReleased,
  });

  final int? season;
  final Image? image;
  final List<Episode> episodes;
  final bool? isReleased;

  Season copyWith({
    int? season,
    Image? image,
    List<Episode>? episodes,
    bool? isReleased,
  }) {
    return Season(
      season: season ?? this.season,
      image: image ?? this.image,
      episodes: episodes ?? this.episodes,
      isReleased: isReleased ?? this.isReleased,
    );
  }

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      season: json["season"],
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      episodes: json["episodes"] == null
          ? []
          : List<Episode>.from(
              json["episodes"]!.map((x) => Episode.fromJson(x))),
      isReleased: json["isReleased"],
    );
  }

  Map<String, dynamic> toJson() => {
        "season": season,
        "image": image?.toJson(),
        "episodes": episodes.map((x) => x.toJson()).toList(),
        "isReleased": isReleased,
      };

  @override
  String toString() {
    return "$season, $image, $episodes, $isReleased, ";
  }

  @override
  List<Object?> get props => [
        season,
        image,
        episodes,
        isReleased,
      ];
}

class Episode extends Equatable {
  const Episode({
    required this.id,
    required this.title,
    required this.episode,
    required this.season,
    required this.releaseDate,
    required this.description,
    required this.url,
    required this.img,
  });

  final String? id;
  final String? title;
  final int? episode;
  final int? season;
  final DateTime? releaseDate;
  final String? description;
  final String? url;
  final Image? img;

  Episode copyWith({
    String? id,
    String? title,
    int? episode,
    int? season,
    DateTime? releaseDate,
    String? description,
    String? url,
    Image? img,
  }) {
    return Episode(
      id: id ?? this.id,
      title: title ?? this.title,
      episode: episode ?? this.episode,
      season: season ?? this.season,
      releaseDate: releaseDate ?? this.releaseDate,
      description: description ?? this.description,
      url: url ?? this.url,
      img: img ?? this.img,
    );
  }

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json["id"],
      title: json["title"],
      episode: json["episode"],
      season: json["season"],
      releaseDate: DateTime.tryParse(json["releaseDate"] ?? ""),
      description: json["description"],
      url: json["url"],
      img: json["img"] == null ? null : Image.fromJson(json["img"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "episode": episode,
        "season": season,
        "releaseDate":
            "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "description": description,
        "url": url,
        "img": img?.toJson(),
      };

  @override
  String toString() {
    return "$id, $title, $episode, $season, $releaseDate, $description, $url, $img, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        episode,
        season,
        releaseDate,
        description,
        url,
        img,
      ];
}

class Image extends Equatable {
  const Image({
    required this.mobile,
    required this.hd,
  });

  final String? mobile;
  final String? hd;

  Image copyWith({
    String? mobile,
    String? hd,
  }) {
    return Image(
      mobile: mobile ?? this.mobile,
      hd: hd ?? this.hd,
    );
  }

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      mobile: json["mobile"],
      hd: json["hd"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "hd": hd,
      };

  @override
  String toString() {
    return "$mobile, $hd, ";
  }

  @override
  List<Object?> get props => [
        mobile,
        hd,
      ];
}

class Trailer extends Equatable {
  const Trailer({
    required this.id,
    required this.site,
    required this.url,
  });

  final String? id;
  final String? site;
  final String? url;

  Trailer copyWith({
    String? id,
    String? site,
    String? url,
  }) {
    return Trailer(
      id: id ?? this.id,
      site: site ?? this.site,
      url: url ?? this.url,
    );
  }

  factory Trailer.fromJson(Map<String, dynamic> json) {
    return Trailer(
      id: json["id"],
      site: json["site"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "site": site,
        "url": url,
      };

  @override
  String toString() {
    return "$id, $site, $url, ";
  }

  @override
  List<Object?> get props => [
        id,
        site,
        url,
      ];
}

class Translation extends Equatable {
  const Translation({
    required this.title,
    required this.description,
    required this.language,
  });

  final String? title;
  final String? description;
  final String? language;

  Translation copyWith({
    String? title,
    String? description,
    String? language,
  }) {
    return Translation(
      title: title ?? this.title,
      description: description ?? this.description,
      language: language ?? this.language,
    );
  }

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      title: json["title"],
      description: json["description"],
      language: json["language"],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "language": language,
      };

  @override
  String toString() {
    return "$title, $description, $language, ";
  }

  @override
  List<Object?> get props => [
        title,
        description,
        language,
      ];
}
