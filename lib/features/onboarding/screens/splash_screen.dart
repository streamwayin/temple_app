import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/home/screens/home_screen.dart';
import 'package:temple_app/features/onboarding/screens/onboarding_screen1.dart';
import 'package:temple_app/features/onboarding/widgets/rotating_circle.dart';

import '../widgets/pendulum_animation.dart';
import '../widgets/rsp_custom_painter.dart';
import '../widgets/rsp_custom_painter2.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool onBoardingVisited = false;
  @override
  void initState() {
    if (onBoardingVisited) {
      Future.delayed(const Duration(seconds: 2))
          .then((value) => Navigator.pushNamed(context, HomeScreen.routeName));
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
          (value) => Navigator.pushNamed(context, OnboardingScreen.routeName));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        color: const Color(0xffff7f00),
        child: Stack(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: CustomPaint(
                painter: RPSCustomPainter2(),
              ),
            ),
            SizedBox(
              height: size.height * .98,
              width: size.width,
              child: CustomPaint(
                painter: RPSCustomPainter(),
              ),
            ),
            Positioned(
              left: 0,
              child: SizedBox(
                height: size.height * .4,
                child: const PendulumAnimation(
                  toLeft: false,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: SizedBox(
                height: size.height * .4,
                child: const PendulumAnimation(
                  toLeft: true,
                ),
              ),
            ),
            Positioned(
              top: 120.h,
              left: (size.width / 2) - 125,
              child: Stack(
                children: [
                  const RotatingCircleImage(),
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: Image.asset(
                        'assets/images/babaji_image.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset("assets/images/bottom_mandir.png"),
            ),
            Positioned(
              bottom: 130.h,
              left: 0,
              right: 0,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ram Prasad Ji',
                    style: TextStyle(
                      fontFamily: 'Champagne',
                      fontSize: 70,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
