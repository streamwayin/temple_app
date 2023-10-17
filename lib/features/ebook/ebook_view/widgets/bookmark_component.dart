import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';

class Bookmarkcomponent extends StatelessWidget {
  const Bookmarkcomponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpubViewerBloc, EpubViewerState>(
      builder: (context, state) {
        List<Map<String, String>> list = state.bookmaks;
        return (list.isEmpty)
            ? const Center(
                child: Text(
                  'No bookmarks found !!',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              )
            : ListView.builder(
                itemCount: state.bookmaks.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20)
                      .copyWith(top: 20),
                  child: InkWell(
                    onTap: () {
                      context
                          .read<EpubViewerBloc>()
                          .add(GoTobookmark(bookmarkMap: list[index]));
                    },
                    child: Text(
                      list[index]["name"]!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
