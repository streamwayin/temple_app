class VideoModel {
  String id;
  String title;
  String thumbnail;
  String description;
  String url;
  String author;
  Duration? duration;
  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.url,
    required this.author,
    this.duration,
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
      author: map['auther'] ?? '',
      duration: map['duration'] == null
          ? null
          : Duration(milliseconds: int.parse(map['duration'])),
    );
  }
}
