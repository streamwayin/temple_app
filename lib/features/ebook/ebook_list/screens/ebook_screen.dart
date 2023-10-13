import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/epub_viewer_screen.dart';

import '../bloc/ebook_bloc.dart';

class EbookScreen extends StatelessWidget {
  static const String routeName = '/ebook-screen';
  const EbookScreen({super.key});
  @override
  Widget build(BuildContext context) {
    EbookBloc ebookBloc = context.read<EbookBloc>();
    return BlocConsumer<EbookBloc, EbookState>(
      listener: (BuildContext context, EbookState state) {
        if (state.pathString != null) {
          context
              .read<EpubViewerBloc>()
              .add(EpubViewerInitialEvent(path: state.pathString!));
          Navigator.pushNamed(context, EpubViwerScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('ebook')),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0)
                    .copyWith(top: 8),
                child: Column(
                  children: [
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
                                color: const Color.fromARGB(255, 192, 192, 192),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
              (state.loading == true) ? const Text('data') : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}
