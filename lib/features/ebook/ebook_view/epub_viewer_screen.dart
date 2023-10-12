import "package:epub_view/epub_view.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/features/auth/widgets/custom_text_field.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';
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
          appBar: AppBar(
            title: const Text('Book title'),
            actions: [
              IconButton(
                  onPressed: () async {
                    String? boomark =
                        state.epubReaderController!.generateEpubCfi();
                    if (context.mounted) {
                      if (boomark == null) {
                        Utils.showSnackBar(
                            context: context, message: "something went wrong");
                        return;
                      }
                      addBookmarkDialog(
                          context, bookmarkNameController, size, boomark);
                    }
                  },
                  icon: const Icon(Icons.bookmark_add))
            ],
          ),
          drawer: Drawer(
            child: SafeArea(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      height: 50,
                      color: Colors.black12,
                      child: const TabBar(
                          labelColor: Colors.deepOrange,
                          unselectedLabelColor: Colors.white,
                          tabs: [
                            Tab(text: "Index"),
                            Tab(text: "Bookmarks"),
                          ]),
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        EpubViewTableOfContents(
                            controller: state.epubReaderController!),
                        const Bookmarkcomponent(),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: EpubView(
            builders: EpubViewBuilders<DefaultBuilderOptions>(
              options: const DefaultBuilderOptions(),
              chapterDividerBuilder: (_) => const Divider(),
            ),
            controller: state.epubReaderController!,
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
