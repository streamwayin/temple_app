import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/epub_viewer_screen.dart';
import 'package:temple_app/widgets/common_background_component.dart';
import 'package:temple_app/widgets/utils.dart';

import '../bloc/ebook_bloc.dart';

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
    Size size = MediaQuery.of(context).size;
    EbookBloc ebookBloc = context.read<EbookBloc>();
    return BlocConsumer<EbookBloc, EbookState>(
      listener: (BuildContext context, EbookState state) {
        if (state.pathString != null) {
          context.read<EpubViewerBloc>().add(EpubViewerInitialEvent(
              path: state.pathString!, book: state.selectedBook!));
          Navigator.pushNamed(context, EpubViwerScreen.routeName);
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0)
                    .copyWith(top: 8),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50.h),
                      const EbookAppBar(),
                      SizedBox(height: 20.h),
                      const Text(
                        'Trending',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
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
                                      const Color.fromARGB(255, 192, 192, 192)
                                          .withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                      image: AssetImage(
                                        trendingBookList[index],
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      const Text(
                        'Featured',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: GridView.builder(
                          itemCount: state.booksList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 18,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: 163),
                          itemBuilder: (context, index) {
                            var item = state.booksList[index];
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color:
                                      const Color.fromARGB(255, 192, 192, 192),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    ebookBloc
                                        .add(DownloadBookEvent(index: index));
                                  },
                                  child: SizedBox(
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 80,
                                          decoration: const BoxDecoration(
                                            border: Border(),
                                            color: Color.fromARGB(
                                                255, 231, 203, 201),
                                          ),
                                        ),
                                        Text(
                                          item.name,
                                          maxLines: 2,
                                          style: const TextStyle(
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
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}

class EbookAppBar extends StatelessWidget {
  const EbookAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 56.h,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    weight: BorderSide.strokeAlignOutside,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'My Library',
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                print('search');
              },
              child: Container(
                height: 30.h,
                width: 30.w,
                decoration: BoxDecoration(
                    color: const Color(0xfffba140),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
