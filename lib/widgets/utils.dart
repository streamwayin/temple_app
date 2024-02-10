import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:temple_app/constants.dart';
import 'package:temple_app/features/bottom_bar/bloc/bottom_bar_bloc.dart';
import 'package:temple_app/features/my-profile/bloc/profile_bloc.dart';
import 'package:temple_app/features/notification/screens/notification_screen.dart';

class Utils {
  static showSnackBar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static Widget showLoadingOnSceeen() {
    return Container(
      decoration: const BoxDecoration(color: Color.fromARGB(66, 87, 86, 86)),
      child: Center(
        child: LoadingAnimationWidget.prograssiveDots(
            color: const Color.fromARGB(255, 75, 74, 74), size: 60),
      ),
    );
  }

  static AppBar buildAppBarNoBackButton(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // leading: BackButton(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: appBarGradient,
        ),
      ),
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Container(
              height: 50.h,
              child: SvgPicture.asset("assets/svg/app_bar.svg",
                  colorFilter:
                      ColorFilter.mode(Colors.white, BlendMode.srcIn))),
          Spacer(),
          InkWell(
            onTap: () async {
              context
                  .read<BottomBarBloc>()
                  .add(ChangeCurrentPageIndex(newIndex: 4));
              await Future.delayed(Duration(milliseconds: 250));
              context
                  .read<ProfileBloc>()
                  .add(GoToNotificationScreen(goToNotificationScreen: true));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => NotificationSereen()));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              // height: 42,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Badge(
                child: const Icon(Icons.notifications_sharp,
                    color: Colors.black, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static AppBar buildAppBarWithBackButton(BuildContext context) {
    return AppBar(
      leading: BackButton(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: appBarGradient,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: 50.h,
              child: SvgPicture.asset("assets/svg/app_bar.svg",
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn))
              // Image.asset(
              //   "assets/figma/shree_bada_ramdwara.png",
              //   fit: BoxFit.fitHeight,
              // ),
              ),
          InkWell(
            onTap: () {
              context
                  .read<BottomBarBloc>()
                  .add(ChangeCurrentPageIndex(newIndex: 4));
              context
                  .read<ProfileBloc>()
                  .add(GoToNotificationScreen(goToNotificationScreen: true));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              // height: 42,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Badge(
                child: const Icon(Icons.notifications_sharp,
                    color: Colors.black, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Positioned templeBackground() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Image.asset("assets/figma/bottom_temple.png"),
    );
  }
}
