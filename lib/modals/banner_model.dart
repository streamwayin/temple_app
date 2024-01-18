class BannerModel {
  String bannerTextId;
  List<String> quotes;
  BannerModel({required this.bannerTextId, required this.quotes});

  factory BannerModel.fromJson(Map<String, dynamic> map) {
    return BannerModel(
      bannerTextId: map["bannerTextId"],
      quotes: (map['quotes'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }
}
