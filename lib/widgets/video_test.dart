/*


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideosState extends State<Videos> {
  List<String> videoList;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final videoList = _dir.listSync().map((item) => item.path).where(
            (item) => item.endsWith(".mp4") || item.endsWith(".avi") || item.endsWith(".webm")
    ).toList(growable: false);
    if (videoList != null) {
      if (videoList.length > 0) {
        return ListView.builder(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 16),
            itemBuilder: (BuildContext _context, int index) {
              if (index >= videoList.length) {
                return null;
              }
              return VideoPlayerScreen(
                path: videoList[index],
              );
            }
        );
      }
    }
    return VideoPlayerScreen(
      path: videoList[0],
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String path;

  VideoPlayerScreen({Key key, @required this.path}): super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(
    path: this.path,
  );
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFeature;
  final String path;

  _VideoPlayerScreenState({Key key, @required this.path});

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(path));
    _initializeVideoPlayerFeature = _controller.initialize();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: FutureBuilder(
            future: _initializeVideoPlayerFeature,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              }
              return Center(child: CircularProgressIndicator());
            }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        )
    );
  }
}*/
