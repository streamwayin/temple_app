import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../modals/sightseen_model.dart';
import '../../../repositories/sightseen_repository.dart';
part 'sightseen_event.dart';
part 'sightseen_state.dart';

class SightseenBloc extends Bloc<SightseenEvent, SightseenState> {
  final sightseenRepo = SightseenRepository();
  SightseenBloc() : super(SightseenInitial()) {
    on<SightseenEventInitial>(onSightseenEventInitial);
  }

  FutureOr<void> onSightseenEventInitial(
      SightseenEventInitial event, Emitter<SightseenState> emit) async {
    List<SightseenModel>? sightseenList =
        await sightseenRepo.getSightseensDataFromDB();
    if (sightseenList.isNotEmpty) {
      sightseenList.sort((a, b) => (a.index).compareTo(b.index));
    }
    emit(state.copyWith(sightseenList: sightseenList));
  }
}
