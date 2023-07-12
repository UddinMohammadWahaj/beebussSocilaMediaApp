import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/services/Streaming/streaming_home_api_calls.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/Streaming/info_card.dart';
import 'package:bizbultest/widgets/Streaming/preview_video_player.dart';
import 'package:bizbultest/widgets/Streaming/video_header.dart';
import 'package:bizbultest/widgets/Streaming/video_preview_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:video_player/video_player.dart';

import 'detailed_video_info_page_series.dart';

class DetailedVideoInfoPageMovie extends StatefulWidget {
  final String? image;
  final CategoryDataModel? video;

  const DetailedVideoInfoPageMovie({Key? key, this.image, this.video})
      : super(key: key);

  @override
  _DetailedVideoInfoPageMovieState createState() =>
      _DetailedVideoInfoPageMovieState();
}

class _DetailedVideoInfoPageMovieState
    extends State<DetailedVideoInfoPageMovie> {
  late FlickManager _flickManager;
  bool isVideoPlaying = false;

  Widget _similarMovieList() {
    return FutureBuilder(
        future: _similarMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _videoList.videos.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 4 / 5),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      AspectRatio(
                          aspectRatio: 4.5 / 6,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  barrierColor: Colors.white.withOpacity(0),
                                  elevation: 0,
                                  backgroundColor: Colors.grey.shade900,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(10.0),
                                          topRight:
                                              const Radius.circular(10.0))),
                                  //isScrollControlled:true,
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return InfoCard(
                                      video: _videoList
                                          .videos[index].categoryData![0],
                                      onTap: () {
                                        print(_videoList.videos[index]
                                                .categoryData![0].videoType
                                                .toString() +
                                            " type");
                                        if (_videoList.videos[index]
                                                .categoryData![0].videoType ==
                                            1) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailedVideoInfoPageMovie(
                                                        video: _videoList
                                                            .videos[index]
                                                            .categoryData![0],
                                                        image: _videoList
                                                            .videos[index]
                                                            .categoryData![0]
                                                            .poster,
                                                      )));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailedVideoInfoPageSeries(
                                                        video: _videoList
                                                            .videos[index]
                                                            .categoryData![0],
                                                        image: _videoList
                                                            .videos[index]
                                                            .categoryData![0]
                                                            .poster,
                                                      )));
                                        }
                                      },
                                    );
                                  });
                            },
                            child: Container(
                                color: Colors.transparent,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      _videoList.videos[index].categoryData![0]
                                          .poster!,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ))),
                          )),
                    ],
                  );
                });
          } else {
            return _placeHolderList();
          }
        });
  }

  Widget _placeHolderList() {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 30,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 9 / 16),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              AspectRatio(
                aspectRatio: 9 / 16,
                child: SkeletonAnimation(
                  shimmerColor: Colors.black38,
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      shape: BoxShape.rectangle,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget _tabButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border(top: BorderSide(color: Colors.red, width: 3)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              text,
              style: whiteBold.copyWith(fontSize: 11.0.sp),
            ),
          )),
    );
  }

  late Future _similarMovies;

  StreamCategoryVideos _videoList = StreamCategoryVideos([]);

  Future<void> _getSimilarMovies() async {
    _similarMovies = StreamHomeApi.getMoreLikeThisVideos(widget.video!.videoId!)
        .then((value) {
      setState(() {
        _videoList.videos = value.videos;
      });
      print(_videoList.videos.length.toString() + " len");
      return value;
    });
  }

  @override
  void initState() {
    _getSimilarMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5.0.h),
        child: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          brightness: Brightness.dark,
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
                splashRadius: 20,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  print("clicked on search");
                })
          ],
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !isVideoPlaying
                ? VideoPreviewCard(
                    onTap: () {
                      print("clicked");
                      setState(() {
                        isVideoPlaying = true;
                        //_flickManager.flickVideoManager.videoPlayerController.play();
                      });
                    },
                    video: widget.video,
                  )
                : PreviewVideoPlayer(
                    flickManager: _flickManager,
                    url: widget.video!.videoPreviewTrailer,
                  ),
            Container(
              height: 65.0.h - height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VideoHeader(
                      video: widget.video!,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.shade700,
                      width: 100.0.w,
                    ),
                    _tabButton(
                      AppLocalizations.of("MORE LIKE THIS"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _similarMovieList()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
