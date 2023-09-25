import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/constants.dart';
import 'dart:developer' as lgr;

import '../widgets/single_wallpaper_component.dart';

class WallpaperScreen extends StatelessWidget {
  const WallpaperScreen({super.key});
  static const String routeName = '/wallpaper-screen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallpapers'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          height: double.infinity,
          child: GridView.builder(
            itemCount: wallpaperImagesList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 290.h,
                mainAxisSpacing: 2,
                crossAxisCount: 2,
                crossAxisSpacing: 2),
            itemBuilder: (context, index) {
              wallpaperImagesList[index];
              return SingleWallpaperComponent(
                wallpaperUrl: wallpaperImagesList[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
