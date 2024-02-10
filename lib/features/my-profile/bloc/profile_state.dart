part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.navigateToNotificationScreen = false,
  });
  final bool navigateToNotificationScreen;

  @override
  List<Object> get props => [
        navigateToNotificationScreen,
      ];

  ProfileState copyWith({
    bool? navigateToNotificationScreen,
  }) {
    return ProfileState(
      navigateToNotificationScreen:
          navigateToNotificationScreen ?? this.navigateToNotificationScreen,
    );
  }
}

final class ProfileInitial extends ProfileState {}
