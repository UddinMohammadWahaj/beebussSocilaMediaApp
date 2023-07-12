import 'dart:io';
import 'dart:typed_data';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/models/profile_posts_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/profile_feeds_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ProfilePostImageCard extends StatefulWidget {
  final NewsFeedModel post;
  final String stringOfPostID;
  final int length;
  final String otherMemberID;
  final int index;
  final AllFeeds postsList;
  final Function changeColor;
  final Function isChannelOpen;
  final Function setNavBar;
  final Function refresh;

  ProfilePostImageCard({
    Key? key,
    required this.post,
    required this.stringOfPostID,
    required this.length,
    required this.otherMemberID,
    required this.index,
    required this.changeColor,
    required this.isChannelOpen,
    required this.setNavBar,
    required this.refresh,
    required this.postsList,
  }) : super(key: key);

  @override
  _ProfilePostImageCardState createState() => _ProfilePostImageCardState();
}

class _ProfilePostImageCardState extends State<ProfilePostImageCard>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    _generateThumbnail(widget.postsList.feeds[widget.index].postImgData!
        .split("~~")[0]
        .toString());
    print("---ttypeee--- " +
        widget.postsList.feeds[widget.index].postMultiImage.toString());
    super.initState();
  }

  late File videoImage;
  void _generateThumbnail(String path) async {
    // setState(() async {
    // print("---generating--- " +
    //     widget.postsList.feeds[widget.index].postImgData
    //         .split("~~")[0]
    //         .toString());

    print("path thumbnail=$path");
    Uint8List? unit8list;
    unit8list = await VideoThumbnail.thumbnailData(
      video: path,
      // widget.postsList.feeds[widget.index].postImgData
      //     .split("~~")[0]
      //     .toString(),
      imageFormat: ImageFormat.JPEG,
      quality: 50,
    );

    final tempDir = await getTemporaryDirectory();
    final file =
        await new File('${tempDir.path}/image${widget.index + 1}.jpg').create();

    file.writeAsBytesSync(unit8list!);
    videoImage = file;
    print("----videoimage $videoImage");
    // setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        print(widget.post.postId);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileFeedsPage(
                      refresh: widget.refresh,
                      setNavBar: widget.setNavBar,
                      isChannelOpen: widget.isChannelOpen,
                      changeColor: widget.changeColor,
                      otherMemberID: widget.otherMemberID,
                      post: widget.post,
                      currentMemberImage: CurrentUser().currentUser.image,
                      listOfPostID: widget.stringOfPostID,
                      postID: widget.post.postId,
                      logo: CurrentUser().currentUser.logo,
                      country: CurrentUser().currentUser.country,
                      memberID: CurrentUser().currentUser.memberID,
                    )));
      },
      child: Container(
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: (widget.post.postImgData!.endsWith(".mp4") ||
                          widget.post.postImgData!
                              .split("~~")[0]
                              .endsWith(".m3u8")) &&
                      widget.post.postImgData != null &&
                      widget.post.postMultiImage == 0
                  ? Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: videoImage == null || videoImage.path.isEmpty
                          ? Container()
                          : Image.file(
                              videoImage,
                              fit: BoxFit.cover,
                            ),
                      // child: Image(
                      //   image: CachedNetworkImageProvider(widget
                      //       .post.postImgData
                      //       ?.replaceAll(".mp4", ".jpg")),
                      // fit: BoxFit.cover,
                      // ),
                    )
                  : widget.post.postMultiImage == 1 &&
                          (widget.post.postImgData!
                                  .split("~~")[0]
                                  .endsWith(".mp4") ||
                              widget.post.postImgData!
                                  .split("~~")[0]
                                  .endsWith(".m3u8"))
                      ? Container(
                          color: Colors.grey.withOpacity(0.2),
                          child: videoImage == null || videoImage.path.isEmpty
                              ? Container()
                              : Image.file(
                                  videoImage,
                                  fit: BoxFit.cover,
                                ),
                          //   : Image(
                          // image: CachedNetworkImageProvider(widget
                          //     .postsList.feeds[widget.index].thumbnailUrl),
                          // postImgData
                          // .split("~~")[0]
                          // .toString()
                          // ?.replaceAll(".mp4", ".jpg")),
                          // fit: BoxFit.cover,
                          // ),
                        )
                      : Container(
                          color: Colors.grey.withOpacity(0.2),
                          child: Image(
                            image: CachedNetworkImageProvider(
                                widget.post.postMultiImage == 1
                                    ? widget.post.postImgData!.split("~~")[0]
                                    : widget.post.postImgData!),
                            fit: BoxFit.cover,
                          ),
                        ),
            ),
            widget.post.postMultiImage == 1
                ? Positioned.fill(
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Image.asset(
                            "assets/images/multiple.png",
                            height: 2.5.h,
                          ),
                        )),
                  )
                : Container(),
            widget.post.postType == "Video"
                ? Positioned.fill(
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.video_collection,
                              color: Colors.white,
                              size: 2.5.h,
                            ))),
                  )
                : Container(),
            widget.post.postType == "svideo"
                ? Positioned.fill(
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              CustomIcons.shortbuz1,
                              color: Colors.white,
                              size: 2.5.h,
                            ))),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
