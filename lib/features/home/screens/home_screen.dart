import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/play-audio-screen/play_audio_screen.dart';
import 'package:temple_app/features/audio/screens/audio_screen.dart';
import 'package:temple_app/features/bottom_bar/bloc/bottom_bar_bloc.dart';
import 'package:temple_app/features/ebook/ebook_list/bloc/ebook_bloc.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/features/home/screens/widgets/carousel_image.dart';
import 'package:temple_app/features/home/screens/widgets/category_component.dart';
import 'package:temple_app/features/video/video-screen/video_screen.dart';
import 'package:temple_app/features/wallpaper/image-album/bloc/wallpaper_bloc.dart';
import 'package:temple_app/features/wallpaper/image-album/image_album_screen.dart';
import 'package:temple_app/features/wallpaper/image/bloc/image_bloc.dart';
import 'package:temple_app/features/wallpaper/image/image_screen.dart';
import 'package:temple_app/features/yatara/yatara_screen.dart';
import 'package:temple_app/modals/carousel_model.dart';
import 'package:temple_app/modals/ebook_model.dart';
import 'package:temple_app/modals/image_album_model.dart';
import 'package:temple_app/repositories/epub_repository.dart';
import 'package:temple_app/repositories/home_repository.dart';
import 'package:temple_app/repositories/wallpaper_repository.dart';
import 'package:temple_app/services/firebase_analytics_service.dart';
import 'package:temple_app/services/firebase_notification_service.dart';
import 'package:temple_app/services/notification_service.dart';
import 'package:temple_app/widgets/utils.dart';
import '../../../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home-page';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isControlBarExpanded = false;
  // setuped initally not using corrently
  NotificationService notificationService = NotificationService();
  // setuped initally not using corrently
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseNotificatonService firebaseNotificatonService =
      FirebaseNotificatonService();

  @override
  void initState() {
    // setuped initally not using corrently
    // _requestPermissions();
    // setuped initally not using corrently
    // notificationService.initiliseNotifications();
    // handle firebase message while in background or terminated
    firebaseNotificatonService.requestNotificationPermission();
    firebaseNotificatonService.firebaseInit(context);

    firebaseNotificatonService.setupInteractMessage(context);
    firebaseMessingInit();
    super.initState();
  }

  firebaseMessingInit() async {
    // await FirebaseNotificatonService().initNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.navigateToImageFromNotification == true &&
            state.booksLoading == false) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ImageScreen()));
          context.read<HomeBloc>().add(
              ToggleNavigateFromNotificaionToImageFromHomeEvent(
                  toogleNaviBool: false));
        } else if (state.navigateToImageFromNotificationToAlbum == true &&
            state.booksLoading == false) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AudioScreen()));
          context.read<HomeBloc>().add(
              ToggleNavigateFromNotificationScreenToAlbumsEvent(
                  toogleAlbumNavi: false));
        } else if (state.navigateToFromNotificationToPlayAudioScreen == true &&
            state.booksLoading == false) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PlayAudioScreen()));
          context.read<HomeBloc>().add(
              ToggleNavigateFromNotificaionFromHomeEventPlayAudioScreen(
                  togglePlayAudioScreenNavi: false));
          context
              .read<HomeBloc>()
              .add(const ChangeOnPlayAudioSreenOrNot(onPlayAudioScreen: true));
        } else if (state.navigateToFromNotificationToImageScreen == true &&
            state.booksLoading == false) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ImageScreen()));
          context.read<HomeBloc>().add(
              ToggleNavigateFromNotificaionFromHomeEventImageScreen(
                  toggleImageScreenNavi: false));
        } else if (state.navigateToFromNotificationToYoutubeScreen == true &&
            state.booksLoading == false) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoScreen(
                        videoList: state.youtubeVidoeIdForNoification,
                      )));
          context.read<HomeBloc>().add(
              ToggleNavigateFromNotificaionFromHomeEventVidoeScreen(
                  toggleYoutubVideoScreenNavi: false));
        } else if (state.navigateToFromNotificationToYoutubeScreen) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => YataraScreen()));
          context.read<HomeBloc>().add(
              ToggleNavigateFromNotificationFromHomeEventEventsScreen(
                  toggleEventScreenNavi: false));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: Utils.buildAppBarNoBackButton(context),
          backgroundColor: scaffoldBackground,
          body: RefreshIndicator(
            onRefresh: () => onRefresh(),
            child: SizedBox(
              width: size.width,
              height: size.height * 0.83,
              child: Stack(
                children: [
                  _templeBackground(),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        CarouselImage(
                          cauraselIndex: state.cauraselPageIndex,
                          carouselList: state.carouselList,
                        ),
                        _gap(10),
                        CatagoryComponent(),
                        _gap(10),
                        _booksSeeAllText(),
                        _bookListHomeComponent(size, state),
                        _buildWallpaperText(context),
                        _buildHomeWalpapersComponent(size),
                      ],
                    ),
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
                  // Positioned(
                  //   bottom: 50,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       AudioRepository audioRepository = AudioRepository();
                  //       audioRepository.uploadYatarasDataToFirebase();
                  //     },
                  //     child: const Text("upload imges"),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding _buildWallpaperText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Wallpapers",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  // context.read<BottomBarBloc>().add(ChangeCurrentPageIndex(
                  //     newIndex: 3,
                  //     navigationString: ImageAlbumScreen.routeName));
                  FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
                      name: "screen_view",
                      parameters: {"TITLE": ImageAlbumScreen.routeName});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageAlbumScreen()));
                },
                child: Text(
                  "See all",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
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

  // the temple background behind the stack
  Positioned _templeBackground() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Image.asset("assets/figma/bottom_temple.png"),
    );
  }

  Padding _bookListHomeComponent(Size size, HomeState state) {
    List<EbookModel> tempList = List.from(state.booksList);
    tempList.sort((a, b) => (a.index).compareTo(b.index));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        children: [
          SizedBox(
            height: 170.h,
            width: size.width,
            child: state.booksLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tempList.length,
                    itemBuilder: (context, index) {
                      var item = tempList[index];
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
                              context.read<BottomBarBloc>().add(
                                  ChangeCurrentPageIndex(
                                      newIndex: 3,
                                      navigationString: EbookScreen.routeName));
                              context
                                  .read<EbookBloc>()
                                  .add(DownloadBookEventEbookList(book: item));
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
                                      imageUrl: item.thumbnail,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
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
                                      height: 2,
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
              InkWell(
                onTap: () {
                  context.read<BottomBarBloc>().add(ChangeCurrentPageIndex(
                      newIndex: 3, navigationString: EbookScreen.routeName));
                },
                child: Text(
                  "See all",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
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

  Widget _buildHomeWalpapersComponent(Size size) {
    return BlocBuilder<WallpaperBloc, WallpaperState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            children: [
              SizedBox(
                height: 170.h,
                width: size.width,
                child: state.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.imageAlbumList.length,
                        itemBuilder: (context, index) {
                          var item = state.imageAlbumList[index];
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
                                  context.read<ImageBloc>().add(ImageInitialEvent(
                                      albumModel:
                                          item)); //     navigationString: ImageAlbumScreen.routeName));
                                  FirebaseAnalyticsService.firebaseAnalytics!
                                      .logEvent(
                                          name: "screen_view",
                                          parameters: {
                                        "TITLE": ImageScreen.routeName
                                      });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ImageScreen()));
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
                                          imageUrl: item.thumbnail!,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
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
      },
    );
  }

  Future<void> onRefresh() async {
    EpubRepository bookRepository = EpubRepository();
    WallpaperRepository wallpaperRepo = WallpaperRepository();
    List<EbookModel>? bookList = await bookRepository.getEpubListFromWeb();
    List<ImageAlbumModel>? imageAlbumList =
        await wallpaperRepo.getImageAlbumFromDb();
    if (imageAlbumList != null) {
      var tempList = imageAlbumList;
      int length = tempList.length + 1;
      tempList.sort((a, b) => (a.index ?? length).compareTo(b.index ?? length));

      context.read<WallpaperBloc>().add(
          AddImageAlbumModelFromRefreshIndicator(imageAlbumModel: tempList));
    }
    if (bookList != null) {
      var tempList2 = bookList;
      int length = tempList2.length + 1;
      tempList2.sort((a, b) => (a.index).compareTo(b.index));
      context
          .read<HomeBloc>()
          .add(AddStateEbookDataFromRefreshIndicator(bookList: tempList2));
    }
    HomeRepository homeRepository = HomeRepository();
    final carouselList = await homeRepository.getCarouselImagesFromDB();
    List<CarouselModel> tempListWithVisible = [];
    if (carouselList != null) {
      for (var a in carouselList) {
        if (a.visibility == true) {
          tempListWithVisible.add(a);
        }
      }
    }
    tempListWithVisible.sort((a, b) => (a.index).compareTo(b.index));
    // print(tempListWithVisible.length);
    for (var a in tempListWithVisible) {
      print(a.imageUrl);
    }
    ;
    context.read<HomeBloc>().add(
        AddCarouslDataFromRefreshIndicator(carouslList: tempListWithVisible));
    return;
  }
}
