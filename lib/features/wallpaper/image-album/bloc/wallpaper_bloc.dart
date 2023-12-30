import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:temple_app/modals/image_album_model.dart';
import 'package:temple_app/modals/image_model.dart';
import 'package:temple_app/repositories/wallpaper_repository.dart';

part 'wallpaper_event.dart';
part 'wallpaper_state.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  // final firebaseAnalytics = FirebaseAnalytics.instance;
  WallpaperRepository wallpaperRepo = WallpaperRepository();
  WallpaperBloc() : super(WallpaperInitial()) {
    // init();
    on<WallpaperInitialEvent>(onWallpaperInitialEvent);
  }
  // void init() {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   firebaseAnalytics.setAnalyticsCollectionEnabled(true);
  //   firebaseAnalytics.setUserId(id: uid);
  // }

  FutureOr<void> onWallpaperInitialEvent(
      WallpaperInitialEvent event, Emitter<WallpaperState> emit) async {
    emit(state.copyWith(isLoading: true));
    List<ImageAlbumModel>? imageAlbumList =
        await wallpaperRepo.getImageAlbumFromDb();
    if (imageAlbumList != null) {
      emit(state.copyWith(imageAlbumList: imageAlbumList, isLoading: false));
    }
    emit(state.copyWith(isLoading: false));
  }
}
