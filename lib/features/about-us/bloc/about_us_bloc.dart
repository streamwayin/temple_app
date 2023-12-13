import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/modals/saint_model.dart';
import 'package:temple_app/repositories/about_us_repository.dart';

import '../../../modals/acharayas_model.dart';

part 'about_us_event.dart';
part 'about_us_state.dart';

class AboutUsBloc extends Bloc<AboutUsEvent, AboutUsState> {
  final _abooutUsRepository = AbooutUsRepository();
  AboutUsBloc() : super(AboutUsInitial()) {
    on<AboutUsInitialEvent>(onAboutUsInitialEvent);
  }

  FutureOr<void> onAboutUsInitialEvent(
      AboutUsInitialEvent event, Emitter<AboutUsState> emit) async {
    List<AcharayasModel>? acharayasLIst =
        await _abooutUsRepository.getAcharayasDataFromDB();
    List<SantModel>? saintList = await _abooutUsRepository.getSantsDataFromDb();
    if (acharayasLIst.isNotEmpty) {
      acharayasLIst.sort((a, b) => (a.index).compareTo(b.index));
    }
    if (saintList.isNotEmpty) {
      saintList.sort((a, b) => (a.index).compareTo(b.index));
    }
    emit(state.copyWith(
      acharayasList: acharayasLIst,
      santList: saintList,
    ));
  }
}
