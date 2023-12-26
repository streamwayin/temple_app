import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallpaper/wallpaper.dart';

class SetWallpaperAsDialog extends StatelessWidget {
  const SetWallpaperAsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 182.h,
          width: 40.w,
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  await Wallpaper.homeScreen();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'homeScreen',
                        style: TextStyle(fontSize: 17.sp),
                      ).tr(),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await Wallpaper.lockScreen();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'lockScreen',
                        style: TextStyle(fontSize: 17.sp),
                      ).tr(),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await Wallpaper.bothScreen();
                  Navigator.pop(context);
                  print("Task Done");
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'homeAndLockScreen',
                        style: TextStyle(fontSize: 17.sp),
                      ).tr(),
                    ],
                  ),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'cancel',
                        style: TextStyle(fontSize: 17.sp),
                      ).tr(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
