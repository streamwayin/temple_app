import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/modals/carousel_model.dart';

class CarouselImage extends StatefulWidget {
  const CarouselImage(
      {Key? key, required this.cauraselIndex, required this.carouselList})
      : super(key: key);
  final int cauraselIndex;
  final List<CarouselModel> carouselList;

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: 160.h,
      width: size.width,
      child: widget.carouselList.length == 0
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
                InkWell(
                  onTap: () {
                    String img = widget.carouselList[currentIndex].imageUrl;
                    showGeneralDialog(
                      context: context,
                      barrierColor: Color.fromARGB(213, 0, 0, 0),
                      // barrierDismissible: true,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return Container(
                          height: 400,
                          color: const Color.fromARGB(20, 76, 175, 79),
                          child: InteractiveViewer(child: Image.network(img)),
                        );
                      },
                    );
                  },
                  child: CarouselSlider(
                    items: widget.carouselList.map(
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
                        setState(() {
                          currentIndex = index;
                        });
                        context
                            .read<HomeBloc>()
                            .add(CarouselPageIndexChanged(newIndex: index));
                      },
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 50,
                    child: DotsIndicator(
                      dotsCount: widget.carouselList.length,
                      position: widget.cauraselIndex,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
