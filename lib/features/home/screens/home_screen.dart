import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/bloc/play_audio_bloc.dart';
import 'package:temple_app/features/audio/screens/album_screen.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/features/home/screens/widgets/carousel_image.dart';
import 'package:temple_app/features/home/screens/widgets/category_component.dart';
import 'package:temple_app/features/home/screens/widgets/home_category_component.dart';
import 'package:temple_app/features/video/video-list/screens/video_list_screen.dart';
import 'package:temple_app/features/wallpaper/image-album/image_album_screen.dart';
import 'package:temple_app/services/notification_service.dart';
import 'package:temple_app/widgets/update_app_dialog.dart';
import 'package:temple_app/widgets/update_opacity_component.dart';
import '../../../constants.dart';
import '../../about-us/screens/about_us_bottom_nav_bar.dart';
import '../../contact-us/screens/contact_us_screen.dart';
import '../../sightseen/screens/sightseen_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home-page';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isControlBarExpanded = false;
  NotificationService notificationService = NotificationService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    _requestPermissions();
    notificationService.initiliseNotifications();

    super.initState();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      // final bool? grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();
      // setState(() {
      //   _notificationsEnabled = grantedNotificationPermission ?? false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> homeComponentList = [
      {
        "name": "wallpaper",
        "imagePath": "assets/images/images.png",
        "routeName": ImageAlbumScreen.routeName,
        "onTap": () {
          Navigator.pushNamed(context, ImageAlbumScreen.routeName);
        }
      },
      {
        "name": "audio",
        "imagePath": "assets/images/volume.png",
        "routeName": AlbumScreen.routeName,
        "onTap": () {
          Navigator.pushNamed(context, AlbumScreen.routeName);
        }
      },
      {
        "name": "video",
        "imagePath": "assets/images/series.png",
        "routeName": VideoListScreen.routeName,
        "onTap": () {
          Navigator.pushNamed(context, VideoListScreen.routeName);
        }
      },
      {
        "name": "ebook",
        "imagePath": "assets/images/ebook.png",
        "routeName": EbookScreen.routeName,
        "onTap": () {
          Navigator.pushNamed(context, EbookScreen.routeName);
        }
      },
      {
        "name": "aboutUs",
        "imagePath": "assets/images/personal-information.png",
        "onTap": () {
          context
              .read<PlayAudioBloc>()
              .add(const ChangeOnAboutUsNavBar(onAboutUsNavBar: true));
          Navigator.pushNamed(context, AboutUsBottomNavBar.routeName);
        }
      },
      {
        "name": "contactUs",
        "imagePath": "assets/images/operator.png",
        "onTap": () {
          Navigator.pushNamed(context, ContactUsScreen.routeName);
        }
      },
      {
        "name": "sightseen",
        "imagePath": "assets/images/operator.png",
        "onTap": () {
          Navigator.pushNamed(context, SigntseenScreen.routeName);
        }
      },
    ];
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            exit(0);
          },
          child: Scaffold(
            appBar: _buildAppBar(),
            backgroundColor: scaffoldBackground,
            body: SingleChildScrollView(
              child: SizedBox(
                width: size.width.w,
                height: size.height.h,
                child: Stack(
                  children: [
                    _templeBackground(),
                    Column(
                      children: [
                        CarouselImage(cauraselIndex: state.cauraselPageIndex),
                        _gap(10),
                        CatagoryComponent(),
                        _gap(10),
                        _booksSeeAllText(),
                        _bookListHomeComponent(size, state),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 24.0)
                        //       .copyWith(top: 8),
                        //   child: SizedBox(
                        //     height: 400.h,
                        //     child: GridView.builder(
                        //       itemCount: homeComponentList.length,
                        //       gridDelegate:
                        //           SliverGridDelegateWithFixedCrossAxisCount(
                        //         mainAxisExtent: 100.h,
                        //         mainAxisSpacing: 10,
                        //         crossAxisSpacing: 10,
                        //         crossAxisCount: 3,
                        //       ),
                        //       itemBuilder: (context, index) {
                        //         Map<String, dynamic> category =
                        //             homeComponentList[index];
                        //         return HomeCategoryComponent(
                        //           imagePath: category["imagePath"]!,
                        //           name: category["name"]!,
                        //           // routeName: category['routeName']!,
                        //           onTap: category["onTap"],
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    // ElevatedButton(
                    //   onPressed: () {
                    //     print('object');
                    //     final db = FirebaseFirestore.instance;
                    //     db.settings = const Settings(
                    //       persistenceEnabled: true,
                    //       cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
                    //     );
                    //   },
                    //   child: const Text("enable presistance"),
                    // ),
                    // Positioned(
                    //   bottom: 10,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       notificationService.sendNotification("hello", "hi");
                    //     },
                    //     child: const Text("send notification"),
                    //   ),
                    // ),
                    // Positioned(
                    //   bottom: 50,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       notificationService.showBigPictureNotification();
                    //     },
                    //     child: const Text("send notification"),
                    //   ),
                    // ),
                    // Positioned(
                    //   bottom: 50,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       AudioRepository audioRepository = AudioRepository();
                    //       audioRepository.uploadImageToFirebase();
                    //     },
                    //     child: const Text("upload imges"),
                    //   ),
                    // ),
                    state.updateMandatory
                        ? UpdateOpacityComponent()
                        : SizedBox(),
                    state.updateMandatory ? UpdateAppDialog() : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // the temple background behind the stack
  Positioned _templeBackground() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Image.asset("assets/figma/bottom_temple.png"),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: appBarGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 55.h,
            child: Image.asset(
              "assets/figma/shree_bada_ramdwara.png",
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            // height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Badge(
              child: const Icon(Icons.notifications_sharp,
                  color: Colors.black, size: 35),
            ),
          ),
        ],
      ),
    );
  }

  Padding _bookListHomeComponent(Size size, HomeState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        children: [
          SizedBox(
            height: 170.h,
            width: size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.booksList.length,
              itemBuilder: (context, index) {
                var item = state.booksList[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 212, 212, 212),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        // ebookBloc
                        //     .add(DownloadBookEvent(book: item));
                      },
                      child: SizedBox(
                        height: 160.h,
                        width: 80.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 100.h,
                              width: 80.w,
                              child: CachedNetworkImage(
                                imageUrl: item.thumbnailUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Text(
                              item.title,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _booksSeeAllText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Books",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Text(
                "See all",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Color(0xffc5bab1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _gap(int height) => SizedBox(height: height.h);
}
