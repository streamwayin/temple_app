import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/features/audio/screens/play_audio_screen.dart';
import 'package:temple_app/modals/album_model.dart';

import '../bloc/play_audio_bloc.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key, required this.albumIndex});
  final int albumIndex;
  static const String routeName = '/album-screen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    onReorder(oldIndex, newIndex) {
      context.read<PlayAudioBloc>().add(SongIndexChanged(
          newIndex: newIndex, oldIndex: oldIndex, albumIndex: albumIndex));
    }

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PlayAudioBloc, PlayAudioState>(
          builder: (context, state) {
            List<Song> songList = state.albums[albumIndex].songList;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.albums[albumIndex].name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: size.height * .9,
                    child: ReorderableListView.builder(
                      itemBuilder: (context, ind) {
                        Song song = songList[ind];
                        return ListTile(
                          key: Key(ind.toString()),
                          onTap: () {
                            Navigator.pushNamed(
                                context, PlayAudioScreen.routeName,
                                arguments: ind);
                          },
                          leading: (song.songThumbnail != null)
                              ? CachedNetworkImage(
                                  imageUrl: song.songThumbnail!,
                                  placeholder: (context, url) => Image.asset(
                                      'assets/images/sound-waves.png'),
                                )
                              : const SizedBox(),
                          title: Text(song.songName),
                        );
                      },
                      itemCount: songList.length,
                      onReorder: onReorder,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
