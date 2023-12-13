class SightseenModel {
  final String title;
  final String sightseenId;
  final String index;
  final String? image;
  final List<String> description;

  SightseenModel(
      {required this.title,
      required this.sightseenId,
      required this.index,
      required this.image,
      required this.description});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'sightseenId': sightseenId,
      'index': index,
      'image': image,
      'description': description,
    };
  }

  factory SightseenModel.fromJson(Map<String, dynamic> map) {
    return SightseenModel(
      title: map['title'],
      sightseenId: map['sightseenId'],
      index: map['index'],
      image: map['image'],
      description: List<String>.from(map['description']),
    );
  }
}
