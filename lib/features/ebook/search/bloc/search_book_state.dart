part of 'search_book_bloc.dart';

class SearchBookState extends Equatable {
  final bool isSearching;
  final List<EbookModel> books;
  final EbookModel? selectedBook;
  final List<EbookModel> filteredBooks;
  final Map<String, String> downloadEbookMap;
  final String? pathString;
  final String? message;

  final bool loading;
  const SearchBookState(
      {this.isSearching = false,
      this.books = const [],
      this.filteredBooks = const [],
      this.downloadEbookMap = const {},
      this.loading = false,
      this.pathString,
      this.selectedBook,
      this.message});

  @override
  List<Object?> get props => [
        isSearching,
        books,
        filteredBooks,
        downloadEbookMap,
        loading,
        pathString,
        selectedBook,
        message
      ];

  SearchBookState copyWith({
    bool? isSearching,
    List<EbookModel>? books,
    List<EbookModel>? filteredBooks,
    Map<String, String>? downloadEbookMap,
    bool? loading,
    String? pathString,
    EbookModel? selectedBook,
    String? message,
  }) {
    return SearchBookState(
        isSearching: isSearching ?? this.isSearching,
        books: books ?? this.books,
        filteredBooks: filteredBooks ?? this.filteredBooks,
        downloadEbookMap: downloadEbookMap ?? this.downloadEbookMap,
        loading: loading ?? this.loading,
        pathString: pathString ?? this.pathString,
        selectedBook: selectedBook ?? this.selectedBook,
        message: message ?? this.message);
  }
}

final class SearchBookInitial extends SearchBookState {}
