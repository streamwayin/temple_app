class ArtistModel {
  final String artistId;
  final int index;
  final String name;

  ArtistModel(
      {required this.artistId, required this.index, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'artistId': artistId,
      'index': index,
      'name': name,
    };
  }

  factory ArtistModel.fromJson(Map<String, dynamic> map) {
    return ArtistModel(
      artistId: map['artistId'] ?? '',
      index: map['index'],
      name: map['name'] ?? '',
    );
  }
}
