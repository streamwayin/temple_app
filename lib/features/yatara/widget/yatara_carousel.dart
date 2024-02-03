import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/modals/yatara_model.dart';

class YataraCarousel extends StatefulWidget {
  const YataraCarousel({Key? key, required this.carouselList})
      : super(key: key);
  final List<ImageArrayModel> carouselList;

  @override
  State<YataraCarousel> createState() => _YataraCarouselState();
}

class _YataraCarouselState extends State<YataraCarousel> {
  int carouslIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        print(widget.carouselList[carouslIndex].image);
        showGeneralDialog(
          context: context,
          barrierColor: Color.fromARGB(213, 0, 0, 0),
          // barrierDismissible: true,
          pageBuilder: (context, animation, secondaryAnimation) {
            return Container(
              height: 400,
              color: const Color.fromARGB(20, 76, 175, 79),
              child: InteractiveViewer(
                  child:
                      Image.network(widget.carouselList[carouslIndex].image)),
            );
          },
        );
      },
      child: SizedBox(
        height: 160.h,
        width: size.width,
        child: Stack(
          children: [
            CarouselSlider(
              items: widget.carouselList.map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) => Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: 160.h,
                        width: double.infinity,
                        // width: size.width,
                        child: CachedNetworkImage(
                          imageUrl: i.image,
                          fit: BoxFit.contain,
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
                    carouslIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
