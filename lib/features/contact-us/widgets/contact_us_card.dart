import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsCard extends StatelessWidget {
  const ContactUsCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.ontap,
  });
  final String title;
  final String imagePath;
  final Function() ontap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: SizedBox(
          height: 80.h,
          width: 90.w,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 35.h,
                  child: Image.asset(imagePath),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 12.sp),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
