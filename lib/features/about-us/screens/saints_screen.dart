import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/about_us_bloc.dart';

class SaintsScreen extends StatelessWidget {
  const SaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AboutUsBloc, AboutUsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: state.santList.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 510.h,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              final sant = state.santList[index];
                              return Container(
                                margin: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width: 220.w,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: CircleAvatar(
                                                radius: 70.sp,
                                                backgroundImage: const AssetImage(
                                                    "assets/images/babaji_image.png"),
                                              ),
                                            ),
                                            // Positioned(
                                            //   right: 0,
                                            //   bottom: 35,
                                            //   top: 35,
                                            //   child:
                                            // )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      sant.name,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        wordSpacing: 1.5,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      "Some description",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        wordSpacing: 1.5,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        sant.callNo != null
                                            ? InkWell(
                                                onTap: () async {
                                                  final Uri url = Uri(
                                                      scheme: 'tel',
                                                      path: '+912912780574');
                                                  if (await canLaunchUrl(url)) {
                                                    launchUrl(url);
                                                  }
                                                },
                                                child: const AboutUsContactButton(
                                                    logoPath:
                                                        "assets/images/call1.png"),
                                              )
                                            : const SizedBox(),
                                        SizedBox(
                                          width: 20.h,
                                        ),
                                        sant.whatsappNo != null
                                            ? InkWell(
                                                onTap: () async {
                                                  Uri link = Uri.parse(
                                                      'http://wa.me/919829444550?text=hi');
                                                  if (await canLaunchUrl(
                                                      link)) {
                                                    launchUrl(link,
                                                        mode: LaunchMode
                                                            .externalApplication);
                                                  } else {
                                                    print(
                                                        'failed to launch whatsapp');
                                                  }
                                                },
                                                child: const AboutUsContactButton(
                                                    logoPath:
                                                        "assets/images/whatsapp.png"),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.santList.length - 2,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              final sant = state.santList[index + 2];
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 70.sp,
                                    backgroundImage: const AssetImage(
                                        "assets/images/babaji_image.png"),
                                  ),
                                  Text(
                                    sant.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      wordSpacing: 1.5,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class AboutUsContactButton extends StatelessWidget {
  const AboutUsContactButton({
    super.key,
    required this.logoPath,
  });
  final String logoPath;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30.h,
      width: 30.h,
      child: Image.asset(
        logoPath,
        fit: BoxFit.cover,
      ),
    );
  }
}

class MyListView extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'name': 'Item 1', 'image': 'assets/item1.jpg'},
    {'name': 'Item 2', 'image': 'assets/item2.jpg'},
    {'name': 'Item 3', 'image': 'assets/item3.jpg'},
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          // First item, display in a single row
          return Row(
            children: [
              buildItem(data[index]),
            ],
          );
        } else if (index == 1) {
          // Second item, display in a single row
          return Row(
            children: [
              buildItem(data[index]),
            ],
          );
        } else {
          // Display two items in a row starting from the third item
          return Row(
            children: [
              buildItem(data[index]),
              buildItem(data[index + 1]),
            ],
          );
        }
      },
    );
  }

  Widget buildItem(Map<String, dynamic> item) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(
            item['image'],
            height: 100, // Adjust the height as needed
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8), // Adjust the spacing between image and name
          Text(item['name']),
        ],
      ),
    );
  }
}
