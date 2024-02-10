import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temple_app/features/auth/screens/auth_screen.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/epub_viewer_screen.dart';
import 'package:temple_app/features/ebook/search/bloc/search_book_bloc.dart';
import 'package:temple_app/features/ebook/search/screens/search_book_screen.dart';
import 'package:temple_app/modals/ebook_model.dart';
import 'package:temple_app/repositories/epub_repository.dart';
import 'package:temple_app/services/firebase_analytics_service.dart';
import 'package:temple_app/widgets/utils.dart';

import '../../../../constants.dart';
import '../../pdf_view/pdf_view_screen.dart';
import '../bloc/ebook_bloc.dart';

class EbookScreen extends StatelessWidget {
  static const String routeName = '/ebook-screen';
  const EbookScreen({super.key});
  @override
  Widget build(BuildContext context) {
    EbookBloc ebookBloc = context.read<EbookBloc>();
    return BlocConsumer<EbookBloc, EbookState>(
      listener: (BuildContext context, EbookState state) async {
        if (state.pathString != null) {
          // context.read<EpubViewerBloc>().add(EpubViewerInitialEvent(
          //     path: state.pathString!, book: state.selectedBook!));
          // state.selectedBook!.fileType == "ebook"
          //     ? Navigator.pushNamed(context, EpubViwerScreen.routeName)
          //     : Navigator.pushNamed(context, PdfScreenScreen.routeName,
          //         arguments: state.selectedBook);

          // navigate user based on is logged in or not
          // bool? isUserLoggedIn = context.read<AuthBloc>().state.isLoggedIn;
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          bool? isUserLoggedIn = sharedPreferences.getBool(IS_USER_LOGGED_IN);

          if (isUserLoggedIn != null && isUserLoggedIn == true) {
            if (state.selectedBook!.fileType == "epub") {
              context.read<EpubViewerBloc>().add(EpubViewerInitialEvent(
                  path: state.pathString!, book: state.selectedBook!));
              //     arguments: index);
              FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
                  name: "screen_view",
                  parameters: {"TITLE": EpubViwerScreen.routeName});
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EpubViwerScreen()));
              // Navigator.pushNamed(context, EpubViwerScreen.routeName);
            } else {
              // Navigator.pushNamed(context, PdfScreenScreen.routeName,
              //     arguments: state.selectedBook);
              FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
                  name: "screen_view",
                  parameters: {"TITLE": PdfScreenScreen.routeName});
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfScreenScreen(
                            book: state.selectedBook!,
                            bookPath: state.pathString!,
                          )));
            }
          } else {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: AuthScreen(),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );

            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => AuthScreen()));
            // // Navigator.pushNamed(context, AuthScreen.routeName);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: Utils.buildAppBarNoBackButton(context),
          body: RefreshIndicator(
            onRefresh: () async {
              EpubRepository epubRepository = EpubRepository();
              List<EbookModel>? list =
                  await epubRepository.getEpubListFromWeb();
              if (list != null) {
                var tempList = list;
                int length = tempList.length + 1;
                tempList.sort(
                    (a, b) => (a.index ?? length).compareTo(b.index ?? length));
                context.read<EbookBloc>().add(
                    AddEbookListFromRefreshIndicatorEvent(bookList: tempList));
              }
              return;
            },
            child: Stack(
              children: [
                _templeBackground(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0)
                      .copyWith(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _gap(10),
                      _buildSearchBar(context, state),
                      _gap(10),
                      _buildAllBookText().tr(),
                      _gap(10),
                      _buildBookListViewBuilder(state),
                    ],
                  ),
                ),
                (state.loading == true)
                    ? Utils.showLoadingOnSceeen()
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  Expanded _buildBookListViewBuilder(EbookState state) {
    return Expanded(
      child: GridView.builder(
        itemCount: state.booksList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            mainAxisExtent: 163),
        itemBuilder: (context, index) {
          var item = state.booksList[index];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: const Color.fromARGB(255, 212, 212, 212),
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: InkWell(
                onTap: () {
                  context
                      .read<EbookBloc>()
                      .add((DownloadBookEventEbookList(book: item)));
                },
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 80,
                        child: CachedNetworkImage(
                          imageUrl: item.thumbnail,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
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
    );
  }

  Text _buildAllBookText() {
    return const Text(
      'allBooks',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    );
  }

  InkWell _buildSearchBar(BuildContext context, EbookState state) {
    return InkWell(
      onTap: () {
        // Navigator.pushNamed(context, SearchBookScreen.routeName);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchBookScreen(),
            ));
        context
            .read<SearchBookBloc>()
            .add(SearchBookInitialEvent(books: state.booksList));
      },
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          fillColor: orange200,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(300),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: "Search",
          suffixIcon: Icon(
            Icons.search,
          ),
          isDense: true, // Added this
          contentPadding: EdgeInsets.symmetric(horizontal: 8)
              .copyWith(left: 16), // Added this
        ),
      ),
    );
  }

  SizedBox _gap(int height) => SizedBox(height: height.h);

  SizedBox _horizontalBookListComponent(List<String> trendingBookList) {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingBookList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 120.h,
              width: 90.w,
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 192, 192, 192).withOpacity(0.7),
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: AssetImage(
                    trendingBookList[index],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Positioned _templeBackground() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Image.asset("assets/figma/bottom_temple.png"),
    );
  }
}
