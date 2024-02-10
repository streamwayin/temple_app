import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temple_app/modals/notification_model.dart';

class NotificationRepository {
  Future<List<NotificationModel>?> getNotificationListFromDB() async {
    List<NotificationModel> notificationModelList = [];
    try {
      final data = await FirebaseFirestore.instance
          .collection("notifications")
          .orderBy("timestamp", descending: true)
          .limit(10)
          .get(GetOptions(source: Source.serverAndCache));

      List<QueryDocumentSnapshot<Map<String, dynamic>>> queryDocumentSnapshot =
          data.docs;
      for (var a in queryDocumentSnapshot) {
        if (a.exists) {
          notificationModelList.add(NotificationModel.fromJson(a.data()));
        }
      }
    } catch (e) {
      print('before return catch');
    }
    // print(notificationModelList.length);
    // notificationModelList
    //     .sort((a, b) => (b.timestamp!).compareTo(a.timestamp!));
    // notificationModelList = notificationModelList.take(10).toList();
    return notificationModelList;
  }
}
