part of 'ebook_bloc.dart';

class EbookEvent extends Equatable {
  const EbookEvent();

  @override
  List<Object> get props => [];
}

class FetchEpubListEvent extends EbookEvent {}

class DownloadBookEvent extends EbookEvent {
  final int index;

  const DownloadBookEvent({
    required this.index,
  });
}