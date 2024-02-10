import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';
import 'package:temple_app/features/audio/screens/album_screen.dart';
import 'package:temple_app/features/bottom_bar/bloc/bottom_bar_bloc.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';
import 'package:temple_app/features/yatara/yatara_screen.dart';
import 'package:temple_app/services/firebase_analytics_service.dart';

import '../../../../constants.dart';

class CatagoryComponent extends StatelessWidget {
  const CatagoryComponent({
    super.key,
  });
  void navigateToSingleCategoryPage(BuildContext context, String? routeName) {
    if (routeName != null) {
      switch (routeName) {
        case AlbumScreen.routeName:
          {
            context.read<BottomBarBloc>().add(ChangeCurrentPageIndex(
                newIndex: 2, navigationString: EbookScreen.routeName));
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => AlbumScreen()));
          }
        case EbookScreen.routeName:
          {
            context.read<BottomBarBloc>().add(ChangeCurrentPageIndex(
                newIndex: 3, navigationString: EbookScreen.routeName));
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => EbookScreen()));
          }
        case YataraScreen.routeName:
          {
            FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
                name: "screen_view",
                parameters: {"TITLE": YataraScreen.routeName});
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => YataraScreen()));
          }
        case "panchang":
          {
            showDialogCoomingDiaogBox(context, "Panchang");
          }
        case "kariyakram":
          {
            FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
                name: "screen_view", parameters: {"TITLE": '/yatara-screen'});
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => YataraScreen()));
            // showDialogCoomingDiaogBox(context, "Kariyakram");
          }
        case "calander":
          {
            showDialogCoomingDiaogBox(context, "calander");
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80.h,
                child: GridView.builder(
                  itemCount: categoryImages.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 16 / 12,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    categoryImages[index]['image'];
                    return GestureDetector(
                      onTap: () => navigateToSingleCategoryPage(
                          context, categoryImages[index]['routeName']),
                      child: Center(
                        child: Container(
                          height: 71,
                          width: 103,
                          child: Stack(
                            children: [
                              Image.asset(categoryImages[index]['image']!),
                              Center(
                                child: Text(
                                  categoryImages[index]['title']!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              )
                            ],
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

  // cooming soon
  showDialogCoomingDiaogBox(BuildContext context, String title) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title),
              content: GifView.asset("assets/images/coming-soon.gif"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
