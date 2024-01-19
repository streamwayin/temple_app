part of 'ebook_bloc.dart';

class EbookEvent extends Equatable {
  const EbookEvent();

  @override
  List<Object> get props => [];
}

// class FetchEpubListEvent extends EbookEvent {}
class FetchEpubListFromWebEvent extends EbookEvent {}

class DownloadBookEventEbookList extends EbookEvent {
  // final int index;
  final EbookModel book;

  const DownloadBookEventEbookList({
    required this.book,
  });
}

class AddEbookListFromRefreshIndicatorEvent extends EbookEvent {
  final List<EbookModel> bookList;

  AddEbookListFromRefreshIndicatorEvent({required this.bookList});
}
