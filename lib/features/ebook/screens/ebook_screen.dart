import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/features/ebook/bloc/ebook_bloc.dart';

class EbookScreen extends StatelessWidget {
  static const String routeName = '/ebook-screen';
  const EbookScreen({super.key});
  @override
  Widget build(BuildContext context) {
    EbookBloc ebookBloc = context.read<EbookBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('ebook')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 8),
        child: ElevatedButton(
          onPressed: () {
            ebookBloc.add(DownloadBookEvent());
          },
          child: const Text('download'),
        ),
      ),
    );
  }
}
