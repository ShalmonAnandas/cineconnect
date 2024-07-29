import 'package:cineconnect/models/book_search_result.dart';
import 'package:equatable/equatable.dart';

class LibraryModel extends Equatable {
  const LibraryModel({
    required this.taskId,
    required this.book,
    required this.fileName,
    required this.link,
  });

  final String? taskId;
  final BookSearchResult? book;
  final String? fileName;
  final List<dynamic>? link;

  LibraryModel copyWith({
    String? taskId,
    BookSearchResult? book,
    String? fileName,
    List<dynamic>? link,
  }) {
    return LibraryModel(
      taskId: taskId ?? this.taskId,
      book: book ?? this.book,
      fileName: fileName ?? this.fileName,
      link: link ?? this.link,
    );
  }

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      taskId: json["taskID"],
      book:
          json["book"] == null ? null : BookSearchResult.fromJson(json["book"]),
      fileName: json["fileName"],
      link: json["link"],
    );
  }

  Map<String, dynamic> toJson() => {
        "taskID": taskId,
        "book": book?.toJson(),
        "fileName": fileName,
        "link": link,
      };

  @override
  String toString() {
    return "$taskId, $book, $fileName, $link, ";
  }

  @override
  List<Object?> get props => [
        taskId,
        book,
        fileName,
        link,
      ];
}
