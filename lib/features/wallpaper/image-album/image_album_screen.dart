import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/wallpaper/image-album/bloc/wallpaper_bloc.dart';
import 'package:temple_app/features/wallpaper/image/bloc/image_bloc.dart';
import 'package:temple_app/features/wallpaper/image/image_screen.dart';
import 'package:temple_app/modals/image_album_model.dart';
import 'package:temple_app/repositories/wallpaper_repository.dart';
import 'package:temple_app/services/firebase_analytics_service.dart';

import 'package:temple_app/widgets/utils.dart';

class ImageAlbumScreen extends StatelessWidget {
  const ImageAlbumScreen({super.key});
  static const String routeName = "/walpaper-screen";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WallpaperBloc, WallpaperState>(
      builder: (context, state) {
        return Scaffold(
          appBar: Utils.buildAppBarWithBackButton(context),
          body: RefreshIndicator(
            onRefresh: () => onRefresh(context),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Utils.templeBackground(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: GridView.builder(
                      itemCount: state.imageAlbumList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 220.h,
                        // childAspectRatio: 9 / 16,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        final album = state.imageAlbumList[index];
                        return ImageAlbumComponent(
                          imagePath: album.thumbnail!,
                          name: album.title,
                          onTap: () {
                            context.read<ImageBloc>().add(ImageInitialEvent(
                                albumModel:
                                    album)); //     navigationString: ImageAlbumScreen.routeName));
                            FirebaseAnalyticsService.firebaseAnalytics!
                                .logEvent(name: "screen_view", parameters: {
                              "TITLE": ImageScreen.routeName
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ImageScreen()));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onRefresh(BuildContext context) async {
    WallpaperRepository wallpaperRepo = WallpaperRepository();
    List<ImageAlbumModel>? imageAlbumList =
        await wallpaperRepo.getImageAlbumFromDb();
    if (imageAlbumList != null) {
      var tempList = imageAlbumList;
      tempList.sort((a, b) => (a.index).compareTo(b.index));
      context.read<WallpaperBloc>().add(
          AddImageAlbumModelFromRefreshIndicator(imageAlbumModel: tempList));
    }
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
          color: Color.fromARGB(166, 245, 214, 168),
          // border: Border.all(color: const Color.fromARGB(255, 133, 80, 2)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              height: 170.h,
              width: 110.w,
              child: CachedNetworkImage(
                imageUrl: imagePath,
                fit: BoxFit.cover,
              ),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
            ),
            Text(
              name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "KRDEV020",
              ),
            ).tr()
          ],
        ),
      ),
    );
  }
}
