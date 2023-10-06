import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:temple_app/features/audio/bloc/play_audio_bloc.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 50,
          onPressed: () {
            context
                .read<PlayAudioBloc>()
                .add(const ChangeSongEvent(previous: true));
          },
          icon: const Icon(
            Icons.skip_previous_rounded,
          ),
        ),
        BlocConsumer<PlayAudioBloc, PlayAudioState>(
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
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: () {
                  context
                      .read<PlayAudioBloc>()
                      .add(const PlayOrPauseSongEvent(play: true));
                },
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: () {
                  context
                      .read<PlayAudioBloc>()
                      .add(const PlayOrPauseSongEvent(play: false));
                },
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () {
                  // player.seek(Duration.zero)
                },
              );
            }
          },
        ),
        IconButton(
          iconSize: 50,
          onPressed: () {
            context
                .read<PlayAudioBloc>()
                .add(const ChangeSongEvent(next: true));
          },
          icon: const Icon(
            Icons.skip_next_rounded,
          ),
        ),
      ],
    );
  }
}
