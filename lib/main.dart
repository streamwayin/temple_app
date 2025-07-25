import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:temple_app/constants.dart';
import 'package:temple_app/features/about-us/bloc/about_us_bloc.dart';
import 'package:temple_app/features/audio/bloc/play_audio_bloc.dart';
import 'package:temple_app/features/audio/play-audio-screen/bloc/play_audio_screen_bloc.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/bottom_bar/bloc/bottom_bar_bloc.dart';
import 'package:temple_app/features/ebook/ebook_list/bloc/ebook_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';
import 'package:temple_app/features/ebook/search/bloc/search_book_bloc.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/features/my-profile/bloc/profile_bloc.dart';
import 'package:temple_app/features/notification/bloc/notification_bloc.dart';
import 'package:temple_app/features/onboarding/bloc/splash_bloc.dart';
import 'package:temple_app/features/onboarding/screens/splash_screen.dart';
import 'package:temple_app/features/sightseen/bloc/sightseen_bloc.dart';
import 'package:temple_app/features/video/video-list/bloc/video_list_bloc.dart';
import 'package:temple_app/features/wallpaper/image-album/bloc/wallpaper_bloc.dart';
import 'package:temple_app/features/wallpaper/image/bloc/image_bloc.dart';
import 'package:temple_app/features/yatara/bloc/yatara_bloc.dart';
import 'package:temple_app/firebase_options.dart';
import 'package:temple_app/modals/notification_model.dart';
import 'package:temple_app/repositories/audo_repository.dart';
import 'package:temple_app/repositories/auth_repository.dart';
import 'package:temple_app/repositories/epub_repository.dart';
import 'package:temple_app/router.dart';
import 'package:temple_app/services/firebase_analytics_service.dart';
import 'package:temple_app/services/firebase_notification_service.dart';
import 'package:temple_app/widgets/custom_stack_with_bottom_player.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
@pragma('vm:entry-point')
Future<void> _firebaseMessengingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseNotificatonService firebaseNotificatonService =
      FirebaseNotificatonService();
  NotificationModel? notificationModel;
  Map<String, dynamic> map = {
    "type": "audio-track",
    "id": "",
    "index": 5,
    'title': "This is title",
    'body': "This is title  body"
  };
  if (remoteMessage.notification == null) {
    notificationModel = NotificationModel.fromJson(remoteMessage.data);
  } else {
    notificationModel = NotificationModel.fromJson(map);
  }
  firebaseNotificatonService.customSoundSwitchCase(
      notificationModel: notificationModel);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessengingBackgroundHandler);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
  ]);
  await EasyLocalization.ensureInitialized();
  FirebaseAnalyticsService().init();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
      ],
      path: 'assets/translations',
      startLocale: const Locale('hi', 'IN'),
      fallbackLocale: const Locale('hi', 'IN'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    AudioRepository audioRepository = AudioRepository();
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => AuthRepository(),
            ),
            RepositoryProvider(
              create: (context) => EpubRepository(),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthBloc(authRepository: AuthRepository()),
              ),
              BlocProvider(
                create: (context) =>
                    PlayAudioBloc(audioRepository: audioRepository)
                      ..add(PlayAudioEventInitial()),
              ),
              // BlocProvider(create: (context) => EbookBloc()),
              BlocProvider(create: (context) => EpubViewerBloc()),
              BlocProvider(create: (context) => SplashBloc()),
              BlocProvider(create: (context) => SearchBookBloc()),
              BlocProvider(
                  create: (context) => HomeBloc()..add(HomeEventInitial())),
              BlocProvider(
                  create: (context) =>
                      AboutUsBloc()..add(AboutUsInitialEvent())),
              BlocProvider(
                create: (context) =>
                    SightseenBloc()..add(SightseenEventInitial()),
              ),
              BlocProvider(
                  create: (context) =>
                      WallpaperBloc()..add(WallpaperInitialEvent())),
              BlocProvider(create: (context) => ImageBloc()),
              BlocProvider(
                  create: (context) =>
                      VideoListBloc()..add(VideoListInitialEvent())),
              BlocProvider(create: (context) => BottomBarBloc()),
              BlocProvider(
                  create: (context) => YataraBloc()..add(YataraInitialEvent())),
              BlocProvider(
                  create: (context) =>
                      EbookBloc()..add(FetchEpubListFromWebEvent())),
              BlocProvider(
                  create: (context) =>
                      PlayAudioScreenBloc(audioRepository: audioRepository)),
              BlocProvider(
                  create: (context) =>
                      NotificationBloc()..add(NotificationEventInitial())),
              BlocProvider(create: (context) => ProfileBloc()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              // showPerformanceOverlay: true,
              navigatorKey: navigatorKey,
              navigatorObservers: <NavigatorObserver>[observer],
              theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
                  useMaterial3: true,
                  scaffoldBackgroundColor: scaffoldBackground),

              builder: (context, child) =>
                  CustomStackWithBottomPlayer(child: child!),
              // builder: (context, child) => Text('data'),
              onGenerateRoute: (settings) => generateRoute(settings),
              initialRoute: SplashScreen.routeName,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              // home: const MyHomePage(),`
            ),
          ),
        );
      },
    );
  }
}
