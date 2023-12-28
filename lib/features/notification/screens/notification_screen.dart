import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationSereen extends StatelessWidget {
  const NotificationSereen({super.key, required this.remoteMessage});
  static const String routeName = "/notification-screen";
  final RemoteMessage remoteMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${remoteMessage.notification?.title}"),
          Text("${remoteMessage.notification?.body}"),
          Text("${remoteMessage.data}"),
        ],
      ),
    );
  }
}
