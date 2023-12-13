import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/modals/acharayas_model.dart';

import '../bloc/about_us_bloc.dart';

class AcharayasScreen extends StatelessWidget {
  const AcharayasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AboutUsBloc, AboutUsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: state.acharayasList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.acharayasList.length,
                        itemBuilder: (context, index) {
                          AcharayasModel acharaya = state.acharayasList[index];
                          return Card(
                            child: ListTile(
                              leading: SizedBox(
                                height: 40.h,
                                width: 40.w,
                                child: const Placeholder(),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    acharaya.name!.toUpperCase(),
                                  ),
                                  Text(capitalizeFirstLetter(acharaya.tag!)),
                                  Row(
                                    children: [
                                      Text('From ${acharaya.peethaaroodh}'),
                                      Text('  To ${acharaya.nirvaan}')
                                    ],
                                  )
                                ],
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

  String capitalizeFirstLetter(String input) {
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }
}
