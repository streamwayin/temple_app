import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:temple_app/features/about-us/screens/about_us_screen.dart';
import 'package:temple_app/features/about-us/screens/acharayas_screen.dart';
import 'package:temple_app/features/about-us/screens/saints_screen.dart';

import '../../audio/bloc/play_audio_bloc.dart';

class AboutUsBottomNavBar extends StatelessWidget {
  const AboutUsBottomNavBar({super.key});
  static const String routeName = "/contact-us-bottom-nav-bar";
  @override
  Widget build(BuildContext context) {
    PersistentTabController controller;

    controller = PersistentTabController();

    return WillPopScope(
      onWillPop: () async {
        context
            .read<PlayAudioBloc>()
            .add(const ChangeOnAboutUsNavBar(onAboutUsNavBar: false));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('aboutUs').tr(),
        ),
        body: PersistentTabView(
          context,
          controller: controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.once,
          itemAnimationProperties: const ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle
              .style3, // Choose the nav bar style with this property.
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const AboutUsScreen(),
      const AcharayasScreen(),
      const SaintsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.info),
        title: "About",
        activeColorPrimary: const Color(0xfffb8c00),
        inactiveColorPrimary: const Color.fromARGB(255, 240, 190, 130),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Acharayas",
        activeColorPrimary: const Color(0xfffb8c00),
        inactiveColorPrimary: const Color.fromARGB(255, 240, 190, 130),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.people),
        title: "Saints",
        activeColorPrimary: const Color(0xfffb8c00),
        inactiveColorPrimary: const Color.fromARGB(255, 240, 190, 130),
      ),
    ];
  }
}
