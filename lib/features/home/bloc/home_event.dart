part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeEventInitial extends HomeEvent {}

class ChangeOnPlayAudioSreenOrNot extends HomeEvent {
  final bool onPlayAudioScreen;

  const ChangeOnPlayAudioSreenOrNot({required this.onPlayAudioScreen});
}

class CarouselPageIndexChanged extends HomeEvent {
  final int newIndex;

  CarouselPageIndexChanged({required this.newIndex});
}

class AddStateEbookDataFromRefreshIndicator extends HomeEvent {
  final List<EbookModel> bookList;
  // final List<ImageAlbumModel> imageAlbum;

  AddStateEbookDataFromRefreshIndicator({
    required this.bookList,
    // required this.imageAlbum,
  });
}
