part of 'wallpaper_bloc.dart';

class WallpaperState extends Equatable {
  const WallpaperState({
    this.imageList = const [],
    this.imageAlbumList = const [],
    this.isLoading = true,
  });
  final List<ImageModel> imageList;
  final List<ImageAlbumModel> imageAlbumList;
  final bool isLoading;
  @override
  List<Object?> get props => [imageList, imageAlbumList, isLoading];

  WallpaperState copyWith({
    List<ImageModel>? imageList,
    List<ImageAlbumModel>? imageAlbumList,
    bool? isLoading,
  }) {
    return WallpaperState(
      imageList: imageList ?? this.imageList,
      imageAlbumList: imageAlbumList ?? this.imageAlbumList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final class WallpaperInitial extends WallpaperState {}
