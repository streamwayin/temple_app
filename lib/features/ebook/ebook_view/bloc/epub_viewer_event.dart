part of 'epub_viewer_bloc.dart';

class EpubViewerEvent extends Equatable {
  const EpubViewerEvent();

  @override
  List<Object> get props => [];
}

class EpubViewerInitialEvent extends EpubViewerEvent {}

class AddNewBookmarkEvent extends EpubViewerEvent {
  final String bookmarkName;
  final String epubcfi;

  const AddNewBookmarkEvent(
      {required this.bookmarkName, required this.epubcfi});
}

class GoTobookmark extends EpubViewerEvent {
  final Map<String, String> bookmarkMap;

  const GoTobookmark({required this.bookmarkMap});
}
