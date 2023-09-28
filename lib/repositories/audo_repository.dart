import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:temple_app/modals/album_model.dart';

import '../constants.dart';

class AudioRepository {
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

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(data);
      print('Song downloaded and saved to: ${file.path}');
      return file;
    } else {
      return null;
    }
  }
}
