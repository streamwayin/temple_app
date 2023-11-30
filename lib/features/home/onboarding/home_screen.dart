import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';
import 'package:temple_app/features/video/screens/video_screen.dart';
import 'package:temple_app/features/wallpaper/screens/wallpaper_screen.dart';
import 'package:gif_view/gif_view.dart';
import '../../../main.dart';
import '../../../widgets/common_background_component.dart';
import '../../audio/bloc/play_audio_bloc.dart';
import '../../audio/screens/play_audio_screen.dart';
import '../screens/widgets/home_category_component.dart';

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
    List<Map<String, String>> homeComponentList = [
      {
        "name": "Wallpapers",
        "imagePath": "assets/images/images.png",
        "routeName": WallpaperScreen.routeName
      },
      {
        "name": "Audio",
        "imagePath": "assets/images/volume.png",
        "routeName": AudioScreen.routeName
      },
      {
        "name": "Video",
        "imagePath": "assets/images/series.png",
        "routeName": VideoScreen.routeName
      },
      {
        "name": "E-Book",
        "imagePath": "assets/images/ebook.png",
        "routeName": EbookScreen.routeName
      }
    ];
    return Scaffold(
      // appBar: AppBar(
      //   title: const Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Text('Home Page'),
      //       // IconButton(
      //       //     onPressed: () {
      //       //       FirebaseAuth.instance.signOut();
      //       //     },
      //       //     icon: const Icon(Icons.logout)),
      //       SongPlayingIndicator()
      //     ],
      //   ),
      // ),
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
                  Map<String, String> category = homeComponentList[index];
                  return HomeCategoryComponent(
                    imagePath: category["imagePath"]!,
                    name: category["name"]!,
                    routeName: category['routeName']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

