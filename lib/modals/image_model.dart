class ImageModel {
  String albumId;
  String imageId;
  int index;
  String thumbnail;
  String title;
  ImageModel({
    required this.albumId,
    required this.imageId,
    required this.index,
    required this.thumbnail,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'imageId': imageId,
      'index': index,
      'thumbnail': thumbnail,
      'title': title,
    };
  }

  factory ImageModel.fromJson(Map<String, dynamic> map) {
    return ImageModel(
      albumId: map['albumId'] ?? '',
      imageId: map['imageId'] ?? '',
      index: map['index'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      title: map['title'] ?? '',
    );
  }
}
