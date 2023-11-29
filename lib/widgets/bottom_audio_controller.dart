import 'package:flutter/material.dart';

import '../features/audio/screens/play_audio_screen.dart';
import '../main.dart';

class BottomAudioController extends StatelessWidget {
  const BottomAudioController({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(navigatorKey.currentContext!)
            .pushNamed(PlayAudioScreen.routeName);
      },
      child: Container(
        height: 60.0, // Set to your desired initial height
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: () {
                // Handle previous button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                print('Play button pressed');
                // Handle play button press
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () {
                // Handle next button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
