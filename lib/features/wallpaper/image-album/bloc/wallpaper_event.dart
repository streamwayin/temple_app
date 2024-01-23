part of 'wallpaper_bloc.dart';

class WallpaperEvent extends Equatable {
  const WallpaperEvent();

  @override
  List<Object> get props => [];
}

class WallpaperInitialEvent extends WallpaperEvent {}

class FetchImagesListFromDbEvent extends WallpaperEvent {}

class AddImageAlbumModelFromRefreshIndicator extends WallpaperEvent {
  final List<ImageAlbumModel> imageAlbumModel;

  AddImageAlbumModelFromRefreshIndicator({required this.imageAlbumModel});
}
