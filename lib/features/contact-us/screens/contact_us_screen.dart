import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:temple_app/constants.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';
import 'package:temple_app/widgets/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/contact_us_card.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});
  static const String routeName = "/cotact-us";

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    List<Map<String, String>> contactUsList = [
      {
        "name": "Call Us",
        "imagePath": "assets/images/call.png",
      },
      {
        "name": "Location",
        "imagePath": "assets/images/map.png",
      },
      {
        "name": "Chat Us",
        "imagePath": "assets/images/contact.png",
      },
    ];
    List<Function()> functionsList = [
      () async {
        final Uri url = Uri(scheme: 'tel', path: '+912912780574');
        if (await canLaunchUrl(url)) {
          launchUrl(url);
        }
      },
      () async {
        MapsLauncher.launchCoordinates(26.311008738763295, 73.01100694232782);
      },
      () async {
        Uri link = Uri.parse('http://wa.me/919256862779?text=hi');
        if (await canLaunchUrl(link)) {
          launchUrl(Uri.parse('http://wa.me/919829444550'),
              mode: LaunchMode.externalApplication);
        } else {
          print('failed to launch whatsapp');
        }
      }
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Utils.buildAppBarWithBackButton(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 140.h,
                child: Center(
                  child: Image.asset("assets/images/contactus.png"),
                ),
              ),
              SizedBox(
                height: 95.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: contactUsList.length,
                  itemBuilder: (context, index) => ContactUsCard(
                    title: contactUsList[index]["name"]!,
                    imagePath: contactUsList[index]["imagePath"]!,
                    ontap: functionsList[index],
                  ),
                ),
              ),
              _gap(10),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'QUICK CONTACT',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                ),
              ),
              contactUsText("Name"),
              CustomTextField(
                  isPassword: false,
                  controller: nameController,
                  hintText: "Enter Full Name Here"),
              contactUsText("Email"),
              CustomTextField(
                isPassword: false,
                controller: nameController,
                hintText: "Enter Email Address",
              ),
              contactUsText("Message"),
              CustomTextField(
                  isPassword: false,
                  controller: nameController,
                  minLines: 3,
                  hintText: "Enter Your Message"),
              _gap(20),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Send",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget contactUsText(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        const Text(
          " *",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  SizedBox _gap(int height) {
    return SizedBox(
      height: height.h,
    );
  }
}
