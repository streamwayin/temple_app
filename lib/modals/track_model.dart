class TrackModel {
  String albumId;
  String artistId;
  String? artistName;
  String title;
  String songUrl;
  String? thumbnail;
  String trackId;
  int? index;
  Translated translated;

  TrackModel({
    required this.albumId,
    required this.artistId,
    required this.artistName,
    required this.title,
    required this.songUrl,
    required this.thumbnail,
    required this.trackId,
    this.index,
    required this.translated,
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
      'index': index,
      "translated": translated.toJson(),
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
      index: (map['index'] != null) ? int.parse(map['index'].toString()) : null,
      translated: Translated.fromJson(map["translated"]),
    );
  }
}

class Translated {
  String bn;
  String en;
  String gu;
  String hi;
  String kn;
  String ta;
  String te;
  Translated({
    required this.bn,
    required this.en,
    required this.gu,
    required this.hi,
    required this.kn,
    required this.ta,
    required this.te,
  });

  Map<String, dynamic> toJson() {
    return {
      'bn': bn,
      'en': en,
      'gu': gu,
      'hi': hi,
      'kn': kn,
      'ta': ta,
      'te': te,
    };
  }

  factory Translated.fromJson(Map<String, dynamic> map) {
    return Translated(
      bn: map['bn'] ?? '',
      en: map['en'] ?? '',
      gu: map['gu'] ?? '',
      hi: map['hi'] ?? '',
      kn: map['kn'] ?? '',
      ta: map['ta'] ?? '',
      te: map['te'] ?? '',
    );
  }
}
