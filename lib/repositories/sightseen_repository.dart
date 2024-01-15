import 'package:cloud_firestore/cloud_firestore.dart';

import '../modals/sightseen_model.dart';

class SightseenRepository {
  Future<List<SightseenModel>> getSightseensDataFromDB() async {
    final data = await FirebaseFirestore.instance.collection('sightseens').get(
          const GetOptions(source: Source.serverAndCache),
        );
    List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
    List<SightseenModel> signtseenList = [];
    for (var b in a) {
      if (b.exists) {
        signtseenList.add(SightseenModel.fromJson(b.data()));
      }
    }
    return signtseenList;
  }
}
