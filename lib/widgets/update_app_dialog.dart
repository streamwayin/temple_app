import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppDialog extends StatelessWidget {
  const UpdateAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 150.h,
        width: 300.w,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Text.rich(
                  TextSpan(
                      text:
                          'आप का एप पुराना हो गया है कृपया नया एप अपडेट करे ।'),
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              // Text('You are not using the latest version',style: TextStyle(fontSize: 18,color: Colors.white),),
              // Text('update your app to continue',style: TextStyle(fontSize: 18,color: Colors.white),),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        Uri url = Uri.parse(
                            'https://play.google.com/store/apps/details?id=in.streamway.temple_app');
                        if (await canLaunchUrl(url)) {
                          launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          print('failed to share app');
                        }
                      },
                      child: Text("Go to playstore")),
                  ElevatedButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: Text("Exit")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
