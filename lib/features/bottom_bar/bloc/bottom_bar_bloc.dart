import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_bar_event.dart';
part 'bottom_bar_state.dart';

class BottomBarBloc extends Bloc<BottomBarEvent, BottomBarState> {
  BottomBarBloc() : super(BottomBarInitial()) {
    on<ChangeCurrentPageIndex>(onChangeCurrentPageIndex);
  }

  FutureOr<void> onChangeCurrentPageIndex(
      ChangeCurrentPageIndex event, Emitter<BottomBarState> emit) {
    int newIndex = event.newIndex;
    emit(state.copyWith(currentPageIndex: newIndex));
  }
}
