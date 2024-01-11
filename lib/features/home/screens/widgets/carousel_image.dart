import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({Key? key, required this.cauraselIndex})
      : super(key: key);
  final int cauraselIndex;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> carouselText = [
      "हानि लाभ तो चलता रहेगा,हौसला और श्री राम पे भरोसा कम मत होने देना!",
      "हानि लाभ तो चलता रहेगा,हौसला और श्री राम पे भरोसा कम मत होने देना!",
      "हानि लाभ तो चलता रहेगा,हौसला और श्री राम पे भरोसा कम मत होने देना!",
    ];
    return SizedBox(
      height: 160.h,
      width: size.width,
      child: Stack(
        children: [
          Image.asset(
            "assets/figma/caurasel_background.png",
            fit: BoxFit.fitWidth,
            height: 160.h,
            width: size.width,
          ),
          Positioned(
            left: 20,
            child: SizedBox(
              height: 160.h,
              width: size.width,
              child: CarouselSlider(
                items: carouselText.map(
                  (i) {
                    return Builder(
                      builder: (BuildContext context) => Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 210.w,
                          child: Text(
                            i,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
                options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: true,
                  height: 200,
                  onPageChanged: (index, reason) {
                    context
                        .read<HomeBloc>()
                        .add(CarouselPageIndexChanged(newIndex: index));
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: 100.w,
            top: 20.h,
            child: Image.asset("assets/figma/comma.png"),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset("assets/figma/babaji_image.png"),
          ),
          Positioned(
            left: 100.w,
            bottom: 20.h,
            child: RotatedBox(
              quarterTurns: 2,
              child: Image.asset("assets/figma/comma.png"),
            ),
          ),
          Positioned(
            bottom: 25.h,
            left: 80.w,
            child: SizedBox(
              height: 50,
              child: DotsIndicator(
                dotsCount: 3,
                position: cauraselIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
