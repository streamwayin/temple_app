import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:temple_app/features/audio/screens/album_screen.dart';
import 'package:temple_app/features/bottom_bar/bloc/bottom_bar_bloc.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/features/my-profile/screens/my_profile_screen.dart';
import 'package:temple_app/features/video/video-list/screens/video_list_screen.dart';
import 'package:temple_app/widgets/update_app_dialog.dart';
import 'package:temple_app/widgets/update_opacity_component.dart';

import '../../../../constants.dart';
import '../home/screens/home_screen.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});
  static const String routeName = '/bottom-bar';
  @override
  Widget build(BuildContext context) {
    final _controller = PersistentTabController(initialIndex: 0);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state1) {
        return BlocConsumer<BottomBarBloc, BottomBarState>(
          listener: (context, state) {
            _controller.index = state.currentPageIndex;
            if (state.navigationString.isNotEmpty) {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => SearchBookScreen()));
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                PersistentTabView(
                  context,
                  onItemSelected: (value) {
                    context
                        .read<BottomBarBloc>()
                        .add(ChangeCurrentPageIndex(newIndex: value));
                  },
                  screens: screens(),
                  items: navBarItems(),
                  controller: _controller,
                  navBarStyle: NavBarStyle.style1,
                  popAllScreensOnTapOfSelectedTab: true,
                ),
                state1.updateMandatory ? UpdateOpacityComponent() : SizedBox(),
                state1.updateMandatory ? UpdateAppDialog() : SizedBox(),
              ],
            );
          },
        );
      },
    );

    // BlocBuilder<BottomBarBloc, BottomBarState>(
    //   builder: (context, state) {
    //     final _controller = PersistentTabController(initialIndex: 0);
    //     return Scaffold(
    //         appBar: PreferredSize(
    //           preferredSize: const Size.fromHeight(60),
    //           child: _buildAppBar(),
    //         ),
    //         backgroundColor: scaffoldBackground,
    //         bottomNavigationBar:
    //             _buildBottomNavBar(state.currentPageIndex, context),
    //         body: IndexedStack(
    //           children: pages,
    //           index: state.currentPageIndex,
    //         ));
    //   },
    // );
  }

  screens() {
    return [
      const HomeScreen(),
      VideoListScreen(),
      AlbumScreen(),
      EbookScreen(),
      MyProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          "assets/svg/home_svg.svg",
          colorFilter: ColorFilter.mode(Color(0xff593600), BlendMode.srcIn),
        ),
        title: "Home",
        activeColorPrimary: Colors.orange,
        inactiveColorPrimary: const Color.fromARGB(255, 110, 70, 10),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          "assets/svg/video-favourite.svg",
          colorFilter: ColorFilter.mode(Color(0xff593600), BlendMode.srcIn),
        ),
        title: "Video",
        activeColorPrimary: Colors.orange,
        inactiveColorPrimary: const Color.fromARGB(255, 110, 70, 10),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          "assets/svg/playlist.svg",
          colorFilter: ColorFilter.mode(Color(0xff593600), BlendMode.srcIn),
        ),
        title: "Audio",
        activeColorPrimary: Colors.orange,
        inactiveColorPrimary: const Color.fromARGB(255, 110, 70, 10),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          "assets/svg/book_svg.svg",
          colorFilter: ColorFilter.mode(Color(0xff593600), BlendMode.srcIn),
        ),
        title: "Book",
        activeColorPrimary: Colors.orange,
        inactiveColorPrimary: const Color.fromARGB(255, 110, 70, 10),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          "assets/svg/more_svg.svg",
          colorFilter: ColorFilter.mode(Color(0xff593600), BlendMode.srcIn),
        ),
        title: "Profile",
        activeColorPrimary: Colors.orange,
        inactiveColorPrimary: const Color.fromARGB(255, 110, 70, 10),
      ),
    ];
  }
}

ClipRRect _buildBottomNavBar(int currentPageIndex, BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    ),
    child: NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      elevation: 10,
      height: 74,
      backgroundColor: Color.fromARGB(255, 250, 218, 198),
      onDestinationSelected: (int index) {
        context
            .read<BottomBarBloc>()
            .add(ChangeCurrentPageIndex(newIndex: index));
      },
      indicatorColor: indicatorColor,
      selectedIndex: currentPageIndex,
      indicatorShape: CircleBorder(),
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: SvgPicture.asset(
            "assets/svg/home_svg.svg",
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          icon: SvgPicture.asset(
            "assets/svg/home_svg.svg",
            colorFilter: ColorFilter.mode(Color(0xff593600), BlendMode.srcIn),
          ),
          // icon: Icon(Icons.home_outlined, color: Color(0xff593600)),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: SvgPicture.asset(
            "assets/svg/video-favourite.svg",
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          icon: SvgPicture.asset(
            "assets/svg/video-favourite.svg",
            colorFilter: ColorFilter.mode(Color(0xff593600), BlendMode.srcIn),
          ),
          // icon: Icon(Icons.home_outlined, color: Color(0xff593600)),
          label: 'video',
        ),
        NavigationDestination(
          selectedIcon: SvgPicture.asset(
            "assets/svg/playlist.svg",
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          icon: SvgPicture.asset(
            "assets/svg/playlist.svg",
            colorFilter: ColorFilter.mode(Color(0xff593600), BlendMode.srcIn),
          ),
          // icon: Icon(Icons.home_outlined, color: Color(0xff593600)),
          label: 'audio',
        ),
        NavigationDestination(
          selectedIcon: SvgPicture.asset(
            "assets/svg/book_svg.svg",
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          icon: SvgPicture.asset(
            "assets/svg/book_svg.svg",
            colorFilter: ColorFilter.mode(Color(0xff593600), BlendMode.srcIn),
          ),
          // icon: Icon(Icons.home_outlined, color: Color(0xff593600)),
          label: 'books',
        ),
        NavigationDestination(
          selectedIcon: SvgPicture.asset(
            "assets/svg/more_svg.svg",
            colorFilter: ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          icon: SvgPicture.asset(
            "assets/svg/more_svg.svg",
            colorFilter: ColorFilter.mode(Color(0xff593600), BlendMode.srcIn),
          ),
          // icon: Icon(Icons.home_outlined, color: Color(0xff593600)),
          label: 'books',
        ),
      ],
    ),
  );
}
