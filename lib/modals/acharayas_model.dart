class AcharayasModel {
  String? name;
  int index;
  String? achariyaId;
  String? deeksha;
  String? janm;
  String? nirvaan;
  String? tag;
  String? peethaaroodh;
  AcharayasModel(
      {this.name,
      required this.index,
      this.achariyaId,
      this.deeksha,
      this.janm,
      this.nirvaan,
      this.tag,
      this.peethaaroodh});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'index': index,
      'achariyaId': achariyaId,
      'deeksha': deeksha,
      'janm': janm,
      'nirvaan': nirvaan,
      'tag': tag,
      'peethaaroodh': peethaaroodh
    };
  }

  factory AcharayasModel.fromJson(Map<String, dynamic> map) {
    return AcharayasModel(
      index: map['index'],
      achariyaId: map['artistId'],
      name: map['name'] ?? '',
      deeksha: map['deeksha'],
      janm: map['janm'],
      nirvaan: map['nirvaan'],
      tag: map['tag'],
      peethaaroodh: map['peethaaroodh'],
    );
  }
}
