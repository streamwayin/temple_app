part of 'ebook_bloc.dart';

class EbookState extends Equatable {
  final bool loading;
  final File? downloadedFilePath;
  final List<EbookModel> booksList;
  const EbookState(
      {this.loading = false,
      this.downloadedFilePath,
      this.booksList = const []});

  @override
  List<Object?> get props => [loading, downloadedFilePath, booksList];

  EbookState copyWith({
    bool? loading,
    File? downloadedFilePath,
    List<EbookModel>? booksList,
  }) {
    return EbookState(
      loading: loading ?? this.loading,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
      booksList: booksList ?? this.booksList,
    );
  }
}
