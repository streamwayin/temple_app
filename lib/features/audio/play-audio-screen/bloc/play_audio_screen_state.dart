part of 'play_audio_screen_bloc.dart';

class PlayAudioScreenState extends Equatable {
  const PlayAudioScreenState({
    this.loopMode = false,
    this.isSuffling = false,
    this.navigateFromNotification = false,
    this.notiNaviString = '',
  });
  final bool loopMode;
  final bool isSuffling;
  final bool navigateFromNotification;
  final String notiNaviString;
  @override
  List<Object> get props =>
      [loopMode, isSuffling, navigateFromNotification, notiNaviString];

  PlayAudioScreenState copyWith(
      {bool? loopMode,
      bool? isSuffling,
      bool? navigateFromNotification,
      String? notiNaviString}) {
    return PlayAudioScreenState(
        loopMode: loopMode ?? this.loopMode,
        isSuffling: isSuffling ?? this.isSuffling,
        navigateFromNotification:
            navigateFromNotification ?? this.navigateFromNotification,
        notiNaviString: notiNaviString ?? this.notiNaviString);
  }
}

final class PlayAudioScreenInitial extends PlayAudioScreenState {}
