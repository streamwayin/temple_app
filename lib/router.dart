import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:temple_app/features/about-us/screens/about_us_bottom_nav_bar.dart';
import 'package:temple_app/features/about-us/screens/about_us_screen.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/features/audio/screens/album_screen.dart';
import 'package:temple_app/features/audio/screens/play_audio_screen.dart';
import 'package:temple_app/features/auth/screens/auth_screen.dart';
import 'package:temple_app/features/contact-us/screens/contact_us_screen.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';
import 'package:temple_app/features/ebook/ebook_view/epub_viewer_screen.dart';
import 'package:temple_app/features/ebook/pdf_view/pdf_view_screen.dart';
import 'package:temple_app/features/ebook/search/screens/search_book_screen.dart';
import 'package:temple_app/features/home/screens/home_screen.dart';
import 'package:temple_app/features/notification/screens/notification_screen.dart';
import 'package:temple_app/features/onboarding/screens/onboarding_screen1.dart';
import 'package:temple_app/features/onboarding/screens/splash_screen.dart';
import 'package:temple_app/features/sightseen/screens/sightseen_screen.dart';
import 'package:temple_app/features/sightseen/screens/single_sightseen_screen.dart';
import 'package:temple_app/features/video/video-list/screens/video_list_screen.dart';
import 'package:temple_app/features/video/video-screen/video_screen.dart';
import 'package:temple_app/features/wallpaper/image/image_screen.dart';
import 'package:temple_app/features/wallpaper/image-album/image_album_screen.dart';
import 'package:temple_app/modals/ebook_model.dart';
import 'package:temple_app/features/bottom_bar/bottom_bar.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SplashScreen(),
      );
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
    case ImageAlbumScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ImageAlbumScreen(),
      );
    case ImageScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ImageScreen(),
      );
    case AudioScreen.routeName:
      var index = routeSettings.arguments as int;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AudioScreen(albumIndex: index),
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
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AlbumScreen(),
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
    case AboutUsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AboutUsScreen(),
      );
    case ContactUsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ContactUsScreen(),
      );
    case AboutUsBottomNavBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AboutUsBottomNavBar(),
      );
    case SigntseenScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SigntseenScreen(),
      );
    case PdfScreenScreen.routeName:
      final EbookModel book = routeSettings.arguments as EbookModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => PdfScreenScreen(book: book),
      );
    case SingleSightseenScreen.routeName:
      var index = routeSettings.arguments as int;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SingleSightseenScreen(index: index),
      );
    case NotificationSereen.routeName:
      var remoteMessage = routeSettings.arguments as RemoteMessage;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => NotificationSereen(remoteMessage: remoteMessage),
      );
    case VideoListScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => VideoListScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => BottomBar(),
      );

    default:
      return MaterialPageRoute(
          builder: (_) => const Center(
                child: Text(''),
              ));
  }
}
