import 'dart:convert';

import 'package:temple_app/modals/video_model.dart';

class VideoAlbumModel {
  String albumId;
  String index;
  String title;
  String playlistId;
  String description;
  String thumbnail;

  List<VideoModel> videosList;
  VideoAlbumModel({
    required this.albumId,
    required this.index,
    required this.title,
    required this.playlistId,
    required this.description,
    required this.videosList,
    required this.thumbnail,
  });

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'index': index,
      'name': title,
      'playlistId': playlistId,
      'description': description,
      'videosList': videosList.map((x) => x.toJson()).toList(),
      'thumbnail': thumbnail
    };
  }

  factory VideoAlbumModel.fromJson(Map<String, dynamic> map) {
    return VideoAlbumModel(
      albumId: map['albumId'] ?? '',
      index: map['index'] ?? '',
      title: map['title'] ?? '',
      playlistId: map['playlistId'] ?? '',
      description: map['description'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      videosList: (map['videosList'] != null)
          ? List<VideoModel>.from(
              (json.decode(map['videosList']) as List<dynamic>)
                  .map((item) => VideoModel.fromJson(item)))
          : [],
    );
  }
}
