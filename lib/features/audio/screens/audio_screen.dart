import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/screens/play_audio_screen.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/modals/track_model.dart';

import '../../../widgets/utils.dart';
import '../bloc/play_audio_bloc.dart';

//AudioScreen
class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key, required this.albumIndex});
  final int albumIndex;
  static const String routeName = '/album-screen';
  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    Size size = MediaQuery.of(context).size;
    onReorder(oldIndex, newIndex) {
      context.read<PlayAudioBloc>().add(SongIndexChanged(
          newIndex: newIndex, oldIndex: oldIndex, albumIndex: albumIndex));
    }

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PlayAudioBloc, PlayAudioState>(
          builder: (context, state) {
            List<TrackModel>? songList = state.tracks;
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0)
                      .copyWith(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(
                            width: size.width - 150.w,
                            child: Text(
                              state.albums[albumIndex].name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              context
                                  .read<PlayAudioBloc>()
                                  .add(const PlayOrPauseSongEvent(play: true));
                              Navigator.pushNamed(
                                  context, PlayAudioScreen.routeName);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 25.h,
                              width: 70.w,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text("Play All"),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * .89,
                        child: songList == null
                            ? (state.tracksPageLoading == true)
                                ? const SizedBox()
                                : const Center(
                                    child: Text("Unable to fetch data"),
                                  )
                            : ReorderableListView.builder(
                                itemBuilder: (context, ind) {
                                  TrackModel song = songList[ind];
                                  return Padding(
                                    key: Key(ind.toString()),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: ListTile(
                                      // on tap audio
                                      onTap: () =>
                                          tapOnsongTile(context, state, ind),
                                      leading: (song.thumbnail != null)
                                          ? SizedBox(
                                              width: 55.w,
                                              height: 55.h,
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: CachedNetworkImage(
                                                      imageUrl: song.thumbnail!,
                                                      placeholder: (context,
                                                              url) =>
                                                          Image.asset(
                                                              'assets/images/sound-waves.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  state.currentPlaylistTracks != null &&
                                                          state.singleSongIndex !=
                                                              null &&
                                                          state
                                                                  .currentPlaylistTracks![
                                                                      state
                                                                          .singleSongIndex!]
                                                                  .trackId ==
                                                              state.tracks![ind]
                                                                  .trackId &&
                                                          state.showBottomMusicController ==
                                                              true
                                                      ? Positioned(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            height: 55.h,
                                                            width: 55.w,
                                                            child: SizedBox(
                                                              height: 10.h,
                                                              width: 10.w,
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/music.gif',
                                                                // fit: BoxFit
                                                                //     .contain,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      title: Text(
                                        currentLocale.languageCode == "hi"
                                            ? song.translated.hi
                                            : song.title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  );
                                },
                                itemCount: songList.length,
                                onReorder: onReorder,
                              ),
                      )
                    ],
                  ),
                ),
                (state.tracksPageLoading == true)
                    ? Utils.showLoadingOnSceeen()
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }

  tapOnsongTile(BuildContext context, PlayAudioState state, int ind) {
    if (state.currentAlbumId != state.currentPlaylistAlbumId) {
      context
          .read<PlayAudioBloc>()
          .add(LoadCurrentPlaylistEvent(initialIndex: ind));
      context.read<PlayAudioBloc>().add(ChangeCurrentPlaylistAlbumId());
    } else {
      context.read<PlayAudioBloc>().add(PlaySinglesongEvent(index: ind));
    }

    context.read<PlayAudioBloc>().add(const PlayOrPauseSongEvent(play: true));
    context
        .read<HomeBloc>()
        .add(const ChangeOnPlayAudioSreenOrNot(onPlayAudioScreen: true));
    context.read<PlayAudioBloc>().add(
          const ChangeShowBottomMusicController(
              changeShowBottomMusicController: true),
        );
    Navigator.pushNamed(context, PlayAudioScreen.routeName);

    context.read<PlayAudioBloc>().add(const SaveCurrentAlbumToLocalStorage());
    context.read<PlayAudioBloc>().add(SavePlayingTracksEvent());
  }
}
