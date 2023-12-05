import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});
  static const String routeName = "/contact-us";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Religious App"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80.sp,
                backgroundImage:
                    const AssetImage("assets/images/babaji_image.png"),
              ),
              _gap(10),
              Text(
                "About Ramprasad Ji",
                style: TextStyle(
                    fontSize: 24.sp, decoration: TextDecoration.underline),
              ),
              _gap(5),
              Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                style: TextStyle(fontSize: 14.sp),
                textAlign: TextAlign.justify,
              ),
              _gap(10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AboutUsSocialLogo(url: 'assets/images/youtube.png'),
                  AboutUsSocialLogo(url: 'assets/images/instagram.png'),
                  AboutUsSocialLogo(url: 'assets/images/facebook.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _gap(int height) {
    return SizedBox(
      height: height.h,
    );
  }
}

class AboutUsSocialLogo extends StatelessWidget {
  const AboutUsSocialLogo({
    super.key,
    required this.url,
  });
  final String url;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(height: 40.h, child: Image.asset(url)),
    );
  }
}
