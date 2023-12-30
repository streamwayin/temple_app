import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/wallpaper/image-album/bloc/wallpaper_bloc.dart';
import 'package:temple_app/features/wallpaper/image/bloc/image_bloc.dart';
import 'package:temple_app/features/wallpaper/image/image_screen.dart';

import 'package:temple_app/widgets/common_background_component.dart';

class ImageAlbumScreen extends StatelessWidget {
  const ImageAlbumScreen({super.key});
  static const String routeName = "/walpaper-screen";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WallpaperBloc, WallpaperState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('wallpaper').tr(),
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                const CommonBackgroundComponent(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GridView.builder(
                    itemCount: state.imageAlbumList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 100.h,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      final album = state.imageAlbumList[index];
                      return ImageAlbumComponent(
                        imagePath: album.thumbnail!,
                        name: album.title,
                        onTap: () {
                          context
                              .read<ImageBloc>()
                              .add(ImageInitialEvent(albumModel: album));
                          Navigator.pushNamed(context, ImageScreen.routeName);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ImageAlbumComponent extends StatelessWidget {
  const ImageAlbumComponent(
      {super.key,
      required this.imagePath,
      required this.name,
      required this.onTap});

  final String imagePath;
  final String name;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              height: 70.h,
              width: 70.w,
              child: CachedNetworkImage(imageUrl: imagePath),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
            ),
            Text(
              name,
              style: const TextStyle(fontFamily: "KRDEV020"),
            ).tr()
          ],
        ),
      ),
    );
  }
}
