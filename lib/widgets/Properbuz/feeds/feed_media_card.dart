import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/view/Properbuz/detailed_image_view.dart';
import 'package:bizbultest/view/Properbuz/detailed_video_view.dart';
import 'package:bizbultest/view/Properbuz/properbuz_web_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

class FeedMediaCard extends GetView<ProperbuzFeedController> {
  final int index;
  final int val;

  FeedMediaCard({Key? key, required this.index, required this.val})
      : super(key: key);

  ProperbuzFeedController ctr = Get.put(ProperbuzFeedController());

  Widget _customURLInfoCard(String domain) {
    return Container(
      color: Colors.grey.shade100,
      child: ListTile(
        contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10),
        title: Text(
          AppLocalizations.of(
            controller.getFeedsList(val)[index].video!.urlCaption!,
          ),
          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          domain,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _singleImageCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailedImageView(index: index, val: val),
        ),
      ),
      child: Container(
        color: Colors.transparent,
        child: Image(
          image: CachedNetworkImageProvider(
              controller.getFeedsList(val)[index].images![0]),
          fit: BoxFit.cover,
          width: 100.0.w,
          height: 40.0.h,
        ),
      ),
    );
  }

  Widget _customImageCard(String image, double width) {
    return Container(
      constraints: BoxConstraints(maxHeight: 60.0.h, minHeight: 40.0.h),
      width: width,
      child: Image(
        image: CachedNetworkImageProvider(image),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _multipleImagesCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailedImageView(index: index, val: val),
        ),
      ),
      child: Container(
          width: 100.0.w,
          color: Colors.transparent,
          constraints: BoxConstraints(maxHeight: 60.0.h, minHeight: 40.0.h),
          child: Column(
            children: [
              Container(
                  height: 55.h,
                  child: Obx(
                    () => PageView.builder(
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (int value) {
                        ctr.selectIndex.value = value;
                        // ctr.update();
                      },
                      itemCount:
                          controller.getFeedsList(val)[index].images!.length,
                      itemBuilder: (context, index1) {
                        return _customImageCard(
                          controller.getFeedsList(val)[index].images![index1],
                          100.0.w - 1.0,
                        );
                      },
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.getFeedsList(val)[index].images!.length,
                  (index2) {
                    return Obx(() => index2 == ctr.selectIndex.value
                        ? _indicator(true)
                        : _indicator(false));
                  },
                ),
              )
            ],
          )
          // Row(
          //   children: [
          //     _customImageCard(
          //         controller.getFeedsList(val)[index].images[0], 50.0.w - 1.0),
          //     SizedBox(
          //       width: 2,
          //     ),
          //     _customImageCard(
          //         controller.getFeedsList(val)[index].images[1], 50.0.w - 1.0),
          //   ],
          // ),
          ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0;
        i < controller.getFeedsList(val)[index].images!.length;
        i++) {
      list.add(i == ctr.selectIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.black.withOpacity(.5) : Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  Widget _videoCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedVideoView(index: index, val: val))),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            _customImageCard(
                controller.getFeedsList(val)[index].video!.videoThumb!,
                100.0.w),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: new BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _youtubeCard() {
    return GestureDetector(
      onTap: () => controller.openYouTube(index),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Stack(
              children: [
                _customImageCard(
                    controller.getFeedsList(val)[index]!.video!.videoThumb!,
                    100.0.w),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.red.shade800,
                        shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _customURLInfoCard("youtube.com")
          ],
        ),
      ),
    );
  }

  Widget _bebuzeeVideoCard() {
    return Column(
      children: [
        Stack(
          children: [
            _customImageCard(
                controller.getFeedsList(val)[index].video!.videoThumb!,
                100.0.w),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.rectangle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        _customURLInfoCard("bebuzee.com")
      ],
    );
  }

  Widget _urlCard(BuildContext context) {
    // print("-------urlLink ${controller.getFeedsList(val)[index].urlLink}");
    return
        // controller.getFeedsList(val)[index].urlLink == null
        //     // &&
        //     // controller.getFeedsList(val)[index].urlLink.length == 0
        //     ? Container()
        // :
        GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProperbuzWebView(
                        url: controller
                            .getFeedsList(val)[index]
                            .urlLink![0]
                            .url!))),
            child: Container(
              color: Colors.transparent,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, indexs) => Container(
                  height: 0.1.h,
                ),
                shrinkWrap: true,
                itemCount: controller.getFeedsList(val)[index].urlLink!.length,
                itemBuilder: (context, indexx) => InkWell(
                  onTap: () {
                    // print("-------- ${}");
                    print(
                        "-------urlLink ${controller.getFeedsList(val)[index].urlLink![indexx]}");
                    // launch(
                    //     '${controller.getFeedsList(val)[index].urlLink.url[indexx]}');
                  },
                  child: Column(
                    children: [
                      Container(
                          height: 250,
                          width: 100.0.w,
                          child: CachedNetworkImage(
                              placeholder: (ctx, url) => SkeletonAnimation(
                                      child: Container(
                                    color: Colors.grey.shade400,
                                    height: 250,
                                    width: 100.0.w,
                                  )),
                              imageUrl: controller
                                  .getFeedsList(val)[index]
                                  .urlLink![indexx]
                                  .image!)

                          // Image(
                          //   image: CachedNetworkImageProvider(controller
                          //       .getFeedsList(val)[index]
                          //       .urlLink[indexx]
                          //       .image,),
                          //   fit: BoxFit.cover,
                          // ),
                          ),
                      Container(
                        color: Colors.grey.shade100,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.only(top: 5, left: 10, right: 10),
                          title: Text(
                            AppLocalizations.of(
                              controller
                                  .getFeedsList(val)[index]
                                  .urlLink![indexx]
                                  .title!,
                            ),
                            style: TextStyle(
                                fontSize: 14.5, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            controller
                                .getFeedsList(val)[index]
                                .urlLink![indexx]
                                .domain!,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade600),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget _mediaCard(BuildContext context) {
    // controller.getFeedsList(val)[index].urlLink.title != ""
    //     ?

    // : Container();
    print("------@@@-- ${controller.getFeedsList(val)[index].postType}");
    switch (controller.getFeedsList(val)[index].postType) {
      case "image":
        return _singleImageCard(context);
        break;
      case "video":
        return _videoCard(context);
        break;
      case "multiple":
        return _multipleImagesCard(context);
        break;
      case "youtube":
        return _youtubeCard();
        break;
      case "bebuzee":
        return _bebuzeeVideoCard();
        break;
      case "post":
        return _urlCard(context);
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: controller
                    .getFeedsList(val)[index]
                    .description!
                    .value
                    .isNotEmpty
                ? 8
                : 0),
        child: Column(
          children: [
            _mediaCard(context),
            controller.getFeedsList(val)[index].postType != "post" &&
                    controller
                        .getFeedsList(val)[index]
                        .description!
                        .contains("https://")
                ? _urlCard(context)
                : Container(),
          ],
        ));
  }
}
