part of 'video_bloc.dart';

sealed class VideoState extends Equatable {
  const VideoState();
  
  @override
  List<Object> get props => [];
}

final class VideoInitial extends VideoState {}
