// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temple_app/modals/album_model.dart';
import 'package:temple_app/repositories/audo_repository.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:temple_app/widgets/utils.dart';

import '../../../constants.dart';

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? offlineSongs = prefs.getString(OFFLINE_DOWNLOADED_SONG_KEY);
      if (offlineSongs != null) {
        AlbumModel albumModel = AlbumModel.fromJson(offlineSongs);
        list.add(albumModel);
      }
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
        .map(
          (e) => (e.songUrl != null)
              ? AudioSource.uri(
                  Uri.parse(e.songUrl!),
                  tag: MediaItem(
                    id: '1',
                    title: e.songName,
                    artist: 'singer..',
                    artUri: Uri.parse(e.songThumbnail!),
                  ),
                )
              : AudioSource.asset(
                  e.songPath!,
                  tag: MediaItem(
                    id: '1',
                    title: e.songName,
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
    emit(state.copyWith(
        concatenatingAudioSource: playlist,
        currentAlbumIndex: event.albumIndex));
  }

  FutureOr<void> onDownloadSongEvent(
      DownloadSongEvent event, Emitter<PlayAudioState> emit) async {
    // doing this in order to get songs meta data so that we can store it in local storeage and use it when we will play downloaded song
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Song saveSong =
        state.albums[state.currentAlbumIndex!].songList[event.currentSongIndex];
    try {
      File? localImagePath = await audioRepository.downloadByUrl(
          "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Deva Shree Ganesha(PagalWorld.com.se).mp3",
          'deva');
      if (localImagePath == null) {
        Utils.showSnackBar(
            context: event.context, message: 'Failed to download the video');
        return;
      }
      Song song = Song(
          songPath: localImagePath.path,
          songThumbnail: saveSong.songThumbnail,
          songName: saveSong.songName);
      AlbumModel? albumModel;
      String? offlineSongs = prefs.getString(OFFLINE_DOWNLOADED_SONG_KEY);
      if (offlineSongs != null) {
        albumModel = AlbumModel.fromJson(offlineSongs);
        albumModel.songList.add(song);
      } else {
        albumModel = AlbumModel(name: 'Downloaded', songList: [song]);
      }
      var encodedData = jsonEncode(albumModel.toMap());

      prefs.setString(OFFLINE_DOWNLOADED_SONG_KEY, encodedData);
    } catch (e) {
      // emit(PlayAudioErrorState(errorMesssage: e.toString()));
    }
  }
}
