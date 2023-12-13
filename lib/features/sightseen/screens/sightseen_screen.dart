import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/sightseen/bloc/sightseen_bloc.dart';
import 'package:temple_app/features/sightseen/screens/single_sightseen_screen.dart';
import 'package:temple_app/widgets/utils.dart';

class SigntseenScreen extends StatelessWidget {
  const SigntseenScreen({super.key});
  static const String routeName = '/sightseen-screen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<SightseenBloc, SightseenState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Sightseens"),
          ),
          body: state.sightseenList.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(
                      height: size.height - 80,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.sightseenList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                crossAxisCount: 2,
                                childAspectRatio: 10 / 16),
                        itemBuilder: (context, index) {
                          final sant = state.sightseenList[index];
                          return InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, SingleSightseenScreen.routeName,
                                arguments: index),
                            child: Column(
                              children: [
                                Container(
                                  height: 240.h,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 240, 198, 134),
                                  ),
                                ),
                                Text(
                                  sant.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    wordSpacing: 1.5,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Utils.showLoadingOnSceeen(),
        );
      },
    );
  }
}
