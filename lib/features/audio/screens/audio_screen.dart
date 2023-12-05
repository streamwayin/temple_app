import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/screens/album_screen.dart';
import 'package:temple_app/widgets/utils.dart';

import '../bloc/play_audio_bloc.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});
  static const String routeName = '/audio-screen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Albums'),
          ],
        ),
      ),
      body: BlocBuilder<PlayAudioBloc, PlayAudioState>(
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocConsumer<PlayAudioBloc, PlayAudioState>(
                        listener: (context, state) {
                          if (state.isTracksAvailable != null) {
                            context
                                .read<PlayAudioBloc>()
                                .add(const LoadCurrentPlaylistEvent());
                          }
                        },
                        builder: (context, state) {
                          return Expanded(
                            child: ReorderableListView.builder(
                              itemCount: state.albums.length,
                              onReorder: (oldIndex, newIndex) {
                                context.read<PlayAudioBloc>().add(
                                    AlbumIndexChanged(
                                        newIndex: newIndex,
                                        oldIndex: oldIndex));
                              },
                              itemBuilder: (context, index) {
                                var album = state.albums[index];
                                return GestureDetector(
                                  key: Key('$index'),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AlbumScreen.routeName,
                                        arguments: index);
                                    context.read<PlayAudioBloc>().add(
                                        UpdateSelectedAlbumIndex(index: index));
                                    context.read<PlayAudioBloc>().add(
                                        FetchSongsOfAlbum(
                                            albumId: album.albumId));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 45.h,
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                        255, 233, 232, 232)
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: (album.thumbnail != null)
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            album.thumbnail!,
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.asset(
                                                          'assets/images/sound-waves.png'),
                                                    ),
                                            ),
                                            state.currentAlbumIndex != null &&
                                                    state
                                                            .albums[state
                                                                .currentAlbumIndex!]
                                                            .albumId ==
                                                        state.albums[index]
                                                            .albumId
                                                ? SizedBox(
                                                    height: 45.h,
                                                    width: 50.w,
                                                    child: Image.asset(
                                                      'assets/images/music.gif',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        SizedBox(width: 5.w),
                                        SizedBox(
                                          width: size.width - 110.w,
                                          child: Text(
                                            album.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
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
                    ],
                  ),
                ),
              ),
              (state.albumsPageLoading == true)
                  ? Utils.showLoadingOnSceeen()
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }
}
