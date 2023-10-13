part of 'ebook_bloc.dart';

class EbookState extends Equatable {
  final bool loading;
  final File? downloadedFilePath;
  final List<EbookModel> booksList;
  final String? message;
  final Map<String, String> downloadEbookMap;
  final String? pathString;
  const EbookState({
    this.loading = false,
    this.downloadedFilePath,
    this.booksList = const [],
    this.message,
    this.downloadEbookMap = const {},
    this.pathString,
  });

  @override
  List<Object?> get props => [
        loading,
        downloadedFilePath,
        booksList,
        message,
        downloadEbookMap,
        pathString
      ];

  EbookState copyWith({
    bool? loading,
    File? downloadedFilePath,
    List<EbookModel>? booksList,
    String? message,
    Map<String, String>? downloadEbookMap,
    String? pathString,
  }) {
    return EbookState(
        loading: loading ?? this.loading,
        downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
        booksList: booksList ?? this.booksList,
        message: this.message,
        downloadEbookMap: downloadEbookMap ?? this.downloadEbookMap,
        pathString: pathString);
  }
}
