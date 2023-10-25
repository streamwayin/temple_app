import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/ebook/ebook_view/widgets/toggle_font_size_widget.dart';

import '../../../../constants.dart';
import '../bloc/epub_viewer_bloc.dart';

class EpubViewerWidget extends StatelessWidget {
  const EpubViewerWidget({
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
          Expanded(
            child: EpubViewActualChapter(
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
                          color: (state.backgroundColor == 0xff464646 ||
                                  state.backgroundColor == 0xff000000)
                              ? Colors.white
                              : null,
                          fontSize: state.fontSize,
                          fontFamily: 'KRDEV020'),
                    ),
                    chapterDividerBuilder: (_) => const Divider(),
                  ),
                  controller: state.epubReaderController!,
                  onDocumentLoaded: (document) {
                    print(document.Content);
                    print(document.Chapters);
                  },
                  onChapterChanged: (chapter) {},
                  onDocumentError: (error) {},
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
                    icon: Icon(
                      Icons.restart_alt_rounded,
                      color: (state.backgroundColor == 0xff464646 ||
                              state.backgroundColor == 0xff000000)
                          ? Colors.white
                          : null,
                    ),
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
