part of 'play_audio_screen_bloc.dart';

sealed class PlayAudioScreenEvent extends Equatable {
  const PlayAudioScreenEvent();

  @override
  List<Object> get props => [];
}

class ToggleLoopMode extends PlayAudioScreenEvent {
  final bool loopmode;

  ToggleLoopMode({required this.loopmode});
}

class ToggleSuffleMode extends PlayAudioScreenEvent {
  final bool suffle;

  ToggleSuffleMode({required this.suffle});
}
