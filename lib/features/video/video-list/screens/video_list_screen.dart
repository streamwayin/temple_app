import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/features/video/video-list/bloc/video_list_bloc.dart';
import 'package:temple_app/modals/video_album_model.dart';
import 'package:temple_app/widgets/common_background_component.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});
  static const String routeName = '/video-list-screen';

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  var yt = YoutubeExplode();
  List<String> vidoeList = [];
  @override
  // void initState() {
  //   initial();
  //   super.initState();
  // }

  initial() async {
    // ytlist = yt.playlists.getVideos("PLosaC3gb0kGC1jJXceKOVZ29Rq0Mfj4wK");
    await for (var video
        in yt.playlists.getVideos("PLosaC3gb0kGC1jJXceKOVZ29Rq0Mfj4wK")) {
      vidoeList.add(video.id.value);
      setState(() {});
      // var videoTitle = video.id;
      // var videoAuthor = video.author;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoListBloc, VideoListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("Videos")),
          body: state.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    CommonBackgroundComponent(),

                    // Text(
                    //   "${state.videoList.length}",
                    // ),
                    // Text("${state.isLoading}")

                    ListView.builder(
                      itemCount: state.videoAlbumModelList.length,
                      itemBuilder: (context, index) {
                        VideoAlbumModel videoAlbum =
                            state.videoAlbumModelList[index];
                        return ListTile(
                          leading: SizedBox(
                            child: CachedNetworkImage(
                              height: 50.h,
                              width: 50.w,
                              imageUrl: videoAlbum.thumbnail,
                            ),
                          ),
                          title: Text("${videoAlbum.title}"),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<VideoListBloc>()
                                .add(VideoListInitialEvent());
                          },
                          child: Text("trigger event")),
                    )
                  ],
                ),
        );
      },
    );
  }
}
