part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.onPlayAudioScreen = false,
    this.updateMandatory = false,
    this.cauraselPageIndex = 0,
    this.booksList = const [],
    this.downloadEbookMap = const {},
    this.booksLoading = false,
    this.bannerText,
    this.carouselList = const [],
    this.navigateToImageFromNotification = false,
    this.navigateToImageFromNotificationToAlbum = false,
    this.navigateToFromNotificationToPlayAudioScreen = false,
  });
  final bool onPlayAudioScreen;
  final bool updateMandatory;
  final int cauraselPageIndex;
  final List<EbookModel> booksList;
  final Map<String, String> downloadEbookMap;
  final bool booksLoading;
  final BannerModel? bannerText;
  final List<CarouselModel> carouselList;
  final bool navigateToImageFromNotification;
  final bool navigateToImageFromNotificationToAlbum;
  final bool navigateToFromNotificationToPlayAudioScreen;
  @override
  List<Object?> get props => [
        onPlayAudioScreen,
        cauraselPageIndex,
        updateMandatory,
        booksLoading,
        bannerText,
        navigateToImageFromNotification,
        navigateToImageFromNotificationToAlbum,
        navigateToFromNotificationToPlayAudioScreen
      ];
  HomeState copyWith({
    bool? onPlayAudioScreen,
    bool? updateMandatory,
    int? cauraselPageIndex,
    List<EbookModel>? booksList,
    Map<String, String>? downloadEbookMap,
    bool? booksLoading,
    BannerModel? bannerText,
    List<CarouselModel>? carouselList,
    bool? navigateToImageFromNotification,
    bool? navigateToImageFromNotificationToAlbum,
    bool? navigateToFromNotificationToPlayAudioScreen,
  }) {
    return HomeState(
      onPlayAudioScreen: onPlayAudioScreen ?? this.onPlayAudioScreen,
      updateMandatory: updateMandatory ?? this.updateMandatory,
      cauraselPageIndex: cauraselPageIndex ?? this.cauraselPageIndex,
      booksList: booksList ?? this.booksList,
      downloadEbookMap: downloadEbookMap ?? this.downloadEbookMap,
      booksLoading: booksLoading ?? this.booksLoading,
      bannerText: bannerText ?? this.bannerText,
      carouselList: carouselList ?? this.carouselList,
      navigateToImageFromNotification: navigateToImageFromNotification ??
          this.navigateToImageFromNotification,
      navigateToImageFromNotificationToAlbum:
          navigateToImageFromNotificationToAlbum ??
              this.navigateToImageFromNotificationToAlbum,
      navigateToFromNotificationToPlayAudioScreen:
          navigateToFromNotificationToPlayAudioScreen ??
              this.navigateToFromNotificationToPlayAudioScreen,
    );
  }
}

final class HomeInitial extends HomeState {}
