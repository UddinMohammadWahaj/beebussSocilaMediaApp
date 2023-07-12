import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Streaming/Controllers/category_controller.dart';
import 'package:bizbultest/view/Streaming/detailed_video_player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SeasonCard extends StatefulWidget {
  final int? index;
  final int? catIndex;
  final int? episodeIndex;
  final String? image;

  const SeasonCard(
      {Key? key, this.image, this.index, this.catIndex, this.episodeIndex})
      : super(key: key);

  @override
  _SeasonCardState createState() => _SeasonCardState();
}

class _SeasonCardState extends State<SeasonCard> {
  CategoryController controller = Get.put(CategoryController());

  TextStyle _style(double size, FontWeight weight, Color color) {
    return GoogleFonts.dmSans(fontSize: size, fontWeight: weight, color: color);
  }

  Widget _imageCard() {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      width: 35.0.w,
      height: 10.0.h,
      child: Stack(
        children: [
          Container(
            height: 10.0.h,
            width: 35.0.w,
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: CachedNetworkImageProvider(
                        controller
                            .categoricalSeriesList[widget.index!]
                            .categoryData![widget.catIndex!]
                            .episodes![widget.episodeIndex!]
                            .poster!,
                      ),
                      fit: BoxFit.cover,
                    ))),
          ),
          Center(
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleCard() {
    return Container(
      width: 65.0.w - 45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Text(
            AppLocalizations.of(
              "${widget.episodeIndex! + 1}. ${controller.categoricalSeriesList[widget.index!].categoryData![widget.catIndex!].episodes![widget.episodeIndex!].title}",
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _style(10.0.sp, FontWeight.bold, Colors.white),
          )),
          SizedBox(
            height: 4,
          ),
          Container(
              child: Text(
            controller
                .categoricalSeriesList[widget.index!]
                .categoryData![widget.catIndex!]
                .episodes![widget.episodeIndex!]
                .duration!,
            style: _style(10.0.sp, FontWeight.normal, Colors.grey.shade500),
          )),
        ],
      ),
    );
  }

  Widget _descriptionCard() {
    return Text(
      AppLocalizations.of(
        controller
            .categoricalSeriesList[widget.index!]
            .categoryData![widget.catIndex!]
            .episodes![widget.episodeIndex!]
            .description!,
      ),
      style: _style(9.5.sp, FontWeight.normal, Colors.grey.shade400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.grey.shade500.withOpacity(0.4),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailedVideoPlayerScreen(
                        video: controller
                            .categoricalSeriesList[widget.index!]
                            .categoryData![widget.catIndex!]
                            .episodes![widget.episodeIndex!]
                            .video,
                        title: controller
                            .categoricalSeriesList[widget.index!]
                            .categoryData![widget.catIndex!]
                            .episodes![widget.episodeIndex!]
                            .title,
                      )));
        },
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 5, left: 10, right: 10, top: 5),
          child: Container(
            width: 100.0.w,
            child: Column(
              children: [
                Row(
                  children: [
                    _imageCard(),
                    SizedBox(
                      width: 15,
                    ),
                    _titleCard(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                _descriptionCard()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
