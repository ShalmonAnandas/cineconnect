import 'package:equatable/equatable.dart';

class Search extends Equatable {
  Search({
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.results,
  });

  final String? currentPage;
  final int? totalPages;
  final bool? hasNextPage;
  final List<Result> results;

  Search copyWith({
    String? currentPage,
    int? totalPages,
    bool? hasNextPage,
    List<Result>? results,
  }) {
    return Search(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      results: results ?? this.results,
    );
  }

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      currentPage: json["currentPage"],
      totalPages: int.tryParse(json["totalPages"].toString()),
      hasNextPage: json["hasNextPage"],
      results: json["results"] == null
          ? []
          : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "totalPages": totalPages,
        "hasNextPage": hasNextPage,
        "results": results.map((x) => x?.toJson()).toList(),
      };

  @override
  String toString() {
    return "$currentPage, $totalPages, $hasNextPage, $results, ";
  }

  @override
  List<Object?> get props => [
        currentPage,
        totalPages,
        hasNextPage,
        results,
      ];
}

class Result extends Equatable {
  Result({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
  });

  final String? id;
  final String? title;
  final String? url;
  final String? image;

  Result copyWith({
    String? id,
    String? title,
    String? url,
    String? image,
  }) {
    return Result(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      image: image ?? this.image,
    );
  }

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json["id"],
      title: json["title"],
      url: json["url"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url": url,
        "image": image,
      };

  @override
  String toString() {
    return "$id, $title, $url, $image, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        url,
        image,
      ];
}
