import "package:epub_view/epub_view.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/widgets/toggle_font_size_widget.dart';
import 'package:temple_app/widgets/utils.dart';

import '../../../constants.dart';

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
                          'Index',
                          style: TextStyle(fontSize: 18),
                        )
                      ]),
                    ),
                  ),
                  Text(
                    'Book title',
                    style: TextStyle(
                        color: (state.backgroundColor == 0xff464646 ||
                                state.backgroundColor == 0xff000000)
                            ? Colors.white
                            : null),
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
                    icon: const Icon(Icons.bookmark_add)),
                IconButton(
                  onPressed: () {
                    context
                        .read<EpubViewerBloc>()
                        .add(const ChangeBodyStackIndexEvent(bodyIndex: 2));
                  },
                  icon: const Icon(Icons.bookmarks_rounded),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    weight: 20,
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
                EpubViewerWIdget(size: size, state: state),
                EpubViewTableOfContents(
                  controller: state.epubReaderController!,
                  func: () {
                    context
                        .read<EpubViewerBloc>()
                        .add(const ChangeBodyStackIndexEvent(bodyIndex: 0));
                  },
                ),
                const Bookmarkcomponent()
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
                  'Add bookmark',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                CustomTextField(
                    isPassword: false,
                    controller: controller,
                    hintText: 'Name'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        context.read<EpubViewerBloc>().add(AddNewBookmarkEvent(
                            bookmarkName: controller.text, epubcfi: epubcfi));
                        Navigator.pop(context);
                      },
                      child: const Text("Add"),
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

class EpubViewerWIdget extends StatelessWidget {
  const EpubViewerWIdget({
    super.key,
    required this.size,
    required this.state,
  });
  final EpubViewerState state;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(state.backgroundColor),
      child: Column(
        children: [
          EpubViewActualChapter(
            controller: state.epubReaderController!,
            builder: (chapterValue) {
              return Container(
                width: size.width,
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: Text(
                  'Chapter ${chapterValue!.chapter!.Title ?? ''}',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: size.height - 136.9.h,
            width: size.width,
            child: Stack(
              children: [
                EpubView(
                  builders: EpubViewBuilders<DefaultBuilderOptions>(
                    options: DefaultBuilderOptions(
                        textStyle: TextStyle(
                      fontSize: state.fontSize,
                    )),
                    chapterDividerBuilder: (_) => const Divider(),
                  ),
                  controller: state.epubReaderController!,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50.h,
            width: double.infinity,
            child: Material(
              color: (state.backgroundColor == 0xff464646 ||
                      state.backgroundColor == 0xff000000)
                  ? const Color(0xff2b2b2b)
                  : null,
              elevation: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const ToggleFontSizeWidget(),
                  SizedBox(width: 15.w),
                  PopupMenuButton(
                    constraints:
                        BoxConstraints.expand(width: 45.w, height: 200),
                    child: Center(
                      child: Icon(
                        Icons.color_lens,
                        color: Colors.green[300],
                      ),
                    ),
                    itemBuilder: (context) {
                      return List.generate(
                        ebookBackgroundColorList.length,
                        (index) {
                          return PopupMenuItem(
                            onTap: () {
                              context.read<EpubViewerBloc>().add(
                                  BackgroundColorChangedEvent(
                                      backgroundColor:
                                          ebookBackgroundColorList[index]));
                            },
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor:
                                  Color(ebookBackgroundColorList[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.restart_alt_rounded),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Bookmarkcomponent extends StatelessWidget {
  const Bookmarkcomponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpubViewerBloc, EpubViewerState>(
      builder: (context, state) {
        List<Map<String, String>> list = state.bookmaks;
        return ListView.builder(
          itemCount: state.bookmaks.length,
          itemBuilder: (context, index) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
            child: InkWell(
              onTap: () {
                context
                    .read<EpubViewerBloc>()
                    .add(GoTobookmark(bookmarkMap: list[index]));
              },
              child: Text(
                list[index]["name"]!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }
}
