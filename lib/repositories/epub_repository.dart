import 'package:temple_app/modals/ebook_model.dart';

import '../constants.dart';

class EpubRepository {
  Future<List<EbookModel>?> getEpubListFromWeb() async {
    List<EbookModel> ebookList =
        bookLIst.map((e) => EbookModel.fromJson(e)).toList();
    return ebookList;
  }
}
