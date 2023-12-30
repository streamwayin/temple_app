import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/wallpaper/image/bloc/image_bloc.dart';
import 'package:temple_app/widgets/common_background_component.dart';

import '../widgets/single_wallpaper_component.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});
  static const String routeName = '/wallpaper-screen';
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('wallpaper').tr(),
          ),
          body: Stack(
            children: [
              const CommonBackgroundComponent(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  height: double.infinity,
                  child: GridView.builder(
                    itemCount: state.imageList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 290.h,
                        mainAxisSpacing: 2,
                        crossAxisCount: 2,
                        crossAxisSpacing: 2),
                    itemBuilder: (context, index) {
                      final imageModel = state.imageList[index];
                      return SingleWallpaperComponent(
                        wallpaperUrl: imageModel.thumbnail,
                        image: imageModel,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
