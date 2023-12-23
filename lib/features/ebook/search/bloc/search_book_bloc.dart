import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants.dart';
import '../../../../modals/ebook_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_book_event.dart';
part 'search_book_state.dart';

class SearchBookBloc extends Bloc<SearchBookEvent, SearchBookState> {
  SearchBookBloc() : super(SearchBookInitial()) {
    on<SearchBookInitialEvent>(onSearchBookInitialEvent);
    on<SearchEvent>(onSearchEvent);
    on<DownloadBookEvent>(onDownloadBookEvent);
  }

  FutureOr<void> onSearchEvent(event, Emitter<dynamic> emit) {
    print('object');
    var books = state.books;
    List<EbookModel> _filteredBooks = [];
    _filteredBooks = books
        .where((book) =>
            book.title.toLowerCase().contains(event.keyWord.toLowerCase()))
        .toList();
    print(_filteredBooks);
    emit(state.copyWith(filteredBooks: _filteredBooks));
  }

  FutureOr<void> onSearchBookInitialEvent(event, Emitter<dynamic> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? offlineBooks =
        prefs.getString(OFFLINE_DOWNLOADED_EPUB_BOOKS_LIST_KEY);
    Map<String, String> downloadedEbookMap = {};
    if (offlineBooks != null) {
      final decodedMap = json.decode(offlineBooks);
      decodedMap.forEach((key, value) {
        downloadedEbookMap[key] = value.toString();
      });
    }
    emit(state.copyWith(
        books: event.books, downloadEbookMap: downloadedEbookMap));
  }

  FutureOr<void> onDownloadBookEvent(event, Emitter<dynamic> emit) async {
    emit(state.copyWith(loading: true));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      EbookModel epubBook = event.book;
      String? downloadedPath;
      var map = {...state.downloadEbookMap};
      if (map.containsKey(epubBook.id)) {
        final path = map[epubBook.id];
        emit(state.copyWith(
            pathString: path, loading: false, selectedBook: epubBook));
        return;
      }
      if (Platform.isIOS) {
        final PermissionStatus status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          Map<String, dynamic> map =
              await startDownload(epubBook.id, epubBook.id);
          if (map['success'] == true) {
            downloadedPath = map['path'];
          }
        } else {
          await Permission.storage.request();
        }
      } else if (Platform.isAndroid) {
        final map = await startDownload(epubBook.url, epubBook.title);
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
      prefs.setString(OFFLINE_DOWNLOADED_EPUB_BOOKS_LIST_KEY, encodedData);
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
}
