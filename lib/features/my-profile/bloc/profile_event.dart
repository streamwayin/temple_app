part of 'profile_bloc.dart';

class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GoToNotificationScreen extends ProfileEvent {
  final bool goToNotificationScreen;

  GoToNotificationScreen({required this.goToNotificationScreen});
}
