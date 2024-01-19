import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temple_app/modals/yatara_model.dart';
import 'package:temple_app/repositories/yatara_repository.dart';

part 'yatara_event.dart';
part 'yatara_state.dart';

class YataraBloc extends Bloc<YataraEvent, YataraState> {
  YataraRepository yataraRepository = YataraRepository();
  YataraBloc() : super(YataraInitial()) {
    on<YataraInitialEvent>(onYataraInitialEvent);
    on<AddYataraListFromRefreshIndicator>(onAddYataraListFromRefreshIndicator);
  }

  FutureOr<void> onYataraInitialEvent(
      YataraInitialEvent event, Emitter<YataraState> emit) async {
    emit(state.copyWith(isLoading: true));

    List<YataraModel>? yataraList =
        await yataraRepository.getYatraDetilsFromDb();
    if (yataraList != null) {
      emit(state.copyWith(isLoading: false, yataraList: yataraList));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  FutureOr<void> onAddYataraListFromRefreshIndicator(
      AddYataraListFromRefreshIndicator event, Emitter<YataraState> emit) {
    emit(state.copyWith(yataraList: event.yataraList));
  }
}
