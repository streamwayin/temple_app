class ImageAlbumModel {
  final String albumId;
  final String index;
  final String? thumbnail;
  final String title;
  ImageAlbumModel({
    required this.albumId,
    required this.index,
    this.thumbnail,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'index': index,
      'thumbnail': thumbnail,
      'title': title,
    };
  }

  factory ImageAlbumModel.fromJson(Map<String, dynamic> map) {
    return ImageAlbumModel(
      albumId: map['albumId'] ?? '',
      index: map['index'] ?? '',
      thumbnail: map['thumbnail'],
      title: map['title'] ?? '',
    );
  }
}
