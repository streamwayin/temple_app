import 'package:easy_localization/easy_localization.dart';
import "package:epub_view/epub_view.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/widgets/bookmark_component.dart';
import 'package:temple_app/features/ebook/ebook_view/widgets/epub_viewer_widget.dart';
import 'package:temple_app/widgets/utils.dart';

class EpubViwerScreen extends StatelessWidget {
  static const String routeName = "epub-view-screen";
  const EpubViwerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bookmarkNameController = TextEditingController();
    return BlocConsumer<EpubViewerBloc, EpubViewerState>(
      listener: (context, state) {
        if (state.message != null) {
          Utils.showSnackBar(context: context, message: state.message!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(size.width, 40.h),
            child: AppBar(
              backgroundColor: (state.backgroundColor == 0xff464646 ||
                      state.backgroundColor == 0xff000000)
                  ? const Color(0xff2b2b2b)
                  : null,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (state.openIndexIcon == true) {
                        context
                            .read<EpubViewerBloc>()
                            .add(const ChangeBodyStackIndexEvent(bodyIndex: 1));
                      } else {
                        context
                            .read<EpubViewerBloc>()
                            .add(const ChangeBodyStackIndexEvent(bodyIndex: 0));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8)),
                      width: 75.w,
                      child: Row(children: [
                        Icon(
                            (state.openIndexIcon)
                                ? Icons.keyboard_arrow_down_outlined
                                : Icons.keyboard_arrow_up,
                            size: 30),
                        const Text(
                          "index",
                          style: TextStyle(fontSize: 18),
                        ).tr()
                      ]),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      state.book!.title,
                      maxLines: 1,
                      style: TextStyle(
                          color: (state.backgroundColor == 0xff464646 ||
                                  state.backgroundColor == 0xff000000)
                              ? Colors.white
                              : null,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      String? boomark =
                          state.epubReaderController!.generateEpubCfi();
                      if (context.mounted) {
                        if (boomark == null) {
                          Utils.showSnackBar(
                              context: context,
                              message: "something went wrong");
                          return;
                        }
                        addBookmarkDialog(
                            context, bookmarkNameController, size, boomark);
                      }
                    },
                    icon: Icon(
                      Icons.bookmark_add,
                      color: (state.backgroundColor == 0xff464646 ||
                              state.backgroundColor == 0xff000000)
                          ? Colors.white
                          : null,
                    )),
                IconButton(
                  onPressed: () {
                    (state.openIndexIcon)
                        ? context
                            .read<EpubViewerBloc>()
                            .add(const ChangeBodyStackIndexEvent(bodyIndex: 2))
                        : context
                            .read<EpubViewerBloc>()
                            .add(const ChangeBodyStackIndexEvent(bodyIndex: 0));
                  },
                  icon: Icon(
                    Icons.bookmarks_rounded,
                    color: (state.backgroundColor == 0xff464646 ||
                            state.backgroundColor == 0xff000000)
                        ? Colors.white
                        : null,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    weight: 20,
                    color: (state.backgroundColor == 0xff464646 ||
                            state.backgroundColor == 0xff000000)
                        ? Colors.white
                        : null,
                  ),
                ),
              ],
            ),
          ),
          body: SizedBox(
            height: size.height,
            width: size.width,
            child: IndexedStack(
              index: state.bodyIndex,
              children: [
                EpubViewerWidget(size: size, state: state),
                EpubViewTableOfContents(
                  controller: state.epubReaderController!,
                  func: () {
                    context
                        .read<EpubViewerBloc>()
                        .add(const ChangeBodyStackIndexEvent(bodyIndex: 0));
                  },
                ),
                Bookmarkcomponent(
                  func: (Map<String, String> map) {
                    context
                        .read<EpubViewerBloc>()
                        .add(GoTobookmark(bookmarkMap: map));
                    context
                        .read<EpubViewerBloc>()
                        .add(const ChangeBodyStackIndexEvent(bodyIndex: 0));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  addBookmarkDialog(BuildContext context, TextEditingController controller,
      Size size, String epubcfi) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          height: size.height * .3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'addbookmark',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ).tr(),
                CustomTextField(
                    isPassword: false,
                    controller: controller,
                    hintText: 'name'.tr()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('cancel'.tr()),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        context.read<EpubViewerBloc>().add(AddNewBookmarkEvent(
                            bookmarkName: controller.text, epubcfi: epubcfi));
                        Navigator.pop(context);
                      },
                      child: Text("add".tr()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
