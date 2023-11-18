class TrackModel {
  String albumId;
  String artistId;
  String? artistName;
  String title;
  String songUrl;
  String? thumbnail;
  String trackId;

  TrackModel({
    required this.albumId,
    required this.artistId,
    required this.artistName,
    required this.title,
    required this.songUrl,
    required this.thumbnail,
    required this.trackId,
  });

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'artistId': artistId,
      'artistName': artistName,
      'title': title,
      'songUrl': songUrl,
      'thumbnail': thumbnail,
      'trackId': trackId,
    };
  }

  factory TrackModel.fromJson(Map<String, dynamic> map) {
    return TrackModel(
      albumId: map['albumId'] ?? '',
      artistId: map['artistId'] ?? '',
      artistName: map['artistName'] ?? '',
      title: map['title'] ?? '',
      songUrl: map['songUrl'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      trackId: map['trackId'] ?? '',
    );
  }
}
