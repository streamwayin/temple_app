import 'package:audio_session/audio_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:rxdart/rxdart.dart';
import 'package:temple_app/features/audio/bloc/play_audio_bloc.dart';

import '../widgets/common.dart';
import '../widgets/controller_buttons.dart';

class PlayAudioScreen extends StatefulWidget {
  const PlayAudioScreen({Key? key, required this.index}) : super(key: key);
  final int index;
  static const String routeName = '/play-audio-screen';
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<PlayAudioScreen> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _player.setAudioSource(
          context.read<PlayAudioBloc>().state.concatenatingAudioSource!);
      _player.seek(Duration.zero, index: widget.index);
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: BlocListener<PlayAudioBloc, PlayAudioState>(
            listener: (context, state) {
              if (state is PlayAudioErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  state.errorMesssage,
                )));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: const Alignment(-0.9, 0),
                    child: IconButton(
                        onPressed: () {
                          context.read<PlayAudioBloc>().add(DownloadSongEvent(
                              currentSongIndex: _player.currentIndex!,
                              context: context));
                        },
                        icon: const Icon(Icons.download))),
                SizedBox(
                  height: size.height * .4,
                  width: size.width * .8,
                  child: StreamBuilder<SequenceState?>(
                    stream: _player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        return const SizedBox();
                      }
                      final metadata = state!.currentSource!.tag as MediaItem;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  height: size.height * .4,
                                  width: size.width * .8,
                                  decoration: const BoxDecoration(
                                      // color: Colors.redAccent,
                                      ),
                                  child: CachedNetworkImage(
                                    imageUrl: metadata.artUri.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            metadata.title,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          Text(
                            metadata.artist!,
                          ),
                          (metadata.album == null)
                              ? const SizedBox()
                              : Text(
                                  metadata.album!,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                        ],
                      );
                    },
                  ),
                ),

                // Display seek bar. Using StreamBuilder, this widget rebuilds
                // each time the position, buffered position or duration changes.
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: _player.seek,
                    );
                  },
                ),
                // Display play/pause button and volume/speed sliders.
                ControlButtons(_player),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
