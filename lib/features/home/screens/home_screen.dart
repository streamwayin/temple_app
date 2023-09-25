import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/features/home/screens/widgets/home_category_component.dart';
import 'package:temple_app/features/video/screens/video_screen.dart';
import 'package:temple_app/features/wallpaper/screens/wallpaper_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home-page';
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
      // {
      //   "name": "Wallpapers",
      //   "imagePath": "assets/images/images.png",
      //   "routeName": WallpaperScreen.routeName
      // }
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Home Page'),
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            height: double.infinity,
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
        ),
      ),
    );
  }
}
