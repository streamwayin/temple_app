import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/wallpaper/image/bloc/image_bloc.dart';
import 'package:temple_app/modals/image_model.dart';
import 'package:temple_app/widgets/common_background_component.dart';
import 'package:temple_app/widgets/utils.dart';

import '../widgets/single_wallpaper_component.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});
  static const String routeName = '/wallpaper-screen';

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ImageBloc, ImageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: Utils.buildAppBarWithBackButton(),
          body: Stack(
            children: [
              // const CommonBackgroundComponent(),
              PageView.builder(
                scrollDirection: Axis.vertical,
                controller: _pageController,
                itemCount: state.imageList.length,
                itemBuilder: (context, index) {
                  final imageModel = state.imageList[index];
                  return SingleWallpaperComponent(
                    image: imageModel,
                  );
                  //  _buildPage(state.imageList[index]);
                },
              ),
              // SizedBox(
              //   height: size.height,
              //   child: ListView.builder(
              //     itemBuilder: (context, index) {
              //       final imageModel = state.imageList[index];
              //       return SingleWallpaperComponent(
              //         wallpaperUrl: imageModel.thumbnail,
              //         image: imageModel,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPage(ImageModel imageModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors
            .blue, // You can replace this with an Image.network(image) widget
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            imageModel.thumbnail,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
