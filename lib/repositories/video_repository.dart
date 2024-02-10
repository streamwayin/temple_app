import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/retry.dart';
import 'package:temple_app/modals/video_album_model_db.dart';

class VideoRepository {
  final dbInstance = FirebaseFirestore.instance;
  Future<List<VideoAlbumModelDb>> getVideoAlbumListFromWeb() async {
    List<VideoAlbumModelDb> videoList = [];
    final data = await dbInstance.collection("video-albums").get(
          const GetOptions(source: Source.serverAndCache),
        );
    final listOfDataMap = data.docs;

    for (var a in listOfDataMap) {
      if (a.exists) {
        videoList.add(VideoAlbumModelDb.fromJson(a.data()));
      }
    }
    videoList.sort((a, b) => a.index.compareTo(b.index));
    return videoList;
  }

  Future<VideoAlbumModelDb?> getSingleVideoAlubmFromDbForNotification(
      String docId) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('video-albums')
          .doc(docId)
          .get(
            const GetOptions(source: Source.serverAndCache),
          );
      if (data.exists) {
        return VideoAlbumModelDb.fromJson(data.data()!);
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
