import 'package:cloud_firestore/cloud_firestore.dart';

import '../modals/acharayas_model.dart';
import '../modals/saint_model.dart';

class AbooutUsRepository {
  Future<List<AcharayasModel>> getAcharayasDataFromDB() async {
    final data = await FirebaseFirestore.instance.collection('acharayas').get(
          const GetOptions(source: Source.serverAndCache),
        );
    List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
    List<AcharayasModel> achariyasList = [];
    for (var b in a) {
      if (b.exists) {
        achariyasList.add(AcharayasModel.fromJson(b.data()));
      }
    }
    return achariyasList;
  }

  Future<List<SantModel>> getSantsDataFromDb() async {
    List<SantModel> santList = [];
    final data = await FirebaseFirestore.instance.collection("sants").get(
          const GetOptions(source: Source.serverAndCache),
        );

    List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
    for (var b in a) {
      if (b.exists) {
        santList.add(SantModel.fromJson(b.data()));
      }
    }
    return santList;
  }
}
