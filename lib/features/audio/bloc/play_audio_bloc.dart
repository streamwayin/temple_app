import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:temple_app/modals/album_model.dart';
import 'package:temple_app/repositories/audo_repository.dart';
import 'package:http/http.dart' as http;

part 'play_audio_event.dart';
part 'play_audio_state.dart';

class PlayAudioBloc extends Bloc<PlayAudioEvent, PlayAudioState> {
  PlayAudioBloc() : super(PlayAudioInitial()) {
    on<GetAudioListFromWebEvent>(onGetAudioListFromWeb);
    on<AlbumIndexChanged>(onAlbumIndexChanged);
    on<SongIndexChanged>(onSongIndexChanged);
    on<LoadCurrentPlaylistEvent>(onLoadCurrentPlaylistEvent);
    on<DownloadSongEvent>(onDownloadSongEvent);
  }
  AudioRepository audioRepository = AudioRepository();
  FutureOr<void> onGetAudioListFromWeb(
      GetAudioListFromWebEvent event, Emitter<PlayAudioState> emit) async {
    final list = await audioRepository.getAudioListFromweb();
    if (list != null) {
      emit(state.copyWith(albums: list));
    }
  }

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

  FutureOr<void> onSongIndexChanged(
      SongIndexChanged event, Emitter<PlayAudioState> emit) {
    int oldIndex = event.oldIndex;
    int newIndex = event.newIndex;
    var songs = state.albums[event.albumIndex].songList;
    var song = songs[oldIndex];
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    songs
      ..removeAt(oldIndex)
      ..insert(newIndex, song);
  }

  FutureOr<void> onLoadCurrentPlaylistEvent(
      LoadCurrentPlaylistEvent event, Emitter<PlayAudioState> emit) {
    List<AudioSource> audioSourceList = state.albums[event.albumIndex].songList
        .map((e) => AudioSource.uri(Uri.parse(e.songUrl),
            tag: MediaItem(
                id: '1',
                title: e.songName,
                artist: 'singer..',
                artUri: Uri.parse(e.songThumbnail))))
        .toList();
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),

      children: audioSourceList,
    );
    emit(state.copyWith(concatenatingAudioSource: playlist));
  }

  FutureOr<void> onDownloadSongEvent(
      DownloadSongEvent event, Emitter<PlayAudioState> emit) async {
    try {
      // download song and get its location
      File? songFile = await audioRepository.downloadByUrl(
          event.song.songUrl, event.song.songName);
      if (songFile == null) {
        emit(const PlayAudioErrorState(
            errorMesssage: 'Failed to download song'));
        return;
      }
      // Exception('Failed to download song');
      File? imageFile = await audioRepository.downloadByUrl(
          event.song.songThumbnail, "${event.song.songName}Thumbnail");
      if (imageFile == null) {
        emit(const PlayAudioErrorState(
            errorMesssage: 'Failed to download song'));
        return;
      }
    } catch (e) {
      emit(PlayAudioErrorState(errorMesssage: e.toString()));
    }
  }
}
