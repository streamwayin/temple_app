import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:temple_app/main.dart';
import 'package:temple_app/repositories/auth_repository.dart';

import '../features/notification/screens/notification_screen.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title : ${message.notification?.title}");
  print("Title : ${message.notification?.body}");
  print("Title : ${message.data}");
}

class FirebaseNotificatonService {
  final _firebaseMessenging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
      "high_importance_channel", "High Importance Notifications ",
      description: "This channel is used by push notification ",
      importance: Importance.defaultImportance);
  final _localNotification = FlutterLocalNotificationsPlugin();
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(
      NotificationSereen.routeName,
      arguments: message,
    );
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              _androidChannel.id, _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/app_logo'),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  int id = 0;
// tech brother
  void initLocalNotifications(RemoteMessage message) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@drawable/app_logo');
    var iosInitializationSettings = DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (details) {
        handleMessage(message);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    // print("notificaaaaaaaaaaaaaaaaationnnnnnnnnnnnnn");
    // // AndroidNotificationChannel channel = AndroidNotificationChannel(
    // //     Random.secure().nextInt(100000).toString(),
    // //     // 'channel-id-1',
    // //     'High Importance Notifications',
    // //     importance: Importance.max);
    // AndroidNotificationDetails androidNotificationDetails =
    //     AndroidNotificationDetails(
    //         // channel.id.toString(), channel.name.toString(),
    //         'your other channel id',
    //         'your other channel name',
    //         channelDescription: 'your channel description',
    //         importance: Importance.high,
    //         sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    //         priority: Priority.high,
    //         ticker: 'ticker');
    // DarwinNotificationDetails darwinNotificationDetails =
    //     DarwinNotificationDetails(
    //         presentAlert: true, presentBadge: true, presentSound: true);
    // NotificationDetails notificationDetails = NotificationDetails(
    //     android: androidNotificationDetails, iOS: darwinNotificationDetails);
    // Future.delayed(Duration.zero, () {
    //   _flutterLocalNotificationsPlugin.show(
    //       0,
    //       message.notification!.title.toString(),
    //       message.notification!.body.toString(),
    //       notificationDetails);
    // });
    if (id % 2 == 0) {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        channelDescription: 'your other channel description',
        sound: RawResourceAndroidNotificationSound('ramprasadji'),
      );
      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        sound: 'slow_spring_board.aiff',
      );
      final LinuxNotificationDetails linuxPlatformChannelSpecifics =
          LinuxNotificationDetails(
        sound: AssetsLinuxSound('sound/slow_spring_board.mp3'),
      );
      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
        macOS: darwinNotificationDetails,
        linux: linuxPlatformChannelSpecifics,
      );
      await _flutterLocalNotificationsPlugin.show(
        id++,
        'custom sound notification title',
        'custom sound notification body',
        notificationDetails,
      );
    } else {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'your other channel id 2',
        'your other channel name',
        channelDescription: 'your other channel description',
        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
      );
      const DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(
        sound: 'slow_spring_board.aiff',
      );
      final LinuxNotificationDetails linuxPlatformChannelSpecifics =
          LinuxNotificationDetails(
        sound: AssetsLinuxSound('sound/slow_spring_board.mp3'),
      );
      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
        macOS: darwinNotificationDetails,
        linux: linuxPlatformChannelSpecifics,
      );
      await _flutterLocalNotificationsPlugin.show(
        id++,
        'custom sound notification title',
        'custom sound notification body',
        notificationDetails,
      );
    }
  }

  Future<void> initNotification() async {
    await _firebaseMessenging.requestPermission();
    final fCMTOKEN = await _firebaseMessenging.getToken();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthRepository authRepository = AuthRepository();
      authRepository.addDeviceTokenToDB(user.uid, "$fCMTOKEN");
    }
    initPushNotifications();
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initLocalNotifications(message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }
}
