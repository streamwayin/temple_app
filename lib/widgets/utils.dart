import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Utils {
  static showSnackBar(
      {required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static Widget showLoadingOnSceeen() {
    return Container(
      decoration: const BoxDecoration(color: Color.fromARGB(66, 87, 86, 86)),
      child: Center(
        child: LoadingAnimationWidget.prograssiveDots(
            color: const Color.fromARGB(255, 75, 74, 74), size: 60),
      ),
    );
  }
}
