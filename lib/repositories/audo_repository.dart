import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:temple_app/modals/album_model.dart';
import 'package:temple_app/modals/track_model.dart';

import '../constants.dart';
import '../features/audio/widgets/common.dart';
import '../modals/aritst_model.dart';
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
  void previous() => _player.seekToPrevious();
  void setSeekDuration(Duration duration) => _player.seek(duration);
  void playSingleSong(int index) async {
    await _player.seek(Duration.zero, index: index);
  }
  // get albums from fire base

  Future<List<AlbumModel>?> getAlbumListFromDb() async {
    try {
      List<AlbumModel> albumModel = [];
      final data = await FirebaseFirestore.instance.collection('albums').get(
            const GetOptions(source: Source.serverAndCache),
          );
      // final dataa = await FirebaseFirestore.instance.collection('tracks').where(album).get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
      for (var b in a) {
        if (b.exists) {
          albumModel.add(AlbumModel.fromJson(b.data()));
        }
      }
      return albumModel;
    } catch (e) {
      log('$e');
      // print(e);
      return null;
    }
  }

  Future<List<ArtistModel>?> getAritstsListFromDb() async {
    try {
      List<ArtistModel> albumModel = [];
      final data = await FirebaseFirestore.instance.collection('artists').get(
            const GetOptions(source: Source.serverAndCache),
          );
      // final dataa = await FirebaseFirestore.instance.collection('tracks').where(album).get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
      for (var b in a) {
        if (b.exists) {
          albumModel.add(ArtistModel.fromJson(b.data()));
        }
      }
      return albumModel;
    } catch (e) {
      log('$e');
      // print(e);
      return null;
    }
  }

  Future<List<TrackModel>?> getTracksListFromDb(String albumId) async {
    try {
      List<TrackModel> trackModelList = [];
      final data = await FirebaseFirestore.instance
          .collection('tracks')
          .where("albumId", isEqualTo: albumId)
          .get();
      // final dataa = await FirebaseFirestore.instance.collection('tracks').where(album).get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
      for (var b in a) {
        if (b.exists) {
          trackModelList.add(TrackModel.fromJson(b.data()));
        }
      }
      return trackModelList;
    } catch (e) {
      log('$e');
      // print(e);
      return null;
    }
  }

  // Future<List<AlbumModel>?> getAudioListFromweb() async {
  //   try {
  //     List<AlbumModel> albumModel = [];
  //     final data = await FirebaseFirestore.instance.collection('audio').get();
  //     // final dataa = await FirebaseFirestore.instance.collection('tracks').where(album).get();
  //     List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
  //     for (var b in a) {
  //       if (b.exists) {
  //         albumModel.add(AlbumModel.fromJson(jsonEncode(b.data())));
  //       }
  //     }
  //     return albumModel;
  //   } catch (e) {
  //     log('$e');
  //     // print(e);
  //     return null;
  //   }
  // }

  Future<void> uploadBookDataToFirebase() async {
    try {
      for (var a in bookLIst) {
        final docRef = FirebaseFirestore.instance.collection("books").doc();
        await docRef.set(a);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> uploadAlbumDataToFirebase() async {
    List<Map<String, String>> albumlist = [
      {
        "name": "Shree ganesha",
        "artistId": "6FHrfNsgSCcjOA6giiYy",
        "thumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "name": "ram ji bhajan",
        "artistId": "6FHrfNsgSCcjOA6giiYy",
        "thumbnail":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/album%20thumbnail%2Framji.jpg?alt=media&token=a8936039-abfc-484b-aaa0-4a01a2ea9da6"
      },
      {
        "name": "shiv ji bhajan",
        "artistId": "6FHrfNsgSCcjOA6giiYy",
        "thumbnail":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/album%20thumbnail%2Fshivji.jpg?alt=media&token=757fcf36-0f71-4ad1-94aa-4dca6a3ced60"
      },
      {
        "name": "Khatu shyam ji katha",
        "artistId": "6FHrfNsgSCcjOA6giiYy",
        "thumbnail":
            "https://firebasestorage.googleapis.com/v0/b/temple-app-b30a8.appspot.com/o/album%20thumbnail%2Fkhatushyamji.jpg?alt=media&token=5b2744d4-0052-42ca-85f8-f8be9792af56"
      },
    ];
    try {
      for (var a in albumlist) {
        final docRef = FirebaseFirestore.instance.collection("albums").doc();
        final data = {...a, "albumId": docRef.id};
        await docRef.set(data);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> uploadAcharayasDataToFirebase() async {
    try {
      final docRef = FirebaseFirestore.instance.collection("acharayas").doc();
      String name = 'shree mohanadaasajee ma.';
      String tag = 'videh';
      // String janm = '';
      // String deeksha = '1862';
      String peethaaroodh = '2059';
      String nirvaan = 'vartamaan';
      int index = 9;
      final data = {
        "achariyaId": docRef.id,
        'name': name,
        'tag': tag,
        'peethaaroodh': peethaaroodh,
        // 'janm': janm,
        // 'deeksha': deeksha,
        'nirvaan': nirvaan,
        "index": index
      };
      await docRef.set(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> uploadTracksDataToFirebase() async {
    List<Map<String, String>> trackslist = [
      {
        "name": "Deva Shree Ganesha",
        "artistId": "6FHrfNsgSCcjOA6giiYy",
        "albumId": "ilh5s28KfNoaWzAJCYnk",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Deva Shree Ganesha(PagalWorld.com.se).mp3",
        "thumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "name": "Jai Ganesh Jai Ganesh Deva",
        "artistId": "6FHrfNsgSCcjOA6giiYy",
        "albumId": "ilh5s28KfNoaWzAJCYnk",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Jai Ganesh Jai Ganesh Deva(PagalWorld.com.se).mp3",
        "thumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "name": "Morya",
        "artistId": "6FHrfNsgSCcjOA6giiYy",
        "albumId": "ilh5s28KfNoaWzAJCYnk",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Morya(PagalWorld.com.se).mp3",
        "thumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
      {
        "name": "Sukh Karta Dukh Harta",
        "artistId": "6FHrfNsgSCcjOA6giiYy",
        "albumId": "ilh5s28KfNoaWzAJCYnk",
        "songUrl":
            "https://pub-7180d0d5348f4af6a9888fce4502b6b5.r2.dev/Sukh Karta Dukh Harta(PagalWorld.com.se).mp3",
        "thumbnail":
            "https://m.media-amazon.com/images/I/81hzkhVFGBL._SX425_.jpg"
      },
    ];
    try {
      for (var a in trackslist) {
        final docRef = FirebaseFirestore.instance.collection("tracks").doc();
        final data = {...a, "trackId": docRef.id};
        await docRef.set(data);
      }
    } catch (e) {
      throw Exception(e.toString());
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
