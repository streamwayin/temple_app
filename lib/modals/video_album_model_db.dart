class VideoAlbumModelDb {
  String albumId;
  String index;
  String name;
  String playlistId;
  VideoAlbumModelDb({
    required this.albumId,
    required this.index,
    required this.name,
    required this.playlistId,
  });

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'index': index,
      'name': name,
      'playlistId': playlistId,
    };
  }

  factory VideoAlbumModelDb.fromJson(Map<String, dynamic> map) {
    return VideoAlbumModelDb(
      albumId: map['albumId'] ?? '',
      index: map['index'] ?? '',
      name: map['name'] ?? '',
      playlistId: map['playlistId'] ?? '',
    );
  }
}
