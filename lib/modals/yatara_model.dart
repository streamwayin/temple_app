import 'package:cloud_firestore/cloud_firestore.dart';

class YataraModel {
  String title;
  String yataraId;
  int index;
  String description;
  String image;
  String artistId;
  GeoPoint? location;
  DateTime? fromDate;
  DateTime? toDate;
  String call;
  bool isYatara;
  YataraModel({
    required this.title,
    required this.yataraId,
    required this.index,
    required this.description,
    required this.image,
    required this.artistId,
    this.location,
    this.fromDate,
    this.toDate,
    required this.call,
    required this.isYatara,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'yataraId': yataraId,
      'index': index,
      'description': description,
      'image': image,
      'artistId': artistId,
      'location': (location != null)
          ? GeoPoint(location!.latitude, location!.longitude)
          : "",
      'fromdate': fromDate?.millisecondsSinceEpoch,
      'toDate': toDate?.millisecondsSinceEpoch,
      'call': call,
      'isYatara': isYatara,
    };
  }

  factory YataraModel.fromJson(Map<String, dynamic> map) {
    return YataraModel(
      title: map['title'] ?? '',
      yataraId: map['yataraId'] ?? '',
      index: map['index'],
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      artistId: map['artistId'] ?? '',
      location: map['location'],
      fromDate: map['fromDate'] != null
          ? (map['fromDate'] as Timestamp).toDate()
          : null,
      toDate:
          map['toDate'] != null ? (map['toDate'] as Timestamp).toDate() : null,
      call: map['call'] ?? '',
      isYatara: map['isYatara'],
    );
  }
}
