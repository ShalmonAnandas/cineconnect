import 'package:equatable/equatable.dart';

class Search extends Equatable {
  const Search({
    required this.currentPage,
    required this.hasNextPage,
    required this.results,
  });

  final String? currentPage;
  final bool? hasNextPage;
  final List<Result> results;

  Search copyWith({
    String? currentPage,
    bool? hasNextPage,
    List<Result>? results,
  }) {
    return Search(
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      results: results ?? this.results,
    );
  }

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      currentPage: json["currentPage"],
      hasNextPage: json["hasNextPage"],
      results: json["results"] == null
          ? []
          : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "hasNextPage": hasNextPage,
        "results": results.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$currentPage, $hasNextPage, $results, ";
  }

  @override
  List<Object?> get props => [
        currentPage,
        hasNextPage,
        results,
      ];
}

class Result extends Equatable {
  const Result({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
    required this.seasons,
    required this.type,
    required this.releaseDate,
  });

  final String? id;
  final String? title;
  final String? url;
  final String? image;
  final int? seasons;
  final String? type;
  final String? releaseDate;

  Result copyWith({
    String? id,
    String? title,
    String? url,
    String? image,
    int? seasons,
    String? type,
    String? releaseDate,
  }) {
    return Result(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      image: image ?? this.image,
      seasons: seasons ?? this.seasons,
      type: type ?? this.type,
      releaseDate: releaseDate ?? this.releaseDate,
    );
  }

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json["id"].toString(),
      title: json["title"],
      url: json["url"],
      image: json["image"],
      seasons: json["seasons"],
      type: json["type"],
      releaseDate: json["releaseDate"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url": url,
        "image": image,
        "seasons": seasons,
        "type": type,
        "releaseDate": releaseDate,
      };

  @override
  String toString() {
    return "$id, $title, $url, $image, $seasons, $type, $releaseDate, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        url,
        image,
        seasons,
        type,
        releaseDate,
      ];
}
