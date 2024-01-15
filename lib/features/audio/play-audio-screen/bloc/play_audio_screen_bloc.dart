import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
}
