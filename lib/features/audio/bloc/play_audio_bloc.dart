// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temple_app/modals/album_model.dart';
import 'package:temple_app/modals/music_player_data_model.dart';
import 'package:temple_app/modals/track_model.dart';
import 'package:temple_app/repositories/audo_repository.dart';
import 'package:temple_app/widgets/utils.dart';

import '../../../constants.dart';
import '../../../modals/aritst_model.dart';

part 'play_audio_event.dart';
part 'play_audio_state.dart';

class PlayAudioBloc extends Bloc<PlayAudioEvent, PlayAudioState> {
  final AudioRepository audioRepository;
  PlayAudioBloc({required this.audioRepository}) : super(PlayAudioInitial()) {
    _getPref();
    on<PlayAudioEventInitial>(onPlayAudioEventInitial);
    on<AlbumIndexChanged>(onAlbumIndexChanged);
    on<SongIndexChanged>(onSongIndexChanged);
    on<LoadCurrentPlaylistEvent>(onLoadCurrentPlaylistEvent);
    on<DownloadSongEvent>(onDownloadSongEvent);
    on<ChangeSongEvent>(onPlayNextSongEvent);
    on<PlayOrPauseSongEvent>(onPlayOrPauseSongEvent);
    on<SetSeekDurationEvent>(onSetSeekDurationEvent);
    on<FetchSongsOfAlbum>(onFetchSongsOfAlbum);
    on<PlaySinglesongEvent>(onPlaySinglesongEvent);
    on<UpdateSelectedAlbumIndex>(onUpdateSelectedAlbumIndex);
    on<ChangeShowBottomMusicController>(onChangeShowBottomMusicController);
    on<SaveCurrentAlbumToLocalStorage>(onSaveCurrentAlbumToLocalStorage);
    on<LoadSavedTrackInPlayerEvent>(onLoadSavedTrackInPlayerEvent);
    on<GetAlbumsByArtistEvent>(onGetAlbumsByArtistEvent);
    on<ChangeOnAboutUsNavBar>(onChangeOnAboutUsNavBar);
    on<ChangeCurrentPlaylistAlbumId>(onChangeCurrentPlaylistAlbumId);
    on<SavePlayingTracksEvent>(onSavePlayingTracksEvent);
    on<AddAlubmDateFromRefreshIndicator>(onAddAlubmDateFromRefreshIndicator);
    on<AddTrackDateFromRefreshIndicator>(onAddTrackDateFromRefreshIndicator);

    on<PlaySingleSongFromNotificationEvent>(
        onPlaySingleSongFromNotificationEvent);

    on<ReplaySongEvent>(onReplaySongEvent);
    // on<ToggleLoopMode>(onToggleLoopMode);
    // on<ToggleSuffleMode>(onToggleSuffleMode);
  }
  late SharedPreferences sharedPreferences;
  FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
  void _getPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    firebaseAnalytics.setAnalyticsCollectionEnabled(true);
    firebaseAnalytics.setUserId(id: uid);
  }

  FutureOr<void> onPlayAudioEventInitial(
      PlayAudioEventInitial event, Emitter<PlayAudioState> emit) async {
    emit(state.copyWith(albumsPageLoading: true));
    final list = await audioRepository.getAlbumListFromDb();
    var artistsList = await audioRepository.getAritstsListFromDb();
    if (artistsList != null) {
      artistsList.sort((a, b) => (a.index).compareTo(b.index));
    }
    Map<String, String> downloadedSongsMap = {};
    if (list != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? offlineSongs = prefs.getString(OFFLINE_DOWNLOADED_SONG_LIST_KEY);
      if (offlineSongs != null) {
        final decodedMap = json.decode(offlineSongs);
        decodedMap.forEach((key, value) {
          downloadedSongsMap[key] = value.toString();
        });
      }

      // check if song is saved previously or not
      String? currentlyPlayingAlbum =
          prefs.getString(CURRENTLY_PLAYING_ALBUM_MAP);
      if (currentlyPlayingAlbum != null) {
        Map<String, dynamic> savedMap = jsonDecode(currentlyPlayingAlbum);
        String tracksDataJson = savedMap["tracksData"];
        String albumDataJson = savedMap["albumData"];
        int index = 0;

        int? tempIndex = sharedPreferences.getInt(PLAYLIST_CURRENT_SONG_INDEX);
        if (tempIndex != null) {
          index = tempIndex;
        }
        AlbumModel albumModel = AlbumModel.fromJson(jsonDecode(albumDataJson));
        List<dynamic> tracksMapList = jsonDecode(tracksDataJson);
        List<TrackModel> trackList2 =
            tracksMapList.map((map) => TrackModel.fromJson(map)).toList();
        bool isTracksListempty = trackList2.isEmpty ? false : true;
        audioRepository.playSingleSong(2);
        var shortedAlubmList;
        if (list != null && list.isNotEmpty && list[0].index != null) {
          // Create a copy of the list before sorting
          List<AlbumModel> tempTracks = List.from(list);
          int listLength = tempTracks.length + 1;
          tempTracks.sort((a, b) =>
              (a.index ?? listLength).compareTo(b.index ?? listLength));
          shortedAlubmList = tempTracks;
        }
        emit(
          state.copyWith(
            albums: shortedAlubmList,
            downloadedSongsMap: downloadedSongsMap,
            albumsPageLoading: false,
            artistList: artistsList,
            isPreviouslyTracksSaved: isTracksListempty,
            previouslySavedTracks: trackList2,
            currentAlbumId: albumModel.albumId,
            onPlayAudioScreen: false,
            currentPlaylistTracks: trackList2,
            savedInitialEvent: index,
          ),
        );
      } else {
        emit(
          state.copyWith(
            albums: list,
            downloadedSongsMap: downloadedSongsMap,
            albumsPageLoading: false,
            artistList: artistsList,
          ),
        );
      }
    }
  }

// rearanging the albums
  FutureOr<void> onAlbumIndexChanged(
      AlbumIndexChanged event, Emitter<PlayAudioState> emit) {
    int oldIndex = event.oldIndex;
    int newIndex = event.newIndex;
    var albumList = state.albums;
    var album = albumList[oldIndex];
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    albumList
      ..removeAt(oldIndex)
      ..insert(newIndex, album);
    emit(state.copyWith(albums: albumList));
  }

// rearranging the songs
  FutureOr<void> onSongIndexChanged(
      SongIndexChanged event, Emitter<PlayAudioState> emit) {
    int oldIndex = event.oldIndex;
    int newIndex = event.newIndex;
    var songs = state.tracks;
    var song = songs![oldIndex];
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    songs
      ..removeAt(oldIndex)
      ..insert(newIndex, song);
  }

  FutureOr<void> onLoadCurrentPlaylistEvent(
      LoadCurrentPlaylistEvent event, Emitter<PlayAudioState> emit) async {
    List<AudioSource> audioSourceList = state.tracks!
        .map(
          (e) => (!state.downloadedSongsMap.containsKey(e.trackId))
              ? AudioSource.uri(
                  Uri.parse(e.songUrl),
                  tag: MediaItem(
                    id: '1',
                    title: e.translated.hi,
                    artist: e.artistName,
                    artUri: Uri.parse(e.thumbnail!),
                  ),
                )
              : AudioSource.file(
                  state.downloadedSongsMap[e.trackId]!,
                  tag: MediaItem(
                    id: '1',
                    title: e.translated.hi,
                    artist: e.artistName,
                  ),
                ),
        )
        .toList();
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      children: audioSourceList,
    );
    audioRepository.addPlaylist(
        playList: playlist, initialIndex: event.initialIndex);
    await emit.forEach(
      audioRepository.musicPlayerDataStream,
      onData: (data) {
        int? index = audioRepository.currentSongIndex();
        int duration = data.positionData.position.inSeconds;
        if (index != null) {
          sharedPreferences.setInt(PLAYLIST_CURRENT_SONG_INDEX, index);
          sharedPreferences.setInt(PLAYLIST_CURRENT_SONG_DURATION, duration);
        }
        return state.copyWith(
            // currentAlbumIndex: event.albumIndex,
            singleSongIndex: index,
            musicPlayerDataModel: data);
      },
    );
  }

  FutureOr<void> onDownloadSongEvent(
      DownloadSongEvent event, Emitter<PlayAudioState> emit) async {
    emit(state.copyWith(isSongDownloading: true));
    // doing this in order to get songs meta data so that we can store it in local storeage and use it when we will play downloaded song
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Song saveSong =
    //     state.albums[state.currentAlbumIndex!].songList[event.currentSongIndex];
    int? index = audioRepository.currentSongIndex();
    TrackModel? saveSong;
    List<TrackModel>? saveSongList = state.tracks;
    List<TrackModel>? saveSongListOffline = state.previouslySavedTracks;
    if (saveSongList != null) {
      saveSong = saveSongList[index!];
    } else if (saveSongListOffline != null) {
      saveSong = saveSongListOffline[index!];
    }
    if (saveSong != null) {
      try {
        File? localImagePath;
        if (!state.downloadedSongsMap.containsKey(saveSong.trackId)) {
          localImagePath = await audioRepository.downloadByUrl(
              saveSong.songUrl, saveSong.title);
          if (localImagePath == null) {
            Utils.showSnackBar(
              context: event.context,
              message: 'Failed to download the video',
            );
            emit(state.copyWith(isSongDownloading: false));
            return;
          }
        } else {
          Utils.showSnackBar(
              context: event.context, message: 'No need to download the song');
          emit(state.copyWith(isSongDownloading: false));
          return;
        }

        Map<String, String> map = state.downloadedSongsMap;

        map[saveSong.trackId] = localImagePath.path;
        var encodedData = jsonEncode(map);

        prefs.setString(OFFLINE_DOWNLOADED_SONG_LIST_KEY, encodedData);
        emit(state.copyWith(
            snackbarMessage: 'Song Downloaded',
            isSongDownloading: false,
            downloadedSongsMap: map));
      } catch (e) {
        emit(state.copyWith(
            snackbarMessage: 'Failed to download song',
            isSongDownloading: false));
      }
    }
  }

  FutureOr<void> onPlayNextSongEvent(
      ChangeSongEvent event, Emitter<PlayAudioState> emit) {
    if (event.next == true) {
      audioRepository.next();

      int? index = state.singleSongIndex;
      if (index != null) {
        emit(state.copyWith(singleSongIndex: index + 1));
      }
    }
    if (event.previous == true) {
      audioRepository.previous();
      int? index = state.singleSongIndex;
      if (index != null) {
        emit(state.copyWith(singleSongIndex: index - 1));
      }
    }
  }

  FutureOr<void> onPlayOrPauseSongEvent(
      PlayOrPauseSongEvent event, Emitter<PlayAudioState> emit) {
    (event.play) ? audioRepository.play() : audioRepository.pause();
  }

  FutureOr<void> onSetSeekDurationEvent(
      SetSeekDurationEvent event, Emitter<PlayAudioState> emit) {
    audioRepository.setSeekDuration(event.duration);
  }

  FutureOr<void> onFetchSongsOfAlbum(
      FetchSongsOfAlbum event, Emitter<PlayAudioState> emit) async {
    emit(state.copyWith(tracksPageLoading: true));
    firebaseAnalytics
        .logEvent(name: "get_album", parameters: {"albumId": event.albumId});
    List<TrackModel>? tracks =
        await audioRepository.getTracksListFromDb(event.albumId);
    // List<TrackModel> shortedList = [];

    if (tracks != null && tracks.isNotEmpty && tracks[0].index != null) {
      // Create a copy of the list before sorting
      List<TrackModel> tempTracks = List.from(tracks);
      tempTracks.sort((a, b) => (a.index ?? 0).compareTo(b.index ?? 0));
      tracks = tempTracks;
    }
    emit(state.copyWith(
      tracks: tracks, // Use shortedList instead of tracks
      isTracksAvailable: true,
      tracksPageLoading: false,
    ));
  }

  FutureOr<void> onPlaySinglesongEvent(
      PlaySinglesongEvent event, Emitter<PlayAudioState> emit) {
    audioRepository.playSingleSong(event.index);
    String trackId = state.tracks![event.index].trackId;
    firebaseAnalytics
        .logEvent(name: "play_track", parameters: {"trackId": trackId});
    emit(state.copyWith(singleSongIndex: event.index));
  }

  FutureOr<void> onUpdateSelectedAlbumIndex(
      UpdateSelectedAlbumIndex event, Emitter<PlayAudioState> emit) {
    emit(state.copyWith(
        currentAlbumId: state.albums[event.index].albumId,
        currentAlbumIndex: event.index));
  }

  FutureOr<void> onChangeShowBottomMusicController(
      ChangeShowBottomMusicController event, Emitter<PlayAudioState> emit) {
    sharedPreferences.setBool(
        SHOW_BOTTOM_MUSIC_CONTROLLER, event.changeShowBottomMusicController);
    emit(state.copyWith(
        showBottomMusicController: event.changeShowBottomMusicController));
  }

  FutureOr<void> onSaveCurrentAlbumToLocalStorage(
      SaveCurrentAlbumToLocalStorage event,
      Emitter<PlayAudioState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var localAlbums = state.albums;
    var albumData = localAlbums
        .firstWhere((album) => album.albumId == state.currentAlbumId);
    var trackList = state.tracks;
    var tracksMapList = [];
    for (var a in trackList!) {
      tracksMapList.add(a.toJson());
    }
    int? index = audioRepository.currentSongIndex();
    if (trackList != null) {
      Map<String, String> map = {
        "albumData": jsonEncode(albumData.toJson()),
        "tracksData": jsonEncode(tracksMapList),
        "songIndex": "$index"
      };
      prefs.setString(CURRENTLY_PLAYING_ALBUM_MAP, jsonEncode(map));
    }
  }

  FutureOr<void> onLoadSavedTrackInPlayerEvent(
      LoadSavedTrackInPlayerEvent event, Emitter<PlayAudioState> emit) async {
    List<AudioSource> audioSourceList = state.previouslySavedTracks!
        .map(
          (e) => (!state.downloadedSongsMap.containsKey('trackid'))
              ? AudioSource.uri(
                  Uri.parse(e.songUrl),
                  tag: MediaItem(
                    id: '1',
                    title: e.translated.hi,
                    artist: e.artistName,
                    artUri: Uri.parse(e.thumbnail!),
                  ),
                )
              : AudioSource.file(
                  state.downloadedSongsMap['trackid']!,
                  tag: MediaItem(
                    id: '1',
                    title: e.translated.hi,
                    artist: e.artistName,
                  ),
                ),
        )
        .toList();
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),

      children: audioSourceList,
    );
    int? duration = sharedPreferences.getInt(PLAYLIST_CURRENT_SONG_DURATION);
    Duration initialPosition = Duration.zero;
    if (duration != null) {
      initialPosition = Duration(seconds: duration);
    }
    audioRepository.addPlaylist(
        playList: playlist,
        initialIndex: state.savedInitialEvent,
        initialPosition: initialPosition);
    await emit.forEach(
      audioRepository.musicPlayerDataStream,
      onData: (data) {
        int? index = audioRepository.currentSongIndex();
        int duration = data.positionData.position.inSeconds;
        if (index != null) {
          sharedPreferences.setInt(PLAYLIST_CURRENT_SONG_INDEX, index);
          sharedPreferences.setInt(PLAYLIST_CURRENT_SONG_DURATION, duration);
        }
        return state.copyWith(
          singleSongIndex: index,
          musicPlayerDataModel: data,
          onPlayAudioScreen: false,
          showBottomMusicController: true,
        );
      },
    );
  }

  FutureOr<void> onGetAlbumsByArtistEvent(
      GetAlbumsByArtistEvent event, Emitter<PlayAudioState> emit) async {
    emit(state.copyWith(
      albumsPageLoading: true,
    ));
    String artistIdToFind = state.artistList[event.index].artistId;
    print(event.index);
    print(artistIdToFind);
    List<AlbumModel>? tracks =
        await audioRepository.getAlbumByArtist(artistIdToFind);
    emit(state.copyWith(albumsPageLoading: false, albums: tracks));
  }

  FutureOr<void> onChangeOnAboutUsNavBar(
      ChangeOnAboutUsNavBar event, Emitter<PlayAudioState> emit) {
    emit(state.copyWith(onAboutUsNavBar: event.onAboutUsNavBar));
  }

  FutureOr<void> onChangeCurrentPlaylistAlbumId(
      ChangeCurrentPlaylistAlbumId event, Emitter<PlayAudioState> emit) {
    emit(state.copyWith(currentPlaylistAlbumId: state.currentAlbumId));
  }

  FutureOr<void> onSavePlayingTracksEvent(
      SavePlayingTracksEvent event, Emitter<PlayAudioState> emit) {
    final tracks = state.tracks;
    emit(state.copyWith(currentPlaylistTracks: tracks));
  }

  // FutureOr<void> onToggleLoopMode(
  //     ToggleLoopMode event, Emitter<PlayAudioState> emit) async {
  //   print('oooooooooooooooooooooooo');
  //   await audioRepository.loopMode(event.loopmode);
  //   emit(state.copyWith(isLooping: event.loopmode));
  // }

  // FutureOr<void> onToggleSuffleMode(
  //     ToggleSuffleMode event, Emitter<PlayAudioState> emit) async {
  //   await audioRepository.suffle(event.suffle);
  //   emit(state.copyWith(isSuffling: event.suffle));
  // }

  FutureOr<void> onAddAlubmDateFromRefreshIndicator(
      AddAlubmDateFromRefreshIndicator event, Emitter<PlayAudioState> emit) {
    emit(state.copyWith(albums: event.list));
  }

  FutureOr<void> onAddTrackDateFromRefreshIndicator(
      AddTrackDateFromRefreshIndicator event, Emitter<PlayAudioState> emit) {
    emit(state.copyWith(tracks: event.list));
  }

  FutureOr<void> onPlaySingleSongFromNotificationEvent(
      PlaySingleSongFromNotificationEvent event,
      Emitter<PlayAudioState> emit) async {
    var audioUri = AudioSource.uri(Uri.parse(event.trackModel.songUrl),
        tag: MediaItem(
            id: event.trackModel.trackId,
            title: event.trackModel.translated.hi,
            artist: event.trackModel.artistName,
            artUri: Uri.tryParse(event.trackModel.thumbnail!)));
    List<AudioSource> audioSourceList = [audioUri];

    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),

      children: audioSourceList,
    );

    Duration initialPosition = Duration.zero;

    audioRepository.addPlaylist(
        playList: playlist,
        initialIndex: state.savedInitialEvent,
        initialPosition: initialPosition);
    audioRepository.play();
    ////////////////////////////
    ///check down
    ////////////////////////////
    ////////////////////////////
    emit(state.copyWith(onPlayAudioScreen: false));
    await emit.forEach(
      audioRepository.musicPlayerDataStream,
      onData: (data) {
        return state.copyWith(
          musicPlayerDataModel: data,
          showBottomMusicController: true,
        );
      },
    );
  }

  FutureOr<void> onReplaySongEvent(
      ReplaySongEvent event, Emitter<PlayAudioState> emit) {
    audioRepository.replay();
  }
}
