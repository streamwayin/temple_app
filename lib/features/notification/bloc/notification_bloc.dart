import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:temple_app/modals/notification_model.dart';
import 'package:temple_app/repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  late NotificationRepository notificationRepository;
  NotificationBloc() : super(NotificationInitial()) {
    init();
    on<NotificationEventInitial>(onNotificationEventInitial);
  }

  void init() {
    notificationRepository = NotificationRepository();
  }

  FutureOr<void> onNotificationEventInitial(
      NotificationEventInitial event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(notificationLoading: true));
    List<NotificationModel>? notificationList =
        await notificationRepository.getNotificationListFromDB();

    if (notificationList != null) {
      print('object');
      print(notificationList);
      emit(state.copyWith(
          notificationLoading: false, notificationsList: notificationList));
    }
  }
}
