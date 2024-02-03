import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class YataraModel {
  String title;
  String yataraId;
  int index;
  String description;
  String? image;
  String artistId;
  GeoPoint? location;
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? toTime;
  DateTime? fromTime;
  String call;
  bool isYatara;
  List<ImageArrayModel>? imageArray;
  YataraModel({
    required this.title,
    required this.yataraId,
    required this.index,
    required this.description,
    this.image,
    required this.artistId,
    this.location,
    this.fromDate,
    this.toDate,
    this.fromTime,
    this.toTime,
    required this.call,
    required this.isYatara,
    this.imageArray,
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
      'toTime': toDate?.millisecondsSinceEpoch,
      'fromTime': toDate?.millisecondsSinceEpoch,
      'call': call,
      'isYatara': isYatara,
      'imageArray': imageArray?.map((image) => image.toJson()).toList()
    };
  }

  factory YataraModel.fromJson(Map<String, dynamic> map) {
    return YataraModel(
        title: map['title'] ?? '',
        yataraId: map['yataraId'] ?? '',
        index: map['index'],
        description: map['description'] ?? '',
        image: map['image'],
        artistId: map['artistId'] ?? '',
        location: map['location'],
        fromDate: map['fromDate'] != null
            ? (map['fromDate'] as Timestamp).toDate()
            : null,
        toDate: map['toDate'] != null
            ? (map['toDate'] as Timestamp).toDate()
            : null,
        fromTime: map['fromTime'] != null
            ? (map['fromTime'] as Timestamp).toDate()
            : null,
        toTime: map['toTime'] != null
            ? (map['toTime'] as Timestamp).toDate()
            : null,
        call: map['call'] ?? '',
        isYatara: map['isYatara'],
        imageArray: (map['imageArray'] as List<dynamic>?)
            ?.map((imageMap) => ImageArrayModel.fromJson(imageMap))
            .toList());
  }
}

class ImageArrayModel {
  final String image;
  final String imageId;
  ImageArrayModel({
    required this.image,
    required this.imageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'imageId': imageId,
    };
  }

  factory ImageArrayModel.fromJson(Map<String, dynamic> map) {
    return ImageArrayModel(
      image: map['image'] ?? '',
      imageId: map['imageId'] ?? '',
    );
  }
}
