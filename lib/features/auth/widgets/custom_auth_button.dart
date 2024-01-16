import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/constants.dart';

class CustomAuthButton extends StatelessWidget {
  const CustomAuthButton({
    super.key,
    required this.assetUrl,
    required this.title,
    required this.onTap,
  });
  final String assetUrl;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffe86900), // background
            foregroundColor: Colors.white, // foreground
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red))),
        onPressed: onTap,
        child: SizedBox(
          width: 250.w,
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10.w),
              SizedBox(
                  height: 25.h,
                  child: Image.asset(
                    assetUrl,
                    scale: 25,
                  )),
              SizedBox(width: 10.w),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
