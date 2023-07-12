import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_suggestions_model.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/discover_video_player.dart';
import 'package:bizbultest/widgets/discover_video_player_bigvideo.dart';
import 'package:bizbultest/widgets/discover_video_player_shortbuz.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class VideoSuggestionsCard extends StatelessWidget {
  final VideoModel? video;
  final VoidCallback? play;

  VideoSuggestionsCard({Key? key, this.video, this.play}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
        "image of video img ${video.toString()} cat${video!.category} content ${video!.content}");

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: play,
        child: Container(
          child: Stack(
            children: [
              Container(
                width: 150,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        color: Colors.grey.withOpacity(0.2),
                        child:
                            //  DiscoverVideoPlayerBigVideo(
                            //     image: video.image, url: video.video),

                            Image(
                                image:
                                    CachedNetworkImageProvider(video!.image!),
                                fit: BoxFit.cover,
                                height: 100))),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7.0))),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          video!.category!.replaceAll('and', '&').toUpperCase(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              fontFamily: 'Arial'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
