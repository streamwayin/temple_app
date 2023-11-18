import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../auth/widgets/custom_text_field.dart';
import '../../home/onboarding/home_screen.dart';
import '../bloc/splash_bloc.dart';

class SplashContent extends StatelessWidget {
  const SplashContent(
      {super.key,
      required this.controller1,
      required this.controller2,
      required this.image,
      required this.index});
  final TextEditingController controller1;
  final TextEditingController controller2;
  final String image;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _gap(80),
        SizedBox(
          height: 200.h,
          width: 180.w,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                    height: 200.h,
                    child:
                        Image.asset('assets/images/background_rotating.png')),
              ),
              Positioned(
                top: 20.h,
                left: 35.w,
                child: SizedBox(
                  height: 180.h,
                  child: Image.asset(
                    image,
                  ),
                ),
              ),
            ],
          ),
        ),
        _gap(30),
        const Text(
          '।आपका धर्म, आपका ऐप,\nआपका आध्यात्मिक संगी।',
          maxLines: 2,
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              fontFamily: "KRDEV020"),
        ),
        _gap(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // CustomTextField(
              //   isPassword: false,
              //   controller: controller1,
              //   hintText: "What is your weight",
              //   fill: true,
              // ),
              // _gap(10),
              // CustomTextField(
              //   isPassword: false,
              //   controller: controller2,
              //   hintText: "What is your height",
              //   fill: true,
              // ),
            ],
          ),
        ),
        Spacer(),
        // _gap(50),
        Row(
          children: [
            SizedBox(width: 15.w),
            Text(
              '${index + 1}/3 ',
              style: const TextStyle(fontSize: 18, fontFamily: 'KRDEV020'),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'steps',
                  style: TextStyle(fontSize: 18, fontFamily: 'KRDEV020'),
                ).tr(),
              ],
            ),
            Column(
              children: [
                DecoratedBox(
                  decoration: const BoxDecoration(
                      color: Color(0xff23233c), shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () async {
                      if (index == 2) {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.setBool(
                            HAS_USER_VISITED_ONBOARDING_SCREEN, true);
                        if (context.mounted) {
                          Navigator.pushNamed(context, HomeScreen.routeName);
                        }
                      } else {
                        int ind = index + 1;
                        context
                            .read<SplashBloc>()
                            .add(SetIndexEvent(index: ind));
                      }
                    },
                    icon: Icon(
                      index == 2
                          ? Icons.keyboard_double_arrow_right_rounded
                          : Icons.navigate_next_rounded,
                      color: Colors.white,
                      weight: 10,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  index == 2 ? "skip" : 'next',
                  style: const TextStyle(fontSize: 20),
                ).tr(),
                SizedBox(width: 195.w),
              ],
            )
          ],
        ),
        _gap(50),
      ],
    );
  }

  SizedBox _gap(double size) => SizedBox(height: size.h);
}
