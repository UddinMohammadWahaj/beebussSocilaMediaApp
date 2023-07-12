import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Buzzerfeed/buzzerfeedmainpagemodel.dart';
import 'package:bizbultest/services/BuzzfeedControllers/BuzzerfeedApi.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzerfeedhashtagcontroller.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedcontroller.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Buzzfeed/buzfeedexpanded.dart';
import 'package:bizbultest/view/Buzzfeed/buzzerfeedreport.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeed_logo_icons.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedexpandedimage.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeednetworkvideoplayer.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedplayer.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedpoll.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedpostupload.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedprofile.dart';
import 'package:bizbultest/view/Buzzfeed/playground/buzzfeedvideoplay.dart';
import 'package:bizbultest/view/Buzzfeed/trendingtags.dart';
import 'package:bizbultest/view/discover_search_page.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';
import 'package:bizbultest/widgets/discover_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:polls/polls.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import 'buzzerfeedexpandedvideoplayer.dart';
import 'buzzfeedsearch.dart';

class BuzzfeedHashtagView extends StatefulWidget {
  String tag = '';
  BuzzfeedHashtagView({Key? key, this.tag = ''}) : super(key: key);

  @override
  _BuzzfeedHashtagViewState createState() => _BuzzfeedHashtagViewState();
}

class _BuzzfeedHashtagViewState extends State<BuzzfeedHashtagView> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var tweets = [
    Tweet(
      avatar:
          'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
      username: 'Flutter',
      name: 'FlutterDev',
      timeAgo: '5m',
      text:
          'Google’s UI @Sammy #fashion toolkit to build apps for mobile, web, & desktop from a single codebase.',
      comments: '243',
      retweets: '23K',
      favorites: '112K',
    ),
    Tweet(
      avatar:
          'https://pbs.twimg.com/profile_images/1033695141901623301/W-VnxCiG_400x400.jpg',
      username: 'Flutter en Español',
      name: 'EsFlutter',
      timeAgo: '12m',
      text: 'Comunidad Flutter de habla hispana!',
      comments: '46',
      retweets: '4K',
      favorites: '17K',
    ),
    Tweet(
      avatar:
          'https://pbs.twimg.com/profile_images/1168932726461935621/VRtfrDXq_400x400.png',
      username: 'Android Dev',
      name: 'AndroidDev',
      timeAgo: '20m',
      text: 'News and announcements for developers from the Android team.',
      comments: '305',
      retweets: '20K',
      favorites: '1M',
    ),
    Tweet(
      avatar:
          'https://pbs.twimg.com/profile_images/808350098178670592/bYyZI8Bp_400x400.jpg',
      username: 'Google Play',
      name: 'GooglePlay',
      timeAgo: '21m',
      text:
          'We’re exploring the world’s greatest stories through movies, TV, games, apps, books and so much more. Up for new adventures and discoveries? Let’s play.',
      comments: '1K',
      retweets: '70K',
      favorites: '2M',
    ),
    Tweet(
      avatar:
          'https://pbs.twimg.com/profile_images/1253792323051204608/QiaT93TQ_400x400.jpg',
      username: 'Google',
      name: 'Google',
      timeAgo: '26m',
      text: 'HeyGoogle',
      comments: '10K',
      retweets: '500K',
      favorites: '22M',
    ),
  ];

  @override
  void dispose() {
    Get.delete<BuzzerfeedHashtagController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var buzzfeedmaincontroller =
        Get.put(BuzzerfeedHashtagController(fromhashtag: widget.tag));
    Widget headertagCard() {
      return Obx(() => buzzfeedmaincontroller.headerTag.value != ''
          ? GestureDetector(
              onTap: () async {
                //     if (buzzerfeedMainController.hashtagIndex.value == index &&
                //         buzzerfeedMainController.hashtagSelected.value) {
                //       buzzerfeedMainController.hashtagSelected.value = false;
                //       print("tag=${buzzerfeedMainController.tags[index]}");
                //      buzzerfeedMainController.fetchData();
                //     } else {
                //       print("tag called=${buzzerfeedMainController.tags[index]}");
                //      buzzerfeedMainController.fetchData(tag: buzzerfeedMainController.tags[index]);
                //  buzzerfeedMainController.hashtagSelected.value = true;
                //    buzzerfeedMainController.hashtagIndex.value = index;
                //     }
                buzzfeedmaincontroller.headerTag.value = '';
                buzzfeedmaincontroller.fetchData();
              }

              //  =>
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             TagsFeedsView(tag: "${controller.tags[index]}")))

              ,
              child: Container(
                  // margin: EdgeInsets.only(
                  //     left: index == 0 ? 10 : 5,
                  //     right: index == controller.tags.length - 1 ? 10 : 0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: new BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Container(
                    child: Text(
                      "${buzzfeedmaincontroller.headerTag.value}",
                      style: TextStyle(
                          color: featuredColor, fontWeight: FontWeight.w500),
                    ),
                  )),
            )
          : Container());
    }

    Widget searchBar() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => BuzzerfeedSearchPage(
            //               controller: this.buzzfeedmaincontroller,
            //               memberImage: CurrentUser().currentUser.image,
            //               memberID: CurrentUser().currentUser.memberID,
            //               country: CurrentUser().currentUser.country,
            //               logo: CurrentUser().currentUser.logo,
            //             )));
          },
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  SizedBox(
                    width: 20,
                  ),
                  Obx(
                    () => buzzfeedmaincontroller.searchbarText.value != ''
                        ? Text(
                            buzzfeedmaincontroller.searchbarText.value,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            AppLocalizations.of('Search'),
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.4),
                                fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget listOfTweets() {
      return
          //   return Container(
          //     child: Column(
          //       children: [searchBar(), BuzzertrendingTags()],
          //     ),
          //   );
          // }

          ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container(
                // child: Column(
                //   children: [
                //     SizedBox(
                //       height: 1.5.h,
                //     ),
                //     headertagCard(),
                //     searchBar(),
                //     // Obx(()=>buzzfeedmaincontroller.)
                //     BuzzertrendingTags()
                //   ],
                // ),
                );
          }
          return Tweet(
            avatar: buzzfeedmaincontroller
                .listbuzzerfeeddata[index - 1].userPicture!,
            username: buzzfeedmaincontroller
                .listbuzzerfeeddata[index - 1].memberName!,
            name:
                buzzfeedmaincontroller.listbuzzerfeeddata[index - 1].shortcode!,
            timeAgo:
                buzzfeedmaincontroller.listbuzzerfeeddata[index - 1].timeStamp!,
            text: buzzfeedmaincontroller
                .listbuzzerfeeddata[index - 1].description!,
            comments: buzzfeedmaincontroller
                .listbuzzerfeeddata[index - 1].totalComments
                .toString(),
            retweets: buzzfeedmaincontroller
                .listbuzzerfeeddata[index - 1].totalReBuzzerfeed
                .toString(),
            favorites: buzzfeedmaincontroller
                .listbuzzerfeeddata[index - 1].totalLikes
                .toString(),
            userindex: index - 1,
            likeStatus: buzzfeedmaincontroller
                .listbuzzerfeeddata[index - 1].likeStatus!.value,
            buzzerfeedMainController: buzzfeedmaincontroller,
            posttype: buzzfeedmaincontroller.listbuzzerfeeddata[index - 1].type,
            // videoPlayer: BuzzfeedNetworkVideoPlayer(
            //   url: buzzfeedmaincontroller.listbuzzerfeeddata[index].video,
            // ),
          );

          // tweets[0];
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
        ),
        itemCount: buzzfeedmaincontroller.listbuzzerfeeddata.length + 1,
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.all(10.0),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        bottom:

            //  AppBar(
            //     centerTitle: true,
            //     backgroundColor: Colors.white,
            //     title: loadingAnimation(),
            //     elevation: 0,
            //   )
            // :
            AppBar(
          toolbarHeight: 0,
        ),
        title: Text(
          '${widget.tag}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == 0)
                  return Obx(
                    () => Container(
                      color: Colors.white,
                      height: buzzfeedmaincontroller.isUpload.value
                          ? kToolbarHeight
                          : 0,
                      width: 100.0.w,
                      child: Center(
                        child: loadingAnimation(),
                      ),
                    ),
                  );
                if (index == 1) {
                  return Container();
                  // return searchBar();
                }
                if (index == 2) {
                  return Container();
                  // return BuzzertrendingTags();
                }
                return Container(
                  height: 100.0.h - 15.0.h,
                  child: Obx(
                      () => buzzfeedmaincontroller.listbuzzerfeeddata.length ==
                              0
                          ? Center(
                              child: loadingAnimation(),
                            )
                          : SmartRefresher(
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
                                    body = Text("");
                                  }
                                  return Container(
                                    height: 55.0,
                                    child: Center(child: body),
                                  );
                                },
                              ),
                              controller: _refreshController,
                              onRefresh: () {
                                buzzfeedmaincontroller.getTags();
                                buzzfeedmaincontroller.fetchData(
                                    tag: widget.tag);
                                buzzfeedmaincontroller.searchbarText.value = '';
                                buzzfeedmaincontroller.headerTag.value = '';
                                buzzfeedmaincontroller.listbuzzerfeeddata
                                    .refresh();
                                buzzfeedmaincontroller
                                    .currentbuzzerfeedpag.value = 1;
                                _refreshController.refreshCompleted();
                              },
                              onLoading: () {
                                buzzfeedmaincontroller.currentbuzzerfeedpag++;
                                buzzfeedmaincontroller.currentbuzzerfeedpag
                                    .refresh();

                                buzzfeedmaincontroller.loadData(
                                    page: buzzfeedmaincontroller
                                        .currentbuzzerfeedpag,
                                    tag: widget.tag);
                                _refreshController.loadComplete();
                              },
                              child:
                                  //  ListView.separated(
                                  //   shrinkWrap: true,
                                  //   itemBuilder: (BuildContext context, int index) {
                                  //     return Tweet(
                                  //       avatar: buzzfeedmaincontroller
                                  //           .listbuzzerfeeddata[index].userPicture,
                                  //       username: buzzfeedmaincontroller
                                  //           .listbuzzerfeeddata[index].memberName,
                                  //       name: buzzfeedmaincontroller
                                  //           .listbuzzerfeeddata[index].shortcode,
                                  //       timeAgo: buzzfeedmaincontroller
                                  //           .listbuzzerfeeddata[index].timeStamp,
                                  //       text: buzzfeedmaincontroller
                                  //           .listbuzzerfeeddata[index].description,
                                  //       comments: '243',
                                  //       retweets: '23K',
                                  //       favorites: '112K',
                                  //       userindex: index,
                                  //       buzzerfeedMainController: buzzfeedmaincontroller,
                                  //     );

                                  //     // tweets[0];
                                  //   },
                                  //   separatorBuilder: (BuildContext context, int index) =>
                                  //       Divider(
                                  //     height: 0,
                                  //   ),
                                  //   itemCount:
                                  //       buzzfeedmaincontroller.listbuzzerfeeddata.length,
                                  // ),
                                  listOfTweets(),
                            )

                      // Container(color: Colors.pink,
                      // height: Get.height,
                      // width: Get.width,)

                      ),
                );
              }, childCount: 4),
            )
          ],
        ),
      ),

      //------------------
      //  Container(
      //     child: CustomScrollView(
      //         physics: AlwaysScrollableScrollPhysics(),
      //         slivers: [
      //       SliverList(delegate: SliverChildBuilderDelegate((context, index) {
      //         return Obx(
      //             () => buzzfeedmaincontroller.listbuzzerfeeddata.length == 0
      //                 ? Center(
      //                     child: CircularProgressIndicator(),
      //                   )
      //                 :

      // Container(
      //                     height: 100.0.h - 55,
      //                     color: Colors.pink,
      //                     child: SmartRefresher(
      //                       controller: _refreshController,
      //                       enablePullDown: true,
      //                       enablePullUp: true,
      //                       header: CustomHeader(
      //                         builder: (context, mode) {
      //                           return Container(
      //                             child: Center(child: loadingAnimation()),
      //                           );
      //                         },
      //                       ),
      //                       footer: CustomFooter(
      //                         builder: (BuildContext context, LoadStatus mode) {
      //                           Widget body;

      //                           if (mode == LoadStatus.idle) {
      //                             body = Text("");
      //                           } else if (mode == LoadStatus.loading) {
      //                             print("loading tweet");
      //                             body = loadingAnimation();
      //                           } else if (mode == LoadStatus.failed) {
      //                             body = Container(
      //                                 decoration: new BoxDecoration(
      //                                   shape: BoxShape.circle,
      //                                   border: new Border.all(
      //                                       color: Colors.black, width: 0.7),
      //                                 ),
      //                                 child: Padding(
      //                                   padding: EdgeInsets.all(12.0),
      //                                   child: Icon(CustomIcons.reload),
      //                                 ));
      //                           } else if (mode == LoadStatus.canLoading) {
      //                             body = Text("");
      //                           } else {
      //                             body = Text("");
      //                           }
      //                           return Container(
      //                             height: 55.0,
      //                             child: Center(child: body),
      //                           );
      //                         },
      //                       ),
      //                       child: listOfTweets(),
      //                     ),
      //                   ));
      //       }))
      //     ])),

//-----------------------

      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       buildBottomIconButton(Icons.home, Colors.blue),
      //       buildBottomIconButton(Icons.search, Colors.black45),
      //       buildBottomIconButton(Icons.notifications, Colors.black45),
      //       buildBottomIconButton(Icons.mail_outline, Colors.black45),
      //     ],
      //   ),
      // ),
    );
  }

  Widget buildBottomIconButton(IconData icon, Color color) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
      ),
      onPressed: () {},
    );
  }
}

class Tweet extends StatelessWidget {
  final String avatar;
  final String username;
  final String name;
  final String timeAgo;
  final String text;
  final String comments;
  final String retweets;
  final String favorites;
  bool? likeStatus;
  BuzzerfeedHashtagController? buzzerfeedMainController;
  int? userindex;
  String? posttype;
  BuzzfeedNetworkVideoPlayer? videoPlayer;
  FlickManager? flickManager;

  Tweet(
      {Key? key,
      required this.avatar,
      required this.username,
      required this.name,
      required this.timeAgo,
      required this.text,
      required this.comments,
      required this.retweets,
      required this.favorites,
      this.posttype,
      this.likeStatus,
      this.flickManager,
      this.buzzerfeedMainController,
      this.videoPlayer,
      this.userindex})
      : super(key: key);

  get featuredColor => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InkWell(
        // onTap: () {
        //   Navigator.of(Get.context).push(MaterialPageRoute(
        //       builder: (context) => BuzzerfeedExpanded(
        //           description: text,
        //           avatar: this.avatar,
        //           comments: this.comments,
        //           favorites: this.favorites,
        //           buzzerfeedMainController: this.,
        //           likeStatus: this.likeStatus,
        //           name: this.name,
        //           posttype: this.posttype,
        //           retweets: this.retweets,
        //           timeAgo: this.timeAgo,
        //           userindex: this.userindex,
        //           username: this.username)));
        // },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tweetAvatar(),
            tweetBody(),
          ],
        ),
      ),
    );
  }

  Widget tweetAvatar() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        backgroundColor: Colors.black,
        backgroundImage: NetworkImage(buzzerfeedMainController!
            .listbuzzerfeeddata![this.userindex!].userPicture!),
      ),
    );
  }

  Widget linkCard() {
    return (buzzerfeedMainController!
                .listbuzzerfeeddata[this.userindex!].linkDomain!.length ==
            0)
        ? Container(
            height: 0.0,
            width: 0.0,
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // color: Colors.amber,
                child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => Container(
                          height: 0.1.h,
                        ),
                    shrinkWrap: true,
                    itemCount: buzzerfeedMainController!
                        .listbuzzerfeeddata[this.userindex!].linkDesc!.length,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            launch(
                                '${buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].linkLink![index]}');
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0.h)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(2.0.h))),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2.0.h)),
                                  child: Container(
                                      width: 80.0.w,
                                      child: Column(
                                        children: [
                                          buzzerfeedMainController!
                                                      .listbuzzerfeeddata[
                                                          this.userindex!]
                                                      .linkImages![0] ==
                                                  ""
                                              ? Card(
                                                  elevation: 1.0,
                                                  child: Container(
                                                    width: 80.0.w,
                                                    height: 20.0.h,
                                                    child: Image.asset(
                                                      'assets/images/buzzfeed.png',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl:
                                                      buzzerfeedMainController!
                                                          .listbuzzerfeeddata[
                                                              this.userindex!]
                                                          .linkImages![index],
                                                  fit: BoxFit.contain,
                                                ),
                                          Container(
                                              // color: Colors.pink,
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.all(10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].linkDomain![index]}',
                                                    // softWrap: true,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: settingsColor,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  Text(
                                                    '${buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].linkHeader![index]}',
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ],
                                              )),
                                          // Container(
                                          //   alignment: Alignment.center,
                                          //   margin:
                                          //       EdgeInsets.only(left: 1.5.w),
                                          //   child: Text(
                                          //     '${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkDesc[index]}',
                                          //     maxLines: 3,
                                          //     softWrap: true,
                                          //     style: TextStyle(
                                          //         fontWeight: FontWeight.w400),
                                          //   ),
                                          // ),
                                        ],
                                      )),
                                ),
                                // leading: CachedNetworkImage(
                                //   imageUrl: buzzerfeedMainController
                                //       .listbuzzerfeeddata[this.userindex]
                                //       .linkImages[index],
                                //   fit: BoxFit.contain,
                                // ),
                              ),
                            ),
                          ),
                        )),
              ),
            ),
          );
  }

  Widget tweetBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tweetHeader(),
          (!this.text.isEmpty)
              ? tweetText()
              : Container(
                  width: 0,
                  height: 0,
                ),
          (!this.text.isEmpty)
              ? SizedBox(
                  height: 2.0.h,
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          buzzBody(),
          (this
                          .buzzerfeedMainController!
                          .listbuzzerfeeddata[this.userindex!]
                          .quotes !=
                      null &&
                  this
                          .buzzerfeedMainController!
                          .listbuzzerfeeddata[this.userindex!]
                          .quotes!
                          .length !=
                      0)
              ? ReTweet(
                  avatar: this!
                      .buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .quotes![0]
                      .userPicture!,
                  username: this
                      .buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .quotes![0]
                      .memberName!,
                  name: this
                      .buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .quotes![0]
                      .shortcode!,
                  timeAgo: this
                      .buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .quotes![0]
                      .timeStamp!,
                  text: this
                      .buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .quotes![0]
                      .description!,
                  comments: "",
                  retweets: "",
                  quotes: this
                      .buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .quotes!,
                  userindex: this.userindex!,
                  posttype: this
                              .buzzerfeedMainController!
                              .listbuzzerfeeddata[this.userindex!]
                              .quotes![0]
                              .pollStatus !=
                          ""
                      ? this.posttype!
                      : "",
                  favorites: "")
              : Container(),
          linkCard(),
          tweetButtons(),
        ],
      ),
    );
  }

  Widget tweetHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5.0, bottom: 5, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    this.username,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 0.8.w,
                  ),
                  this
                              .buzzerfeedMainController!
                              .listbuzzerfeeddata[this.userindex!]
                              .varified !=
                          ""
                      ? Container(
                          child: Icon(
                          Icons.verified_rounded,
                          size: 1.5.h,
                          color: Colors.blue[800],
                        ))
                      : Container(
                          height: 0,
                          width: 0,
                        )
                ],
              ),
              Text(
                '@${name} · $timeAgo',
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            FontAwesomeIcons.angleDown,
            size: 14.0,
            color: Colors.grey,
          ),
          onPressed: () {
            if (this
                    .buzzerfeedMainController!
                    .listbuzzerfeeddata[this.userindex!]
                    .memberId ==
                CurrentUser().currentUser.memberID)
              showBarModalBottomSheet(
                  context: Get.context!,
                  builder: (context) => ClipRRect(
                      child: Container(
                        width: 100.w,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 3.0.h,
                            ),
                            ListTile(
                              onTap: () {
                                this.buzzerfeedMainController!.removePost(
                                    this
                                        .buzzerfeedMainController!
                                        .listbuzzerfeeddata[this.userindex!]
                                        .buzzerfeedId,
                                    this.userindex);
                                Navigator.of(context).pop();
                              },
                              leading: Icon(
                                FontAwesomeIcons.dumpster,
                                color: Colors.grey,
                                size: 2.0.h,
                              ),
                              title: Text(
                                'Delete Buzz',
                                style: TextStyle(fontSize: 2.0.h),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                var file = [];

                                if (this.posttype == "images") {
                                  file = this
                                      .buzzerfeedMainController!
                                      .listbuzzerfeeddata[this.userindex!]
                                      .images!;
                                } else if (this.posttype == "gif") {
                                  file = this
                                      .buzzerfeedMainController!
                                      .listbuzzerfeeddata[this.userindex!]
                                      .images!;
                                } else if (this.posttype == "videos") {
                                  file = [
                                    this
                                        .buzzerfeedMainController!
                                        .listbuzzerfeeddata[this.userindex!]
                                        .video
                                  ];
                                } else {}

                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => BuzzfeedUploadPost(
                                          purpose: 'post_edit',
                                          edittype: this.posttype!,
                                          editfiles: file,
                                        )));
                              },
                              leading: Icon(
                                FontAwesomeIcons.pen,
                                color: Colors.grey,
                                size: 2.0.h,
                              ),
                              title: Text('Edit Buzz',
                                  style: TextStyle(fontSize: 2.0.h)),
                            ),
                          ],
                        ),
                        height: 20.0.h,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))));
            else {
              details();
            }
          },
        ),
      ],
    );
  }

  Widget tweetText() {
    var newText = text.replaceAll("\$", "~~");
    return FormattedText(
      newText,
      overflow: TextOverflow.clip,
    );
  }

//POLL-START
  Widget pollcontainer(String title, String vote,
      {status: false, selectedPoll: false}) {
    return Container(
      padding: EdgeInsets.all(1.0.h),
      decoration: BoxDecoration(
        color: buzzerfeedMainController!
                .listbuzzerfeeddata[this.userindex!].isvoting!.value
            ? Color.fromARGB(255, 138, 162, 173)
            : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(3.0.w)),
        border: Border.all(
          width: 2,
          color: Color.fromARGB(255, 138, 162, 173),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Obx(
                () => Text(title,
                    style: TextStyle(
                        color: buzzerfeedMainController!
                                .listbuzzerfeeddata[this.userindex!]
                                .isvoting!
                                .value
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              (status == true)
                  ? Icon(
                      Icons.verified_rounded,
                      size: 2.0.h,
                      color: Colors.white,
                    )
                  : Container()
            ],
          ),
          Obx(
            () => Text(
              buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!].isvoting!.value
                  ? vote
                  : ' ',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget testpollBody() {
    var totalpoll = buzzerfeedMainController!
        .listbuzzerfeeddata[this.userindex!].testpoll!.length;

    return Center(
      child: Container(
          child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 1.0.h),
        itemBuilder: (context, index) {
          var selectedPoll = false;

          for (var element in buzzerfeedMainController!
              .listbuzzerfeeddata[this.userindex!].pollAnswer!) {
            print("checking true.");
            if (element.status == true) {
              selectedPoll = true;
              break;
            }
          }
          return Obx(
            () => InkWell(
                onTap: () async {
                  buzzerfeedMainController!.pollvote(
                      buzzerfeedMainController!
                          .listbuzzerfeeddata![this.userindex!]
                          .pollAnswer![index]
                          .answerId,
                      this.userindex);
                  // buzzerfeedMainController.listbuzzerfeeddata.refresh();
                },
                child: pollcontainer(
                  '${buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].pollAnswer![index].answer}',
                  buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!]
                      .testpoll!.value[index].totalVotes,
                  status: buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .testpoll![index]
                      .status,
                )),
          );
        },
        shrinkWrap: true,
        itemCount: totalpoll,
      )),
    );
  }

  Widget pollBody() {
    var polldata = this
        .buzzerfeedMainController!
        .listbuzzerfeeddata[this.userindex!]
        .pollAnswer;

    var polllist = [];
    polldata!.forEach((element) {
      polllist.add(Polls.options(
        title: element.answer!,
        value: 0,
      ));
    });

    print("polllist =${polllist}");
    return PollView(
      polllist: polllist,
    );
  }

//POLL-END
  Widget videoCard() {
    print(
        "current video=${buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].video}");
    return ClipRRect(
        borderRadius: BorderRadius.circular(2.0.w),
        child:
            //  DiscoverVideoPlayer(
            //   url:
            //       buzzerfeedMainController.listbuzzerfeeddata[this.userindex].video,
            // )-

            InkWell(
          onTap: () {
            print("clicked on video");
            Navigator.of(Get.context!).push(MaterialWithModalsPageRoute(
                builder: (context) => BuzzfeedNetworkVideoPlayerExpanded(
                      url: this
                          .buzzerfeedMainController!
                          .listbuzzerfeeddata![this.userindex!]
                          .video!,
                    )));
          },
          child: BuzzerFeedPlay(
            image: buzzerfeedMainController!
                .listbuzzerfeeddata[this.userindex!].thumb!,
            url: buzzerfeedMainController!
                .listbuzzerfeeddata[this.userindex!].video!,
            // flickManager:

            //  FlickManager(
            //     videoPlayerController: VideoPlayerController.network(
            //         buzzerfeedMainController
            //             .listbuzzerfeeddata[this.userindex].video)

            //             ),
          ),
        )
        //     BuzzfeedNetworkVideoPlayer(
        //   url:
        //       buzzerfeedMainController.listbuzzerfeeddata[this.userindex].video,
        // )

        );
  }

//Imgae
  Widget imageCard(imageindex) {
    return InkWell(
      onTap: () {
        Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (context) => BuzzfeedExpandedImage(
            listofimages: this
                .buzzerfeedMainController!
                .listbuzzerfeeddata[this.userindex!]
                .images!,
            index: imageindex,
          ),
        ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.0.w),
        child: Container(
          height: this
                      .buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .images!
                      .length ==
                  1
              ? 50.0.h
              : 25.0.h,
          width: this
                      .buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .images!
                      .length ==
                  1
              ? 82.0.w
              : 35.0.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.0.w),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              placeholder: (context, url) => SkeletonAnimation(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0.w),
                  child: Container(
                    width: this
                                .buzzerfeedMainController!
                                .listbuzzerfeeddata[this.userindex!]
                                .images!
                                .length ==
                            1
                        ? 75.0.w
                        : 35.0.w,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              imageUrl: this
                  .buzzerfeedMainController!
                  .listbuzzerfeeddata[this.userindex!]
                  .images![imageindex],
            ),
          ),
        ),
      ),
    );
  }

  Widget gifCard() {
    return InkWell(
      onTap: () {
        Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (context) => BuzzfeedExpandedImage(
            listofimages: this
                .buzzerfeedMainController!
                .listbuzzerfeeddata[this.userindex!]
                .images!,
            index: 0,
          ),
        ));
      },
      child: Container(
        width: 83.0.w,
        height: this
                    .buzzerfeedMainController!
                    .listbuzzerfeeddata[this.userindex!]
                    .images!
                    .length ==
                1
            ? 45.0.h
            : 25.0.h,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              placeholder: (context, url) => SkeletonAnimation(
                child: Container(
                  width: 75.0.w,
                  height: 25.0.h,
                  color: Colors.grey[300],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              imageUrl: this
                  .buzzerfeedMainController!
                  .listbuzzerfeeddata[this.userindex!]
                  .images![0],
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Widget listofimagecard() {
    // return Container();
    return Container(
        width: 85.0.w,
        height: this
                    .buzzerfeedMainController!
                    .listbuzzerfeeddata[this.userindex!]
                    .images!
                    .length ==
                1
            ? 55.0.h
            : 25.0.h,
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            width: 1.0.w,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: this
              .buzzerfeedMainController!
              .listbuzzerfeeddata[this.userindex!]
              .images!
              .length,
          itemBuilder: (context, index) => imageCard(index),
        ));
  }

//Image end
  Widget buzzBody() {
    print("buzzbody ${this.posttype}");
    return Container(
      child: this.posttype == "text"
          ? Container()
          : this.posttype == "images"
              ? listofimagecard()
              : this.posttype == "poll"
                  ? testpollBody()
                  : this.posttype == "videos"
                      ? Container()
                      // videoCard()
                      : gifCard(),
    );
  }

  Widget customListTile(
      title, context, VoidCallback callback, IconData iconData) {
    return Expanded(
      child: ListTile(
        onTap: callback,
        leading: Icon(
          iconData,
          color: Colors.grey,
          size: 2.0.h,
        ),
        title: Text(
          '$title',
          style: TextStyle(fontSize: 2.0.h),
        ),
      ),
    );
  }

  void details() {
    showBarModalBottomSheet(
        context: Get.context!,
        builder: (context) => ClipRRect(
            child: Container(
              width: 100.w,
              child: Column(
                children: [
                  SizedBox(
                    height: 3.0.h,
                  ),
                  customListTile('Block', context, () {}, Icons.block),
                  customListTile('Report', context, () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BuzzerFeedReport(),
                    ));
                  }, Icons.block),
                ],
              ),
              height: 20.0.h,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))));
  }

  void retweetOptions() {
    showBarModalBottomSheet(
        context: Get.context!,
        builder: (context) => ClipRRect(
            child: Container(
              width: 100.w,
              child: Column(
                children: [
                  SizedBox(
                    height: 3.0.h,
                  ),
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      leading: Icon(
                        FontAwesomeIcons.retweet,
                        color: Colors.grey,
                        size: 3.0.h,
                      ),
                      title: Text(
                        'Rebuzz',
                        style: TextStyle(fontSize: 3.0.h),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      leading: Icon(
                        FontAwesomeIcons.penAlt,
                        color: Colors.grey,
                        size: 3.0.h,
                      ),
                      title: Text('Quote Rebuzz',
                          style: TextStyle(fontSize: 3.0.h)),
                    ),
                  )
                ],
              ),
              height: 20.0.h,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))));
  }

  Widget tweetButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tweetIconButton(FontAwesomeIcons.comment, this.comments, () async {
            // Navigator.of(Get.context).push(MaterialPageRoute(
            //   builder: (context) => BuzzfeedUploadPost(
            //     purpose: "comment_upload",
            //     buzzfeedmaincontroller: this.buzzerfeedMainController,
            //     buzzerfeedId: this
            //         .buzzerfeedMainController
            //         .listbuzzerfeeddata[this.userindex]
            //         .buzzerfeedId,
            //   ),
            // ));
          }),
          tweetIconButton(FontAwesomeIcons.retweet, this.retweets, () {
            retweetOptions();
          }),
          Obx(
            () => tweetIconButton(
                !this
                        .buzzerfeedMainController!
                        .listbuzzerfeeddata[this.userindex!]
                        .likeStatus!
                        .value
                    ? FontAwesomeIcons.heart
                    : FontAwesomeIcons.solidHeart,
                '${this.buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].totalLikes}',
                () {
              print(
                  "likeunlike=${this.buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].likeStatus}");
              buzzerfeedMainController!.likeUnlike(this.userindex);
            },
                color: this
                        .buzzerfeedMainController!
                        .listbuzzerfeeddata[this.userindex!]
                        .likeStatus!
                        .value
                    ? Colors.red
                    : Colors.black45),
          ),
          tweetIconButton(FontAwesomeIcons.share, '', () {
            Share.share(
              'Sharing Buzz ',
            );
          }),
        ],
      ),
    );
  }

  Widget tweetIconButton(IconData icon, String text, VoidCallback callback,
      {Color color: Colors.black45}) {
    return Row(
      children: [
        InkWell(
          onTap: callback,
          child: Icon(
            icon,
            size: 20.0,
            color: color,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(6.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class FormattedText extends GetView<BuzzerfeedMainController> {
  final String? text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? overflow;
  final int? maxLines;

  FormattedText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var parse = <MatchText>[
      MatchText(
        pattern: "(@+[a-zA-Z0-9(_)]{1,})",
        renderWidget: ({dynamic pattern, dynamic text}) => Text(
          text,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'HelveticaNeue',
            fontSize: 2.0.h,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: (String username) {
          print('Text=${username.substring(1)}');
        },
      ),
      MatchText(
        pattern: "(#+[a-zA-Z0-9(_)]{1,})",
        renderWidget: ({dynamic pattern, dynamic text}) => Text(
          text,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'HelveticaNeue',
            fontSize: 2.0.h,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: (String tag) {
          // print('hashtag=${username.substring(1)}');

          controller.fetchData(tag: tag);
          // controller.searchbarText.value = tag;
          controller.headerTag.value = tag;
        },
      ),
      MatchText(
        pattern: "(~~+[a-zA-Z0-9(_)]{1,})",
        renderWidget: ({dynamic pattern, dynamic text}) => Text(
          // text,var newText =
          text.replaceAll("~~", "\$"),
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'HelveticaNeue',
            fontSize: 2.0.h,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: (String tag) {
          // print('hashtag=${username.substring(1)}');
          var newText = tag.replaceAll("~~", "\$");
          controller.fetchData(tag: newText);
          // controller.searchbarText.value = tag;
          controller.headerTag.value = newText;
        },
      ),
      MatchText(
        type: ParsedType.URL,
        pattern: '://',
        renderWidget: ({dynamic pattern, dynamic text}) => Text(
          "",
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'HelveticaNeue',
            fontSize: 2.0.h,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: (String username) {
          launch(username);
        },
      ),
      // MatchText(
      //   pattern: r"://([a-z][a-z0-9_]{4,31})",
      //   renderWidget: ({pattern, text}) => Text(
      //     text,
      //     textDirection: TextDirection.ltr,
      //     style: TextStyle(
      //       color: Colors.blue,
      //       fontFamily: 'HelveticaNeue',
      //       fontSize: 2.0.h,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   onTap: (String username) {
      //     print('Text=${username.substring(1)}');
      //   },
      // ),
    ];

    return ParsedText(
      text: text!,
      onTap: () {
        print("tapped text");
      },
      style: TextStyle(
              // fontFamily: 'HelveticaNeue',
              fontSize: 2.0.h,
              fontWeight: FontWeight.w400,
              color: Colors.black) ??
          TextStyle(
              // fontFamily: 'HelveticaNeue',
              fontSize: 2.0.h,
              fontWeight: FontWeight.w400,
              color: Colors.black),
      alignment: TextAlign.start,
      textDirection: textDirection ?? Directionality.of(context),
      overflow: TextOverflow.clip,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      parse: parse,
      regexOptions: RegexOptions(caseSensitive: false),
    );
  }
}
