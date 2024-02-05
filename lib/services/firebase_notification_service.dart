import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/features/bottom_bar/bloc/bottom_bar_bloc.dart';
import 'package:temple_app/features/ebook/ebook_list/bloc/ebook_bloc.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/features/notification/screens/notification_screen.dart';
import 'package:temple_app/features/video/video-list/bloc/video_list_bloc.dart';
import 'package:temple_app/features/wallpaper/image/bloc/image_bloc.dart';
import 'package:temple_app/features/yatara/yatara_screen.dart';
import 'package:temple_app/main.dart';
import 'package:temple_app/modals/ebook_model.dart';
import 'package:temple_app/modals/image_album_model.dart';
import 'package:temple_app/modals/notification_model.dart';
import 'package:temple_app/modals/track_model.dart';
import 'package:temple_app/modals/video_album_model_db.dart';
import 'package:temple_app/repositories/audo_repository.dart';
import 'package:temple_app/repositories/auth_repository.dart';
import 'package:temple_app/repositories/epub_repository.dart';
import 'package:temple_app/repositories/video_repository.dart';
import 'package:temple_app/repositories/wallpaper_repository.dart';

import '../features/audio/bloc/play_audio_bloc.dart';

class FirebaseNotificatonService {
  final _firebaseMessenging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void handleMessage(BuildContext context, RemoteMessage? message) async {
    if (message == null) return;
    Map<String, dynamic> map = {
      "type": "tracks",
      "id": "07Y36T491UdbDZjosua8",
      "index": 5,
      'title': "This is title",
      'body': "This is title  body"
    };
    NotificationModel notificationModel = NotificationModel.fromJson(map);
    print(notificationModel.type);
    switch (notificationModel.type) {
      // PersistentNavBarNavigator.pushNewScreen(
      //   context,
      //   screen: AudioScreen(),
      //   withNavBar: true, // OPTIONAL VALUE. True by default.
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      // );
      case 'tracks':
        {
          print("indide case");
          AudioRepository audioRepository = AudioRepository();
          TrackModel? trackModel = await audioRepository
              .getTrackDataFromDbForNotifications(docId: notificationModel.id);
          if (trackModel == null) break;
          context
              .read<BottomBarBloc>()
              .add(ChangeCurrentPageIndex(newIndex: 2));
          // context
          //     .read<PlayAudioBloc>()
          //     .add(NavigateFromNotificaionScreenToPlayAudioScreen());
          // go to play song

          context
              .read<PlayAudioBloc>()
              .add(PlaySingleSongFromNotificationEvent(trackModel: trackModel));
          print("indide case finish");
          break;
        }
      case 'albums':
        {
          print("indide case");
          context
              .read<BottomBarBloc>()
              .add(ChangeCurrentPageIndex(newIndex: 2));
          context.read<PlayAudioBloc>().add(NavigateFromNotificaionScreen());
          context
              .read<PlayAudioBloc>()
              .add(FetchSongsOfAlbum(albumId: notificationModel.id));
          print("indide case finish");
          break;
        }
      case 'video-album':
        {
          print("indide case");
          context
              .read<BottomBarBloc>()
              .add(ChangeCurrentPageIndex(newIndex: 1));
          context
              .read<VideoListBloc>()
              .add(NavigateFromNotificaionVidoeAlbumEvent());
          VideoRepository videoRepository = VideoRepository();
          VideoAlbumModelDb? videoAlbumModel = await videoRepository
              .getSingleVideoAlubmFromDbForNotification(notificationModel.id);
          if (videoAlbumModel == null) return;

          context
              .read<VideoListBloc>()
              .add(FetchVideoModelList(playlistId: videoAlbumModel.playlistId));

          print("indide case finish");
          break;
        }
      case 'books':
        {
          context
              .read<BottomBarBloc>()
              .add(ChangeCurrentPageIndex(newIndex: 3));
          context.read<EbookBloc>().add(NavigateFromNotificaionBookEvent());
          EpubRepository epubRepository = EpubRepository();
          EbookModel? ebookModel =
              await epubRepository.getSingleBookDataFromDbForNotification(
                  docId: notificationModel.id);
          if (ebookModel == null) break;
          context
              .read<EbookBloc>()
              .add((DownloadBookEventEbookList(book: ebookModel)));

          print("indide case finish");
          break;
        }
      case 'image-albums':
        {
          context
              .read<BottomBarBloc>()
              .add(ChangeCurrentPageIndex(newIndex: 0));

          context
              .read<HomeBloc>()
              .add(NavigateFromNotificaionToImageFromHomeEvent());

          WallpaperRepository wallpaperRepository = WallpaperRepository();
          ImageAlbumModel? imageAlbumModel = await wallpaperRepository
              .getSingleImageAlbumFromDbForNorification(
                  docId: notificationModel.id);
          if (imageAlbumModel == null) break;
          context.read<ImageBloc>().add(ImageInitialEvent(
              albumModel:
                  imageAlbumModel)); //     navigationString: ImageAlbumScreen.routeName));

          print("indide case finish");
          break;
        }
    }
    // navigatorKey.currentState?.pushNamed(
    //   NotificationSereen.routeName,
    //   arguments: message,
    // );
  }

  int id = 0;
// tech brother
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        AndroidInitializationSettings('@drawable/app_logo');
    var iosInitializationSettings = DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (details) {
        handleMessage(context, message);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    // message.ti
    Map<String, dynamic> map = {
      "type": "audio-album",
      "id": "",
      "index": 5,
      'title': "This is title",
      'body': "This is title  body"
    };
    NotificationModel notificationModel = NotificationModel.fromJson(map);

    customSoundSwitchCase(notificationModel: notificationModel);
  }

  Future<void> initNotification(BuildContext context) async {
    await _firebaseMessenging.requestPermission();
    // await requestNotificationPermission();
    final fCMTOKEN = await _firebaseMessenging.getToken();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AuthRepository authRepository = AuthRepository();
      authRepository.addDeviceTokenToDB(user.uid, "$fCMTOKEN");
    }
    //  initPushNotifications(); // not from tech brother

    FirebaseMessaging.onMessage.listen((message) {
      print('================');
      print(message.toString());

      print('${message.notification?.title}');
      print('${message.notification?.body}');
      print(message.data.toString());
      print('================');

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);

        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessenging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted provisional permission');
    } else {
      // SystemSettings.appNotifications();
      AppSettings.openAppSettings();
      print('user denied permission');
    }
  }

  swithchCaseShowNotification(
      {required String channelId,
      required String notificationSound,
      required NotificationModel notificationModel}) async {
    print(notificationSound);
    AndroidNotificationChannel channel =
        AndroidNotificationChannel(channelId, 'High importance Notifications');
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: 'your other channel description',
            sound: RawResourceAndroidNotificationSound(notificationSound),
            icon: '@drawable/launcher_icon',
            priority: Priority.high,
            importance: Importance.high,
            ticker: 'ticker');
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'slow_spring_board.aiff',
    );
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.show(
      id++,
      notificationModel.title,
      notificationModel.body,
      notificationDetails,
    );
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // print("hereeeeeeeeeeeeeee");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => YataraScreen()));
      handleMessage(context, initialMessage);
    }
    //when app ins inbackground
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void customSoundSwitchCase({required NotificationModel notificationModel}) {
    int index = notificationModel.index;
    String channelId = Random.secure().nextInt(100000).toString();
    switch (index) {
      case 0:
        {
          swithchCaseShowNotification(
              channelId: channelId,
              notificationModel: notificationModel,
              notificationSound: 'notification_sound_0');
          break;
        }
      case 1:
        {
          swithchCaseShowNotification(
              channelId: channelId,
              notificationModel: notificationModel,
              notificationSound: 'notification_sound_1');
          break;
        }
      case 2:
        {
          swithchCaseShowNotification(
              channelId: channelId,
              notificationModel: notificationModel,
              notificationSound: 'notification_sound_2');
          break;
        }
      case 3:
        {
          swithchCaseShowNotification(
              channelId: channelId,
              notificationModel: notificationModel,
              notificationSound: 'notification_sound_3');
          break;
        }
      case 4:
        {
          swithchCaseShowNotification(
              channelId: channelId,
              notificationModel: notificationModel,
              notificationSound: 'notification_sound_4');
          break;
        }
      case 5:
        {
          swithchCaseShowNotification(
              channelId: channelId,
              notificationModel: notificationModel,
              notificationSound: 'notification_sound_5');
          break;
        }
      case 6:
        {
          swithchCaseShowNotification(
              channelId: channelId,
              notificationModel: notificationModel,
              notificationSound: 'notification_sound_6');
          break;
        }
      default:
        {
          swithchCaseShowNotification(
              channelId: channelId,
              notificationModel: notificationModel,
              notificationSound: 'notification_sound_6');
          print("default");
          break;
        }
    }
  }
}
