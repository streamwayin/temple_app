import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
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
  final EpubRepository repository;
  EbookBloc({required this.repository}) : super(const EbookState()) {
    on<FetchEpubListEvent>(onFetchEpubListEvent);
    on<DownloadBookEvent>(onDownloadBookEvent);
  }

  FutureOr<void> onDownloadBookEvent(
      DownloadBookEvent event, Emitter<EbookState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      EbookModel epubBook = state.booksList[event.index];
      String? downloadedPath;
      var map = {...state.downloadEbookMap};
      if (map.containsKey(epubBook.bookId)) {
        final path = map[epubBook.bookId];
        emit(state.copyWith(pathString: path));
        return;
      }
      if (Platform.isIOS) {
        final PermissionStatus status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          emit(state.copyWith(loading: true));
          Map<String, dynamic> map =
              await startDownload(epubBook.bookUrl, epubBook.name);
          if (map['success'] == true) {
            downloadedPath = map['path'];
          }
        } else {
          await Permission.storage.request();
        }
      } else if (Platform.isAndroid) {
        final map = await startDownload(epubBook.bookUrl, epubBook.name);
        if (map['success'] == true) {
          downloadedPath = map['path'];
        }
      } else {
        state.copyWith(message: "Unable to download");
      }
      if (downloadedPath == null) {
        return;
      }

      map[epubBook.bookId] = downloadedPath;
      var encodedData = jsonEncode(map);
      prefs.setString(OFFLINE_DOWNLOADED_EPUB_BOOKS_LIST_KEY, encodedData);
      emit(state.copyWith(downloadEbookMap: map, pathString: downloadedPath));
    } catch (e) {
      emit(state.copyWith(message: "Something went wrong"));
    }
  }

  Future<Map<String, dynamic>> startDownload(String url, String name) async {
    Map<String, dynamic> map = {"success": false, "path": ""};
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = '${appDocDir!.path}/$name.epub';
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

  FutureOr<void> onFetchEpubListEvent(
      FetchEpubListEvent event, Emitter<EbookState> emit) async {
    final list = await repository.getEpubListFromWeb();
    Map<String, String> downloadedEbookMap = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? offlineBooks =
        prefs.getString(OFFLINE_DOWNLOADED_EPUB_BOOKS_LIST_KEY);
    if (offlineBooks != null) {
      final decodedMap = json.decode(offlineBooks);
      decodedMap.forEach((key, value) {
        downloadedEbookMap[key] = value.toString();
      });
    }
    emit(state.copyWith(booksList: list, downloadEbookMap: downloadedEbookMap));
  }
}
