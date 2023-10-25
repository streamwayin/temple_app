import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';

import '../../../widgets/common_background_component.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final weightController = TextEditingController();
    final heightController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Positioned(
              bottom: -25.h,
              right: 0,
              left: 0,
              child: const CommonBackgroundComponent(),
            ),
            Container(
              color: const Color(0xfff5a352).withOpacity(0.6),
            ),
            Positioned(
              child: Image.asset("assets/images/onbaording1.png"),
            ),
            Positioned(
              top: 290.h,
              child: SizedBox(
                width: size.width,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '।आपका धर्म, आपका ऐप,\nआपका आध्यात्मिक संगी।',
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            // ramgji and background
            Positioned(
              top: 70.h,
              left: (size.width / 2 - 90.w),
              child: SizedBox(
                height: 250.h,
                width: 180.w,
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                          height: 200.h,
                          child: Image.asset(
                              'assets/images/background_rotating.png')),
                    ),
                    Positioned(
                      top: 20.h,
                      left: 35.w,
                      child: SizedBox(
                        height: 180.h,
                        child: Image.asset(
                          "assets/images/ramji.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: size.width / 2 - 40,
              child: Column(
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                        color: Color(0xff23233c), shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.white,
                        weight: 10,
                        size: 50,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  const Text(
                    'Next',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            // text fields
            Positioned(
              bottom: 175.h,
              child: SizedBox(
                height: 120.h,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      CustomTextField(
                        isPassword: false,
                        controller: weightController,
                        hintText: "What is your weight",
                        fill: true,
                      ),
                      SizedBox(height: 10.h),
                      CustomTextField(
                        isPassword: false,
                        controller: heightController,
                        hintText: "What is your height",
                        fill: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 105.h,
              left: 20.w,
              child: const Text(
                '1/3 steps',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
