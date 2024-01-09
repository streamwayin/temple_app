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
  final String? currentAlbumId;
  final String? currentPlaylistAlbumId;
  final bool showBottomMusicController;
  final bool onPlayAudioScreen;
  final bool onAboutUsNavBar;
  final bool? isPreviouslyTracksSaved;
  final List<TrackModel>? previouslySavedTracks;
  final List<ArtistModel> artistList;
  final List<TrackModel>? currentPlaylistTracks;
  final int savedInitialEvent;
  final bool updateSavedDataOfPlayer;
  final bool isLooping;
  final bool isSuffling;
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
    this.currentAlbumId,
    this.currentPlaylistAlbumId,
    this.showBottomMusicController = false,
    this.onPlayAudioScreen = false,
    this.onAboutUsNavBar = false,
    this.isPreviouslyTracksSaved = false,
    this.previouslySavedTracks,
    this.artistList = const [],
    this.currentPlaylistTracks,
    this.savedInitialEvent = 0,
    this.updateSavedDataOfPlayer = false,
    this.isLooping = false,
    this.isSuffling = false,
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
        currentAlbumId,
        currentPlaylistAlbumId,
        showBottomMusicController,
        onPlayAudioScreen,
        isPreviouslyTracksSaved,
        previouslySavedTracks,
        artistList,
        onAboutUsNavBar,
        currentPlaylistTracks,
        savedInitialEvent,
        updateSavedDataOfPlayer,
        isLooping,
        isSuffling,
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
    String? currentAlbumId,
    String? currentPlaylistAlbumId,
    bool? showBottomMusicController,
    bool? onPlayAudioScreen,
    bool? onAboutUsNavBar,
    bool? isPreviouslyTracksSaved,
    List<TrackModel>? previouslySavedTracks,
    List<ArtistModel>? artistList,
    List<TrackModel>? currentPlaylistTracks,
    int? savedInitialEvent,
    bool? updateSavedDataOfPlayer,
    bool? isLooping,
    bool? isSuffling,
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
      currentAlbumId: currentAlbumId ?? this.currentAlbumId,
      currentPlaylistAlbumId:
          currentPlaylistAlbumId ?? this.currentPlaylistAlbumId,
      showBottomMusicController:
          showBottomMusicController ?? this.showBottomMusicController,
      onPlayAudioScreen: onPlayAudioScreen ?? this.onPlayAudioScreen,
      onAboutUsNavBar: onAboutUsNavBar ?? this.onAboutUsNavBar,
      isPreviouslyTracksSaved: isPreviouslyTracksSaved,
      previouslySavedTracks:
          previouslySavedTracks ?? this.previouslySavedTracks,
      artistList: artistList ?? this.artistList,
      currentPlaylistTracks:
          currentPlaylistTracks ?? this.currentPlaylistTracks,
      savedInitialEvent: savedInitialEvent ?? this.savedInitialEvent,
      // insert false if we want to  upadte plater data in index
      updateSavedDataOfPlayer: updateSavedDataOfPlayer ?? false,
      isLooping: isLooping ?? false,
      isSuffling: isSuffling ?? false,
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
