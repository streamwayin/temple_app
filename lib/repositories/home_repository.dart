import 'package:cloud_firestore/cloud_firestore.dart';

import '../modals/app_update_model.dart';

class HomeRepository {
  Future<AppUpdateModel?> getMetadata() async {
    AppUpdateModel? appUpdateModel;
    try {
      // Reference to the Firestore collection and document
      CollectionReference metadataCollection =
          FirebaseFirestore.instance.collection('metadata');
      DocumentSnapshot documentSnapshot =
          await metadataCollection.doc('androidVersion').get();

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
}
