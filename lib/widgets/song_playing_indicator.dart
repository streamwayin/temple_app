import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../features/audio/bloc/play_audio_bloc.dart';
import '../features/audio/screens/play_audio_screen.dart';
import '../main.dart';

class SongPlayingIndicator extends StatelessWidget {
  const SongPlayingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<PlayAudioBloc, PlayAudioState>(
      listener: (context, state) {},
      builder: (context, state) {
        PlayerState? playerState = state.musicPlayerDataModel?.playerState;
        MediaItem? sequenceState;
        if (state.musicPlayerDataModel != null) {
          sequenceState = state.musicPlayerDataModel!.sequenceState
              ?.currentSource?.tag as MediaItem;
        }

        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (1 == 2) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 64.0,
            height: 64.0,
            child: const CircularProgressIndicator(),
          );
        } else if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering ||
            processingState != ProcessingState.completed ||
            playing != true) {
          return InkWell(
            onTap: () {
              Navigator.of(navigatorKey.currentContext!)
                  .pushNamed(PlayAudioScreen.routeName);
            },
            child: sequenceState == null
                ? const SizedBox()
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 60.0,
                    decoration: BoxDecoration(
                      // color: Colors.orange[600],
                      color: const Color.fromARGB(237, 56, 48, 59),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _gap(5),
                        Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                              color: Colors.orange[600],
                              borderRadius: BorderRadius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: sequenceState.artUri.toString(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                        _gap(10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sequenceState.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                sequenceState.artist!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          iconSize: 40,
                          onPressed: () {
                            context
                                .read<PlayAudioBloc>()
                                .add(const ChangeSongEvent(previous: true));
                          },
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            color: Colors.orange[600],
                          ),
                        ),
                        BlocConsumer<PlayAudioBloc, PlayAudioState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            PlayerState? playerState =
                                state.musicPlayerDataModel?.playerState;

                            final processingState =
                                playerState?.processingState;
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
                              return IconButton(
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.orange[600],
                                ),
                                iconSize: 40.0,
                                onPressed: () {
                                  context.read<PlayAudioBloc>().add(
                                      const PlayOrPauseSongEvent(play: true));
                                },
                              );
                            } else if (processingState !=
                                ProcessingState.completed) {
                              return IconButton(
                                icon: Icon(
                                  Icons.pause,
                                  color: Colors.orange[600],
                                ),
                                iconSize: 40.0,
                                onPressed: () {
                                  context.read<PlayAudioBloc>().add(
                                      const PlayOrPauseSongEvent(play: false));
                                },
                              );
                            } else {
                              return IconButton(
                                icon: Icon(
                                  Icons.replay,
                                  color: Colors.orange[600],
                                ),
                                iconSize: 40.0,
                                onPressed: () {
                                  // player.seek(Duration.zero)
                                },
                              );
                            }
                          },
                        ),
                        IconButton(
                          iconSize: 40,
                          onPressed: () {
                            context
                                .read<PlayAudioBloc>()
                                .add(const ChangeSongEvent(next: true));
                          },
                          icon: Icon(
                            Icons.skip_next_rounded,
                            color: Colors.orange[600],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  SizedBox _gap(int width) {
    return SizedBox(
      width: width.w,
    );
  }
}
