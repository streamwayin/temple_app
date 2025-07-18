import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:temple_app/constants.dart';
import 'package:temple_app/features/audio/widgets/common.dart';
import '../features/audio/bloc/play_audio_bloc.dart';
import '../features/audio/play-audio-screen/play_audio_screen.dart';
import '../features/home/bloc/home_bloc.dart';
import '../main.dart';

class SongPlayingIndicator extends StatelessWidget {
  const SongPlayingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, homeState) {},
        builder: (context, homeState) {
          return BlocConsumer<PlayAudioBloc, PlayAudioState>(
            listener: (context, state) {
              if (state.isPreviouslyTracksSaved == true) {
                context
                    .read<PlayAudioBloc>()
                    .add(LoadSavedTrackInPlayerEvent());
              }
              // can be removed because saving data in for each insicde play audio bloc
              if (state.updateSavedDataOfPlayer == true) {}
            },
            builder: (context, state) {
              Locale currentLocale = Localizations.localeOf(context);

              MediaItem? sequenceState;
              if (state.musicPlayerDataModel != null) {
                sequenceState = state.musicPlayerDataModel!.sequenceState
                    ?.currentSource?.tag as MediaItem;
              }
              if (state.showBottomMusicController == true &&
                  homeState.onPlayAudioScreen == false) {
                return Stack(
                  children: [
                    GestureDetector(
                      // onHorizontalDragUpdate: (details) {
                      //   print(details.primaryDelta);
                      //   if (details.primaryDelta! < -10) {
                      //     // Swiped left
                      //     // setState(() {
                      //     //   isDraggedLeft = true;
                      //     context.read<PlayAudioBloc>().add(
                      //         ChangeShowBottomMusicController(
                      //             changeShowBottomMusicController: false));
                      //     //   isDraggedRight = false;
                      //     print("dragged");

                      //     // });
                      //   } else if (details.primaryDelta! > 10) {
                      //     print("dragged");
                      //     // Swiped right
                      //     // setState(() {
                      //     //   isDraggedRight = true;
                      //     //   isDraggedLeft = false;
                      //     // });
                      //     context.read<PlayAudioBloc>().add(
                      //         ChangeShowBottomMusicController(
                      //             changeShowBottomMusicController: false));
                      //   }
                      // },
                      // onHorizontalDragEnd: (details) {
                      //   // setState(() {
                      //   //   isDraggedLeft = false;
                      //   //   isDraggedRight = false;
                      //   // });
                      //   print("dragged endeddd");
                      // },
                      onTap: () {
                        context.read<HomeBloc>().add(
                            const ChangeOnPlayAudioSreenOrNot(
                                onPlayAudioScreen: true));
                        Navigator.of(navigatorKey.currentContext!)
                            .pushNamed(PlayAudioScreen.routeName);
                      },
                      child: sequenceState == null
                          ? const SizedBox()
                          : Container(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              height: 75.h,
                              width: size.width,
                              decoration: BoxDecoration(
                                gradient: indicatorGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  // image container
                                  Container(
                                    height: 55.h,
                                    width: 55.w,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 187, 115, 27),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: sequenceState.artUri.toString(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  _gap(10),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Stack(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          Positioned(
                                              top: 0,
                                              child: Container(
                                                // color: Colors.lightGreen,
                                                width: 210.w,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      sequenceState.title,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      sequenceState.artist!,
                                                      // "${state.onPlayAudioScreen}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          Positioned(
                                            bottom: 10,
                                            left: -15,
                                            child: Container(
                                              width: 230.w,
                                              child: BlocBuilder<PlayAudioBloc,
                                                  PlayAudioState>(
                                                builder: (context, state) {
                                                  final PositionData?
                                                      positionData = state
                                                          .musicPlayerDataModel
                                                          ?.positionData;
                                                  return SizedBox(
                                                    height: 20,
                                                    child: SeekBar(
                                                      duration: positionData
                                                              ?.duration ??
                                                          Duration.zero,
                                                      position: positionData
                                                              ?.position ??
                                                          Duration.zero,
                                                      bufferedPosition: positionData
                                                              ?.bufferedPosition ??
                                                          Duration.zero,
                                                      showDuration: false,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 45.h,
                                    width: 45.h,
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svg/indicator_background.svg",
                                          height: 45.h,
                                          width: 45.h,
                                        ),
                                        Center(
                                          child: BlocConsumer<PlayAudioBloc,
                                              PlayAudioState>(
                                            listener: (context, state) {},
                                            builder: (context, state) {
                                              PlayerState? playerState = state
                                                  .musicPlayerDataModel
                                                  ?.playerState;

                                              final processingState =
                                                  playerState?.processingState;
                                              final playing =
                                                  playerState?.playing;
                                              if (processingState ==
                                                      ProcessingState.loading ||
                                                  processingState ==
                                                      ProcessingState
                                                          .buffering) {
                                                return CustomIconButton(
                                                    icon: Icons.pause,
                                                    color: Color(0xff593600),
                                                    onTap: () {});
                                              } else if (playing != true) {
                                                return CustomIconButton(
                                                    icon: Icons.play_arrow,
                                                    color: Color(0xff593600),
                                                    onTap: () {
                                                      context
                                                          .read<PlayAudioBloc>()
                                                          .add(
                                                              const PlayOrPauseSongEvent(
                                                                  play: true));
                                                    });
                                              } else if (processingState !=
                                                  ProcessingState.completed) {
                                                return CustomIconButton(
                                                    icon: Icons.pause,
                                                    color: Color(0xff593600),
                                                    onTap: () {
                                                      context
                                                          .read<PlayAudioBloc>()
                                                          .add(
                                                              const PlayOrPauseSongEvent(
                                                                  play: false));
                                                    });
                                              } else {
                                                return CustomIconButton(
                                                    icon: Icons.replay,
                                                    onTap: () {
                                                      context
                                                          .read<PlayAudioBloc>()
                                                          .add(
                                                              ReplaySongEvent());
                                                      // player.seek(Duration.zero)
                                                    });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  // SizedBox(
                                  // width: size.width * .42,
                                  // child: Row(
                                  // children: [
                                  // CustomIconButton(
                                  //   icon: Icons.skip_previous_rounded,
                                  //   onTap: () {
                                  //     context.read<PlayAudioBloc>().add(
                                  //         const ChangeSongEvent(
                                  //             previous: true));
                                  //   },
                                  // ),
                                  // BlocConsumer<PlayAudioBloc,
                                  //     PlayAudioState>(
                                  //   listener: (context, state) {},
                                  //   builder: (context, state) {
                                  //     PlayerState? playerState = state
                                  //         .musicPlayerDataModel
                                  //         ?.playerState;

                                  //     final processingState =
                                  //         playerState?.processingState;
                                  //     final playing = playerState?.playing;
                                  //     if (processingState ==
                                  //             ProcessingState.loading ||
                                  //         processingState ==
                                  //             ProcessingState.buffering) {
                                  //       return CustomIconButton(
                                  //           icon: Icons.pause,
                                  //           color: const Color.fromARGB(
                                  //               255, 238, 179, 108),
                                  //           onTap: () {});
                                  //     } else if (playing != true) {
                                  //       return CustomIconButton(
                                  //           icon: Icons.play_arrow,
                                  //           onTap: () {
                                  //             context.read<PlayAudioBloc>().add(
                                  //                 const PlayOrPauseSongEvent(
                                  //                     play: true));
                                  //           });
                                  //     } else if (processingState !=
                                  //         ProcessingState.completed) {
                                  //       return CustomIconButton(
                                  //           icon: Icons.pause,
                                  //           onTap: () {
                                  //             context.read<PlayAudioBloc>().add(
                                  //                 const PlayOrPauseSongEvent(
                                  //                     play: false));
                                  //           });
                                  //     } else {
                                  //       return CustomIconButton(
                                  //           icon: Icons.replay,
                                  //           onTap: () {
                                  //             // player.seek(Duration.zero)
                                  //           });
                                  //     }
                                  //   },
                                  // ),
                                  // CustomIconButton(
                                  //     icon: Icons.skip_next_rounded,
                                  //     onTap: () {
                                  //       context.read<PlayAudioBloc>().add(
                                  //           const ChangeSongEvent(
                                  //               next: true));
                                  //     }),
                                  // _gap(5),
                                  // CustomIconButton(
                                  //     icon: Icons.close,
                                  //     onTap: () {
                                  //       context.read<PlayAudioBloc>().add(
                                  //           const ChangeShowBottomMusicController(
                                  //               changeShowBottomMusicController:
                                  //                   false));
                                  //     }),
                                  // ],
                                  // ),
                                  // )
                                ],
                              ),
                            ),
                    ),
                    Positioned(
                        right: 0,
                        top: 0,
                        child: InkWell(
                          onTap: () {
                            // context
                            //     .read<PlayAudioBloc>()
                            //     .add(PlayOrPauseSongEvent(play: false));
                            context.read<PlayAudioBloc>().add(
                                ChangeShowBottomMusicController(
                                    changeShowBottomMusicController: false));
                          },
                          child: Icon(
                            Icons.close,
                            color: Color(0xff593500),
                          ),
                        ))
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          );
        },
      ),
    );
  }

  SizedBox _gap(int width) {
    return SizedBox(
      width: width.w,
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = const Color.fromARGB(255, 253, 140, 2),
  });

  final IconData icon;
  final Function() onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    int iconSize = 35;
    return SizedBox(
      height: 40.h,
      width: 35.h,
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: color,
          size: iconSize.r,
        ),
      ),
    );
  }
}
