import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/sightseen/bloc/sightseen_bloc.dart';
import 'package:temple_app/features/sightseen/screens/single_sightseen_screen.dart';
import 'package:temple_app/services/firebase_analytics_service.dart';
import 'package:temple_app/widgets/utils.dart';

class SigntseenScreen extends StatelessWidget {
  const SigntseenScreen({super.key});
  static const String routeName = '/sightseen-screen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<SightseenBloc, SightseenState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: Utils.buildAppBarWithBackButton(context),
          body: state.sightseenList.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(
                      height: 565.h,
                      child: GridView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.sightseenList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 8.h,
                          crossAxisSpacing: 8.w,
                          crossAxisCount: 2,
                          childAspectRatio: 10.w / 16.h,
                        ),
                        itemBuilder: (context, index) {
                          final sant = state.sightseenList[index];
                          return InkWell(
                            onTap: () {
                              FirebaseAnalyticsService.firebaseAnalytics!
                                  .logEvent(name: "screen_view", parameters: {
                                "TITLE": SingleSightseenScreen.routeName
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SingleSightseenScreen(
                                            index: index,
                                            image: sant.image!,
                                          )));
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 240.h,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 240, 198, 134),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: sant.image!,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Text(
                                  sant.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    wordSpacing: 1.5,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Utils.showLoadingOnSceeen(),
        );
      },
    );
  }
}
