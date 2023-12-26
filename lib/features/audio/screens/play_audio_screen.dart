import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:temple_app/features/audio/bloc/play_audio_bloc.dart';
import 'package:temple_app/widgets/utils.dart';

import '../../home/bloc/home_bloc.dart';
import '../widgets/common.dart';
import '../widgets/controller_buttons.dart';

class PlayAudioScreen extends StatefulWidget {
  const PlayAudioScreen({
    Key? key,
  }) : super(key: key);

  static const String routeName = '/play-audio-screen';
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<PlayAudioScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        context
            .read<HomeBloc>()
            .add(const ChangeOnPlayAudioSreenOrNot(onPlayAudioScreen: false));
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<PlayAudioBloc, PlayAudioState>(
            listener: (context, state) {
              if (state is PlayAudioErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMesssage,
                    ),
                  ),
                );
              }
            },
            child: BlocConsumer<PlayAudioBloc, PlayAudioState>(
              listener: (BuildContext context, PlayAudioState state) {
                if (state.snackbarMessage != null) {
                  Utils.showSnackBar(
                      context: context, message: state.snackbarMessage!);
                }
              },
              builder: (context, state) {
                MediaItem? sequenceState;
                if (state.musicPlayerDataModel != null) {
                  sequenceState = state.musicPlayerDataModel!.sequenceState
                      ?.currentSource?.tag as MediaItem;
                }
                final PositionData? positionData =
                    state.musicPlayerDataModel?.positionData;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: const Alignment(-0.9, 0),
                      child: SizedBox(
                          height: 30.h,
                          child: (!state.isSongDownloading)
                              ? state.singleSongIndex != null &&
                                      !state.downloadedSongsMap.containsKey(
                                          state
                                              .currentPlaylistTracks![
                                                  state.singleSongIndex!]
                                              .trackId)
                                  ? IconButton(
                                      onPressed: () {
                                        context.read<PlayAudioBloc>().add(
                                            DownloadSongEvent(
                                                context: context));
                                      },
                                      icon: const Icon(Icons.download))
                                  : const Icon(Icons.check)
                              : LoadingAnimationWidget.prograssiveDots(
                                  color: const Color.fromARGB(255, 75, 74, 74),
                                  size: 40)),
                    ),
                    SizedBox(
                      height: size.height * .4,
                      width: size.width * .8,
                      child: (sequenceState != null)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Container(
                                        height: size.height * .4,
                                        width: size.width * .8,
                                        decoration: const BoxDecoration(
                                            // color: Colors.redAccent,
                                            ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              sequenceState.artUri.toString(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  sequenceState.title,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                                Text(
                                  sequenceState.artist!,
                                ),
                                (sequenceState.album == null)
                                    ? const SizedBox()
                                    : Text(
                                        sequenceState.album!,
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                      ),
                              ],
                            )
                          : Center(
                              child: SizedBox(
                                  height: 50.h,
                                  child: const AspectRatio(
                                      aspectRatio: 1,
                                      child: CircularProgressIndicator())),
                            ),
                    ),

                    // Display seek bar. Using StreamBuilder, this widget rebuilds
                    // each time the position, buffered position or duration changes.

                    SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                    ),

                    // Display play/pause button and volume/speed sliders.
                    const ControlButtons(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
