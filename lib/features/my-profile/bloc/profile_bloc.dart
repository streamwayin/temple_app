import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<GoToNotificationScreen>(onGoToNotificationScreen);
  }

  FutureOr<void> onGoToNotificationScreen(
      GoToNotificationScreen event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
        navigateToNotificationScreen: event.goToNotificationScreen));
  }
}
