import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:temple_app/features/wallpaper/image/bloc/image_bloc.dart';
import 'package:temple_app/features/wallpaper/widgets/set_wallpaper_as_dialog.dart';
import 'package:temple_app/modals/image_model.dart';
import 'package:temple_app/widgets/utils.dart';
import 'package:wallpaper/wallpaper.dart';

class SingleWallpaperComponent extends StatefulWidget {
  const SingleWallpaperComponent({super.key, required this.image});

  final ImageModel image;

  @override
  State<SingleWallpaperComponent> createState() =>
      _SingleWallpaperComponentState();
}

class _SingleWallpaperComponentState extends State<SingleWallpaperComponent> {
  late Stream<String> progressString;
  late String res;
  bool downloading = false;
  bool downloadingImage = false;
  double downloadingProgress = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          color: const Color.fromARGB(162, 207, 207, 207),
          height: size.height,
          width: size.width,
          // width: size.width.h * .35.h,
          child: CachedNetworkImage(
            imageUrl: widget.image.thumbnail,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            progressIndicatorBuilder: (context, url, progress) =>
                const Center(child: CircularProgressIndicator()),
          ),
        ),
        Positioned(
          bottom: 40.h,
          right: 10.w,
          child: Container(
            decoration: BoxDecoration(),
            height: 190.h,
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // _buildwhatsAppShareButton(),
                _buildDownloadButton(widget.image.thumbnail),
                _buildShareButton(),
                _buildSetAsWalpaperButton(widget.image.thumbnail),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.only(bottom: 16.0.sp),
              child: SvgPicture.asset("assets/svg/Combo_shape.svg")),
        ),
        (downloading == true) ? Utils.showLoadingOnSceeen() : const SizedBox(),
      ],
    );
  }

  InkWell _buildwhatsAppShareButton() {
    return InkWell(
      onTap: () async {
        Share.share(
            "https://play.google.com/store/apps/details?id=in.streamway.temple_app",
            subject: "Check out this app ");
      },
      child: Container(
        height: 55.h,
        width: 55.h,
        child: SvgPicture.asset('assets/svg/Whatsapp.svg'),
      ),
    );
  }

  Widget _buildShareButton() {
    return InkWell(
      onTap: () async {
        Share.share(
            "https://play.google.com/store/apps/details?id=in.streamway.temple_app",
            subject: "Check out this app ");
      },
      child: Container(
        height: 55.h,
        width: 55.h,
        decoration: BoxDecoration(
          color: Color(0xffff7300),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.share,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildDownloadButton(String image) {
    return InkWell(
      onTap: !downloadingImage
          ? () async {
              downloadingImage = true;
              downloadingProgress = 0.1;
              String randomNameForPicture =
                  Random().nextInt(99999999).toString();
              print(randomNameForPicture);
              String? downloadsDirectoryPath =
                  (await DownloadsPath.downloadsDirectory())?.path;
              print("$downloadsDirectoryPath/$randomNameForPicture.jpg");
              print(image);
              File file =
                  File("$downloadsDirectoryPath/$randomNameForPicture.jpg");

              file.create();

              Dio dio = Dio();
              dio.download(
                image,
                file.path,
                deleteOnError: true,
                onReceiveProgress: (count, total) {
                  print((count / total) * 1);
                  setState(() {
                    if (count != total) {
                      downloadingImage = true;
                      downloadingProgress = (count / total) * 1;
                    } else {
                      downloadingImage = false;
                    }
                  });
                },
              );
            }
          : () {},
      child: Container(
        height: 55.h,
        width: 55.h,
        decoration: BoxDecoration(
          color: Color(0xffff7300),
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.download,
                color: Colors.white,
                size: 40,
              ),
            ),
            downloadingImage
                ? Center(
                    child: SizedBox(
                      height: 50.h,
                      width: 50.h,
                      child: CircularProgressIndicator(
                        value: downloadingProgress,
                        color: Color.fromARGB(255, 182, 109, 0),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildSetAsWalpaperButton(String imageUrl) {
    return InkWell(
      onTap: () {
        setState(() {
          downloading = true;
        });
        dowloadImage(context, imageUrl);
      },
      child: Container(
        height: 55.h,
        width: 55.h,
        decoration: BoxDecoration(
          color: Color(0xffff7300),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.wallpaper,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Future<void> dowloadImage(BuildContext context, String imageurl) async {
    progressString = Wallpaper.imageDownloadProgress(imageurl);
    progressString.listen((data) {
      setState(() {
        res = data;
        downloading = true;
      });
      print("DataReceived: " + data);
    }, onDone: () async {
      // setwallpaper(context);
      showDialog(
          context: context, builder: (context) => const SetWallpaperAsDialog());
      setState(() {
        downloading = false;
      });

      print("Task Done");
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
      print("Some Error");
    });
  }
}

setwallpaper(BuildContext context) async {
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  await Wallpaper.homeScreen(
      options: RequestSizeOptions.RESIZE_FIT, width: width, height: height);
}
