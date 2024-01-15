import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temple_app/modals/image_album_model.dart';
import 'package:temple_app/modals/image_model.dart';

class WallpaperRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<ImageAlbumModel>?> getImageAlbumFromDb() async {
    try {
      List<ImageAlbumModel> albumModel = [];
      final data =
          await FirebaseFirestore.instance.collection('image-albums').get(
                const GetOptions(source: Source.serverAndCache),
              );
      // final dataa = await FirebaseFirestore.instance.collection('tracks').where(album).get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
      for (var b in a) {
        if (b.exists) {
          albumModel.add(ImageAlbumModel.fromJson(b.data()));
        }
      }
      return albumModel;
    } catch (e) {
      return null;
    }
  }

  Future<List<ImageModel>?> getImageFromDb(String albumId) async {
    List<ImageModel> wallpaperList = [];
    try {
      final data = await firestore.collection("images").get(
            const GetOptions(source: Source.serverAndCache),
          );
      final listOfMap = data.docs;
      for (var a in listOfMap) {
        if (a.exists) {
          wallpaperList.add(ImageModel.fromJson(a.data()));
        }
      }
      return wallpaperList;
    } catch (e) {
      return null;
    }
  }
}
