import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temple_app/modals/ebook_model.dart';

class EpubRepository {
  Future<List<EbookModel>?> getEpubListFromWeb() async {
    try {
      List<EbookModel> ebookList = [];
      final data = await FirebaseFirestore.instance.collection('books').get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
      for (var b in a) {
        if (b.exists) {
          ebookList.add(EbookModel.fromJson(b.data()));
        }
      }
      return ebookList;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
