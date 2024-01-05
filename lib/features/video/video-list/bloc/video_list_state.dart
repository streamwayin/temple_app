part of 'video_list_bloc.dart';

class VideoListState extends Equatable {
  const VideoListState({
    this.videoAlbumModelList = const [],
    this.isLoading = false,
    // this.vidoePlaylistList = const [],
  });
  final List<VideoAlbumModel> videoAlbumModelList;
  final bool isLoading;
  // final List<Playlist> vidoePlaylistList;
  @override
  List<Object> get props => [
        videoAlbumModelList,
        isLoading,
        // vidoePlaylistList,
      ];

  VideoListState copyWith(
      {List<VideoAlbumModel>? videoAlbumModelList,
      bool? isLoading,
      List<Playlist>? vidoePlaylistList}) {
    return VideoListState(
      videoAlbumModelList: videoAlbumModelList ?? this.videoAlbumModelList,
      isLoading: isLoading ?? this.isLoading,
      // vidoePlaylistList: vidoePlaylistList ?? this.vidoePlaylistList,
    );
  }
}

final class VideoInitial extends VideoListState {}
