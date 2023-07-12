import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

class DetailedVideoView extends GetView<ProperbuzFeedController> {
  final int? index;
  final int? val;

  const DetailedVideoView({Key? key, this.index, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.dark,
          elevation: 0,
          backgroundColor: Colors.black,
        ),
      ),
      backgroundColor: Colors.black,
      body: PostVideoPlayer(
        index: index!,
        val: val!,
      ),
    );
  }
}

class PostVideoPlayer extends StatefulWidget {
  final int? index;
  final int? val;

  const PostVideoPlayer({Key? key, this.index, this.val}) : super(key: key);

  @override
  _PostVideoPlayerState createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  ProperbuzFeedController controller = Get.put(ProperbuzFeedController());

  @override
  void initState() {
    controller.flickManager = new FlickManager(
      videoPlayerController: VideoPlayerController.network(
          controller.getFeedsList(widget.val!)[widget.index!].video!.videoUrl!),
    );

    super.initState();
  }

  @override
  void dispose() {
    controller.flickManager.dispose();
    print("video disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100.0.h,
          width: 100.0.w,
          child: AspectRatio(
            aspectRatio: controller
                .flickManager.flickVideoManager!.videoPlayerValue!.aspectRatio,
            child: FlickVideoPlayer(
              wakelockEnabled: false,
              wakelockEnabledFullscreen: false,
              flickManager: controller.flickManager,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.black.withOpacity(0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      Icons.close,
                      size: 28,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  UserCard(
                    index: widget.index!,
                    val: widget.val!,
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.black.withOpacity(0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      Icons.close,
                      size: 28,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  UserCard(
                    index: widget.index!,
                    val: widget.val!,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UserCard extends GetView<ProperbuzFeedController> {
  final int? index;
  final int? val;
  final bool? showMenu;

  const UserCard({Key? key, this.index, this.val, this.showMenu})
      : super(key: key);

  Widget _userImageCard() {
    return CircleAvatar(
      radius: 22,
      foregroundColor: featuredColor,
      backgroundColor: featuredColor,
      backgroundImage: CachedNetworkImageProvider(
          controller.getFeedsList(val!)[index!].memberProfile!),
    );
  }

  Widget _userNameCard() {
    return Text(
      controller.getFeedsList(val!)[index!].memberName!,
      style: TextStyle(
          fontSize: 14.5, fontWeight: FontWeight.w500, color: Colors.white),
    );
  }

  Widget _userDescriptionCard() {
    return Text(
      AppLocalizations.of(
          controller.getFeedsList(val!)[index!].memberDesignation!),
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _timeStampCard() {
    return Text(
      controller.getFeedsList(val!)[index!].createdAt!,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: Colors.grey.shade50),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Container(
        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _userImageCard(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _userNameCard(),
                      _userDescriptionCard(),
                      _timeStampCard()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
