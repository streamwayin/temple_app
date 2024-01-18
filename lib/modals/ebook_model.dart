class EbookModel {
  final String id;
  final String title;
  final String? titleHi;
  final String? description;
  final String? author;
  final String? authorId;
  final String url;
  final String thumbnailUrl;
  final String fileType;
  final int? index;
  EbookModel({
    required this.id,
    required this.title,
    this.titleHi,
    this.description,
    this.author,
    this.authorId,
    required this.url,
    required this.thumbnailUrl,
    required this.fileType,
    this.index,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_hi': titleHi,
      'description': description,
      'author': author,
      'author_id': authorId,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'file_type': fileType,
      'index': index,
    };
  }

  factory EbookModel.fromJson(Map<String, dynamic> map) {
    return EbookModel(
      id: map['id'],
      title: map['title'],
      titleHi: map['title_hi'],
      description: map['description'],
      author: map['author'],
      authorId: map['author_id'],
      url: map['url'],
      thumbnailUrl: map['thumbnail_url'],
      fileType: map['file_type'],
      index: map['index'],
    );
  }
}
