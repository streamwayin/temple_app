import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAnalyticsService {
  static FirebaseAnalytics? firebaseAnalytics;
  FirebaseAnalyticsService() {
    init();
  }

  void init() async {
    firebaseAnalytics = await FirebaseAnalytics.instance;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    firebaseAnalytics!.setAnalyticsCollectionEnabled(true);
    firebaseAnalytics!.setUserId(id: uid);
  }
}
