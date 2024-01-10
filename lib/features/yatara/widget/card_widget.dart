import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/yatara/bloc/yatara_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../modals/yatara_model.dart';
import '../../about-us/screens/saints_screen.dart';

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
      itemBuilder: (context, index) {
        YataraModel yataraModel = state.yataraList[index];
        return Card(
          color: Color.fromARGB(255, 248, 193, 148),
          elevation: 4.0,
          child: Column(
            children: [
              _buildImage(yataraModel),
              Container(
                padding: EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: ExpansionTile(
                  tilePadding: EdgeInsets.all(0),
                  title: Text(
                    maxLines: 2,
                    yataraModel.title,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis),
                  ),
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "${DateFormat('E, MMM d').format(yataraModel.fromDate!)} ",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        Text(
                          "${DateFormat('h:mm a').format(yataraModel.toDate!)}",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        Text(" - "),
                        Text(
                          "${DateFormat('E, MMM d').format(yataraModel.toDate!)} ",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        Text(
                          "${DateFormat('h:mm a').format(yataraModel.toDate!)}",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Jodhpur",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        Spacer(),
                        yataraModel.call.isNotEmpty
                            ? InkWell(
                                onTap: () async {
                                  final Uri url = Uri(
                                      scheme: 'tel',
                                      path: '${yataraModel.call}');
                                  if (await canLaunchUrl(url)) {
                                    launchUrl(url);
                                  }
                                },
                                child: const AboutUsContactButton(
                                    logoPath: "assets/images/call1.png"),
                              )
                            : SizedBox(),
                        SizedBox(width: 10.w)
                      ],
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container _buildImage(YataraModel yataraModel) {
    return Container(
      height: 160.h,
      width: double.infinity,
      child: Stack(
        children: [
          SizedBox(
            height: 160.h,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                yataraModel.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(color: Color.fromARGB(54, 236, 158, 80)),
          )
        ],
      ),
    );
  }
}
