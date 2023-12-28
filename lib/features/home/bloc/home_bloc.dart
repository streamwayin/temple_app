import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:temple_app/modals/app_update_model.dart';
import 'package:temple_app/repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late HomeRepository homeRepository;
  HomeBloc() : super(HomeInitial()) {
    _initilize();
    on<HomeEventInitial>(onHomeEventInitial);
    on<ChangeOnPlayAudioSreenOrNot>((event, emit) {
      emit(state.copyWith(onPlayAudioScreen: event.onPlayAudioScreen));
    });
  }

  void _initilize() {
    homeRepository = HomeRepository();
  }

  FutureOr<void> onHomeEventInitial(
      HomeEventInitial event, Emitter<HomeState> emit) async {
    AppUpdateModel? appUpdateModel = await homeRepository.getMetadata();
    if (appUpdateModel != null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.version != '${appUpdateModel.version}' &&
          appUpdateModel.mandatory == true) {
        emit(state.copyWith(updateMandatory: true));
      }
    }
  }
}
