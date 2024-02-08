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
  Future<void> addPlaylist(
      {required ConcatenatingAudioSource playList,
      int initialIndex = 0,
      Duration initialPosition = Duration.zero}) async {
    try {
      await _player.setAudioSource(playList,
          initialIndex: initialIndex, initialPosition: initialPosition);
    } catch (e) {
      log("Error loading audio source: $e");
    }
  }

  void play() => _player.play();

  void pause() => _player.pause();

  void next() {
    if (_player.hasNext) {
      _player.seekToNext();
    }
  }

  void replay() {
    _player.seek(Duration.zero);
  }

  int? currentSongIndex() => _player.currentIndex;
  void previous() {
    if (_player.hasPrevious) {
      _player.seekToPrevious();
    }
  }

  void setSeekDuration(Duration duration) => _player.seek(duration);
  void playSingleSong(int index) async {
    await _player.seek(Duration.zero, index: index);
  }

  void suffle(bool suffle) => _player.setShuffleModeEnabled(suffle);

  loopMode(bool loop) {
    if (loop) {
      print("loop mode set==================  true");
      _player.setLoopMode(LoopMode.one);
    } else {
      print("loop mode set==================  false");
      _player.setLoopMode(LoopMode.off);
    }
  }

  // playing from notification
  void setUrl(String url) => _player.setUrl(url);

  // get all albums from web
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
      int length = albumModel.length + 1;

      albumModel
          .sort((a, b) => (a.index ?? length).compareTo(b.index ?? length));
      return albumModel;
    } catch (e) {
      log('$e');
      // print(e);
      return null;
    }
  }
  // get all albums from web of a artist

  Future<List<AlbumModel>?> getAlbumByArtist(String albumId) async {
    try {
      List<AlbumModel> albumModel = [];
      final data = await FirebaseFirestore.instance
          .collection('albums')
          .where("artistID", isEqualTo: albumId)
          .get(
            const GetOptions(source: Source.serverAndCache),
          );
      // final dataa = await FirebaseFirestore.instance.collection('tracks').where(album).get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
      for (var b in a) {
        if (b.exists) {
          albumModel.add(AlbumModel.fromJson(b.data()));
        }
      }
      int length = albumModel.length + 1;
      albumModel
          .sort((a, b) => (a.index ?? length).compareTo(b.index ?? length));
      return albumModel;
    } catch (e) {
      log('$e');
      // print(e);
      return null;
    }
  }

// get all artist from web
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

// get tracks of a specific album
  Future<List<TrackModel>?> getTracksListFromDb(String albumId) async {
    try {
      List<TrackModel> trackModelList = [];
      final data = await FirebaseFirestore.instance
          .collection('tracks')
          .where("albumId", isEqualTo: albumId)
          .get(
            const GetOptions(source: Source.serverAndCache),
          );
      // final dataa = await FirebaseFirestore.instance.collection('tracks').where(album).get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> a = data.docs;
      for (var b in a) {
        if (b.exists) {
          trackModelList.add(TrackModel.fromJson(b.data()));
        }
      }
      int length = trackModelList.length + 1;
      trackModelList
        ..sort((a, b) => (a.index ?? length).compareTo(b.index ?? length));
      return trackModelList;
    } catch (e) {
      log('$e');
      // print(e);
      return null;
    }
  }

  // get single track data and make model for notifications
  Future<TrackModel?> getTrackDataFromDbForNotifications(
      {required String docId}) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection('tracks')
          .doc(docId)
          .get();
      if (data.exists) {
        return TrackModel.fromJson(data.data()!);
      }
    } catch (e) {
      return null;
    }
    return null;
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
        var finalMap = {...a, "id": docRef.id};

        await docRef.set(finalMap);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> uploadImageAlbumToFirebase() async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection("image-albums").doc();
      var finalMap = {
        "albumId": docRef.id,
        "title": "hari om",
        "index": "2",
        "thumbnail": ""
      };
      await docRef.set(finalMap);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> uploadYatarasDataToFirebase() async {
    try {
      final docRef = FirebaseFirestore.instance.collection("yataras").doc();
      var finalMap = {
        "yataraId": docRef.id,
        "title":
            "LIVE शनिवार भक्ति : आज सुबह यह शनिदेव चालीसा Shani Chalisa सुनने से सभी मनोकामनएं पूर्ण होती हैं",
        "index": 1,
        "description":
            'You will find here best of the best Devotional music like: Bhajans, Aarti\'s,  Mantras, Meditation Chants, Jaap, Shlokas, Amritwani and Kirtan\'s. Shree Krishna Bhajan , Hanuman Bhajan , Ganesh Bhajan ,Ram Bhajan , Laxmi Bhajan , Santoshi Maa , Sherawali Mata , Aarti Sangrah , Morning Mantra ,Shiv Bhajan , Shanidev Bhajan , Vishnu Bhajan , Saibaba Bhajan , Devi maa Bhajna , Laxmi Aarti , Ganesh Aarti , Om Jai Jagdish Aarti , Shiv Aarti , Hnauman Aarti ,Shani Aarti , Santoshi mata Aarti , Sai AratSomvar Special Bhajan , Manglvar Special Bhajan ,Budhwar Special Bhajan , Guruvar Special Bhajan , Shukarvar Special Bhajan , Shanivar Special Bhajan , Ravivar Special Bhajan , Morning Bhajan, Bhajan From Films , Many More Bhajan.... Please subscribe to our channel and send your suggestions/Requests for new bhajans, mantra, etc. We will try to fulfill it at the earliest.',
        "image": "https://img.youtube.com/vi/1xv1009jSNk/sddefault.jpg",
        "artistId": "OHUaFtS5SJgQARqnJA3o",
        "call": "8209568325",
        "location": GeoPoint(26.2389, 73.0243),
        "isYatara": true,
        "fromDate": Timestamp.fromMillisecondsSinceEpoch(1706601293000),
        "toDate": Timestamp.fromMillisecondsSinceEpoch(1709279693000),
      };
      await docRef.set(finalMap);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> uploadImageToFirebase() async {
    try {
      int index = 1;
      for (var a in wallpaperImagesList) {
        final docRef = FirebaseFirestore.instance.collection("images").doc();
        var finalMap = {
          "imageId": docRef.id,
          "title": "hari om",
          "index": index,
          "thumbnail": a,
          "albumId": "qnfnv1BakN7HUUIWF54C"
        };

        await docRef.set(finalMap);
        index++;
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

  Future<void> addIndexToAlbumsFromTracks(List<AlbumModel> albumList) async {
    int done = 0;
    for (AlbumModel a in albumList) {
      print("$done/${albumList.length}");
      done++;
      print('==========================');
      print(a.albumId);
      final data = await FirebaseFirestore.instance
          .collection('tracks')
          .where("albumId", isEqualTo: a.albumId)
          .get(
            const GetOptions(source: Source.serverAndCache),
          );
      List<QueryDocumentSnapshot<Map<String, dynamic>>> ab = data.docs;
      TrackModel model;
      if (ab.length != 0) {
        if (ab[0].exists) {
          model = TrackModel.fromJson(ab[0].data());

          try {
            final CollectionReference usersCollection =
                FirebaseFirestore.instance.collection('albums');
            await usersCollection.doc(a.albumId).update({
              'artistID': model.artistId,
            });
            print('Document updated successfully!');
          } catch (e) {
            print('Error updating document: $e');
          }
        }
      } else {
        print(
            "problem with ${a.albumId}xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      }
    }
  }
}
