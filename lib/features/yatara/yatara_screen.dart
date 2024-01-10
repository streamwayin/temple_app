import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/constants.dart';
import 'package:temple_app/features/yatara/bloc/yatara_bloc.dart';
import 'package:temple_app/features/yatara/widget/card_widget.dart';

class YataraScreen extends StatelessWidget {
  const YataraScreen({super.key});
  static const String routeName = '/yatara-screen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<YataraBloc, YataraState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: state.isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: size.height,
                      width: size.width,
                      child: CardWidget(state: state),
                    ),
                  ),
                ),
        );
      },
    );
  }

  SizedBox _gap(int height) {
    return SizedBox(height: height.h);
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(color: Colors.white),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: appBarGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 55.h,
            child: Image.asset(
              "assets/figma/shree_bada_ramdwara.png",
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            // height: 42,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Badge(
              child: const Icon(Icons.notifications_sharp,
                  color: Colors.black, size: 35),
            ),
          ),
        ],
      ),
    );
  }
}
