part of 'image_bloc.dart';

class ImageState extends Equatable {
  const ImageState({
    this.isLoading = true,
    this.imageList = const [],
    this.currentAlbumId = '',
  });
  final bool isLoading;
  final List<ImageModel> imageList;
  final String currentAlbumId;
  @override
  List<Object> get props => [isLoading, imageList, currentAlbumId];

  ImageState copyWith({
    bool? isLoading,
    List<ImageModel>? imageList,
    String? currentAlbumId,
  }) {
    return ImageState(
      isLoading: isLoading ?? this.isLoading,
      imageList: imageList ?? this.imageList,
      currentAlbumId: currentAlbumId ?? this.currentAlbumId,
    );
  }
}

final class ImageInitial extends ImageState {}
