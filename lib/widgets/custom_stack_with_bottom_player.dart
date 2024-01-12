import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/widgets/song_playing_indicator.dart';

import '../features/audio/bloc/play_audio_bloc.dart';

class CustomStackWithBottomPlayer extends StatelessWidget {
  final Widget child;
  const CustomStackWithBottomPlayer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(height: size.height, width: size.width, child: child),
          BlocBuilder<PlayAudioBloc, PlayAudioState>(
            builder: (context, state) {
              return Positioned(
                bottom: 57.h,
                left: 0,
                right: 0,
                child: const SongPlayingIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
