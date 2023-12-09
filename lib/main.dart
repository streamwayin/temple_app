import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:temple_app/features/audio/bloc/play_audio_bloc.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/ebook/ebook_list/bloc/ebook_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';
import 'package:temple_app/features/ebook/search/bloc/search_book_bloc.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/features/onboarding/bloc/splash_bloc.dart';
import 'package:temple_app/features/onboarding/screens/splash_screen.dart';
import 'package:temple_app/firebase_options.dart';
import 'package:temple_app/repositories/auth_repository.dart';
import 'package:temple_app/repositories/epub_repository.dart';
import 'package:temple_app/router.dart';
import 'package:temple_app/widgets/custom_stack_with_bottom_player.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await EasyLocalization.ensureInitialized();
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

  @override
  Widget build(BuildContext context) {
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
                    PlayAudioBloc()..add(PlayAudioEventInitial()),
              ),
              BlocProvider(
                create: (context) => EbookBloc(repository: EpubRepository())
                  ..add(FetchEpubListEvent()),
              ),
              BlocProvider(create: (context) => EpubViewerBloc()),
              BlocProvider(create: (context) => SplashBloc()),
              BlocProvider(create: (context) => SearchBookBloc()),
              BlocProvider(create: (context) => HomeBloc()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
                useMaterial3: true,
              ),
              builder: (context, child) =>
                  CustomStackWithBottomPlayer(child: child!),
              // builder: (context, child) => Text('data'),
              onGenerateRoute: (settings) => generateRoute(settings),
              initialRoute: SplashScreen.routeName,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              // home: const MyHomePage(),
            ),
          ),
        );
      },
    );
  }
}
