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

class ChangeNavigateFromNotificationEvent extends PlayAudioScreenEvent {
  final bool navigateFromNotification;
  // final String notiNaviString;

  ChangeNavigateFromNotificationEvent({
    required this.navigateFromNotification,
    // required this.notiNaviString,
  });
  List<Object> get props => [navigateFromNotification];
}

class NavigateFromNotificationEvent extends PlayAudioScreenEvent {
  final bool navigateFromNotification;
  final String notiNaviString;

  NavigateFromNotificationEvent(
      {required this.navigateFromNotification, required this.notiNaviString});
  @override
  List<Object> get props => [navigateFromNotification, notiNaviString];
}
