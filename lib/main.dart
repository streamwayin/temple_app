import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:temple_app/features/audio/bloc/play_audio_bloc.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/auth/screens/auth_screen.dart';
import 'package:temple_app/features/home/screens/home_screen.dart';
import 'package:temple_app/firebase_options.dart';
import 'package:temple_app/repositories/auth_repository.dart';
import 'package:temple_app/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return RepositoryProvider(
              create: (context) => AuthRepository(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        AuthBloc(authRepository: AuthRepository()),
                  ),
                  BlocProvider(
                      create: (context) =>
                          PlayAudioBloc()..add(GetAudioListFromWebEvent())),
                ],
                child: MaterialApp(
                  title: 'Flutter Demo',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  onGenerateRoute: (settings) => generateRoute(settings),
                  home: StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        // if user logged in we show bottom bar
                        if (snapshot.hasData) {
                          return const HomeScreen();
                        }
                        // if user  is not logged in we show onboarding screen
                        return const AuthScreen();
                      }),
                ),
              ));
        });
  }
}
