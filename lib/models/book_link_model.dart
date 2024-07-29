import 'package:equatable/equatable.dart';

class BookLinkModel extends Equatable {
  const BookLinkModel({
    required this.bookLinkModelGet,
    required this.cloudflare,
    required this.ipfsIo,
  });

  final String? bookLinkModelGet;
  final String? cloudflare;
  final String? ipfsIo;

  BookLinkModel copyWith({
    String? bookLinkModelGet,
    String? cloudflare,
    String? ipfsIo,
  }) {
    return BookLinkModel(
      bookLinkModelGet: bookLinkModelGet ?? this.bookLinkModelGet,
      cloudflare: cloudflare ?? this.cloudflare,
      ipfsIo: ipfsIo ?? this.ipfsIo,
    );
  }

  factory BookLinkModel.fromJson(Map<String, dynamic> json) {
    return BookLinkModel(
      bookLinkModelGet: json["GET"],
      cloudflare: json["Cloudflare"],
      ipfsIo: json["IPFS.io"],
    );
  }

  Map<String, dynamic> toJson() => {
        "GET": bookLinkModelGet,
        "Cloudflare": cloudflare,
        "IPFS.io": ipfsIo,
      };

  @override
  String toString() {
    return "$bookLinkModelGet, $cloudflare, $ipfsIo, ";
  }

  @override
  List<Object?> get props => [
        bookLinkModelGet,
        cloudflare,
        ipfsIo,
      ];
}
