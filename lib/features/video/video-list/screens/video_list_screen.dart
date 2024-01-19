import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/video/video-list/bloc/video_list_bloc.dart';
import 'package:temple_app/features/video/video-screen/video_screen.dart';
import 'package:temple_app/modals/video_album_model.dart';
import 'package:temple_app/modals/video_album_model_db.dart';
import 'package:temple_app/repositories/video_repository.dart';
import 'package:temple_app/widgets/utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});
  static const String routeName = '/video-list-screen';

  @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<VideoListBloc, VideoListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: Utils.buildAppBarNoBackButton(),
          body: state.isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async => onRefresh(context),
                  child: Stack(
                    children: [
                      _templeBackground(),
                      Column(
                        children: [
                          _gap(10),
                          SizedBox(
                            height: size.height * .81,
                            child: ListView.builder(
                              itemCount: state.videoAlbumModelList.length,
                              itemBuilder: (context, index) {
                                VideoAlbumModel videoAlbum =
                                    state.videoAlbumModelList[index];
                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => VideoScreen(
                                                    videoList: state
                                                        .videoAlbumModelList[
                                                            index]
                                                        .videosList,
                                                  )));
                                      // Navigator.of(context)
                                      //     .pushNamed(VideoScreen.routeName);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0)
                                          .copyWith(top: 4),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  height: 55.h,
                                                  width: 100.w,
                                                  imageUrl:
                                                      videoAlbum.thumbnail,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              SizedBox(
                                                width: size.width * .65,
                                                height: 65.h,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      child: Text(
                                                        maxLines: 2,
                                                        "${videoAlbum.title}",
                                                        style: TextStyle(
                                                            fontSize: 16.sp,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ),
                                                    Text(
                                                        "${videoAlbum.author}"),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Divider()
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                      // Positioned(
                      //   bottom: 0,
                      //   child: ElevatedButton(
                      //       onPressed: () async {
                      //         // context
                      //         //     .read<VideoListBloc>()
                      //         //     .add(VideoListInitialEvent());
                      //         var yt = YoutubeExplode();
                      //         await for (var video in yt.playlists.getVideos(
                      //             "PLmqmKUzk1BJUBctyH5wB9dn5eV6Cn1x3W")) {
                      //           print(
                      //               "https://i.ytimg.com/vi/${video.id}/sddefault.jpg");
                      //         }
                      //       },
                      //       child: Text("trigger event")),
                      // ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // vertical gap between widgets
  SizedBox _gap(int height) => SizedBox(height: height.h);

  // the temple background behind the stack
  Positioned _templeBackground() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Image.asset("assets/figma/bottom_temple.png"),
    );
  }

  Future onRefresh(BuildContext context) async {
    VideoRepository videoRepository = VideoRepository();

    List<VideoAlbumModelDb> videoList =
        await videoRepository.getVideoAlbumListFromWeb();

    if (videoList.length != 0) {
      List<VideoAlbumModel> videoAlbumModelList = [];

      var yt = YoutubeExplode();
      for (var a in videoList) {
        Map<String, String> mapForVideoAlbumModel = {};
        mapForVideoAlbumModel["albumId"] = a.playlistId;
        mapForVideoAlbumModel["index"] = a.index;
        log(a.playlistId);
        var playlist = await yt.playlists.get(a.playlistId);
        mapForVideoAlbumModel["title"] = playlist.title;
        mapForVideoAlbumModel["playlistId"] = a.playlistId;
        mapForVideoAlbumModel["albumId"] = a.albumId;
        mapForVideoAlbumModel["description"] = playlist.description;
        mapForVideoAlbumModel["author"] = playlist.author;
        mapForVideoAlbumModel["videoCount"] = playlist.videoCount.toString();
        List<Map<String, String>> loalVideoList = [];
        await for (var video in yt.playlists.getVideos(a.playlistId)) {
          Map<String, String> localVideoMap = {};
          localVideoMap["id"] = video.id.value;
          localVideoMap["title"] = video.title;
          localVideoMap["description"] = video.description;
          localVideoMap["url"] = video.url;

          localVideoMap["duration"] = "${video.duration!.inMilliseconds}";

          localVideoMap["thumbnail"] =
              "https://i.ytimg.com/vi/${video.id}/sddefault.jpg";
          loalVideoList.add(localVideoMap);
        }
        mapForVideoAlbumModel["videosList"] = json.encode(loalVideoList);
        if (loalVideoList.length != 0) {
          mapForVideoAlbumModel["thumbnail"] =
              loalVideoList[0]["thumbnail"] != null
                  ? loalVideoList[0]["thumbnail"]!
                  : '';
        }
        videoAlbumModelList
            .add(VideoAlbumModel.fromJson(mapForVideoAlbumModel));
      }

      if (videoAlbumModelList.isNotEmpty) {
        print(videoAlbumModelList);
        context.read<VideoListBloc>().add(AddVideoAlbumListFromRefreshIndicator(
            videoList: videoAlbumModelList));
      }
    } else {}
    return;
  }
}
