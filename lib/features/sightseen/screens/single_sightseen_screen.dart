import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/sightseen/bloc/sightseen_bloc.dart';
import 'package:temple_app/modals/sightseen_model.dart';

class SingleSightseenScreen extends StatelessWidget {
  const SingleSightseenScreen({super.key, required this.index});
  static const String routeName = '/single-sightseen-screen';
  final int index;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<SightseenBloc, SightseenState>(
      builder: (context, state) {
        SightseenModel sightseen = state.sightseenList[index];
        return Scaffold(
          appBar: AppBar(
            title: const Text("Sightseen"),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(right: 24, left: 24),
                height: size.height,
                child: Column(
                  children: [
                    Text(
                      sightseen.title,
                      style: TextStyle(fontSize: 22.sp),
                    ),
                    Center(
                      child: Container(
                        color: Colors.red,
                        height: 200.h,
                        // child: Image.asset('name'),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sightseen.description.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                aboutUsText(sightseen.description[index]),
                                SizedBox(
                                  height: 5.h,
                                ),
                              ],
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Text aboutUsText(String content) {
    return Text(
      textAlign: TextAlign.justify,
      content,
      style: TextStyle(fontFamily: "KRDEV020", fontSize: 16.sp),
    );
  }
}
