import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/features/audio/screens/album_screen.dart';
import 'package:temple_app/features/ebook/ebook_list/screens/ebook_screen.dart';
import 'package:temple_app/features/home/bloc/home_bloc.dart';

import '../../../../constants.dart';

class CatagoryComponent extends StatelessWidget {
  const CatagoryComponent({
    super.key,
  });
  void navigateToSingleCategoryPage(BuildContext context, String? routeName) {
    if (routeName != null) {
      switch (routeName) {
        case AlbumScreen.routeName:
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AlbumScreen()));
          }
        case EbookScreen.routeName:
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EbookScreen()));
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                child: GridView.builder(
                  itemCount: categoryImages.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 16 / 12,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    categoryImages[index]['image'];
                    return GestureDetector(
                      onTap: () => navigateToSingleCategoryPage(
                          context, categoryImages[index]['routeName']),
                      child: Center(
                        child: Container(
                          height: 71,
                          width: 103,
                          child: Stack(
                            children: [
                              Image.asset(categoryImages[index]['image']!),
                              Center(
                                child: Text(
                                  categoryImages[index]['title']!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
