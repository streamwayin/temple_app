import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/yatara/bloc/yatara_bloc.dart';
import 'package:temple_app/features/yatara/widget/yatara_carousel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../modals/yatara_model.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.state,
  });
  final YataraState state;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.yataraList.length,
      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        YataraModel yataraModel = state.yataraList[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Color(0xfff8dbb5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          // elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(yataraModel, context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      "${yataraModel.title}",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      "दिनांक  ${DateFormat('d/M/yyyy').format(yataraModel.fromDate!)} से ${DateFormat('d/M/yy').format(yataraModel.toDate!)}  तक ",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      "समय  ${DateFormat('h:mm a', 'hi').format(yataraModel.fromDate!)} से ${DateFormat('h:mm a').format(yataraModel.toDate!)}  तक ",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: ExpandableText(
                        yataraModel.description,
                        style: TextStyle(fontSize: 15.sp),
                        expandText: 'और दिखाओ',
                        collapseText: 'कम दिखाएं',
                        maxLines: 2,
                        linkColor: Colors.blue,
                      ),
                    ),
                    _gap(15),
                    // Divider(),
                    _numbersComponent(yataraModel),
                  ],
                ),
              ),
              // Text(
              //   "दिनांक तक ${DateFormat('d/M/yy').format(yataraModel.toDate!)} ",
              //   style: TextStyle(fontSize: 14.sp),
              // ),
              // Container(
              //   padding: EdgeInsets.all(16.0),
              //   alignment: Alignment.centerLeft,
              //   child: ExpansionTile(
              //     tilePadding: EdgeInsets.all(0),
              //     title: Text(
              //       maxLines: 2,
              //       yataraModel.title,
              //       style: TextStyle(
              //           fontSize: 16.0,
              //           fontWeight: FontWeight.w500,
              //           overflow: TextOverflow.ellipsis),
              //     ),
              //     children: <Widget>[
              //       Row(
              //         children: [
              //           Text(
              //             "${DateFormat('E, MMM d').format(yataraModel.fromDate!)} ",
              //             style: TextStyle(fontSize: 14.sp),
              //           ),
              //           Text(
              //             "${DateFormat('h:mm a').format(yataraModel.toDate!)}",
              //             style: TextStyle(fontSize: 14.sp),
              //           ),
              //           Text(" - "),
              //           Text(
              //             "${DateFormat('E, MMM d').format(yataraModel.toDate!)} ",
              //             style: TextStyle(fontSize: 14.sp),
              //           ),
              //           Text(
              //             "${DateFormat('h:mm a').format(yataraModel.toDate!)}",
              //             style: TextStyle(fontSize: 14.sp),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         children: [
              //           Text(
              //             "Jodhpur",
              //             style: TextStyle(fontSize: 18.sp),
              //           ),
              //           Spacer(),
              //           yataraModel.call.isNotEmpty
              //               ? InkWell(
              //                   onTap: () async {
              //                     final Uri url = Uri(
              //                         scheme: 'tel',
              //                         path: '${yataraModel.call}');
              //                     if (await canLaunchUrl(url)) {
              //                       launchUrl(url);
              //                     }
              //                   },
              //                   child: const AboutUsContactButton(
              //                       logoPath: "assets/images/call1.png"),
              //                 )
              //               : SizedBox(),
              //           SizedBox(width: 10.w)
              //         ],
              //       ),
              //       SizedBox(height: 5.h),
              //     ],
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  SizedBox _gap(double height) => SizedBox(height: height.h);

  Widget _numbersComponent(YataraModel yataraModel) {
    List<DropdownMenuEntry<String>> dropDownList = [];
    for (var i in yataraModel.contactList!) {
      for (var j in i.mobileNumbers) {
        dropDownList.add(DropdownMenuEntry(value: j, label: '${i.name} $j'));
      }
    }
    return dropDownList.length != 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "संपर्क करें",
                style: TextStyle(fontSize: 18.sp),
              ),
              DropdownMenu(
                  width: 200.w,
                  onSelected: (value) async {
                    print(value);
                    if (value == null) return;
                    final Uri url = Uri(scheme: 'tel', path: '$value');
                    if (await canLaunchUrl(url)) {
                      launchUrl(url);
                    }
                  },
                  // initialSelection: dropDownList.first,
                  label: Text("फ़ोन नंबर चुनें"),
                  dropdownMenuEntries: dropDownList),
            ],
          )
        : SizedBox();
  }

  Widget _buildImage(YataraModel yataraModel, BuildContext context) {
    return Container(
      height: 160.h,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(54, 236, 158, 80),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: yataraModel.imageArray == null
                ? SizedBox(
                    height: 160.h,
                    width: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                            imageUrl: yataraModel.image!, fit: BoxFit.contain)),
                  )
                : YataraCarousel(carouselList: yataraModel.imageArray!),
          )
        ],
      ),
    );
  }
}

// class AboutUsContactButton extends StatelessWidget {
//   const AboutUsContactButton({
//     super.key,
//     required this.logoPath,
//   });
//   final String logoPath;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 30.h,
//       width: 30.h,
//       child: Image.asset(
//         logoPath,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }
