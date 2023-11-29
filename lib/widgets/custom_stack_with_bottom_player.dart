import 'package:flutter/material.dart';
import 'package:temple_app/widgets/bottom_audio_controller.dart';

class CustomStackWithBottomPlayer extends StatelessWidget {
  final Widget child;
  const CustomStackWithBottomPlayer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(height: size.height, width: size.width, child: child),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomAudioController(),
          ),
        ],
      ),
    );
  }
}
