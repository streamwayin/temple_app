import 'dart:async';
import 'dart:io';

import 'package:epub_view/epub_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'epub_viewer_event.dart';
part 'epub_viewer_state.dart';

class EpubViewerBloc extends Bloc<EpubViewerEvent, EpubViewerState> {
  EpubViewerBloc() : super(const EpubViewerState()) {
    on<EpubViewerInitialEvent>(onEpubViewerInitialEvent);
    on<AddNewBookmarkEvent>(onAddNewBookmarkEvent);
    on<GoTobookmark>(onGoTobookmark);
    on<ChangeFontSizeEvent>(onChangeFontSizeEvent);
  }

  FutureOr<void> onEpubViewerInitialEvent(
      EpubViewerInitialEvent event, Emitter<EpubViewerState> emit) {
    emit(state.copyWith(status: EpubViewerStatus.loading));
    EpubController controller =
        EpubController(document: EpubDocument.openFile(File(event.path)));
    emit(state.copyWith(
        status: EpubViewerStatus.loaded, epubReaderController: controller));
  }

  FutureOr<void> onAddNewBookmarkEvent(
      AddNewBookmarkEvent event, Emitter<EpubViewerState> emit) {
    List<Map<String, String>> bookmarks = [...state.bookmaks];

    Map<String, String> map = {
      "name": event.bookmarkName,
      "epubcfi": event.epubcfi
    };
    bookmarks.add(map);
    emit(state.copyWith(bookmaks: bookmarks, message: "Bookmark added !!!"));
  }

  FutureOr<void> onGoTobookmark(
      GoTobookmark event, Emitter<EpubViewerState> emit) {
    state.epubReaderController!.gotoEpubCfi(event.bookmarkMap["epubcfi"]!);
  }

  FutureOr<void> onChangeFontSizeEvent(
      ChangeFontSizeEvent event, Emitter<EpubViewerState> emit) {
    double fontSize = state.fontSize;
    if (event.decrease == true) {
      fontSize -= 2;
    }
    if (event.increase == true) {
      fontSize += 2;
    }
    emit(state.copyWith(fontSize: fontSize));
  }
}
