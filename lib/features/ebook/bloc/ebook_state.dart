part of 'ebook_bloc.dart';

class EbookState extends Equatable {
  final bool loading;
  final File? downloadedFilePath;
  const EbookState({this.loading = false, this.downloadedFilePath});

  @override
  List<Object?> get props => [loading, downloadedFilePath];

  EbookState copyWith({bool? loading, File? downloadedFilePath}) {
    return EbookState(
      loading: loading ?? this.loading,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
    );
  }
}
