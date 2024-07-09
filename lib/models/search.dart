import 'package:equatable/equatable.dart';

class Search extends Equatable {
  const Search({
    required this.episodesCount,
    required this.label,
    required this.favoriteId,
    required this.thumbnail,
    required this.id,
    required this.title,
  });

  final int? episodesCount;
  final String? label;
  final int? favoriteId;
  final String? thumbnail;
  final int? id;
  final String? title;

  Search copyWith({
    int? episodesCount,
    String? label,
    int? favoriteId,
    String? thumbnail,
    int? id,
    String? title,
  }) {
    return Search(
      episodesCount: episodesCount ?? this.episodesCount,
      label: label ?? this.label,
      favoriteId: favoriteId ?? this.favoriteId,
      thumbnail: thumbnail ?? this.thumbnail,
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      episodesCount: json["episodesCount"],
      label: json["label"],
      favoriteId: json["favoriteID"],
      thumbnail: json["thumbnail"],
      id: json["id"],
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() => {
        "episodesCount": episodesCount,
        "label": label,
        "favoriteID": favoriteId,
        "thumbnail": thumbnail,
        "id": id,
        "title": title,
      };

  @override
  String toString() {
    return "$episodesCount, $label, $favoriteId, $thumbnail, $id, $title, ";
  }

  @override
  List<Object?> get props => [
        episodesCount,
        label,
        favoriteId,
        thumbnail,
        id,
        title,
      ];
}
