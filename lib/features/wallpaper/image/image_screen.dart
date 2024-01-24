import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/features/wallpaper/image/bloc/image_bloc.dart';
import 'package:temple_app/modals/image_model.dart';
import 'package:temple_app/repositories/wallpaper_repository.dart';
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
          body: RefreshIndicator(
            onRefresh: () => onRefresh(state.currentAlbumId),
            child: PageView.builder(
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

  Future<void> onRefresh(String albumId) async {
    WallpaperRepository wallpaperRepository = WallpaperRepository();
    List<ImageModel>? imageList =
        await wallpaperRepository.getImageFromDb(albumId);
    if (imageList != null) {
      var tempList = imageList;
      tempList.sort((a, b) => (a.index).compareTo(b.index));
      context
          .read<ImageBloc>()
          .add(AddImageListFromRefreshIndicator(imageList: tempList));
    }
  }
}
