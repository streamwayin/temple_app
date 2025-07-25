part of 'epub_viewer_bloc.dart';

class EpubViewerEvent extends Equatable {
  const EpubViewerEvent();

  @override
  List<Object> get props => [];
}

class EpubViewerInitialEvent extends EpubViewerEvent {
  final String path;
  final EbookModel book;

  const EpubViewerInitialEvent({required this.path, required this.book});
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

class ChangeBodyStackIndexEvent extends EpubViewerEvent {
  final int bodyIndex;
  const ChangeBodyStackIndexEvent({required this.bodyIndex});
}

class ScrollToEvent extends EpubViewerEvent {
  final int index;

  const ScrollToEvent({required this.index});
}
