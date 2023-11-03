// import "package:cached_network_image/cached_network_image.dart";
// import "package:flutter/material.dart";
// import "package:flutter_bloc/flutter_bloc.dart";
// import "package:flutter_screenutil/flutter_screenutil.dart";
// import "package:temple_app/features/ebook/ebook_list/bloc/ebook_bloc.dart";

// import "../../../../widgets/common_background_component.dart";
// import "../../ebook_view/bloc/epub_viewer_bloc.dart";
// import "../../ebook_view/epub_viewer_screen.dart";
// import "../bloc/search_book_bloc.dart";

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/common_background_component.dart';
import '../../ebook_view/bloc/epub_viewer_bloc.dart';
import '../../ebook_view/epub_viewer_screen.dart';
import '../bloc/search_book_bloc.dart';

class SearchBookScreen extends StatelessWidget {
  const SearchBookScreen({super.key});
  static const String routeName = "/search-book";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<SearchBookBloc, SearchBookState>(
      listener: (context, state) {
        if (state.pathString != null) {
          context.read<EpubViewerBloc>().add(EpubViewerInitialEvent(
              path: state.pathString!, book: state.selectedBook!));
          Navigator.pushNamed(context, EpubViwerScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
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
                      SizedBox(
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
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      weight: BorderSide.strokeAlignOutside,
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  SizedBox(
                                    width: 220.w,
                                    height: 36.h,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        print(value);
                                        context
                                            .read<SearchBookBloc>()
                                            .add(SearchEvent(keyWord: value));
                                      },
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(176, 218, 140, 77),
                                        contentPadding: EdgeInsets.all(8),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                176, 218, 140, 77),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                176, 218, 140, 77),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 30.h,
                                  width: 30.w,
                                  decoration: BoxDecoration(
                                      color: const Color(0xfffba140),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Icon(Icons.close),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // SizedBox(height: 20.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = state.filteredBooks[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () {
                                  context
                                      .read<SearchBookBloc>()
                                      .add(DownloadBookEvent(book: book));
                                },
                                child: Container(
                                  height: 100,
                                  width: size.width,
                                  color:
                                      const Color.fromARGB(255, 233, 208, 155),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 100,
                                          width: 80,
                                          child: CachedNetworkImage(
                                            imageUrl: book.thumbnailUrl,
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
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book.name,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          book.autherName != null
                                              ? Text(
                                                  book.autherName!,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // (state.loading == true)
              //     ? Utils.showLoadingOnSceeen()
              //     : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}
