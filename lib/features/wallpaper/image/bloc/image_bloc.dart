import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:temple_app/modals/image_album_model.dart';
import 'package:temple_app/modals/image_model.dart';
import 'package:temple_app/repositories/wallpaper_repository.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final wallpaperRepo = WallpaperRepository();
  FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
  ImageBloc() : super(ImageInitial()) {
    on<ImageInitialEvent>(onImageInitialEvent);
    on<LogImageSetAswallpaperEvent>(onLogImageSetAswallpaperEvent);
  }
  void init() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    firebaseAnalytics.setAnalyticsCollectionEnabled(true);
    firebaseAnalytics.setUserId(id: uid);
  }

  FutureOr<void> onImageInitialEvent(
      ImageInitialEvent event, Emitter<ImageState> emit) async {
    emit(state.copyWith(isLoading: true));
    final album = event.albumModel;
    List<ImageModel>? imageList =
        await wallpaperRepo.getImageFromDb(album.albumId);
    firebaseAnalytics.logEvent(
      name: "image_album",
      parameters: {"albumId": album.albumId},
    );
    if (imageList != null) {
      print(imageList);
      emit(state.copyWith(isLoading: false, imageList: imageList));
    }
    emit(state.copyWith(isLoading: false));
  }

  FutureOr<void> onLogImageSetAswallpaperEvent(
      LogImageSetAswallpaperEvent event, Emitter<ImageState> emit) {
    firebaseAnalytics.logEvent(name: "wallpaper_set", parameters: {
      "imageId": event.image.imageId,
      "title": event.image.title
    });
  }
}
