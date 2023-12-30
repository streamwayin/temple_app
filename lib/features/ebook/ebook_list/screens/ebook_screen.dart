import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/bloc/auth_bloc.dart';
import 'package:temple_app/features/auth/screens/auth_screen.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/epub_viewer_screen.dart';
import 'package:temple_app/widgets/common_background_component.dart';
import 'package:temple_app/widgets/utils.dart';

import '../../pdf_view/pdf_view_screen.dart';
import '../bloc/ebook_bloc.dart';
import '../widget/ebook_app_bar.dart';

class EbookScreen extends StatelessWidget {
  static const String routeName = '/ebook-screen';
  const EbookScreen({super.key});
  @override
  Widget build(BuildContext context) {
    List<String> trendingBookList = [
      "assets/images/bookcover11.png",
      "assets/images/bookcover11.png",
      "assets/images/bookcover11.png",
      "assets/images/bookcover11.png",
    ];
    EbookBloc ebookBloc = context.read<EbookBloc>();
    return BlocConsumer<EbookBloc, EbookState>(
      listener: (BuildContext context, EbookState state) {
        if (state.pathString != null) {
          // context.read<EpubViewerBloc>().add(EpubViewerInitialEvent(
          //     path: state.pathString!, book: state.selectedBook!));
          // state.selectedBook!.fileType == "ebook"
          //     ? Navigator.pushNamed(context, EpubViwerScreen.routeName)
          //     : Navigator.pushNamed(context, PdfScreenScreen.routeName,
          //         arguments: state.selectedBook);

          // navigate user based on is logged in or not
          bool? isUserLoggedIn = context.read<AuthBloc>().state.isLoggedIn;
          if (isUserLoggedIn != null && isUserLoggedIn == true) {
            if (state.selectedBook!.fileType == "ebook") {
              context.read<EpubViewerBloc>().add(EpubViewerInitialEvent(
                  path: state.pathString!, book: state.selectedBook!));
              Navigator.pushNamed(context, EpubViwerScreen.routeName);
            } else {
              Navigator.pushNamed(context, PdfScreenScreen.routeName,
                  arguments: state.selectedBook);
            }
          } else {
            Navigator.pushNamed(context, AuthScreen.routeName);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                bottom: -25.h,
                right: 0,
                left: 0,
                child: const CommonBackgroundComponent(),
              ),
              Container(
                color: const Color(0xfff5a352).withOpacity(0.6),
              ),
              Positioned(
                child: Image.asset("assets/images/onbaording1.png"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0)
                    .copyWith(top: 8),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 10.h),
                      EbookAppBar(books: state.booksList),
                      SizedBox(height: 10.h),
                      // const Text(
                      //   'Trending',
                      //   style: TextStyle(
                      //       fontSize: 24, fontWeight: FontWeight.w600),
                      // ),
                      // SizedBox(height: 10.h),
                      // SizedBox(
                      //   height: 120.h,
                      //   child: ListView.builder(
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: trendingBookList.length,
                      //     itemBuilder: (context, index) {
                      //       return Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Container(
                      //           height: 120.h,
                      //           width: 90.w,
                      //           decoration: BoxDecoration(
                      //             color:
                      //                 const Color.fromARGB(255, 192, 192, 192)
                      //                     .withOpacity(0.7),
                      //             borderRadius: BorderRadius.circular(30),
                      //             image: DecorationImage(
                      //               image: AssetImage(
                      //                 trendingBookList[index],
                      //               ),
                      //               fit: BoxFit.cover,
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      // SizedBox(height: 10.h),
                      const Text(
                        'allBooks',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ).tr(),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: GridView.builder(
                          itemCount: state.booksList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  color:
                                      const Color.fromARGB(255, 212, 212, 212),
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    ebookBloc
                                        .add(DownloadBookEvent(book: item));
                                  },
                                  child: SizedBox(
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 80,
                                          child: CachedNetworkImage(
                                            imageUrl: item.thumbnailUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
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
                ),
              ),
              (state.loading == true)
                  ? Utils.showLoadingOnSceeen()
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
