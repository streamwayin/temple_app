class VideoAlbumModelDb {
  String albumId;
  int index;
  String name;
  String playlistId;
  String thumbnail;
  VideoAlbumModelDb({
    required this.albumId,
    required this.index,
    required this.name,
    required this.playlistId,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'index': index,
      'name': name,
      'playlistId': playlistId,
      'thumbnail': thumbnail,
    };
  }

  factory VideoAlbumModelDb.fromJson(Map<String, dynamic> map) {
    return VideoAlbumModelDb(
      albumId: map['albumId'] ?? '',
      index: map['index'],
      name: map['name'] ?? '',
      playlistId: map['playlistId'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
    );
  }
}
