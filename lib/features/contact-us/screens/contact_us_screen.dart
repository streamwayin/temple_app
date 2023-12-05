import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';
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
        "name": "Email Us",
        "imagePath": "assets/images/mail-colored.png",
      },
      {
        "name": "Chat Us",
        "imagePath": "assets/images/contact.png",
      },
    ];
    List<Function()> functionsList = [
      () async {
        final Uri url = Uri(scheme: 'tel', path: '+918386853447');
        if (await canLaunchUrl(url)) {
          launchUrl(url);
        }
      },
      () {},
      () {}
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
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
