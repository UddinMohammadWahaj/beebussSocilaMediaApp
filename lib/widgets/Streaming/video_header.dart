import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/services/Streaming/streaming_home_api_calls.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Streaming/detailed_video_player_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class VideoHeader extends StatefulWidget {
  final CategoryDataModel video;

  const VideoHeader({Key? key, required this.video}) : super(key: key);

  @override
  _VideoHeaderState createState() => _VideoHeaderState();
}

class _VideoHeaderState extends State<VideoHeader> {
  TextStyle _style(double size, FontWeight weight, Color color) {
    return GoogleFonts.publicSans(
        fontSize: size, fontWeight: weight, color: color);
  }

  Widget _textCard(String text, Color color) {
    return Container(
        child: Text(
      text,
      style: _style(8.5.sp, FontWeight.normal, color),
    ));
  }

  Widget _spacing(double width) {
    return SizedBox(
      width: width,
    );
  }

  Widget _search() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomCenter,
    );
  }

  Widget _playButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        child: Container(
          width: 95.0.w,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(3)),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 6, right: 15, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.play_arrow_sharp,
                  size: 6.0.w,
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  AppLocalizations.of(
                    'Play',
                  ),
                  style: TextStyle(
                    fontSize: 12.0.sp,
                    fontWeight: FontWeight.w500,
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
                        video: widget.video.video!,
                        title: widget.video.title!,
                      )));
        },
      ),
    );
  }

  void _likeDislike() {
    if (widget.video!.likeStatus == 0) {
      showModalBottomSheet(
          backgroundColor: Colors.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0))),
          //isScrollControlled:true,
          context: context,
          builder: (BuildContext bc) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(bc);
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _likeDislikeButton(Icons.thumb_up_alt_outlined, () {
                            setState(() {
                              widget.video.likeStatus = 1;
                            });
                            Navigator.pop(bc);
                            StreamHomeApi.likeVideo(widget.video.videoId!);
                          }, 35),
                          SizedBox(
                            width: 20,
                          ),
                          _likeDislikeButton(Icons.thumb_down_alt_outlined, () {
                            setState(() {
                              widget.video.likeStatus = 2;
                            });
                            Navigator.pop(bc);
                            StreamHomeApi.dislikeVideo(widget.video.videoId!);
                          }, 35)
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _likeDislikeButton(Icons.close, () {
                        Navigator.pop(bc);
                      }, 20),
                    ],
                  ),
                ),
              ),
            );
          });
    } else if (widget.video.likeStatus == 1 || widget.video.likeStatus == 2) {
      setState(() {
        widget.video.likeStatus = 0;
      });
      StreamHomeApi.removeLikeDislike(widget.video.videoId!);
    }
  }

  Widget _likeDislikeButton(IconData icon, VoidCallback onTap, double radius) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.white,
            width: 0.6,
          ),
        ),
        child: CircleAvatar(
          foregroundColor: Colors.grey.shade900,
          backgroundColor: Colors.grey.shade900,
          radius: radius,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        child: Text(widget.video.description!,
            style: _style(10.0.sp, FontWeight.normal, Colors.white)),
      ),
    );
  }

  Widget _iconTextButton(IconData icon, String text, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          constraints: BoxConstraints(),
          splashRadius: 20,
          onPressed: onTap,
          icon: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          text,
          style: _style(10, FontWeight.normal, Colors.grey.shade400),
        )
      ],
    );
  }

  IconData _likeStatusIcon() {
    int val = widget.video.likeStatus!;
    if (val == 1) {
      return Icons.thumb_up;
    } else if (val == 2) {
      return Icons.thumb_down;
    } else {
      return Icons.thumb_up_alt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                widget.video.title!,
                style: _style(22.0.sp, FontWeight.bold, Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  children: [
                    _textCard(widget.video.videoYear!, Colors.grey.shade300),
                    _spacing(15),
                    Container(
                        decoration: new BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 5),
                          child: _textCard(
                              widget.video.vmRating!, Colors.grey.shade300),
                        )),
                    _spacing(15),
                    _textCard(widget.video.duration!, Colors.grey.shade400),
                    _spacing(15),
                    Container(
                        decoration: new BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          child: _textCard("HD", Colors.black),
                        )),
                  ],
                ),
              ),
            ),
            Center(child: _playButton()),
            _description(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _iconTextButton(
                      widget.video.added == 1 ? Icons.check : Icons.add,
                      AppLocalizations.of(
                        "My List",
                      ), () {
                    if (widget.video.added == 1) {
                      setState(() {
                        widget.video.added = 0;
                      });
                      StreamHomeApi.removeFromMyList(widget.video.videoId!);
                    } else {
                      setState(() {
                        widget.video.added = 1;
                      });
                      StreamHomeApi.addToMyList(widget.video.videoId!);
                    }
                  }),
                  _spacing(20.0.w),
                  _iconTextButton(
                      _likeStatusIcon(),
                      AppLocalizations.of(
                        "Rate",
                      ), () {
                    _likeDislike();
                  }),
                  _spacing(20.0.w),
                  _iconTextButton(
                      Icons.share,
                      AppLocalizations.of(
                        "Share",
                      ),
                      () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
