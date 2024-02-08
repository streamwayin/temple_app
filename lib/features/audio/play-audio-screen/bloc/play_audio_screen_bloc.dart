import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/repositories/audo_repository.dart';

part 'play_audio_screen_event.dart';
part 'play_audio_screen_state.dart';

class PlayAudioScreenBloc
    extends Bloc<PlayAudioScreenEvent, PlayAudioScreenState> {
  final AudioRepository audioRepository;
  PlayAudioScreenBloc({required this.audioRepository})
      : super(PlayAudioScreenInitial()) {
    on<ToggleLoopMode>(onToggleLoopMode);
    on<ToggleSuffleMode>(onToggleSuffleMode);
    on<ChangeNavigateFromNotificationEvent>(
        onChangeNavigateFromNotificationEvent);
    on<NavigateFromNotificationEvent>(onNavigateFromNotificationEvent);
  }
  FutureOr<void> onToggleLoopMode(
      ToggleLoopMode event, Emitter<PlayAudioScreenState> emit) async {
    print('oooooooooooooooooooooooo');
    print("loop mode from bloc${event.loopmode}");
    await audioRepository.loopMode(event.loopmode);
    emit(state.copyWith(loopMode: event.loopmode));
  }

  FutureOr<void> onToggleSuffleMode(
      ToggleSuffleMode event, Emitter<PlayAudioScreenState> emit) {
    audioRepository.suffle(event.suffle);
    emit(state.copyWith(isSuffling: event.suffle));
  }

  FutureOr<void> onChangeNavigateFromNotificationEvent(
      ChangeNavigateFromNotificationEvent event,
      Emitter<PlayAudioScreenState> emit) {
    print('-----------------------------------------------');
    print("onChangeNavigateFromNotificationEvent");
    emit(state.copyWith(
      navigateFromNotification: event.navigateFromNotification,
    ));
  }

  FutureOr<void> onNavigateFromNotificationEvent(
      NavigateFromNotificationEvent event, Emitter<PlayAudioScreenState> emit) {
    emit(state.copyWith(
      navigateFromNotification: event.navigateFromNotification,
      notiNaviString: event.notiNaviString,
    ));
  }
}
