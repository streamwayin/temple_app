import 'package:flutter/material.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/features/audio/screens/play_audio_screen.dart';
import 'package:temple_app/features/home/screens/home_screen.dart';
import 'package:temple_app/features/video/screens/video_screen.dart';
import 'package:temple_app/features/wallpaper/screens/wallpaper_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case WallpaperScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const WallpaperScreen(),
      );
    case AudioScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AudioScreen(),
      );
    case PlayAudioScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PlayAudioScreen(),
      );
    case VideoScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const VideoScreen(),
      );

    default:
      return MaterialPageRoute(
          builder: (_) => const Center(
                child: Text('4o4 page not found'),
              ));
  }
}
