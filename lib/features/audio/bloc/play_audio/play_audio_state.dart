part of 'play_audio_bloc.dart';

sealed class PlayAudioState extends Equatable {
  const PlayAudioState();

  @override
  List<Object> get props => [];
}

final class PlayAudioInitial extends PlayAudioState {}
