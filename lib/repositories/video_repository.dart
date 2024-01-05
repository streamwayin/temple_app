import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temple_app/modals/video_album_model_db.dart';

class VideoRepository {
  final dbInstance = FirebaseFirestore.instance;
  Future<List<VideoAlbumModelDb>> getVideoAlbumListFromWeb() async {
    List<VideoAlbumModelDb> videoList = [];
    final data = await dbInstance.collection("video-albums").get();
    final listOfDataMap = data.docs;

    for (var a in listOfDataMap) {
      if (a.exists) {
        videoList.add(VideoAlbumModelDb.fromJson(a.data()));
      }
    }
    return videoList;
  }
}
