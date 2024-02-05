import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temple_app/constants.dart';
import 'package:temple_app/modals/ebook_model.dart';
import 'package:temple_app/repositories/epub_repository.dart';

part 'ebook_event.dart';
part 'ebook_state.dart';

class EbookBloc extends Bloc<EbookEvent, EbookState> {
  late EpubRepository repository;
  final firebaseAnalytics = FirebaseAnalytics.instance;
  late SharedPreferences sharedPreferences;
  EbookBloc() : super(const EbookState()) {
    init();
    on<FetchEpubListFromWebEvent>(onFetchEpubListEvent);
    on<DownloadBookEventEbookList>(onDownloadBookEventEbookList);
    on<AddEbookListFromRefreshIndicatorEvent>(
        onAddEbookListFromRefreshIndicatorEvent);
    on<NavigateFromNotificaionBookEvent>(onNavigateFromNotificaionBookEvent);
  }
  void init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    firebaseAnalytics.setAnalyticsCollectionEnabled(true);
    firebaseAnalytics.setUserId(id: uid);
    repository = EpubRepository();
  }

  FutureOr<void> onDownloadBookEventEbookList(
      DownloadBookEventEbookList event, Emitter<EbookState> emit) async {
    emit(state.copyWith(loading: true));
    EbookModel epubBook = event.book;
    print(epubBook.toJson());
    firebaseAnalytics.logEvent(
        name: "book_read",
        parameters: {"bookId": epubBook.id, "book_name": epubBook.title});
    try {
      String? downloadedPath;
      var map = {...state.downloadEbookMap};
      print(map);
      if (map.containsKey(epubBook.id)) {
        final path = map[epubBook.id];
        emit(state.copyWith(
            pathString: path, loading: false, selectedBook: epubBook));
        return;
      }
      if (Platform.isIOS) {
        final PermissionStatus status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          Map<String, dynamic> map = await startDownload(
              epubBook.url, epubBook.title, epubBook.fileType);
          if (map['success'] == true) {
            downloadedPath = map['path'];
          }
        } else {
          await Permission.storage.request();
        }
      } else if (Platform.isAndroid) {
        final map = await startDownload(
            epubBook.url, epubBook.title, epubBook.fileType);
        if (map['success'] == true) {
          downloadedPath = map['path'];
        }
      } else {
        state.copyWith(message: "Unable to download", loading: false);
      }
      if (downloadedPath == null) {
        return;
      }

      map[epubBook.id] = downloadedPath;
      var encodedData = jsonEncode(map);
      sharedPreferences.setString(
          OFFLINE_DOWNLOADED_EPUB_BOOKS_LIST_KEY, encodedData);

      emit(state.copyWith(
          downloadEbookMap: map,
          pathString: downloadedPath,
          loading: false,
          selectedBook: epubBook));
    } catch (e) {
      emit(state.copyWith(message: "Something went wrong", loading: false));
    }
    emit(state.copyWith(loading: false));
  }

  Future<Map<String, dynamic>> startDownload(
      String url, String name, String fileType) async {
    Map<String, dynamic> map = {"success": false, "path": ""};
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = '${appDocDir!.path}/$name.$fileType';
    File file = File(path);

    Dio dio = Dio();
    await file.create();
    await dio.download(url, path, deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
      print('Download --- ${(receivedBytes / totalBytes) * 100}');
    });
    map["success"] = true;
    map['path'] = file.path;

    return map;
  }

  // FutureOr<void> onFetchEpubListEvent(
  //     FetchEpubListEvent event, Emitter<EbookState> emit) async {
  //   final list = await repository.getEpubListFromWeb();
  //   Map<String, String> downloadedEbookMap = {};
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? offlineBooks =
  //       prefs.getString(OFFLINE_DOWNLOADED_EPUB_BOOKS_LIST_KEY);
  //   if (offlineBooks != null) {
  //     final decodedMap = json.decode(offlineBooks);
  //     decodedMap.forEach((key, value) {
  //       downloadedEbookMap[key] = value.toString();
  //     });
  //   }
  //   emit(state.copyWith(booksList: list, downloadEbookMap: downloadedEbookMap));
  // }

  FutureOr<void> onFetchEpubListEvent(
      FetchEpubListFromWebEvent event, Emitter<EbookState> emit) async {
    emit(state.copyWith(loading: true));
    List<EbookModel>? list = await repository.getEpubListFromWeb();
    Map<String, String> downloadedEbookMap = {};
    if (list != null && list.isNotEmpty && list[0].index != null) {
      // Create a copy of the list before sorting
      List<EbookModel> tempTracks = List.from(list);
      int tempIndex = list.length + 1;
      tempTracks.sort(
          (a, b) => (a.index ?? tempIndex).compareTo(b.index ?? tempIndex));
      list = tempTracks;
    }
    String? offlineBooks =
        sharedPreferences.getString(OFFLINE_DOWNLOADED_EPUB_BOOKS_LIST_KEY);
    if (offlineBooks != null) {
      final decodedMap = json.decode(offlineBooks);
      decodedMap.forEach((key, value) {
        downloadedEbookMap[key] = value.toString();
      });
    }
    emit(state.copyWith(
        booksList: list, downloadEbookMap: downloadedEbookMap, loading: false));
  }

  FutureOr<void> onAddEbookListFromRefreshIndicatorEvent(
      AddEbookListFromRefreshIndicatorEvent event, Emitter<EbookState> emit) {
    emit(state.copyWith(booksList: event.bookList));
  }

  FutureOr<void> onNavigateFromNotificaionBookEvent(
      NavigateFromNotificaionBookEvent event, Emitter<EbookState> emit) {
    emit(state.copyWith(navigateFromNotificaionBook: true));
  }
}
