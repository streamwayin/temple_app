import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/screens/play_audio_screen.dart';
import 'package:temple_app/modals/track_model.dart';

import '../../../widgets/utils.dart';
import '../bloc/play_audio_bloc.dart';

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key, required this.albumIndex});
  final int albumIndex;
  static const String routeName = '/album-screen';
  @override
  Widget build(BuildContext context) {
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
                              child: const Icon(Icons.arrow_back)),
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
                              child: const Text("Play all"),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * .9,
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
                                      onTap: () {
                                        context.read<PlayAudioBloc>().add(
                                            const PlayOrPauseSongEvent(
                                                play: true));
                                        Navigator.pushNamed(
                                            context, PlayAudioScreen.routeName);
                                        context.read<PlayAudioBloc>().add(
                                            PlaySinglesongEvent(index: ind));
                                      },
                                      leading: (song.thumbnail != null)
                                          ? SizedBox(
                                              width: 60.w,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: song.thumbnail!,
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                          'assets/images/sound-waves.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      title: Text(
                                        song.title,
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
                    : const SizedBox()
              ],
            );
          },
        ),
      ),
    );
  }
}
