import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rotation_check/rotation_check.dart';
import 'package:temple_app/modals/video_model.dart';
import 'package:temple_app/widgets/utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  final List<VideoModel> videoList;
  const VideoScreen({super.key, required this.videoList});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  int currentVideoIndex = 0;

  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  RotationCheck rotationCheck = RotationCheck();
  bool isRoationEnabled = false;

  // explode api
  var yt = YoutubeExplode();

  List<String> _ids = [];

  initial() async {
    for (var a in widget.videoList) {
      _ids.add(a.id);
    }
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoList.first.id,
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

  @override
  void initState() {
    super.initState();
    initial();
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
    Size size = MediaQuery.of(context).size;
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
        // aspectRatio: 9 / 16,
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
        appBar: Utils.buildAppBarWithBackButton(),
        body: ListView(
          children: [
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text("${widget.videoList[3].title}"),
                  _space,
                  _buildVideoList(size, widget.videoList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds';
  }

  Widget _buildVideoList(Size size, List<VideoModel> videroList) {
    Color white = Colors.black;
    return Container(
        height: size.height * 0.6,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: size.width - 80,
                            child: Text(
                              "${_videoMetaData.title}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: white.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                  height: 1.3),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Text(
                            " ${_videoMetaData.author}",
                            style: TextStyle(
                                color: white.withOpacity(0.6), fontSize: 13),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(
                  color: white.withOpacity(0.1),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Up next",
                        style: TextStyle(
                            fontSize: 14,
                            color: white.withOpacity(0.4),
                            fontWeight: FontWeight.w500),
                      ),
                      // Row(
                      //   children: <Widget>[
                      //     Text(
                      //       "Autoplay",
                      //       style: TextStyle(
                      //           fontSize: 14,
                      //           color: white.withOpacity(0.4),
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //     // Switch(
                      //     //     value: isSwitched,
                      //     //     onChanged: (value) {
                      //     //       setState(() {
                      //     //         isSwitched = value;
                      //     //       });
                      //     //     })
                      //   ],
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(videroList.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              currentVideoIndex = index;
                              _controller.load(videroList[index].id);
                            });
                            // _startPlay(home_video_detail[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Stack(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  70) /
                                              2,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  videroList[index].thumbnail),
                                              fit: BoxFit.cover)),
                                      child: videroList[index].duration == null
                                          ? SizedBox()
                                          : Stack(
                                              children: <Widget>[
                                                Positioned(
                                                  bottom: 10,
                                                  right: 12,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                        formatDuration(
                                                            videroList[index]
                                                                .duration!),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.4)),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                        child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: size.width * .39,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  videroList[index].title,
                                                  style: TextStyle(
                                                      color: white
                                                          .withOpacity(0.9),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.3,
                                                      fontSize: 14),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  videroList[index].author,
                                                  style: TextStyle(
                                                      color: white
                                                          .withOpacity(0.4),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                                currentVideoIndex == index
                                    ? Container(
                                        height: 100,
                                        width: 700,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color.fromARGB(26, 0, 0, 0),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black87,
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
const List home_video_detail = [
  {
    "id": 1,
    "thumnail_img": "assets/images/menu_5.jpg",
    "profile_img":
        "https://yt3.ggpht.com/ytc/AAUvwnihe-DJ8LqGo-CIKGvJif0xpv_8aWF0UWiDZJSpEQ=s176-c-k-c0xffffffff-no-rj-mo",
    "username": "Heng Visal",
    "title": "មនុស្សអរូប by Noly Time [Official FULL MV]",
    "view_count": "1,311,740",
    "day_ago": "Dec 10, 2019",
    "subscriber_count": "925K",
    "like_count": "37K",
    "unlike_count": "1.1K",
    "video_url": "assets/videos/video_5.mp4",
    "video_duration": "12:04"
  },
  {
    "id": 2,
    "thumnail_img": "assets/images/menu_1.jpg",
    "profile_img":
        "https://yt3.ggpht.com/ytc/AAUvwnhuheOArV1o5BSo10TdUivctyIHSfzYGKLwudMCdg=s176-c-k-c0xffffffff-no-rj-mo",
    "username": "a day magazine",
    "title": "Violette Wautier - I'd Do It Again | Live in a day",
    "view_count": "1,122,707",
    "day_ago": "Jul 2, 2020",
    "subscriber_count": "88.6K",
    "like_count": "11K",
    "unlike_count": "88",
    "video_url": "assets/videos/video_1.mp4",
    "video_duration": "04:30"
  },
  {
    "id": 3,
    "thumnail_img": "assets/images/menu_6.jpg",
    "profile_img":
        "https://yt3.ggpht.com/ytc/AAUvwniOFTckqAPsjNIg5zGVZnJqLZ58RTgH0a4RSmFKBQ=s176-c-k-c0xffffffff-no-nd-rj-mo",
    "username": "Kmeng Khmer - ក្មេងខ្មែរ Official",
    "title": "KmengKhmer - ឆ្ងាយតែកាយ (Far Away) [Official MV]",
    "view_count": "5,388,486",
    "day_ago": "Sep 8, 2018",
    "subscriber_count": "562K",
    "like_count": "13K",
    "unlike_count": "69",
    "video_url": "assets/videos/video_6.mp4",
    "video_duration": "07:05"
  },
  {
    "id": 4,
    "thumnail_img": "assets/images/menu_2.jpg",
    "profile_img":
        "https://yt3.ggpht.com/ytc/AAUvwniJv0lOI9XzTWKHHA5pD04MMZSsGWCT9qWxb1w9Dw=s176-c-k-c0xffffffff-no-nd-rj-mo",
    "username": "វណ្ណដា-VannDa Official",
    "title": "VANNDA - HIK HIK (FEAT. BAD BOY BERT) [OFFICIAL MUSIC VIDEO]",
    "view_count": "5,109,116",
    "day_ago": "Nov 25, 2020",
    "subscriber_count": "1.45M",
    "like_count": "13K",
    "unlike_count": "69",
    "video_url": "assets/videos/video_2.mp4",
    "video_duration": "04:30"
  },
  {
    "id": 5,
    "thumnail_img": "assets/images/menu_4.jpg",
    "profile_img":
        "https://yt3.ggpht.com/ytc/AAUvwnjcXhQ1Tl-tCyXrovuQwBMHrFwE9uMzzclq2SzHjg=s176-c-k-c0xffffffff-no-rj-mo",
    "username": "KlapYaHandz",
    "title": "Vin Vitou - រាល់ថ្ងៃនេះ (Nowadays) Ft. Ruthko [Official MV]",
    "view_count": "292,288",
    "day_ago": "Sep 25, 2020",
    "subscriber_count": "511K",
    "like_count": "5.9K",
    "unlike_count": "65",
    "video_url": "assets/videos/video_4.mp4",
    "video_duration": "04:30"
  },
];
