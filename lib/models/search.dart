import 'package:equatable/equatable.dart';

class Search extends Equatable {
  const Search({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
    required this.base64image,
    required this.releaseDate,
    required this.type,
    required this.seasons,
  });

  final String? id;
  final String? title;
  final String? url;
  final String? image;
  final String? base64image;
  final String? releaseDate;
  final String? type;
  final int? seasons;

  Search copyWith({
    String? id,
    String? title,
    String? url,
    String? image,
    String? base64image,
    String? releaseDate,
    String? type,
    int? seasons,
  }) {
    return Search(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      image: image ?? this.image,
      base64image: base64image ?? this.base64image,
      releaseDate: releaseDate ?? this.releaseDate,
      type: type ?? this.type,
      seasons: seasons ?? this.seasons,
    );
  }

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      id: json["id"],
      title: json["title"],
      url: json["url"],
      image: json["image"],
      base64image: json["base64Image"],
      releaseDate: json["releaseDate"],
      type: json["type"],
      seasons: json["seasons"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url": url,
        "image": image,
        "base64Image": base64image,
        "releaseDate": releaseDate,
        "type": type,
        "seasons": seasons,
      };

  @override
  String toString() {
    return "$id, $title, $url, $image, $base64image, $releaseDate, $type, $seasons, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        url,
        image,
        base64image,
        releaseDate,
        type,
        seasons,
      ];
}
