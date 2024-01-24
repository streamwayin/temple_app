import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:temple_app/modals/ebook_model.dart';

class PdfScreenScreen extends StatefulWidget {
  const PdfScreenScreen(
      {super.key, required this.book, required this.bookPath});
  static const String routeName = "/pdf-view-screen";
  final EbookModel book;
  final String bookPath;

  @override
  State<PdfScreenScreen> createState() => _PdfScreenScreenState();
}

class _PdfScreenScreenState extends State<PdfScreenScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
    final pdfViewerController = PdfViewerController();
    double pdfSize = 1;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, 40.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  pdfViewerKey.currentState?.openBookmarkView();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8)),
                  width: 75.w,
                  child: Row(children: [
                    const Icon(Icons.keyboard_arrow_down_outlined, size: 30),
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
                  widget.book.title,
                  maxLines: 1,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
          actions: [
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
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.file(
              controller: pdfViewerController,
              scrollDirection: PdfScrollDirection.horizontal,
              pageLayoutMode: PdfPageLayoutMode.single,
              maxZoomLevel: 10,
              initialZoomLevel: pdfSize,
              File(widget.bookPath),
              key: pdfViewerKey,
            ),
          ),
          SizedBox(
            height: 50.h,
            width: double.infinity,
            child: Material(
              elevation: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ToggleFontSizeWidgetPdp(controller: pdfViewerController),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8)),
                    height: 30.h,
                    width: 85.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            if (pdfSize > 1) {
                              pdfViewerController.zoomLevel = pdfSize - 0.1;
                              pdfSize -= 0.1;
                            }
                          },
                          child: const Icon(
                              Icons.remove_circle_outline_outlined,
                              size: 25),
                        ),
                        const Text(
                          "Aa",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                        InkWell(
                            onTap: () {
                              if (pdfSize < 10) {
                                pdfViewerController.zoomLevel = pdfSize + 0.1;
                                pdfSize += 0.1;
                              }
                            },
                            child:
                                const Icon(Icons.add_circle_outline, size: 25)),
                      ],
                    ),
                  ),
                  SizedBox(width: 15.w),
                  IconButton(
                    onPressed: () {
                      pdfSize = 1;
                      pdfViewerController.zoomLevel = 1;
                    },
                    icon: const Icon(
                      Icons.restart_alt_rounded,
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
