import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/ebook/ebook_view/bloc/epub_viewer_bloc.dart';

class ToggleFontSizeWidget extends StatelessWidget {
  const ToggleFontSizeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              context
                  .read<EpubViewerBloc>()
                  .add(const ChangeFontSizeEvent(decrease: true));
            },
            child: const Icon(Icons.remove_circle_outline_outlined, size: 25),
          ),
          const Text(
            "Aa",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          InkWell(
              onTap: () {
                context
                    .read<EpubViewerBloc>()
                    .add(const ChangeFontSizeEvent(increase: true));
              },
              child: const Icon(Icons.add_circle_outline, size: 25)),
        ],
      ),
    );
  }
}
