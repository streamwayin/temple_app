// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'dart:io';
import 'package:equatable/equatable.dart';
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
  PlayAudioBloc() : super(PlayAudioInitial()) {
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
  }
  AudioRepository audioRepository = AudioRepository();
  FutureOr<void> onPlayAudioEventInitial(
      PlayAudioEventInitial event, Emitter<PlayAudioState> emit) async {
    final list = await audioRepository.getAlbumListFromDb();
    final artistsList = await audioRepository.getAritstsListFromDb();
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
      String? currentlyPlayingAlbum =
          prefs.getString(CURRENTLY_PLAYING_ALBUM_MAP);
      if (currentlyPlayingAlbum != null) {
        Map<String, dynamic> savedMap = jsonDecode(currentlyPlayingAlbum);
        String tracksDataJson = savedMap["tracksData"];
        String albumDataJson = savedMap["albumData"];
        // int index = int.parse(savedMap['songIndex']);
        AlbumModel albumModel = AlbumModel.fromJson(jsonDecode(albumDataJson));
        List<dynamic> tracksMapList = jsonDecode(tracksDataJson);
        List<TrackModel> trackList2 =
            tracksMapList.map((map) => TrackModel.fromJson(map)).toList();
        bool isTracksListempty = trackList2.isEmpty ? false : true;
        audioRepository.playSingleSong(1);
        emit(
          state.copyWith(
            albums: list,
            downloadedSongsMap: downloadedSongsMap,
            albumsPageLoading: false,
            isPreviouslyTracksSaved: isTracksListempty,
            previouslySavedTracks: trackList2,
            currentAlbumId: albumModel.albumId,
            onPlayAudioScreen: false,
            artistList: artistsList,
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
          (e) => (!state.downloadedSongsMap.containsKey('trackid'))
              ? AudioSource.uri(
                  Uri.parse(e.songUrl),
                  tag: MediaItem(
                    id: '1',
                    title: e.title,
                    artist: e.artistName,
                    artUri: Uri.parse(e.thumbnail!),
                  ),
                )
              : AudioSource.file(
                  state.downloadedSongsMap['trackid']!,
                  tag: MediaItem(
                    id: '1',
                    title: e.title,
                    artist: '',
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
    TrackModel saveSong = state.tracks![index!];
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

    emit(state.copyWith(singleSongIndex: event.index));
  }

  FutureOr<void> onUpdateSelectedAlbumIndex(
      UpdateSelectedAlbumIndex event, Emitter<PlayAudioState> emit) {
    emit(state.copyWith(currentAlbumId: state.albums[event.index].albumId));
  }

  FutureOr<void> onChangeShowBottomMusicController(
      ChangeShowBottomMusicController event, Emitter<PlayAudioState> emit) {
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
                    title: e.title,
                    artist: e.artistName,
                    artUri: Uri.parse(e.thumbnail!),
                  ),
                )
              : AudioSource.file(
                  state.downloadedSongsMap['trackid']!,
                  tag: MediaItem(
                    id: '1',
                    title: e.title,
                    artist: '',
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
    audioRepository.addPlaylist(playList: playlist);
    await emit.forEach(
      audioRepository.musicPlayerDataStream,
      onData: (data) {
        int? index = audioRepository.currentSongIndex();
        return state.copyWith(
          // currentAlbumIndex: event.albumIndex,
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
    List<AlbumModel>? tracks =
        await audioRepository.getAlbumByArtist(artistIdToFind);
    log(tracks.toString());
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
}
