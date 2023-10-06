import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:temple_app/modals/album_model.dart';

import '../constants.dart';
import '../features/audio/widgets/common.dart';
import '../modals/music_player_data_model.dart';

class AudioRepository {
  final _player = AudioPlayer();

  AudioRepository() {
    _init();
  }
  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      log('A stream error occurred: $e');
    });
  }

  Stream<MusicPlayerDataModel> get musicPlayerDataStream => Rx.combineLatest5<
          Duration,
          Duration,
          Duration?,
          SequenceState?,
          PlayerState?,
          MusicPlayerDataModel>(
      _player.positionStream,
      _player.bufferedPositionStream,
      _player.durationStream,
      _player.sequenceStateStream,
      _player.playerStateStream,
      (position, bufferedPosition, duration, sequenceStateStream,
              playerState) =>
          MusicPlayerDataModel(
              positionData: PositionData(
                  position, bufferedPosition, duration ?? Duration.zero),
              sequenceState: sequenceStateStream,
              playerState: playerState));

  Stream<SequenceState?> get sequenceStateStream => _player.sequenceStateStream;
  Future<void> addPlaylist(ConcatenatingAudioSource playList) async {
    try {
      await _player.setAudioSource(playList);
    } catch (e) {
      log("Error loading audio source: $e");
    }
  }

  void play() => _player.play();

  void pause() => _player.pause();
  void next() => _player.seekToNext();
  int? currentSongIndex() => _player.currentIndex;
  void previous() => _player.seekToPrevious;
  void setSeekDuration(Duration duration) => _player.seek(duration);
  Future<List<AlbumModel>?> getAudioListFromweb() async {
    try {
      List<AlbumModel> albumModel = [];

      for (var a in album) {
        var data = AlbumModel.fromJson(jsonEncode(a));
        albumModel.add(data);
      }

      return albumModel;
    } catch (e) {
      log('$e');
      // print(e);
      return null;
    }
  }

  Future<File?> downloadByUrl(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Uint8List data = response.bodyBytes;

      final directory = await getDownloadsDirectory();
      if (directory == null) {
        return null;
      }

      final musicPath =
          File('${directory.path}/downloaded_music/$fileName.mp3');
      if (!await musicPath.exists()) {
        await musicPath.create(recursive: true);
      }

      await musicPath.writeAsBytes(data);
      return musicPath;
    } else {
      return null;
    }
  }
}
