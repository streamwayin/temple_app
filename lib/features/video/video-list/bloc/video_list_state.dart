part of 'video_list_bloc.dart';

class VideoListState extends Equatable {
  const VideoListState({
    this.videoAlbumModelList = const [],
    this.isLoading = false,
    this.currnetVideoList = const [],
    this.navigateToVideoScreen,
    this.navigateToVideoScreenLoading = false,
    // this.vidoePlaylistList = const [],
  });
  final List<VideoAlbumModel> videoAlbumModelList;
  final bool isLoading;
  final List<VideoModel> currnetVideoList;
  final bool? navigateToVideoScreen;
  final bool navigateToVideoScreenLoading;
  // final List<Playlist> vidoePlaylistList;
  @override
  List<Object?> get props => [
        videoAlbumModelList,
        isLoading, currnetVideoList, navigateToVideoScreen,
        navigateToVideoScreenLoading
        // vidoePlaylistList,
      ];

  VideoListState copyWith({
    List<VideoAlbumModel>? videoAlbumModelList,
    bool? isLoading,
    // List<Playlist>? vidoePlaylistList,
    List<VideoModel>? currnetVideoList,
    bool? navigateToVideoScreen,
    bool? navigateToVideoScreenLoading,
  }) {
    return VideoListState(
      videoAlbumModelList: videoAlbumModelList ?? this.videoAlbumModelList,
      isLoading: isLoading ?? this.isLoading,
      currnetVideoList: currnetVideoList ?? this.currnetVideoList,
      navigateToVideoScreen: navigateToVideoScreen,
      navigateToVideoScreenLoading:
          navigateToVideoScreenLoading ?? this.navigateToVideoScreenLoading,
      // vidoePlaylistList: vidoePlaylistList ?? this.vidoePlaylistList,
    );
  }
}

final class VideoInitial extends VideoListState {}
