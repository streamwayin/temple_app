import 'package:cloud_firestore/cloud_firestore.dart';

import '../modals/yatara_model.dart';

class YataraRepository {
  Future<List<YataraModel>?> getYatraDetilsFromDb() async {
    try {
      List<YataraModel> yatara = [];
      final data = await FirebaseFirestore.instance.collection('events').get(
            const GetOptions(source: Source.serverAndCache),
          );

      List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
      for (var b in a) {
        if (b.exists) {
          print(b.data()["contactList"]);
          yatara.add(YataraModel.fromJson(b.data()));
        }
      }
      print(yatara);
      return yatara;
    } catch (e) {
      return null;
    }
  }
}
