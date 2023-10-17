part of 'epub_viewer_bloc.dart';

enum EpubViewerStatus {
  loading,
  loaded,
  error,
}

class EpubViewerState extends Equatable {
  final EpubController? epubReaderController;
  final EpubViewerStatus status;
  final List<Map<String, String>> bookmaks;
  final String? message;
  final double fontSize;
  final int backgroundColor;
  final bool openIndexIcon;
  final int bodyIndex;
  final EbookModel? book;
  const EpubViewerState({
    this.epubReaderController,
    this.status = EpubViewerStatus.loading,
    this.bookmaks = const [],
    this.message,
    this.fontSize = 16.0,
    this.backgroundColor = 0xFFFFFFFF,
    this.bodyIndex = 0,
    this.openIndexIcon = true,
    this.book,
  });

  @override
  List<Object?> get props => [
        epubReaderController,
        status,
        bookmaks,
        message,
        fontSize,
        backgroundColor,
        openIndexIcon,
        bodyIndex,
        book,
      ];

  EpubViewerState copyWith({
    EpubController? epubReaderController,
    EpubViewerStatus? status,
    List<Map<String, String>>? bookmaks,
    String? message,
    double? fontSize,
    int? backgroundColor,
    bool? showBookIndex,
    bool? showSavedIndex,
    bool? openIndexIcon,
    int? bodyIndex,
    EbookModel? book,
  }) {
    return EpubViewerState(
      epubReaderController: epubReaderController ?? this.epubReaderController,
      status: status ?? this.status,
      bookmaks: bookmaks ?? this.bookmaks,
      message: message,
      fontSize: fontSize ?? this.fontSize,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      openIndexIcon: openIndexIcon ?? this.openIndexIcon,
      bodyIndex: bodyIndex ?? this.bodyIndex,
      book: book ?? this.book,
    );
  }
}
