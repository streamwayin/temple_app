import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/modals/album_model.dart';
import 'package:temple_app/repositories/audo_repository.dart';
import 'package:temple_app/services/firebase_analytics_service.dart';
import 'package:temple_app/widgets/utils.dart';

import '../bloc/play_audio_bloc.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});
  static const String routeName = '/audio-screen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<PlayAudioBloc, PlayAudioState>(
      listener: (context, state) async {
        if (state.isTracksAvailable != null) {
          // context.read<PlayAudioBloc>().add(const LoadCurrentPlaylistEvent());
        }

        // if (playState.navigateFromNotification == true &&
        //     state.albumsPageLoading == false) {
        //   if (state.notiNaviString.length == 0) {
        //     // context.read<PlayAudioBloc>().add(ChangeNavigateFromNotification(
        //     //     navigateFromNotification: false));
        //     context.read<PlayAudioScreenBloc>().add(
        //         ChangeNavigateFromNotificationEvent(
        //             navigateFromNotification: false,
        //             notiNaviString: 'album_screen_noti'));
        //     PersistentNavBarNavigator.pushNewScreen(
        //       context,
        //       screen: AudioScreen(),
        //       withNavBar: true,
        //       pageTransitionAnimation: PageTransitionAnimation.cupertino,
        //     );
        //   } else if (state.notiNaviString == 'play_notification_audio') {
        //     print("i can navigate");
        //     // context.read<PlayAudioBloc>().add(ChangeNavigateFromNotification(
        //     //     navigateFromNotification: false));
        //     // context.read<PlayAudioScreenBloc>().add(
        //     //     ChangeNavigateFromNotificationEvent(
        //     //         navigateFromNotification: false));
        //     // PersistentNavBarNavigator.pushNewScreen(
        //     //   context,
        //     //   screen: PlayAudioFromNotificationScreen(),
        //     //   withNavBar: true,
        //     //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
        //     // );
        //   }
        // }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: Utils.buildAppBarNoBackButton(),
          body: RefreshIndicator(
            onRefresh: () async {
              AudioRepository audioRepository = AudioRepository();
              List<AlbumModel>? list =
                  await audioRepository.getAlbumListFromDb();
              if (list != null) {
                var tempList = list;
                int length = tempList.length + 1;
                tempList.sort(
                    (a, b) => (a.index ?? length).compareTo(b.index ?? length));

                context
                    .read<PlayAudioBloc>()
                    .add(AddAlubmDateFromRefreshIndicator(list: tempList));
              }
              return;
            },
            child: Stack(
              children: [
                _templeBackground(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _gap(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DropdownMenu(
                              width: size.width * .8,
                              enableFilter: true,
                              label: const Text('filterByArtist').tr(),
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 24),
                              ),
                              onSelected: (value) {
                                context
                                    .read<PlayAudioBloc>()
                                    .add(GetAlbumsByArtistEvent(index: value));
                              },
                              dropdownMenuEntries: getMenuItems(state, context),
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<PlayAudioBloc>()
                                    .add(PlayAudioEventInitial());
                              },
                              child: Container(
                                height: 40.h,
                                width: 40.h,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "All",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.albums.length,
                            itemBuilder: (context, index) {
                              var album = state.albums[index];
                              return GestureDetector(
                                key: Key('$index'),
                                onTap: () {
                                  print(state.albums[index].albumId);
                                  // Navigator.pushNamed(
                                  //     context, AudioScreen.routeName,
                                  //     arguments: index);
                                  FirebaseAnalyticsService.firebaseAnalytics!
                                      .logEvent(
                                          name: "screen_view",
                                          parameters: {
                                        "TITLE": AudioScreen.routeName
                                      });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AudioScreen()));
                                  context.read<PlayAudioBloc>().add(
                                      UpdateSelectedAlbumIndex(index: index));
                                  context.read<PlayAudioBloc>().add(
                                      FetchSongsOfAlbum(
                                          albumId: album.albumId));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 45.h,
                                            width: 50.w,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                      255, 233, 232, 232)
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: (album.thumbnail != null)
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          album.thumbnail!,
                                                      fit: BoxFit.cover,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.asset(
                                                        'assets/images/sound-waves.png'),
                                                  ),
                                          ),
                                          state.currentPlaylistAlbumId !=
                                                      null &&
                                                  state.currentPlaylistAlbumId ==
                                                      state
                                                          .albums[index].albumId
                                              ? SizedBox(
                                                  height: 45.h,
                                                  width: 50.w,
                                                  child: Image.asset(
                                                    'assets/images/music.gif',
                                                    fit: BoxFit.contain,
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      SizedBox(width: 5.w),
                                      SizedBox(
                                        width: size.width - 110.w,
                                        child: Text(
                                          album.translated != null
                                              ? album.translated!.hi
                                              : album.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                (state.albumsPageLoading == true)
                    ? Utils.showLoadingOnSceeen()
                    : const SizedBox(),
                Positioned(
                  top: 60,
                  child: Text("${state.albumsPageLoading}"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  SizedBox _gap(int height) => SizedBox(height: height.h);
  List<DropdownMenuEntry> getMenuItems(
      PlayAudioState state, BuildContext context) {
    List<DropdownMenuEntry> list = [];
    for (var a in state.artistList) {
      list.add(DropdownMenuEntry(value: a.index, label: a.name));
    }
    return list;
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
