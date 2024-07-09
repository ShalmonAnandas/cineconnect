import 'package:equatable/equatable.dart';

class Subtitles extends Equatable {
  Subtitles({
    required this.src,
    required this.label,
    required this.land,
    required this.subtitleDefault,
  });

  final String? src;
  final String? label;
  final String? land;
  final bool? subtitleDefault;

  Subtitles copyWith({
    String? src,
    String? label,
    String? land,
    bool? subtitleDefault,
  }) {
    return Subtitles(
      src: src ?? this.src,
      label: label ?? this.label,
      land: land ?? this.land,
      subtitleDefault: subtitleDefault ?? this.subtitleDefault,
    );
  }

  factory Subtitles.fromJson(Map<String, dynamic> json) {
    return Subtitles(
      src: json["src"],
      label: json["label"],
      land: json["land"],
      subtitleDefault: json["default"],
    );
  }

  Map<String, dynamic> toJson() => {
        "src": src,
        "label": label,
        "land": land,
        "default": subtitleDefault,
      };

  @override
  String toString() {
    return "$src, $label, $land, $subtitleDefault, ";
  }

  @override
  List<Object?> get props => [
        src,
        label,
        land,
        subtitleDefault,
      ];
}
