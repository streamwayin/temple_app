part of 'play_audio_bloc.dart';

class PlayAudioState extends Equatable {
  final List<AlbumModel> albums;
  final ConcatenatingAudioSource? concatenatingAudioSource;
  final int? currentAlbumIndex;
  final String? snackbarMessage;
  final bool isSongDownloading;
  final Map<String, String> downloadedSongsMap;
  const PlayAudioState(
      {this.albums = const [],
      this.concatenatingAudioSource,
      this.currentAlbumIndex,
      this.snackbarMessage,
      this.isSongDownloading = false,
      this.downloadedSongsMap = const {}});
  @override
  List<Object?> get props => [
        albums,
        concatenatingAudioSource,
        currentAlbumIndex,
        snackbarMessage,
        isSongDownloading,
        downloadedSongsMap
      ];

  PlayAudioState copyWith({
    List<AlbumModel>? albums,
    ConcatenatingAudioSource? concatenatingAudioSource,
    int? currentAlbumIndex,
    String? snackbarMessage,
    bool? isSongDownloading,
    Map<String, String>? downloadedSongsMap,
  }) {
    return PlayAudioState(
        albums: albums ?? this.albums,
        concatenatingAudioSource:
            concatenatingAudioSource ?? this.concatenatingAudioSource,
        currentAlbumIndex: currentAlbumIndex ?? this.currentAlbumIndex,
        snackbarMessage: snackbarMessage,
        isSongDownloading: isSongDownloading ?? this.isSongDownloading,
        downloadedSongsMap: downloadedSongsMap ?? this.downloadedSongsMap);
  }
}

class PlayAudioInitial extends PlayAudioState {}

class PlayAudioErrorState extends PlayAudioState {
  final String errorMesssage;

  const PlayAudioErrorState({required this.errorMesssage});
}

// class PlayAudioPlaylistState extends PlayAudioState {
//   final ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
//     // Start loading next item just before reaching it
//     useLazyPreparation: true,
//     // Customise the shuffle algorithm
//     shuffleOrder: DefaultShuffleOrder(),
//     // Specify the playlist items
//     children: [
//       AudioSource.uri(Uri.parse('https://example.com/track1.mp3')),
//       AudioSource.uri(Uri.parse('https://example.com/track2.mp3')),
//       AudioSource.uri(Uri.parse('https://example.com/track3.mp3')),
//     ],
//   );
// }
