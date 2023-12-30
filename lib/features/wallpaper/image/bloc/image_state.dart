part of 'image_bloc.dart';

class ImageState extends Equatable {
  const ImageState({
    this.isLoading = true,
    this.imageList = const [],
  });
  final bool isLoading;
  final List<ImageModel> imageList;
  @override
  List<Object> get props => [isLoading, imageList];

  ImageState copyWith({
    bool? isLoading,
    List<ImageModel>? imageList,
  }) {
    return ImageState(
      isLoading: isLoading ?? this.isLoading,
      imageList: imageList ?? this.imageList,
    );
  }
}

final class ImageInitial extends ImageState {}
