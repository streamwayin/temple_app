import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCategoryComponent extends StatelessWidget {
  const HomeCategoryComponent(
      {super.key,
      required this.imagePath,
      required this.name,
      required this.onTap});

  final String imagePath;
  final String name;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              height: 70.h,
              width: 70.w,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                  ),
                  borderRadius: BorderRadius.circular(10)),
            ),
            Text(
              name,
              style: const TextStyle(fontFamily: "KRDEV020"),
            ).tr()
          ],
        ),
      ),
    );
  }
}
