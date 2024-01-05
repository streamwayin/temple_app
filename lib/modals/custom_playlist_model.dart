// import 'dart:convert';

// import 'package:flutter/rendering.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// class CustomPlaylistClass {
//   Playlist playlist;
//   String firstVideoId;
//   String id;
//   String title;

//   CustomPlaylistClass({
//     required this.playlist,
//     required this.firstVideoId,
//     required this.id,
//     required this.title,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'playlist': playlist.toMap(),
//       'firstVideoId': firstVideoId,
//       'id': id,
//       'title': title,
//     };
//   }

//   factory CustomPlaylistClass.fromJson(Map<String, dynamic> map) {
//     return CustomPlaylistClass(
//       playlist: Playlist.fromMap(map['playlist']),
//       firstVideoId: map['firstVideoId'] ?? '',
//       id: map['id'] ?? '',
//       title: map['title'] ?? '',
//     );
//   }
// }
