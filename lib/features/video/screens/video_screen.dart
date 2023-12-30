import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rotation_check/rotation_check.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/video_list.dart';

// class VideoScreen extends StatelessWidget {
//   const VideoScreen({super.key});
//   static const String routeName = '/video-screen';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video'),
//       ),
//       body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: Column(
//             children: [
//               Container(
//                 color: Colors.lightGreenAccent,
//                 height: 30.h,
//                 width: 60.w,
//               )
//             ],
//           )),
//     );
//   }
// }
class VideoScreen extends StatefulWidget {
  static const String routeName = '/video-screen';

  const VideoScreen({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  RotationCheck rotationCheck = RotationCheck();
  bool isRoationEnabled = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void rotationCheckk() async {
    bool? local = await rotationCheck.isRotationLocked();
    if (local != null) isRoationEnabled = local;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        (isRoationEnabled)
            ? null
            : SystemChrome.setPreferredOrientations(
                [DeviceOrientation.landscapeLeft]);
      },
      onExitFullScreen: () {
        (isRoationEnabled)
            ? SystemChrome.setPreferredOrientations(DeviceOrientation.values)
            : SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.settings,
          //     color: Colors.white,
          //     size: 25.0,
          //   ),
          //   onPressed: () {
          //     log('Settings Tapped!');
          //   },
          // ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Youtube Player Flutter',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.video_library),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoList(),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _space,
                  _text('Title', _videoMetaData.title),
                  _space,
                  _text('Channel', _videoMetaData.author),
                  _space,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  var id = YoutubePlayer.convertUrlToId(
                        _idController.text,
                      ) ??
                      '';
                  if (action == 'LOAD') _controller.load(id);
                  if (action == 'CUE') _controller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  _showSnackBar('Source can\'t be empty!');
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}

// Widget controlles(){
//   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.skip_previous),
//                         onPressed: _isPlayerReady
//                             ? () => _controller.load(_ids[
//                                 (_ids.indexOf(_controller.metadata.videoId) -
//                                         1) %
//                                     _ids.length])
//                             : null,
//                       ),
//                       IconButton(
//                         icon: Icon(
//                           _controller.value.isPlaying
//                               ? Icons.pause
//                               : Icons.play_arrow,
//                         ),
//                         onPressed: _isPlayerReady
//                             ? () {
//                                 _controller.value.isPlaying
//                                     ? _controller.pause()
//                                     : _controller.play();
//                                 setState(() {});
//                               }
//                             : null,
//                       ),
//                       IconButton(
//                         icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
//                         onPressed: _isPlayerReady
//                             ? () {
//                                 _muted
//                                     ? _controller.unMute()
//                                     : _controller.mute();
//                                 setState(() {
//                                   _muted = !_muted;
//                                 });
//                               }
//                             : null,
//                       ),
//                       FullScreenButton(
//                         controller: _controller,
//                         color: Colors.blueAccent,
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.skip_next),
//                         onPressed: _isPlayerReady
//                             ? () => _controller.load(_ids[
//                                 (_ids.indexOf(_controller.metadata.videoId) +
//                                         1) %
//                                     _ids.length])
//                             : null,
//                       ),
//                     ],
//                   ),
// }