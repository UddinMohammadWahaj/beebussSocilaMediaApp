import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/services/Streaming/Controllers/cover_page_controller.dart';
import 'package:bizbultest/services/Streaming/streaming_home_api_calls.dart';
import 'package:bizbultest/view/Streaming/detailed_video_info_page_movies.dart';
import 'package:bizbultest/view/Streaming/detailed_video_player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';

import 'info_card.dart';

class FeaturedVideoCard extends StatefulWidget {
  final CategoryDataModel video;
  const FeaturedVideoCard({Key? key, required this.video}) : super(key: key);

  @override
  _FeaturedVideoCardState createState() => _FeaturedVideoCardState();
}

class _FeaturedVideoCardState extends State<FeaturedVideoCard> {
  CoverPageController _coverPageController = Get.put(CoverPageController());

  Widget _flatButton(IconData icon, String title, VoidCallback onTap) {
    return TextButton(
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white))),
      child: Column(
        children: <Widget>[
          Icon(icon),
          SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w300),
          ),
        ],
      ),
      onPressed: onTap,
    );
  }

  Widget _playButton() {
    return InkWell(
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 6, right: 15, top: 4, bottom: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.play_arrow_sharp,
                size: 30,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                AppLocalizations.of(
                  'Play',
                ),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailedVideoPlayerScreen(
                      video: widget.video.video,
                      title: widget.video.title,
                    )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_coverPageController.coverPageVideoList.length == 0) {
        return Container(
          height: 65.0.h,
        );
      } else {
        return Container(
          height: 65.0.h,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image(
                image: CachedNetworkImageProvider(widget.video.poster!),
                fit: BoxFit.cover,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [0.1, 0.6, 1.0],
                    colors: [Colors.black54, Colors.transparent, Colors.black],
                  ),
                ),
                child: Container(
                  height: 40.0,
                  width: 100.0.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 3.0,
                                color: Colors.blue
                                //  Color.fromRGBO(185, 3, 12, 1.0)
                                ,
                              ),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(
                              "${widget.video.title}",
                            ),
                            maxLines: 3,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              height: 0.65,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _flatButton(
                                widget.video.added == 1
                                    ? Icons.check
                                    : Icons.add,
                                AppLocalizations.of(
                                  "My List",
                                ), () {
                              if (widget.video.added == 1) {
                                setState(() {
                                  widget.video.added = 0;
                                });
                                StreamHomeApi.removeFromMyList(
                                    widget.video.videoId!);
                              } else {
                                setState(() {
                                  widget.video.added = 1;
                                });
                                StreamHomeApi.addToMyList(
                                    widget.video.videoId!);
                              }
                            }),
                            _playButton(),
                            _flatButton(
                                Icons.info_outline,
                                AppLocalizations.of(
                                  "Info",
                                ), () {
                              print("clicked on info");
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
                                      video: widget.video,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailedVideoInfoPageMovie(
                                                      video: widget.video,
                                                      image:
                                                          widget.video.poster,
                                                    )));
                                      },
                                    );
                                  });
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
