import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'ebook_event.dart';
part 'ebook_state.dart';

class EbookBloc extends Bloc<EbookEvent, EbookState> {
  EbookBloc() : super(const EbookState()) {
    on<DownloadBookEvent>(onDownloadBookEvent);
  }

  FutureOr<void> onDownloadBookEvent(
      DownloadBookEvent event, Emitter<EbookState> emit) async {
    if (Platform.isIOS) {
      final PermissionStatus status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        emit(state.copyWith(loading: true));
        Map<String, dynamic> map = await startDownload();
        if (map['success'] == true) {
          emit(state.copyWith(loading: false, downloadedFilePath: map['path']));
        }
      } else {
        await Permission.storage.request();
      }
    } else if (Platform.isAndroid) {
      print('object');
      final PermissionStatus status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        print('object');
        final map = await startDownload();
        print(map['path']);
      } else {
        await Permission.storage.request();
      }
    } else {
      PlatformException(code: '500');
    }
    final map = await startDownload();
    print(map['path']);
    print(map['success']);
  }

  Future<Map<String, dynamic>> startDownload() async {
    Map<String, dynamic> map = {"success": false, "path": ""};
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = '${appDocDir!.path}/sample.epub';
    File file = File(path);

    Dio dio = Dio();
    await file.create();
    await dio.download(
        "https://vocsyinfotech.in/envato/cc/flutter_ebook/uploads/22566_The-Racketeer---John-Grisham.epub",
        path,
        deleteOnError: true, onReceiveProgress: (receivedBytes, totalBytes) {
      print('Download --- ${(receivedBytes / totalBytes) * 100}');
    });
    map["success"] = true;
    map['path'] = file.path;

    return map;
  }
}
