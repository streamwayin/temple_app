import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});
  static const String routeName = '/video-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video'),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Container(
                color: Colors.lightGreenAccent,
                height: 30.h,
                width: 60.w,
              )
            ],
          )),
    );
  }
}
