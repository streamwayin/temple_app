part of 'image_bloc.dart';

sealed class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class ImageInitialEvent extends ImageEvent {
  final ImageAlbumModel albumModel;

  ImageInitialEvent({required this.albumModel});
}

class LogImageSetAswallpaperEvent extends ImageEvent {
  final ImageModel image;

  LogImageSetAswallpaperEvent({required this.image});
}

class AddImageListFromRefreshIndicator extends ImageEvent {
  final List<ImageModel> imageList;

  AddImageListFromRefreshIndicator({required this.imageList});
}

class ImageInitialNotificationEvent extends ImageEvent {
  final ImageModel imageModel;

  ImageInitialNotificationEvent({required this.imageModel});
}

class ShowPictureDownloadingNotificationEvent extends ImageEvent {
  final double downloadedPercentage;

  ShowPictureDownloadingNotificationEvent({required this.downloadedPercentage});
}
