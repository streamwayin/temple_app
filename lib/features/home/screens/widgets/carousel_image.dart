import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/modals/carousel_model.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage(
      {Key? key, required this.cauraselIndex, required this.carouselList})
      : super(key: key);
  final int cauraselIndex;
  final List<CarouselModel> carouselList;

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
      child: carouselList.length == 0
          ? Shimmer.fromColors(
              child: Container(
                width: double.infinity,
                height: 160.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
              ),
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
            )
          : Stack(
              children: [
                // Image.asset(
                //   "assets/figma/caurasel_background.png",
                //   fit: BoxFit.fitWidth,
                //   height: 160.h,
                //   width: size.width,
                // ),
                CarouselSlider(
                  items: carouselList.map(
                    (i) {
                      return Builder(
                        builder: (BuildContext context) => Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: size.width,
                            child: CachedNetworkImage(
                              imageUrl: i.imageUrl,
                              fit: BoxFit.cover,
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

                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 50,
                    child: DotsIndicator(
                      dotsCount: carouselList.length,
                      position: cauraselIndex,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
