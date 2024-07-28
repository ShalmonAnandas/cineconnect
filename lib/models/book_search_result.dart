import 'package:equatable/equatable.dart';

class BookSearchResult extends Equatable {
  const BookSearchResult({
    required this.author,
    required this.title,
    required this.poster,
    required this.language,
    required this.pages,
    required this.size,
    required this.entension,
    required this.releaseDate,
    required this.downloadLinks,
  });

  final String? author;
  final String? title;
  final String? poster;
  final String? language;
  final String? pages;
  final String? size;
  final String? entension;
  final String? releaseDate;
  final String? downloadLinks;

  BookSearchResult copyWith({
    String? author,
    String? title,
    String? poster,
    String? language,
    String? pages,
    String? size,
    String? entension,
    String? releaseDate,
    String? downloadLinks,
  }) {
    return BookSearchResult(
      author: author ?? this.author,
      title: title ?? this.title,
      poster: poster ?? this.poster,
      language: language ?? this.language,
      pages: pages ?? this.pages,
      size: size ?? this.size,
      entension: entension ?? this.entension,
      releaseDate: releaseDate ?? this.releaseDate,
      downloadLinks: downloadLinks ?? this.downloadLinks,
    );
  }

  factory BookSearchResult.fromJson(Map<String, dynamic> json) {
    return BookSearchResult(
      author: json["author"],
      title: json["title"],
      poster: json["poster"],
      language: json["language"],
      pages: json["pages"],
      size: json["size"],
      entension: json["entension"],
      releaseDate: json["release_date"],
      downloadLinks: json["download_links"],
    );
  }

  Map<String, dynamic> toJson() => {
        "author": author,
        "title": title,
        "poster": poster,
        "language": language,
        "pages": pages,
        "size": size,
        "entension": entension,
        "release_date": releaseDate,
        "download_links": downloadLinks,
      };

  @override
  String toString() {
    return "$author, $title, $poster, $language, $pages, $size, $entension, $releaseDate, $downloadLinks, ";
  }

  @override
  List<Object?> get props => [
        author,
        title,
        poster,
        language,
        pages,
        size,
        entension,
        releaseDate,
        downloadLinks,
      ];
}
