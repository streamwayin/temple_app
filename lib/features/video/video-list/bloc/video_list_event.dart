part of 'video_list_bloc.dart';

sealed class VideoListEvent extends Equatable {
  const VideoListEvent();

  @override
  List<Object> get props => [];
}

class VideoListInitialEvent extends VideoListEvent {}

class AddVideoAlbumListFromRefreshIndicator extends VideoListEvent {
  final List<VideoAlbumModel> videoList;

  AddVideoAlbumListFromRefreshIndicator({required this.videoList});
}

class FetchVideoModelList extends VideoListEvent {
  final String playlistId;

  FetchVideoModelList({required this.playlistId});
}

class NavigateFromNotificaionVidoeAlbumEvent extends VideoListEvent {}
