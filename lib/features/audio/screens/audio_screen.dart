import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/screens/album_screen.dart';
import 'package:temple_app/features/audio/screens/play_audio_screen.dart';

import '../bloc/play_audio_bloc.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});
  static const String routeName = '/audio-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<PlayAudioBloc, PlayAudioState>(
                builder: (context, state) {
                  return Expanded(
                    child: ReorderableListView.builder(
                      itemCount: state.albums.length,
                      onReorder: (oldIndex, newIndex) {
                        context.read<PlayAudioBloc>().add(AlbumIndexChanged(
                            newIndex: newIndex, oldIndex: oldIndex));
                      },
                      itemBuilder: (context, index) {
                        var album = state.albums[index];
                        return GestureDetector(
                          key: Key('$index'),
                          onTap: () {
                            Navigator.pushNamed(context, AlbumScreen.routeName,
                                arguments: index);
                            context.read<PlayAudioBloc>().add(
                                LoadCurrentPlaylistEvent(albumIndex: index));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  color: Colors.grey,
                                  height: 50,
                                  width: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: album.thumbnail,
                                    fit: BoxFit.cover,
                                    // 'https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/album%20thumbnail%2Fhanumanji.jpg?alt=media&token=8850ddc4-9997-4511-a483-90d370c22acb',
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  album.name,
                                  style: const TextStyle(fontSize: 24),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // GestureDetector(
              //   onTap: () {},
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Image.asset(
              //         'assets/images/folder.png',
              //         scale: 12,
              //       ),
              //       SizedBox(width: 5.w),
              //       const Text(
              //         'My fav',
              //         style: TextStyle(fontSize: 24),
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
