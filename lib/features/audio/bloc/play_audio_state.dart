part of 'play_audio_bloc.dart';

class PlayAudioState extends Equatable {
  final List<AlbumModel> albums;
  final ConcatenatingAudioSource? concatenatingAudioSource;
  final int? singleSongIndex;
  final String? snackbarMessage;
  final bool isSongDownloading;
  final Map<String, String> downloadedSongsMap;
  final MusicPlayerDataModel? musicPlayerDataModel;
  final List<TrackModel>? tracks;
  final bool? isTracksAvailable;
  final bool albumsPageLoading;
  final bool tracksPageLoading;
  final int? currentAlbumIndex;
  final bool showBottomMusicController;
  final bool onPlayAudioScreen;
  final bool isPreviouslyTracksSaved;
  final List<TrackModel>? previouslySavedTracks;
  const PlayAudioState({
    this.albums = const [],
    this.concatenatingAudioSource,
    this.singleSongIndex,
    this.snackbarMessage,
    this.isSongDownloading = false,
    this.downloadedSongsMap = const {},
    this.musicPlayerDataModel,
    this.tracks,
    this.isTracksAvailable,
    this.albumsPageLoading = true,
    this.tracksPageLoading = true,
    this.currentAlbumIndex,
    this.showBottomMusicController = false,
    this.onPlayAudioScreen = false,
    this.isPreviouslyTracksSaved = false,
    this.previouslySavedTracks,
  });
  @override
  List<Object?> get props => [
        albums,
        concatenatingAudioSource,
        singleSongIndex,
        snackbarMessage,
        isSongDownloading,
        downloadedSongsMap,
        musicPlayerDataModel,
        tracks,
        isTracksAvailable,
        albumsPageLoading,
        tracksPageLoading,
        currentAlbumIndex,
        showBottomMusicController,
        onPlayAudioScreen,
        isPreviouslyTracksSaved,
        previouslySavedTracks
      ];

  PlayAudioState copyWith({
    List<AlbumModel>? albums,
    ConcatenatingAudioSource? concatenatingAudioSource,
    int? singleSongIndex,
    String? snackbarMessage,
    bool? isSongDownloading,
    Map<String, String>? downloadedSongsMap,
    MusicPlayerDataModel? musicPlayerDataModel,
    List<TrackModel>? tracks,
    bool? isTracksAvailable,
    bool? albumsPageLoading,
    bool? tracksPageLoading,
    int? currentAlbumIndex,
    bool? showBottomMusicController,
    bool? onPlayAudioScreen,
    bool? isPreviouslyTracksSaved,
    List<TrackModel>? previouslySavedTracks,
  }) {
    return PlayAudioState(
      albums: albums ?? this.albums,
      concatenatingAudioSource:
          concatenatingAudioSource ?? this.concatenatingAudioSource,
      singleSongIndex: singleSongIndex ?? this.singleSongIndex,
      snackbarMessage: snackbarMessage,
      isSongDownloading: isSongDownloading ?? this.isSongDownloading,
      downloadedSongsMap: downloadedSongsMap ?? this.downloadedSongsMap,
      musicPlayerDataModel: musicPlayerDataModel ?? this.musicPlayerDataModel,
      tracks: tracks ?? this.tracks,
      isTracksAvailable: isTracksAvailable,
      albumsPageLoading: albumsPageLoading ?? this.albumsPageLoading,
      tracksPageLoading: tracksPageLoading ?? this.tracksPageLoading,
      currentAlbumIndex: currentAlbumIndex ?? this.currentAlbumIndex,
      showBottomMusicController:
          showBottomMusicController ?? this.showBottomMusicController,
      onPlayAudioScreen: onPlayAudioScreen ?? this.onPlayAudioScreen,
      isPreviouslyTracksSaved:
          isPreviouslyTracksSaved ?? this.isPreviouslyTracksSaved,
      previouslySavedTracks:
          previouslySavedTracks ?? this.previouslySavedTracks,
    );
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
