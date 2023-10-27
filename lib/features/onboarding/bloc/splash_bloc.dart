import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SetIndexEvent>(onSetIndexEvent);
  }

  FutureOr<void> onSetIndexEvent(
      SetIndexEvent event, Emitter<SplashState> emit) {
    emit(state.copyWith(index: event.index));
  }
}
