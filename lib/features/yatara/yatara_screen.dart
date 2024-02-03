import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/yatara/bloc/yatara_bloc.dart';
import 'package:temple_app/features/yatara/widget/card_widget.dart';
import 'package:temple_app/modals/yatara_model.dart';
import 'package:temple_app/repositories/yatara_repository.dart';
import 'package:temple_app/widgets/utils.dart';

class YataraScreen extends StatelessWidget {
  const YataraScreen({super.key});
  static const String routeName = '/yatara-screen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<YataraBloc, YataraState>(
      builder: (context, state) {
        return Scaffold(
          appBar: Utils.buildAppBarWithBackButton(),
          body: state.isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    YataraRepository yataraRepository = YataraRepository();
                    List<YataraModel>? yataraList =
                        await yataraRepository.getYatraDetilsFromDb();
                    if (yataraList != null) {
                      List<YataraModel> filteredList = [];
                      for (var a in yataraList) {
                        if (a.isYatara == true) {
                          filteredList.add(a);
                        }
                      }
                      var tempList = filteredList;
                      tempList.sort((a, b) => (a.index).compareTo(b.index));
                      context.read<YataraBloc>().add(
                          AddYataraListFromRefreshIndicator(
                              yataraList: tempList));
                    }
                    return;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            height: size.height,
                            width: size.width,
                            child: CardWidget(state: state),
                          ),
                        ),
                      ],
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
}
