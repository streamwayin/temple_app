import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final int index;
  final String type;
  final String id;
  final String title;
  final String body;
  final DateTime? timestamp;
  NotificationModel(
      {required this.index,
      required this.type,
      required this.id,
      required this.title,
      required this.body,
      this.timestamp});

  // Map<String, dynamic> toJson() {
  //   return {
  //     'index': index,
  //     'type': type,
  //     'id': id,
  //     'title': title,
  //     'body': body,
  //   };
  // }

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
      index: map['index'] != null ? int.parse(map['index']) : 0,
      type: map['type'] ?? '',
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : null,
    );
  }
}
