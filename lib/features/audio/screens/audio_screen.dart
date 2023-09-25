import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/audio/screens/play_audio_screen.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});
  static const String routeName = '/audio-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.w),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, PlayAudioScreen.routeName);
                    },
                    leading: const Image(
                      image: AssetImage('assets/images/sound-waves.png'),
                    ),
                    title: const Text('Ram ji se keah dena jai siya ram'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
