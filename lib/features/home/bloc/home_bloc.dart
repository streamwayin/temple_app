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
import 'package:temple_app/modals/image_album_model.dart';
import 'package:temple_app/repositories/home_repository.dart';

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
}
