import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temple_app/modals/banner_model.dart';

import '../modals/app_update_model.dart';

class HomeRepository {
  Future<AppUpdateModel?> getMetadata() async {
    AppUpdateModel? appUpdateModel;
    try {
      // Reference to the Firestore collection and document
      CollectionReference metadataCollection =
          FirebaseFirestore.instance.collection('metadata');
      DocumentSnapshot documentSnapshot =
          await metadataCollection.doc('androidVersion').get(
                const GetOptions(source: Source.serverAndCache),
              );

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Convert the data to a Map
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        appUpdateModel = AppUpdateModel.fromJson(data);
        // You can now use the 'data' map for further processing
        return appUpdateModel;
      } else {
        // Document does not exist
        return appUpdateModel; // or handle the absence of the document as needed
      }
    } catch (e) {
      // Handle any errors that may occur during the process
      print("Error fetching data: $e");
      return appUpdateModel; // or throw an exception, log, etc.
    }
  }

//   Future getQuotes() async {
//     AppUpdateModel? appUpdateModel;
//     try {
//       // Reference to the Firestore collection and document
//       CollectionReference metadataCollection =
//           FirebaseFirestore.instance.collection('bannerText');

// }
//     } catch (e) {
//       // Handle any errors that may occur during the process
//       print("Error fetching data: $e");
//       return appUpdateModel; // or throw an exception, log, etc.
//     }
//   }
  Future<BannerModel> getQuotes() async {
    final data = await FirebaseFirestore.instance.collection('bannerText').get(
          const GetOptions(source: Source.serverAndCache),
        );
    List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
    List<BannerModel> signtseenList = [];

    for (var b in a) {
      if (b.exists) {
        print(b.data());
        print(b["quotes"][0]);
        signtseenList.add(BannerModel.fromJson(b.data()));

        // signtseenList.add(SightseenModel.fromJson(b.data()));
      }
    }
    return signtseenList[0];
  }
}
