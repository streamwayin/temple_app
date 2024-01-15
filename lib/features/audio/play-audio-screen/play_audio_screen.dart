import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:temple_app/features/audio/bloc/play_audio_bloc.dart';
import 'package:temple_app/features/audio/play-audio-screen/bloc/play_audio_screen_bloc.dart';
import 'package:temple_app/widgets/utils.dart';

import '../../../constants.dart';
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
    return PopScope(
      onPopInvoked: (didPop) {
        context
            .read<HomeBloc>()
            .add(const ChangeOnPlayAudioSreenOrNot(onPlayAudioScreen: false));
        //   return true;
      },
      // onWillPop: () async {
      //   context
      //       .read<HomeBloc>()
      //       .add(const ChangeOnPlayAudioSreenOrNot(onPlayAudioScreen: false));
      //   return true;
      // },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: BlocListener<PlayAudioBloc, PlayAudioState>(
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
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _gap(50),
                  _buildDisplayPicture(size, sequenceState),
                  _gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        // SvgPicture.asset('assets/svg/volume.svg'),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              bool loopMode = context
                                  .read<PlayAudioScreenBloc>()
                                  .state
                                  .loopMode;
                              print('loop mode from screen');
                              print(loopMode);
                              context
                                  .read<PlayAudioScreenBloc>()
                                  .add(ToggleLoopMode(loopmode: !loopMode));
                            },
                            child: Stack(
                              children: [
                                context
                                        .read<PlayAudioScreenBloc>()
                                        .state
                                        .loopMode
                                    ? SvgPicture.asset(
                                        'assets/svg/loop.svg',
                                        colorFilter: ColorFilter.mode(
                                            Color(0xff593600), BlendMode.srcIn),
                                      )
                                    : SvgPicture.asset('assets/svg/loop.svg')
                              ],
                            )),
                        SizedBox(width: 5.w),
                        InkWell(
                          onTap: () {
                            bool isSuffling = context
                                .read<PlayAudioScreenBloc>()
                                .state
                                .isSuffling;
                            context
                                .read<PlayAudioScreenBloc>()
                                .add(ToggleSuffleMode(suffle: !isSuffling));
                          },
                          child: context
                                  .read<PlayAudioScreenBloc>()
                                  .state
                                  .isSuffling
                              ? SvgPicture.asset(
                                  'assets/svg/shuffle-outline.svg',
                                  colorFilter: ColorFilter.mode(
                                      Color(0xff593600), BlendMode.srcIn),
                                )
                              // color: Color(0xff8996b8),
                              : SvgPicture.asset(
                                  'assets/svg/shuffle-outline.svg'),
                          // Icon(Icons.shuffle_on, color: Color(0xff8996b8)),
                        ),
                      ],
                    ),
                  ),
                  _gap(10),
                  // Display seek bar. Using StreamBuilder, this widget rebuilds
                  // each time the position, buffered position or duration changes.
                  SeekBar(
                    duration: positionData?.duration ?? Duration.zero,
                    position: positionData?.position ?? Duration.zero,
                    bufferedPosition:
                        positionData?.bufferedPosition ?? Duration.zero,
                  ),
                  _gap(30),
                  // Display play/pause button and volume/speed sliders.
                  const ControlButtons(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  SizedBox _gap(int height) => SizedBox(height: height.h);

  SizedBox _buildDisplayPicture(Size size, MediaItem? sequenceState) {
    return SizedBox(
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
                          imageUrl: sequenceState.artUri.toString(),
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
                      fontSize: 22, fontWeight: FontWeight.w600),
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
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: appBarGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 55.h,
            child: Image.asset(
              "assets/figma/shree_bada_ramdwara.png",
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            // height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Badge(
              child: const Icon(Icons.notifications_sharp,
                  color: Colors.black, size: 35),
            ),
          ),
        ],
      ),
    );
  }
}
