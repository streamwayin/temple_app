import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temple_app/features/audio/play-audio-screen/play_audio_screen.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/modals/track_model.dart';
import 'package:temple_app/repositories/audo_repository.dart';
import 'package:temple_app/services/firebase_analytics_service.dart';

import '../../../constants.dart';
import '../../../widgets/utils.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/screens/auth_screen.dart';
import '../bloc/play_audio_bloc.dart';

//AudioScreen
class AudioScreen extends StatelessWidget {
  const AudioScreen({
    super.key,
  });
  // final int albumIndex;
  static const String routeName = '/album-screen';
  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    Size size = MediaQuery.of(context).size;
    // onReorder(oldIndex, newIndex) {
    //   context.read<PlayAudioBloc>().add(SongIndexChanged(
    //       newIndex: newIndex, oldIndex: oldIndex, albumIndex: albumIndex));
    // }

    bool? isUserLoggedIn = context.read<AuthBloc>().state.isLoggedIn;
    return Scaffold(
      appBar: Utils.buildAppBarWithBackButton(),
      body: SafeArea(
        child: BlocBuilder<PlayAudioBloc, PlayAudioState>(
          builder: (context, state) {
            List<TrackModel>? songList = state.tracks;
            return RefreshIndicator(
              onRefresh: () async {
                AudioRepository audioRepository = AudioRepository();
                List<TrackModel>? trackList = await audioRepository
                    .getTracksListFromDb(state.currentAlbumId!);
                if (trackList != null) {
                  var tempList = trackList;
                  int length = tempList.length + 1;
                  tempList.sort((a, b) =>
                      (a.index ?? length).compareTo(b.index ?? length));

                  context
                      .read<PlayAudioBloc>()
                      .add(AddTrackDateFromRefreshIndicator(list: tempList));
                }
              },
              child: Stack(
                children: [
                  _templeBackground(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   children: [
                        //     SizedBox(width: 10.w),
                        //     SizedBox(
                        //       width: size.width - 150.w,
                        //       child: Text(
                        //         '',
                        //         // state.c
                        //         overflow: TextOverflow.ellipsis,
                        //         style: const TextStyle(
                        //             fontSize: 24, fontWeight: FontWeight.w500),
                        //       ),
                        //     ),
                        //     const Spacer(),
                        //     InkWell(
                        //       onTap: () {
                        //         if (isUserLoggedIn != null &&
                        //             isUserLoggedIn == true) {
                        //           context.read<PlayAudioBloc>().add(
                        //               const PlayOrPauseSongEvent(play: true));
                        //           Navigator.pushNamed(
                        //               context, PlayAudioScreen.routeName);
                        //         } else {
                        //           Navigator.pushNamed(
                        //               context, AuthScreen.routeName);
                        //         }
                        //       },
                        //       child: Container(
                        //         alignment: Alignment.center,
                        //         height: 25.h,
                        //         width: 70.w,
                        //         decoration: BoxDecoration(
                        //             border: Border.all(),
                        //             borderRadius: BorderRadius.circular(10)),
                        //         child: const Text("playAll").tr(),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        Expanded(
                          // height: size.height * .84,
                          // height: 568.h,
                          child: songList == null
                              ? (state.tracksPageLoading == true)
                                  ? const SizedBox()
                                  : const Center(
                                      child: Text("Unable to fetch data"),
                                    )
                              : ListView.builder(
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
                                                        imageUrl:
                                                            song.thumbnail!,
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
                                                                state
                                                                    .tracks![
                                                                        ind]
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
                                ),
                        )
                      ],
                    ),
                  ),
                  (state.tracksPageLoading == true)
                      ? Utils.showLoadingOnSceeen()
                      : const SizedBox(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  tapOnsongTile(
    BuildContext context,
    PlayAudioState state,
    int ind,
  ) async {
    // bool? isUserLoggedIn = context.read<AuthBloc>().state.isLoggedIn;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isUserLoggedIn = sharedPreferences.getBool(IS_USER_LOGGED_IN);

    if (isUserLoggedIn != null && isUserLoggedIn == true) {
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
      // Navigator.pushNamed(context, PlayAudioScreen.routeName);
      //     arguments: index);
      FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
          name: "screen_view",
          parameters: {"TITLE": PlayAudioScreen.routeName});
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PlayAudioScreen()));

      context.read<PlayAudioBloc>().add(const SaveCurrentAlbumToLocalStorage());
      context.read<PlayAudioBloc>().add(SavePlayingTracksEvent());
    } else {
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: AuthScreen(),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => AuthScreen()));
      // Navigator.pushNamed(context, AuthScreen.routeName);
    }
  }

  Positioned _templeBackground() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Image.asset("assets/figma/bottom_temple.png"),
    );
  }
}
