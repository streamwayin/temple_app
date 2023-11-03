import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/ebook/search/bloc/search_book_bloc.dart';
import 'package:temple_app/features/ebook/search/screens/search_book_screen.dart';
import 'package:temple_app/modals/ebook_model.dart';

class EbookAppBar extends StatelessWidget {
  final List<EbookModel> books;
  const EbookAppBar({super.key, required this.books});

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
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                Navigator.pushNamed(context, SearchBookScreen.routeName);
                context
                    .read<SearchBookBloc>()
                    .add(SearchBookInitialEvent(books: books));
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
