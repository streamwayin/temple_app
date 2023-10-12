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
  const EpubViewerState(
      {this.epubReaderController,
      this.status = EpubViewerStatus.loading,
      this.bookmaks = const [],
      this.message});

  @override
  List<Object?> get props => [epubReaderController, status, bookmaks, message];

  EpubViewerState copyWith({
    EpubController? epubReaderController,
    EpubViewerStatus? status,
    List<Map<String, String>>? bookmaks,
    String? message,
  }) {
    return EpubViewerState(
      epubReaderController: epubReaderController ?? this.epubReaderController,
      status: status ?? this.status,
      bookmaks: bookmaks ?? this.bookmaks,
      message: message,
    );
  }
}
