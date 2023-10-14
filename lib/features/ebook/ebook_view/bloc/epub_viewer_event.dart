part of 'epub_viewer_bloc.dart';

class EpubViewerEvent extends Equatable {
  const EpubViewerEvent();

  @override
  List<Object> get props => [];
}

class EpubViewerInitialEvent extends EpubViewerEvent {
  final String path;

  const EpubViewerInitialEvent({required this.path});
}

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

class ChangeFontSizeEvent extends EpubViewerEvent {
  final bool increase;
  final bool decrease;

  const ChangeFontSizeEvent({
    this.increase = false,
    this.decrease = false,
  });
}

class BackgroundColorChangedEvent extends EpubViewerEvent {
  final int backgroundColor;

  const BackgroundColorChangedEvent({required this.backgroundColor});
}

class ShowBookIndexEvent extends EpubViewerEvent {
  final bool showBookIndex;

  const ShowBookIndexEvent({required this.showBookIndex});
}
