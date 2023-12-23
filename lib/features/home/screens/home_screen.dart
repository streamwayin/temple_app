import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/bloc/play_audio_bloc.dart';
import 'package:temple_app/features/audio/screens/album_screen.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';
import 'package:temple_app/features/home/screens/widgets/home_category_component.dart';
import 'package:temple_app/features/video/screens/video_screen.dart';
import 'package:temple_app/features/wallpaper/screens/wallpaper_screen.dart';
import '../../../widgets/common_background_component.dart';
import '../../about-us/screens/about_us_bottom_nav_bar.dart';
import '../../contact-us/screens/contact_us_screen.dart';
import '../../sightseen/screens/sightseen_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home-page';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isControlBarExpanded = false;
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> homeComponentList = [
      {
        "name": "wallpaper",
        "imagePath": "assets/images/images.png",
        "routeName": WallpaperScreen.routeName,
        "onTap": () {
          Navigator.pushNamed(context, WallpaperScreen.routeName);
        }
      },
      {
        "name": "audio",
        "imagePath": "assets/images/volume.png",
        "routeName": AlbumScreen.routeName,
        "onTap": () {
          Navigator.pushNamed(context, AlbumScreen.routeName);
        }
      },
      {
        "name": "video",
        "imagePath": "assets/images/series.png",
        "routeName": VideoScreen.routeName,
        "onTap": () {
          Navigator.pushNamed(context, VideoScreen.routeName);
        }
      },
      {
        "name": "ebook",
        "imagePath": "assets/images/ebook.png",
        "routeName": EbookScreen.routeName,
        "onTap": () {
          Navigator.pushNamed(context, EbookScreen.routeName);
        }
      },
      {
        "name": "aboutUs",
        "imagePath": "assets/images/personal-information.png",
        "onTap": () {
          context
              .read<PlayAudioBloc>()
              .add(const ChangeOnAboutUsNavBar(onAboutUsNavBar: true));
          Navigator.pushNamed(context, AboutUsBottomNavBar.routeName);
        }
      },
      {
        "name": "contactUs",
        "imagePath": "assets/images/operator.png",
        "onTap": () {
          Navigator.pushNamed(context, ContactUsScreen.routeName);
        }
      },
      {
        "name": "Sightseen",
        "imagePath": "assets/images/operator.png",
        "onTap": () {
          Navigator.pushNamed(context, SigntseenScreen.routeName);
        }
      },
    ];
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            const CommonBackgroundComponent(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GridView.builder(
                itemCount: homeComponentList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 100.h,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  Map<String, dynamic> category = homeComponentList[index];
                  return HomeCategoryComponent(
                    imagePath: category["imagePath"]!,
                    name: category["name"]!,
                    // routeName: category['routeName']!,
                    onTap: category["onTap"],
                  );
                },
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     print('object');
            //     final db = FirebaseFirestore.instance;
            //     db.settings = const Settings(
            //       persistenceEnabled: true,
            //       cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
            //     );
            //   },
            //   child: const Text("enable presistance"),
            // ),
          ],
        ),
      ),
    );
  }
}
