class CarouselModel {
  String imageId;
  int index;
  String imageUrl;
  bool visibility;
  CarouselModel({
    required this.imageId,
    required this.index,
    required this.imageUrl,
    required this.visibility,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageId': imageId,
      'index': index,
      'imageUrl': imageUrl,
      'visibility': visibility,
    };
  }

  factory CarouselModel.fromJson(Map<String, dynamic> map) {
    return CarouselModel(
      imageId: map['imageId'] ?? '',
      index: map['index']?.toInt() ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      visibility: map['visibility'] ?? false,
    );
  }
}
