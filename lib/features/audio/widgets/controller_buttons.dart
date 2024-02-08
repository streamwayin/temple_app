import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:temple_app/features/audio/bloc/play_audio_bloc.dart';

import '../../../constants.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<PlayAudioBloc, PlayAudioState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDownloadButton(state, context),
              SizedBox(
                width: size.width * .18,
                child: IconButton(
                  iconSize: 50,
                  onPressed: () {
                    context
                        .read<PlayAudioBloc>()
                        .add(const ChangeSongEvent(previous: true));
                  },
                  icon: SvgPicture.asset('assets/svg/previous.svg'),
                ),
              ),
              SizedBox(
                width: size.width * .18,
                child: BlocConsumer<PlayAudioBloc, PlayAudioState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    PlayerState? playerState =
                        state.musicPlayerDataModel?.playerState;

                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return IconButton(
                        icon: SvgPicture.asset('assets/svg/pause.svg'),
                        iconSize: 40.0,
                        onPressed: () {
                          // context
                          //     .read<PlayAudioBloc>()
                          //     .add(const PlayOrPauseSongEvent(play: true));
                        },
                      );
                    } else if (playing != true) {
                      return IconButton(
                        icon: const Icon(Icons.play_arrow),
                        iconSize: 40.0,
                        onPressed: () {
                          context
                              .read<PlayAudioBloc>()
                              .add(const PlayOrPauseSongEvent(play: true));
                        },
                      );
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                        icon: SvgPicture.asset('assets/svg/pause.svg'),
                        iconSize: 60.0,
                        onPressed: () {
                          context
                              .read<PlayAudioBloc>()
                              .add(const PlayOrPauseSongEvent(play: false));
                        },
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.replay),
                        iconSize: 40.0,
                        onPressed: () {
                          context.read<PlayAudioBloc>().add(ReplaySongEvent());
                          // player.seek(Duration.zero)
                        },
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                width: size.width * .18,
                child: IconButton(
                  iconSize: 50,
                  onPressed: () {
                    context
                        .read<PlayAudioBloc>()
                        .add(const ChangeSongEvent(next: true));
                  },
                  icon: SvgPicture.asset('assets/svg/next.svg'),
                ),
              ),
              Icon(Icons.more_horiz)
            ],
          ),
        );
      },
    );
  }

  Container _buildDownloadButton(PlayAudioState state, BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: indicatorColor, borderRadius: BorderRadius.circular(70)),
        height: 30.h,
        width: 30.h,
        child: (!state.isSongDownloading)
            ? state.singleSongIndex != null &&
                    !state.downloadedSongsMap.containsKey(state
                        .currentPlaylistTracks![state.singleSongIndex!].trackId)
                ? InkWell(
                    onTap: () {
                      context
                          .read<PlayAudioBloc>()
                          .add(DownloadSongEvent(context: context));
                    },
                    child: Center(
                      child: Icon(Icons.download),
                    ),
                  )
                : Center(child: const Icon(Icons.check))
            : Center(
                child: LoadingAnimationWidget.prograssiveDots(
                    color: const Color.fromARGB(255, 75, 74, 74), size: 40),
              ));
  }
}
