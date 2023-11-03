part of 'ebook_bloc.dart';

class EbookState extends Equatable {
  final bool loading;
  final File? downloadedFilePath;
  final List<EbookModel> booksList;
  final String? message;
  final Map<String, String> downloadEbookMap;
  final String? pathString;
  final EbookModel? selectedBook;
  final bool isSearching;
  const EbookState({
    this.loading = false,
    this.downloadedFilePath,
    this.booksList = const [],
    this.message,
    this.downloadEbookMap = const {},
    this.pathString,
    this.selectedBook,
    this.isSearching = false,
  });

  @override
  List<Object?> get props => [
        loading,
        downloadedFilePath,
        booksList,
        message,
        downloadEbookMap,
        pathString,
        selectedBook,
        isSearching
      ];

  EbookState copyWith({
    bool? loading,
    File? downloadedFilePath,
    List<EbookModel>? booksList,
    String? message,
    Map<String, String>? downloadEbookMap,
    String? pathString,
    EbookModel? selectedBook,
    bool? isSearching,
  }) {
    return EbookState(
      loading: loading ?? this.loading,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
      booksList: booksList ?? this.booksList,
      message: this.message,
      downloadEbookMap: downloadEbookMap ?? this.downloadEbookMap,
      pathString: pathString,
      selectedBook: selectedBook ?? this.selectedBook,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}
