import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCategoryComponent extends StatelessWidget {
  const HomeCategoryComponent({
    super.key,
    required this.routeName,
    required this.imagePath,
    required this.name,
  });
  final String routeName;
  final String imagePath;
  final String name;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
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
            Text(name)
          ],
        ),
      ),
    );
  }
}
