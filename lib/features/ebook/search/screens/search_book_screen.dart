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
import 'package:temple_app/constants.dart';
import 'package:temple_app/services/firebase_analytics_service.dart';
import 'package:temple_app/widgets/utils.dart';

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
          FirebaseAnalyticsService.firebaseAnalytics!.logEvent(
              name: "screen_view",
              parameters: {"TITLE": EpubViwerScreen.routeName});
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EpubViwerScreen()));
          // Navigator.pushNamed(context, EpubViwerScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: Utils.buildAppBarWithBackButton(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _gap(10),
                    _buildSearchBar(context),
                    _gap(20),
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
                                color: const Color.fromARGB(255, 233, 208, 155),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 100,
                                        width: 80,
                                        child: CachedNetworkImage(
                                          imageUrl: book.thumbnail,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
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
                                          book.title,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        book.author != null
                                            ? Text(
                                                book.author!,
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
                // (state.loading == true)
                //     ? Utils.showLoadingOnSceeen()
                //     : const SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }

  SizedBox _gap(int height) => SizedBox(height: height.h);

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      autofocus: true,
      onChanged: (value) {
        print(value);
        context.read<SearchBookBloc>().add(SearchEvent(keyWord: value));
      },
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
        suffixIcon: InkWell(
          onTap: () {
            print('object');
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
            size: 25,
          ),
        ),
        isDense: true, // Added this
        contentPadding: EdgeInsets.symmetric(horizontal: 8)
            .copyWith(left: 16), // Added this
      ),
    );
  }
}
