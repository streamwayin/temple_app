import 'dart:developer' as lgr;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/wallpaper/widgets/set_wallpaper_as_dialog.dart';
import 'package:wallpaper/wallpaper.dart';

class SingleWallpaperComponent extends StatefulWidget {
  const SingleWallpaperComponent({
    super.key,
    required this.wallpaperUrl,
  });
  final String wallpaperUrl;

  @override
  State<SingleWallpaperComponent> createState() =>
      _SingleWallpaperComponentState();
}

class _SingleWallpaperComponentState extends State<SingleWallpaperComponent> {
  late Stream<String> progressString;
  late String res;
  bool downloading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * .4,
      child: Column(
        children: [
          Container(
            height: 250.h,
            width: size.width * .4,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    widget.wallpaperUrl,
                  ),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Container(
            height: 25.h,
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: InkWell(
              onTap: () {
                lgr.log('started');
                dowloadImage(
                  context,
                  widget.wallpaperUrl,
                );
              },
              child: Center(
                  child: (downloading)
                      ? const SizedBox(
                          height: 20,
                          child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: CircularProgressIndicator()),
                        )
                      : const Text(
                          'Set as ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
            ),
          )
        ],
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
  String home = await Wallpaper.homeScreen(
      options: RequestSizeOptions.RESIZE_FIT, width: width, height: height);
  print(home);
}
