import 'package:flutter/material.dart';
import 'package:temple_app/features/audio/screens/album_screen.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/features/audio/screens/play_audio_screen.dart';
import 'package:temple_app/features/auth/screens/auth_screen.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';
import 'package:temple_app/features/ebook/ebook_view/epub_viewer_screen.dart';
import 'package:temple_app/features/ebook/search/screens/search_book_screen.dart';
import 'package:temple_app/features/home/screens/home_screen.dart';
import 'package:temple_app/features/onboarding/screens/onboarding_screen1.dart';
import 'package:temple_app/features/video/screens/video_screen.dart';
import 'package:temple_app/features/wallpaper/screens/wallpaper_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
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
      // int index = routeSettings.arguments as int;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PlayAudioScreen(),
      );
    case VideoScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const VideoScreen(),
      );
    case AlbumScreen.routeName:
      var index = routeSettings.arguments as int;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AlbumScreen(albumIndex: index),
      );
    case EbookScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const EbookScreen(),
      );
    case EpubViwerScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const EpubViwerScreen(),
      );
    case OnboardingScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OnboardingScreen(),
      );
    case SearchBookScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchBookScreen(),
      );

    default:
      return MaterialPageRoute(
          builder: (_) => const Center(
                child: Text('4o4 page not found'),
              ));
  }
}
