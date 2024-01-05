class VideoModel {
  String id;
  String title;
  String thumbnail;
  String description;
  String url;
  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'description': description,
      'url': url,
    };
  }

  factory VideoModel.fromJson(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
    );
  }
}
