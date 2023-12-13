class SantModel {
  final String name;
  final String? image;
  final String index;
  final String? whatsappNo;
  final String? callNo;

  SantModel(
      {required this.name,
      this.image,
      required this.index,
      this.whatsappNo,
      this.callNo});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'index': index,
      'whatsappNo': whatsappNo,
      'callNo': callNo
    };
  }

  factory SantModel.fromJson(Map<String, dynamic> map) {
    return SantModel(
      name: map['name'],
      image: map['image'],
      index: map['index'],
      whatsappNo: map['whatsappNo'],
      callNo: map['callNo'],
    );
  }
}
