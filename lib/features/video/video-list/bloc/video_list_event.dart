part of 'video_list_bloc.dart';

sealed class VideoListEvent extends Equatable {
  const VideoListEvent();

  @override
  List<Object> get props => [];
}

class VideoListInitialEvent extends VideoListEvent {}
