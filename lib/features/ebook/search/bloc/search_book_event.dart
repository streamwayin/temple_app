part of 'search_book_bloc.dart';

class SearchBookEvent extends Equatable {
  const SearchBookEvent();

  @override
  List<Object> get props => [];
}

class SearchBookInitialEvent extends SearchBookEvent {
  final List<EbookModel> books;
  SearchBookInitialEvent({
    required this.books,
  });
}

class SearchEvent extends SearchBookEvent {
  final String keyWord;
  const SearchEvent({
    required this.keyWord,
  });
}

class DownloadBookEvent extends SearchBookEvent {
  // final int index;
  final EbookModel book;

  const DownloadBookEvent({
    required this.book,
  });
}
