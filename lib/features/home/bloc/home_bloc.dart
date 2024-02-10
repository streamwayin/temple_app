import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temple_app/modals/app_update_model.dart';
import 'package:temple_app/modals/banner_model.dart';
import 'package:temple_app/modals/carousel_model.dart';
import 'package:temple_app/modals/ebook_model.dart';
import 'package:temple_app/modals/video_model.dart';
import 'package:temple_app/repositories/home_repository.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../constants.dart';
import '../../../repositories/epub_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late HomeRepository homeRepository;
  late EpubRepository bookRepository;
  late SharedPreferences sharedPreferences;
  HomeBloc() : super(HomeInitial()) {
    _initilize();
    on<HomeEventInitial>(onHomeEventInitial);
    on<ChangeOnPlayAudioSreenOrNot>((event, emit) {
      emit(state.copyWith(onPlayAudioScreen: event.onPlayAudioScreen));
    });
    on<CarouselPageIndexChanged>(onCarouselPageIndexChanged);
    on<AddStateEbookDataFromRefreshIndicator>(
        onAddStateEbookDataFromRefreshIndicator);
    on<AddCarouslDataFromRefreshIndicator>(
        onAddCarouslDataFromRefreshIndicator);
    on<NavigateFromNotificaionToImageFromHomeEvent>(
        onNavigateFromNotificaionToImageFromHomeEvent);
    on<ToggleNavigateFromNotificaionToImageFromHomeEvent>(
        onToggleNavigateFromNotificaionToImageFromHomeEvent);
    on<NavigateFromNotificationScreenToAlbumsEvent>(
        onNavigateFromNotificationScreenToAlbumsEvent);
    on<ToggleNavigateFromNotificationScreenToAlbumsEvent>(
        onToggleNavigateFromNotificationScreenToAlbumsEvent);
    on<NavigateFromNotificaionFromHomeEventPlayAudioScreen>(
        onNavigateFromNotificaionFromHomeEventPlayAudioScreen);
    on<ToggleNavigateFromNotificaionFromHomeEventPlayAudioScreen>(
        onToggleNavigateFromNotificaionFromHomeEventPlayAudioScreen);
    on<NavigateFromNotificaionFromHomeEventImageScreen>(
        onNavigateFromNotificaionFromHomeEventImageScreen);
    on<ToggleNavigateFromNotificaionFromHomeEventImageScreen>(
        onToggleNavigateFromNotificaionFromHomeEventImageScreen);
    on<NavigateFromNotificaionFromHomeEventVidoeScreen>(
        onNavigateFromNotificaionFromHomeEventVidoeScreen);
    on<ToggleNavigateFromNotificaionFromHomeEventVidoeScreen>(
        onToggleNavigateFromNotificaionFromHomeEventVidoeScreen);
    on<NavigateFromNotificationFromHomeEventEventsScreen>(
        onNavigateFromNotificationFromHomeEventEventsScreen);
    on<ToggleNavigateFromNotificationFromHomeEventEventsScreen>(
        onToggleNavigateFromNotificationFromHomeEventEventsScreen);
  }

  void _initilize() async {
    homeRepository = HomeRepository();
    bookRepository = EpubRepository();
    sharedPreferences = await SharedPreferences.getInstance();
  }

  FutureOr<void> onHomeEventInitial(
      HomeEventInitial event, Emitter<HomeState> emit) async {
    emit(state.copyWith(booksLoading: true));
    AppUpdateModel? appUpdateModel = await homeRepository.getMetadata();

    final quotes = await homeRepository.getQuotes();

    if (appUpdateModel != null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.version != '${appUpdateModel.version}' &&
          appUpdateModel.mandatory == true) {
        emit(state.copyWith(updateMandatory: true));
      }
    }

    final list = await bookRepository.getEpubListFromWeb();
    // get banner data fileter them
    final carouselList = await homeRepository.getCarouselImagesFromDB();
    List<CarouselModel> tempListWithVisible = [];
    if (carouselList != null) {
      for (var a in carouselList) {
        if (a.visibility == true) {
          tempListWithVisible.add(a);
        }
      }
    }
    tempListWithVisible.sort((a, b) => (a.index).compareTo(b.index));
    Map<String, String> downloadedEbookMap = {};

    String? offlineBooks =
        sharedPreferences.getString(OFFLINE_DOWNLOADED_EPUB_BOOKS_LIST_KEY);
    if (offlineBooks != null) {
      final decodedMap = json.decode(offlineBooks);
      decodedMap.forEach((key, value) {
        downloadedEbookMap[key] = value.toString();
      });
    }
    emit(state.copyWith(
        booksList: list,
        downloadEbookMap: downloadedEbookMap,
        booksLoading: false,
        bannerText: quotes,
        carouselList: tempListWithVisible));
  }

  FutureOr<void> onCarouselPageIndexChanged(
      CarouselPageIndexChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(cauraselPageIndex: event.newIndex));
  }

  FutureOr<void> onAddStateEbookDataFromRefreshIndicator(
      AddStateEbookDataFromRefreshIndicator event, Emitter<HomeState> emit) {
    emit(state.copyWith(booksList: event.bookList));
  }

  FutureOr<void> onAddCarouslDataFromRefreshIndicator(
      AddCarouslDataFromRefreshIndicator event, Emitter<HomeState> emit) {
    emit(state.copyWith(carouselList: event.carouslList));
  }

  FutureOr<void> onNavigateFromNotificaionToImageFromHomeEvent(
      NavigateFromNotificaionToImageFromHomeEvent event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(navigateToImageFromNotification: true));
  }

  FutureOr<void> onToggleNavigateFromNotificaionToImageFromHomeEvent(
      ToggleNavigateFromNotificaionToImageFromHomeEvent event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(navigateToImageFromNotification: event.toogleNaviBool));
  }

  FutureOr<void> onNavigateFromNotificationScreenToAlbumsEvent(
      NavigateFromNotificationScreenToAlbumsEvent event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(navigateToImageFromNotificationToAlbum: true));
  }

  FutureOr<void> onToggleNavigateFromNotificationScreenToAlbumsEvent(
      ToggleNavigateFromNotificationScreenToAlbumsEvent event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(
        navigateToImageFromNotificationToAlbum: event.toogleAlbumNavi));
  }

  FutureOr<void> onNavigateFromNotificaionFromHomeEventPlayAudioScreen(
      NavigateFromNotificaionFromHomeEventPlayAudioScreen event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(navigateToFromNotificationToPlayAudioScreen: true));
  }

  FutureOr<void> onToggleNavigateFromNotificaionFromHomeEventPlayAudioScreen(
      ToggleNavigateFromNotificaionFromHomeEventPlayAudioScreen event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(navigateToFromNotificationToPlayAudioScreen: false));
  }

  FutureOr<void> onNavigateFromNotificaionFromHomeEventImageScreen(
      NavigateFromNotificaionFromHomeEventImageScreen event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(navigateToFromNotificationToImageScreen: true));
  }

  FutureOr<void> onToggleNavigateFromNotificaionFromHomeEventImageScreen(
      ToggleNavigateFromNotificaionFromHomeEventImageScreen event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(
        navigateToFromNotificationToImageScreen: event.toggleImageScreenNavi));
  }

  FutureOr<void> onNavigateFromNotificaionFromHomeEventVidoeScreen(
      NavigateFromNotificaionFromHomeEventVidoeScreen event,
      Emitter<HomeState> emit) async {
    var yt = YoutubeExplode();
    var video = await yt.videos.get(event.youtubeVideoId);
    Map<String, String> localVideoMap = {};
    localVideoMap["id"] = video.id.value;
    localVideoMap["title"] = video.title;
    localVideoMap["description"] = video.description;
    localVideoMap["url"] = video.url;

    localVideoMap["duration"] = "${video.duration!.inMilliseconds}";

    localVideoMap["thumbnail"] =
        "https://i.ytimg.com/vi/${video.id}/sddefault.jpg";
    VideoModel videoModel = VideoModel.fromJson(localVideoMap);
    print(" navigateToFromNotificationToYoutubeScreen: true,");
    print(videoModel.toJson());
    emit(state.copyWith(
        navigateToFromNotificationToYoutubeScreen: true,
        youtubeVidoeIdForNoification: [videoModel]));
  }

  FutureOr<void> onToggleNavigateFromNotificaionFromHomeEventVidoeScreen(
      ToggleNavigateFromNotificaionFromHomeEventVidoeScreen event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(
        navigateToFromNotificationToYoutubeScreen:
            event.toggleYoutubVideoScreenNavi));
  }

  FutureOr<void> onNavigateFromNotificationFromHomeEventEventsScreen(
      NavigateFromNotificationFromHomeEventEventsScreen event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(navigateToFromNotificationToYoutubeScreen: true));
  }

  FutureOr<void> onToggleNavigateFromNotificationFromHomeEventEventsScreen(
      ToggleNavigateFromNotificationFromHomeEventEventsScreen event,
      Emitter<HomeState> emit) {
    emit(state.copyWith(
        navigateToFromNotificationToYoutubeScreen:
            event.toggleEventScreenNavi));
  }
}
