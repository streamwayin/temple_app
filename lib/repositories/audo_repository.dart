import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:temple_app/modals/album_model.dart';

import '../constants.dart';

class AudioRepository {
  // File? _musicFolder;
  // AudioRepository() {
  //   init();
  // }
  // Future<void> init() async {
  //   Directory? documentDirectory = await getApplicationDocumentsDirectory();
  //   final musicFolder = File('${documentDirectory.path}/downloaded_music/');
  //   if (!await musicFolder.exists()) {
  //     await musicFolder.create(recursive: true);
  //   }
  //   _musicFolder = musicFolder;
  // }

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
      print('Song downloaded and saved to: ${musicPath.path}');
      return musicPath;
    } else {
      return null;
    }
  }
}
