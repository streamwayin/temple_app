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
  final bool showBookIndex;
  final bool showSavedIndex;

  const EpubViewerState({
    this.epubReaderController,
    this.status = EpubViewerStatus.loading,
    this.bookmaks = const [],
    this.message,
    this.fontSize = 16.0,
    this.backgroundColor = 0xFFFFFFFF,
    this.showBookIndex = false,
    this.showSavedIndex = false,
  });

  @override
  List<Object?> get props => [
        epubReaderController,
        status,
        bookmaks,
        message,
        fontSize,
        backgroundColor,
        showBookIndex,
        showSavedIndex
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
  }) {
    return EpubViewerState(
      epubReaderController: epubReaderController ?? this.epubReaderController,
      status: status ?? this.status,
      bookmaks: bookmaks ?? this.bookmaks,
      message: message,
      fontSize: fontSize ?? this.fontSize,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showBookIndex: showBookIndex ?? this.showBookIndex,
      showSavedIndex: showSavedIndex ?? this.showSavedIndex,
    );
  }
}
