import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';
import 'package:temple_app/features/home/screens/widgets/home_category_component.dart';
import 'package:temple_app/features/video/screens/video_screen.dart';
import 'package:temple_app/features/wallpaper/screens/wallpaper_screen.dart';
import 'package:gif_view/gif_view.dart';
import '../../../widgets/common_background_component.dart';
import '../../audio/bloc/play_audio_bloc.dart';

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

class SongPlayingIndicator extends StatelessWidget {
  const SongPlayingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayAudioBloc, PlayAudioState>(
      listener: (context, state) {},
      builder: (context, state) {
        PlayerState? playerState = state.musicPlayerDataModel?.playerState;

        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 64.0,
            height: 64.0,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
        } else if (processingState != ProcessingState.completed) {
          return SizedBox(
            height: 60,
            width: 80,
            child: GifView.asset(
              'assets/images/playing.gif',
              invertColors: true,
              height: 200,
              width: 200,
            ),
          );
        } else {
          return const SizedBox();
        }
        return const SizedBox();
      },
    );
  }
}

class MusicControlBar extends StatelessWidget {
  const MusicControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Adjust the height as needed
      color: Colors.grey[200], // Set the background color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.repeat),
            onPressed: () {
              // Handle repeat button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: () {
              // Handle previous button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () {
              // Handle pause button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () {
              // Handle next button press
            },
          ),
        ],
      ),
    );
  }
}
