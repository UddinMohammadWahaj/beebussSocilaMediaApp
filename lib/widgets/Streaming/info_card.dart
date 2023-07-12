import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/services/Streaming/Controllers/category_controller.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/Streaming/detailed_video_player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class InfoCard extends StatefulWidget {
  final VoidCallback? onTap;
  final CategoryDataModel? video;

  const InfoCard({Key? key, this.onTap, this.video}) : super(key: key);

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  TextStyle _style(double size, FontWeight weight, Color color) {
    return GoogleFonts.publicSans(
        fontSize: size, fontWeight: weight, color: color);
  }

  Widget _greyTextCard(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 2),
      child: Container(
        child: Text(text,
            style: _style(8.5.sp, FontWeight.normal, Colors.grey.shade500)),
      ),
    );
  }

  Widget _closeButton() {
    return Container(
      decoration: new BoxDecoration(
          shape: BoxShape.circle, color: Colors.grey.shade700),
      child: IconButton(
          splashRadius: 10,
          padding: EdgeInsets.all(4),
          constraints: BoxConstraints(),
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        width: 100.0.w - 100 - 34,
        child: Text(
          widget.video!.description!,
          style: _style(10.0.sp, FontWeight.normal, Colors.white),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _playButton() {
    return InkWell(
      child: Container(
        width: 40.0.w,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
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
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailedVideoPlayerScreen(
                      video: widget.video!.video,
                      title: widget.video!.title,
                    )));
      },
    );
  }

  Widget _flatButton(IconData icon, String title, VoidCallback onTap) {
    return ElevatedButton(
      style: ButtonStyle(
          textStyle:
              MaterialStateProperty.all(TextStyle(color: Colors.grey.shade500)),
          overlayColor: MaterialStateProperty.all(Colors.transparent)),
      // highlightColor: Colors.transparent,
      // splashColor: Colors.transparent,
      // textColor: Colors.grey.shade500,
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 8.5.sp, fontWeight: FontWeight.w300),
          ),
        ],
      ),
      onPressed: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                      height: 140,
                      width: 100,
                      child: Image(
                        image:
                            CachedNetworkImageProvider(widget.video!.poster!),
                        fit: BoxFit.cover,
                      )),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.0.w - 100 - 24,
                      child: ListTile(
                        dense: true,
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        contentPadding: EdgeInsets.only(left: 10, bottom: 0),
                        title: Text(
                          widget.video!.title!,
                          style: _style(15.0.sp, FontWeight.bold, Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: _greyTextCard(
                            "${widget.video!.videoYear}     ${widget.video!.vmRating}      ${widget.video!.duration}"),
                        trailing: _closeButton(),
                      ),
                    ),
                    _description()
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _playButton(),
                _flatButton(
                    Icons.download_rounded,
                    AppLocalizations.of(
                      "Download",
                    ), () async {
                  customToastBlack(
                      AppLocalizations.of("Saved video to this device."),
                      15,
                      ToastGravity.CENTER);
                  await GallerySaver.saveVideo(widget.video!.video!);
                }),
                _flatButton(
                    Icons.play_arrow_outlined,
                    AppLocalizations.of(
                      "Preview",
                    ), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailedVideoPlayerScreen(
                                video: widget.video!.video,
                                title: widget.video!.title,
                              )));
                })
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 0.3,
            width: 100.0.w,
            color: Colors.grey.shade500,
          ),
          Container(
            width: 100.0.w - 24,
            child: ListTile(
              onTap: widget.onTap,
              visualDensity: VisualDensity(horizontal: -4, vertical: 0),
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
              title: Text(
                  AppLocalizations.of(
                    "Details & More",
                  ),
                  style: _style(10.0.sp, FontWeight.w400, Colors.white)),
              leading: Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 22,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
