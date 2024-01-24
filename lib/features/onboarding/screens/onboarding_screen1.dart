import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/common_background_component.dart';
import '../bloc/splash_bloc.dart';
import '../widgets/splash_content.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  static const String routeName = 'onboarding-screen';
  @override
  Widget build(BuildContext context) {
    List<String> imageList = [
      "assets/images/ramji.png",
      "assets/images/hanumanji.png",
      "assets/images/ramji.png",
    ];
    Size size = MediaQuery.of(context).size;
    final TextEditingController weightController = TextEditingController();
    final TextEditingController heightController = TextEditingController();
    PageController pageController = PageController(initialPage: 0);

    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        pageController.animateToPage(state.index,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                // background
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
                  child: Image.asset("assets/images/onboarding.png"),
                ),
                PageView.builder(
                  onPageChanged: (value) {
                    context.read<SplashBloc>().add(SetIndexEvent(index: value));
                  },
                  controller: pageController,
                  itemCount: imageList.length,
                  itemBuilder: (context, index) => SplashContent(
                    controller1: weightController,
                    controller2: heightController,
                    image: imageList[index],
                    index: index,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
