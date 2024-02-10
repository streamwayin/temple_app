import 'package:cloud_firestore/cloud_firestore.dart';

import '../modals/yatara_model.dart';

class YataraRepository {
  Future<List<YataraModel>?> getYatraDetilsFromDb() async {
    try {
      List<YataraModel> yatara = [];
      final data = await FirebaseFirestore.instance
          .collection('events')
          .orderBy("index", descending: false)
          .get(
            const GetOptions(source: Source.serverAndCache),
          );

      List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
      for (var b in a) {
        if (b.exists) {
          print(b.data()["contactList"]);
          yatara.add(YataraModel.fromJson(b.data()));
        }
      }
      return yatara;
    } catch (e) {
      print('Error fetching images: $e');
      return null;
    }
  }
}
