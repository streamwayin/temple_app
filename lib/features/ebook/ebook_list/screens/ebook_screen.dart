import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';
import 'package:temple_app/features/ebook/ebook_view/epub_viewer_screen.dart';

import '../../../../repositories/epub_repository.dart';
import '../bloc/ebook_bloc.dart';

class EbookScreen extends StatelessWidget {
  static const String routeName = '/ebook-screen';
  const EbookScreen({super.key});
  @override
  Widget build(BuildContext context) {
    EbookBloc ebookBloc = context.read<EbookBloc>();
    return BlocBuilder<EbookBloc, EbookState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('ebook')),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 8),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    ebookBloc.add(DownloadBookEvent());
                  },
                  child: const Text('download'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    context
                        .read<EpubViewerBloc>()
                        .add(EpubViewerInitialEvent());
                    Navigator.pushNamed(context, EpubViwerScreen.routeName);
                    // VocsyEpub.setConfig(
                    //   themeColor: Theme.of(context).primaryColor,
                    //   identifier: "iosBook",
                    //   scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                    //   allowSharing: true,
                    //   enableTts: true,
                    //   nightMode: true,
                    // );
                    // // get current locator
                    // VocsyEpub.locatorStream.listen((locator) {
                    //   print('LOCATOR: $locator');
                    // });
                    // await VocsyEpub.openAsset(
                    //   'assets/images/ebooks/gaban_mob.epub',
                    //   lastLocation: EpubLocator.fromJson({
                    //     "bookId": "2239",
                    //     "href": "/OEBPS/ch06.xhtml",
                    //     "created": 1539934158390,
                    //     "locations": {
                    //       "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                    //     }
                    //   }),
                    // );
                  },
                  child: const Text('Open Assets E-pub'),
                ),
                ElevatedButton(
                    onPressed: () {
                      EpubRepository epubRepository = EpubRepository();
                      epubRepository.getEpubListFromWeb();
                    },
                    child: Text("get"))
              ],
            ),
          ),
        );
      },
    );
  }
}
