import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/video_ads_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/providers/feeds/popular_videos_provider.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/widgets/Newsfeeds/video_suggestions_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import '../video_page_main.dart';

class PopularVideos extends StatelessWidget {
  final Function? changeColor;
  final Function? setNavBar;
  final Future? popularVideosFuture;

  const PopularVideos(
      {Key? key, this.changeColor, this.setNavBar, this.popularVideosFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PopularVideosProvider>(
      builder: (BuildContext? context, popularVideosProvider, Widget? child) {
        return Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Container(
            height: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(1.0.h),
                        child: Text(
                          AppLocalizations.of("Popular Videos"),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future: popularVideosFuture,
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          print(snapshot.data);
                          return SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: CustomHeader(
                              builder: (context, mode) {
                                return Container(
                                  child: Center(child: loadingAnimation()),
                                );
                              },
                            ),
                            footer: CustomFooter(
                              builder:
                                  (BuildContext context, LoadStatus? mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = Text("");
                                } else if (mode == LoadStatus.loading) {
                                  body = loadingAnimation();
                                } else if (mode == LoadStatus.failed) {
                                  body = Container(
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: new Border.all(
                                            color: Colors.black, width: 0.7),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Icon(CustomIcons.reload),
                                      ));
                                } else if (mode == LoadStatus.canLoading) {
                                  body = Text("");
                                } else {
                                  body = Text(
                                    AppLocalizations.of(
                                      "No more Data",
                                    ),
                                  );
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            controller:
                                popularVideosProvider.videoRefreshController,
                            onRefresh: () =>
                                popularVideosProvider.onRefreshVideos(context),
                            onLoading: () =>
                                popularVideosProvider.onLoadingVideos(context),
                            child: ListView.builder(
                              addAutomaticKeepAlives: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: popularVideosProvider.videoList.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    VideoSuggestionsCard(
                                      play: () async {
                                        popularVideosProvider.showLoad(index);

                                        var video = popularVideosProvider
                                            .videoList[index];
                                        //  await popularVideosProvider
                                        //     .getVideoDetails(
                                        //   popularVideosProvider
                                        //       .videoList[index].postId,
                                        //   context,
                                        // );
                                        var adList = await popularVideosProvider
                                            .getAds();
                                        popularVideosProvider.stopLoad(index);
                                        print("data (video cat) =${video}");
                                        VideoListModelData data =
                                            new VideoListModelData();
                                        data.category = video!.category;
                                        data.categoryIt = video!.categoryIt;
                                        data.content = video!.content;
                                        data.countryId = video!.countryId;
                                        data.countryName = video!.countryName;
                                        data.dislikeIcon = video!.dislikeIcon;
                                        data.dislikeStatus =
                                            video!.dislikeStatus == 1
                                                ? true
                                                : false;
                                        data.embedController =
                                            video!.embedController;
                                        data.image = video!.image;
                                        data.isSelected = video!.isSelected;
                                        data.languageId = video!.languageId;
                                        data.languageName = video!.languageName;
                                        data.likeIcon = video!.likeIcon;
                                        data.likeStatus = video!.likeStatus == 1
                                            ? true
                                            : false;
                                        data.name = video!.name;
                                        data.numViews = video!.numViews;
                                        data.numberOfDislike =
                                            video!.numberOfDislike;
                                        data.videoWidth = video!.videoWidth;
                                        data.videoTags = video!.videoTags;
                                        data.videoHeight = video!.videoHeight;
                                        data.video = video!.video;
                                        data.userImage = video!.userImage;
                                        data.userId = video!.userID;
                                        data.totalVideos = video!.totalVideos;
                                        data.totalComments =
                                            video!.totalComments;
                                        data.timeStamp = video!.timeStamp;
                                        data.shortcode = video!.shortcode;
                                        data.shareUrl = video!.shareUrl;
                                        data.quality = video!.quality;
                                        data.postId = int.parse(video.postId!);
                                        data.postContent = video!.postContent;
                                        data.numberOfLike = video!.numberOfLike;
                                        data.numberOfDislike =
                                            video!.numberOfDislike;
                                        data.followStatus = video!.followStatus;
                                        data.name = video!.name;

                                        print(
                                            "data followstats =${data.name} video!.name=${video!.name}");
                                        changeColor!(true);
                                        setNavBar!(true);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainVideoPage(
                                                      adsList: adList,
                                                      changeColor: changeColor,
                                                      video: data,
                                                      // video: popularVideosProvider
                                                      //     .videoList[index],
                                                      from: "Feeds",

                                                      // scrollController: widget.scrollController,
                                                      scrollController:
                                                          ScrollController(),
                                                      setNavBar: setNavBar,
                                                    )));
                                      },
                                      video: popularVideosProvider
                                          .videoList[index],
                                    ),
                                    (popularVideosProvider.loadinglist[index])
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Container()
                                  ],
                                );

                                // return VideoSuggestionsCard(
                                //   play: () async {
                                //     changeColor(true);
                                //     setNavBar(true);
                                //     popularVideosProvider.showLoad(index);

                                //     var video = await popularVideosProvider
                                //         .getVideoDetails(
                                //       popularVideosProvider
                                //           .videoList[index].postId,
                                //       context,
                                //     );

                                //     print("data (video cat) =${video}");
                                //     VideoListModelData data =
                                //         new VideoListModelData();
                                //     data.category = video!.category;
                                //     data.categoryIt = video!.categoryIt;
                                //     data.content = video!.content;
                                //     data.countryId = video!.countryId;
                                //     data.countryName = video!.countryName;
                                //     data.dislikeIcon = video!.dislikeIcon;
                                //     data.dislikeStatus =
                                //         video!.dislikeStatus == 1 ? true : false;
                                //     data.embedController =
                                //         video!.embedController;
                                //     data.image = video!.image;
                                //     data.isSelected = video!.isSelected;
                                //     data.languageId = video!.languageId;
                                //     data.languageName = video!.languageName;
                                //     data.likeIcon = video!.likeIcon;
                                //     data.likeStatus =
                                //         video!.likeStatus == 1 ? true : false;
                                //     data.name = video!.name;
                                //     data.numViews = video!.numViews;
                                //     data.numberOfDislike =
                                //         video!.numberOfDislike;
                                //     data.videoWidth = video!.videoWidth;
                                //     data.videoTags = video!.videoTags;
                                //     data.videoHeight = video!.videoHeight;
                                //     data.video = video!.video;
                                //     data.userImage = video!.userImage;
                                //     data.userId = video!.userID;
                                //     data.totalVideos = video!.totalVideos;
                                //     data.totalComments = video!.totalComments;
                                //     data.timeStamp = video!.timeStamp;
                                //     data.shortcode = video!.shortcode;
                                //     data.shareUrl = video!.shareUrl;
                                //     data.quality = video!.quality;
                                //     data.postId = int.parse(video!.postId);
                                //     data.postContent = video!.postContent;
                                //     data.numberOfLike = video!.numberOfLike;
                                //     data.numberOfDislike =
                                //         video!.numberOfDislike;

                                //     print("data (video cat) =${data}");

                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) => MainVideoPage(
                                //                   adsList: null,
                                //                   changeColor: changeColor,
                                //                   video: data,
                                //                   // video: popularVideosProvider
                                //                   //     .videoList[index],
                                //                   from: "Feeds",

                                //                   // scrollController: widget.scrollController,
                                //                   scrollController:
                                //                       ScrollController(),
                                //                   setNavBar: setNavBar,
                                //                 )));
                                //     popularVideosProvider.stopLoad(index);
                                //   },
                                //   video: popularVideosProvider.videoList[index],
                                // );
                              },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
