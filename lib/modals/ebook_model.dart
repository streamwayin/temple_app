class EbookModel {
  final String name;
  final String bookId;
  final String thumbnailUrl;
  final String bookUrl;
  EbookModel({
    required this.name,
    required this.bookId,
    required this.thumbnailUrl,
    required this.bookUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'bookId': bookId,
      'thumbnailUrl': thumbnailUrl,
      'url': bookUrl,
    };
  }

  factory EbookModel.fromJson(Map<String, dynamic> map) {
    return EbookModel(
      name: map['name'],
      bookId: map['bookId'],
      thumbnailUrl: map['thumbnailUrl'],
      bookUrl: map['bookUrl'],
    );
  }
}
