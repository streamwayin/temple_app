part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  const NotificationState({
    this.notificationLoading = false,
    this.notificationsList = const [],
  });
  final bool notificationLoading;
  final List<NotificationModel> notificationsList;
  @override
  List<Object> get props => [
        notificationLoading,
        notificationsList,
      ];

  NotificationState copyWith({
    bool? notificationLoading,
    List<NotificationModel>? notificationsList,
  }) {
    return NotificationState(
      notificationLoading: notificationLoading ?? this.notificationLoading,
      notificationsList: notificationsList ?? this.notificationsList,
    );
  }
}

final class NotificationInitial extends NotificationState {}
