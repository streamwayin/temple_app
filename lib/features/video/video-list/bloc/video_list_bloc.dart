import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:temple_app/modals/video_album_model.dart';
import 'package:temple_app/modals/video_model.dart';
import 'package:temple_app/repositories/video_repository.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../modals/video_album_model_db.dart';

part 'video_list_event.dart';
part 'video_list_state.dart';

class VideoListBloc extends Bloc<VideoListEvent, VideoListState> {
  VideoListBloc() : super(VideoInitial()) {
    on<VideoListInitialEvent>(onVideoInitialEvent);
    on<AddVideoAlbumListFromRefreshIndicator>(
        onAddVideoAlbumListFromRefreshIndicator);
    on<FetchVideoModelList>(onFetchVideoModelList);
    on<NavigateFromNotificaionVidoeAlbumEvent>(
        onNavigateFromNotificaionVidoeAlbumEvent);
  }
  VideoRepository videoRepository = VideoRepository();
  FutureOr<void> onVideoInitialEvent(
      VideoListInitialEvent event, Emitter<VideoListState> emit) async {
    emit(state.copyWith(isLoading: true));
    List<VideoAlbumModelDb> videoList =
        await videoRepository.getVideoAlbumListFromWeb();

    if (videoList.length != 0) {
      List<VideoAlbumModel> videoAlbumModelList = [];

      var yt = YoutubeExplode();
      for (var a in videoList) {
        Map<String, String> mapForVideoAlbumModel = {};

        mapForVideoAlbumModel["albumId"] = a.playlistId;
        mapForVideoAlbumModel["index"] = '${a.index}';
        // log(a.playlistId);
        // var playlist = await yt.playlists.get(a.playlistId);
        // print('1');
        mapForVideoAlbumModel["title"] = a.name;
        mapForVideoAlbumModel["playlistId"] = a.playlistId;
        mapForVideoAlbumModel["albumId"] = a.albumId;
        // mapForVideoAlbumModel["description"] = playlist.description;
        // mapForVideoAlbumModel["author"] = playlist.author;
        // mapForVideoAlbumModel["videoCount"] = playlist.videoCount.toString();
        mapForVideoAlbumModel["thumbnail"] = a.thumbnail;
        // print('2');
        List<Map<String, String>> loalVideoList = [];
        // await for (var video in yt.playlists.getVideos(a.playlistId)) {
        //   Map<String, String> localVideoMap = {};
        //   localVideoMap["id"] = video.id.value;
        //   localVideoMap["title"] = video.title;
        //   localVideoMap["description"] = video.description;
        //   localVideoMap["url"] = video.url;

        //   localVideoMap["duration"] = "${video.duration!.inMilliseconds}";

        //   localVideoMap["thumbnail"] =
        //       "https://i.ytimg.com/vi/${video.id}/sddefault.jpg";
        //   loalVideoList.add(localVideoMap);
        // }
        // mapForVideoAlbumModel["videosList"] = json.encode(loalVideoList);
        // if (loalVideoList.length != 0) {
        //   mapForVideoAlbumModel["thumbnail"] =
        //       loalVideoList[0]["thumbnail"] != null
        //           ? loalVideoList[0]["thumbnail"]!
        //           : '';
        // }
        videoAlbumModelList
            .add(VideoAlbumModel.fromJson(mapForVideoAlbumModel));
      }
      var tempList = videoAlbumModelList;
      tempList.sort((a, b) => (a.index).compareTo(b.index));
      emit(state.copyWith(
          isLoading: false, videoAlbumModelList: videoAlbumModelList));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  FutureOr<void> onAddVideoAlbumListFromRefreshIndicator(
      AddVideoAlbumListFromRefreshIndicator event,
      Emitter<VideoListState> emit) {
    emit(state.copyWith(videoAlbumModelList: event.videoList));
  }

  FutureOr<void> onFetchVideoModelList(
      FetchVideoModelList event, Emitter<VideoListState> emit) async {
    emit(state.copyWith(navigateToVideoScreenLoading: true));
    List<VideoModel> loalVideoList = [];
    var yt = YoutubeExplode();
    await for (var video in yt.playlists.getVideos(event.playlistId)) {
      Map<String, String> localVideoMap = {};
      localVideoMap["id"] = video.id.value;
      localVideoMap["title"] = video.title;
      localVideoMap["description"] = video.description;
      localVideoMap["url"] = video.url;

      localVideoMap["duration"] = "${video.duration!.inMilliseconds}";

      localVideoMap["thumbnail"] =
          "https://i.ytimg.com/vi/${video.id}/sddefault.jpg";
      loalVideoList.add((VideoModel.fromJson(localVideoMap)));
    }
    emit(state.copyWith(
      currnetVideoList: loalVideoList,
      navigateToVideoScreen: true,
      navigateToVideoScreenLoading: false,
    ));
    print(loalVideoList);
  }

  FutureOr<void> onNavigateFromNotificaionVidoeAlbumEvent(
      NavigateFromNotificaionVidoeAlbumEvent event,
      Emitter<VideoListState> emit) {
    emit(state.copyWith(navigateFromNotification: true));
  }
}
