import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/features/home/screens/widgets/home_category_component.dart';
import 'package:temple_app/features/video/screens/video_screen.dart';
import 'package:temple_app/features/wallpaper/screens/wallpaper_screen.dart';

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
        height: double.infinity,
        child: Stack(
          children: [
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
            (isControlBarExpanded)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isControlBarExpanded = false;
                      });
                    },
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                    ),
                  )
                : Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            isControlBarExpanded = true;
                          });
                        },
                        child: AnimatedContainer(
                            height: isControlBarExpanded
                                ? MediaQuery.of(context).size.height
                                : 60,
                            duration: const Duration(milliseconds: 10000),
                            child: MusicControlBar())))
          ],
        ),
      ),
    );
  }
}

class MusicControlBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Adjust the height as needed
      color: Colors.grey[200], // Set the background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.repeat),
            onPressed: () {
              // Handle repeat button press
            },
          ),
          IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: () {
              // Handle previous button press
            },
          ),
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              // Handle pause button press
            },
          ),
          IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: () {
              // Handle next button press
            },
          ),
        ],
      ),
    );
  }
}
