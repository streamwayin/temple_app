class AlbumModel {
  String albumId;
  String artistId;
  String name;
  String thumbnail;
  AlbumModel({
    required this.albumId,
    required this.artistId,
    required this.name,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'artistId': artistId,
      'name': name,
      'thumbnail': thumbnail,
    };
  }

  factory AlbumModel.fromJson(Map<String, dynamic> map) {
    return AlbumModel(
      albumId: map['albumId'] ?? '',
      artistId: map['artistId'] ?? '',
      name: map['name'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
    );
  }
}

// class AlbumModel {
//   String name;
//   String? thumbnail;
//   List<Song> songList;
//   AlbumModel({
//     required this.name,
//     this.thumbnail,
//     required this.songList,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'thumbnail': thumbnail,
//       'songList': songList.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory AlbumModel.fromMap(Map<String, dynamic> map) {
//     return AlbumModel(
//       name: map['name'],
//       thumbnail: map['thumbnail'],
//       songList: List<Song>.from(map['songList']?.map((x) => Song.fromMap(x))),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory AlbumModel.fromJson(String source) =>
//       AlbumModel.fromMap(json.decode(source));
// }

// class Song {
//   String songUrl;
//   String? songThumbnail;
//   String songName;
//   String artistId;
//   String trackId;
//   String albumId;
//   Song({
//     required this.songUrl,
//     this.songThumbnail,
//     required this.songName,
//     required this.artistId,
//     required this.trackId,
//     required this.albumId,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'songUrl': songUrl,
//       'songThumbnail': songThumbnail,
//       'songName': songName,
//       'artistId': artistId,
//       'trackId': trackId,
//       'albumId': albumId
//     };
//   }

//   factory Song.fromMap(Map<String, dynamic> map) {
//     return Song(
//       songUrl: map['songUrl'],
//       songThumbnail: map['songThumbnail'],
//       songName: map['songName'] ?? '',
//       artistId: map['artistId'],
//       trackId: map['trackId'],
//       albumId: map['albumId'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Song.fromJson(String source) => Song.fromMap(json.decode(source));
// }
