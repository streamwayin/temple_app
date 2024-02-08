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

class AddCarouslDataFromRefreshIndicator extends HomeEvent {
  final List<CarouselModel> carouslList;

  AddCarouslDataFromRefreshIndicator({
    required this.carouslList,
  });
}

class NavigateFromNotificaionToImageFromHomeEvent extends HomeEvent {}

class ToggleNavigateFromNotificaionToImageFromHomeEvent extends HomeEvent {
  final bool toogleNaviBool;

  ToggleNavigateFromNotificaionToImageFromHomeEvent(
      {required this.toogleNaviBool});
}

class NavigateFromNotificationScreenToAlbumsEvent extends HomeEvent {}

class ToggleNavigateFromNotificationScreenToAlbumsEvent extends HomeEvent {
  final bool toogleAlbumNavi;

  ToggleNavigateFromNotificationScreenToAlbumsEvent(
      {required this.toogleAlbumNavi});
}

class NavigateFromNotificaionFromHomeEventPlayAudioScreen extends HomeEvent {}

class ToggleNavigateFromNotificaionFromHomeEventPlayAudioScreen
    extends HomeEvent {
  final bool togglePlayAudioScreenNavi;

  ToggleNavigateFromNotificaionFromHomeEventPlayAudioScreen(
      {required this.togglePlayAudioScreenNavi});
}
