class TrackModel {
  String albumId;
  String artistId;
  String name;
  String songUrl;
  String? thumbnail;
  String trackId;
  TrackModel({
    required this.albumId,
    required this.artistId,
    required this.name,
    required this.songUrl,
    required this.thumbnail,
    required this.trackId,
  });

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'artistId': artistId,
      'name': name,
      'songUrl': songUrl,
      'thumbnail': thumbnail,
      'trackId': trackId,
    };
  }

  factory TrackModel.fromJson(Map<String, dynamic> map) {
    return TrackModel(
      albumId: map['albumId'] ?? '',
      artistId: map['artistId'] ?? '',
      name: map['name'] ?? '',
      songUrl: map['songUrl'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      trackId: map['trackId'] ?? '',
    );
  }
}
