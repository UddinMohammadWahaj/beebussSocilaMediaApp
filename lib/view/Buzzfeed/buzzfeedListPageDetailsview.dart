import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Buzzerfeed/BuzzerfeedMyListModel.dart';
import 'package:bizbultest/models/Buzzerfeed/buzzerfeedmainpagemodel.dart';
import 'package:bizbultest/services/BuzzfeedControllers/BuzzerfeedApi.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedcontroller.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Buzzfeed/buzfeedexpanded.dart';
import 'package:bizbultest/view/Buzzfeed/buzzerfeedhashtagpage.dart';
import 'package:bizbultest/view/Buzzfeed/buzzerfeedreport.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedListview.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeed_logo_icons.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedexpandedimage.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeednetworkvideoplayer.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedplayer.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedpoll.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedpostupload.dart';
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

import 'buzzerfeedexpandedbylist.dart';
import 'buzzerfeedexpandedvideoplayer.dart';
import 'buzzfeedsearch.dart';

class BuzzfeedListDetailView extends StatefulWidget {
  BuzzerfeedMainController? buzzfeedmaincontroller;
  DataBuzzList? mylistdata;
  Function? edit;
  BuzzfeedListDetailView(
      {Key? key, this.buzzfeedmaincontroller, this.mylistdata, this.edit})
      : super(key: key);

  @override
  _BuzzfeedListDetailViewState createState() => _BuzzfeedListDetailViewState();
}

class _BuzzfeedListDetailViewState extends State<BuzzfeedListDetailView> {
  late BuzzerfeedMainController buzzfeedmaincontroller;
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
    // Get.delete<BuzzerfeedController>();
    widget.buzzfeedmaincontroller!.mylistdetaildata.value = <BuzzerfeedDatum>[];
    widget.buzzfeedmaincontroller!.islistempty.value = false;
    super.dispose();
  }

  @override
  void initState() {
    buzzfeedmaincontroller = widget.buzzfeedmaincontroller!;
    buzzfeedmaincontroller.fetchMyListDetail(widget.mylistdata!.listId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget headertagCard() {
      return Obx(() => this.buzzfeedmaincontroller.headerTag.value != ''
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
                this.buzzfeedmaincontroller.headerTag.value = '';
                this.buzzfeedmaincontroller.fetchData();
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
                  child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "${this.buzzfeedmaincontroller.headerTag.value}",
                            style: TextStyle(
                                color: featuredColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Icon(Icons.close)
                      ])),
            )
          : Container());
    }

    Widget searchBar() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BuzzerfeedSearchPage(
                          controller: this.buzzfeedmaincontroller,
                          memberImage: CurrentUser().currentUser.image!,
                          memberID: CurrentUser().currentUser.memberID!,
                          country: CurrentUser().currentUser.country!,
                          logo: CurrentUser().currentUser.logo!,
                        )));
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
              margin: EdgeInsets.only(top: 5),
              width: 100.0.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.mylistdata!.images!,
                    height: 30.h,
                    width: 90.w,
                    fit: BoxFit.fill,
                  ),
                  Text('${widget.mylistdata!.name}',
                      style: TextStyle(
                          fontSize: 2.0.h, fontWeight: FontWeight.bold)),
                  Text('${widget.mylistdata!.description}',
                      style: TextStyle(
                        fontSize: 2.0.h,
                        fontWeight: FontWeight.w500,
                      )),
                  Text('@${widget.mylistdata!.shortcode}',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 1.5.h,
                          fontWeight: FontWeight.w500)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${widget.mylistdata!.totalMember} ' +
                            AppLocalizations.of('Members')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${widget.mylistdata!.totalFollow} ' +
                            AppLocalizations.of('Followers')),
                      ),
                    ],
                  ),
                  CurrentUser().currentUser.memberID !=
                          widget.mylistdata!.memberId
                      ? InkWell(
                          onTap: () async {
                            widget.mylistdata!.isFollowing!.value =
                                !widget.mylistdata!.isFollowing!.value;
                            print(
                                "response of url=https://www.bebuzee.com/api/buzzerfeed/listFollowUnfollow?list_id=${widget.mylistdata!.listId}&user_id=${CurrentUser().currentUser.memberID}");
                            var response = await ApiProvider().fireApi(
                                'https://www.bebuzee.com/api/buzzerfeed/listFollowUnfollow?list_id=${widget.mylistdata!.listId}&user_id=${CurrentUser().currentUser.memberID}');
                            print("response of follow list=${response.data}");
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                                color: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Obx(
                                    () => Text(
                                      '${widget.mylistdata!.isFollowing!.value ? AppLocalizations.of("Following") : AppLocalizations.of('Follow')}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            widget.mylistdata!.isFollowing!.value =
                                !widget.mylistdata!.isFollowing!.value!;
                            print(
                                "response of url=https://www.bebuzee.com/api/buzzerfeed/listFollowUnfollow?list_id=${widget.mylistdata!.listId}&user_id=${CurrentUser().currentUser.memberID}");
                            var response = await ApiProvider().fireApi(
                                'https://www.bebuzee.com/api/buzzerfeed/listFollowUnfollow?list_id=${widget.mylistdata!.listId}&user_id=${CurrentUser().currentUser.memberID}');
                            print("response of follow list=${response.data}");
                            widget.edit!(
                              purpose: 'edit',
                              listname: widget.mylistdata!.name,
                              listdescription: widget.mylistdata!.description,
                              image: widget.mylistdata!.images,
                              listid: widget.mylistdata!.listId,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                                color: Colors.black,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(AppLocalizations.of('Edit'),
                                        style:
                                            TextStyle(color: Colors.white)))),
                          ),
                        )
                ],
              ),
            );
          }
          print(
              "index=${index} length=${buzzfeedmaincontroller.mylistdetaildata.length}");
          return Tweet(
            avatar:
                buzzfeedmaincontroller.mylistdetaildata[index - 1].userPicture!,
            username:
                buzzfeedmaincontroller.mylistdetaildata[index - 1].memberName!,
            name: buzzfeedmaincontroller.mylistdetaildata[index - 1].shortcode!,
            timeAgo:
                buzzfeedmaincontroller.mylistdetaildata[index - 1].timeStamp!,
            text:
                buzzfeedmaincontroller.mylistdetaildata[index - 1].description!,
            comments: buzzfeedmaincontroller
                .mylistdetaildata[index - 1].totalComments
                .toString(),
            retweets: buzzfeedmaincontroller
                .mylistdetaildata[index - 1].totalReBuzzerfeed!.value
                .toString(),
            favorites: buzzfeedmaincontroller
                .mylistdetaildata[index - 1].totalLikes
                .toString(),
            userindex: index - 1,
            likeStatus: buzzfeedmaincontroller
                .mylistdetaildata[index - 1].likeStatus!.value,
            buzzerfeedMainController: buzzfeedmaincontroller,
            posttype: buzzfeedmaincontroller.mylistdetaildata[index - 1].type!,
            // videoPlayer: BuzzfeedNetworkVideoPlayer(
            //   url: buzzfeedmaincontroller.mylistdetaildata[index].video,
            // ),
          );

          // tweets[0];
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
        ),
        itemCount: buzzfeedmaincontroller.mylistdetaildata.length + 1,
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            }),
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
          AppLocalizations.of('My List'),
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
                      () => buzzfeedmaincontroller.mylistdetaildata.length == 0
                          ? Obx(
                              () => Center(
                                child: !buzzfeedmaincontroller.islistempty.value
                                    ? loadingAnimation()
                                    : Text(AppLocalizations.of(
                                        'Your List is empty')),
                              ),
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
                                buzzfeedmaincontroller.fetchData();
                                buzzfeedmaincontroller.searchbarText.value = '';
                                buzzfeedmaincontroller.headerTag.value = '';
                                buzzfeedmaincontroller.mylistdetaildata
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
                                        .currentbuzzerfeedpag);
                                _refreshController.loadComplete();
                              },
                              child:

                                  //  ListView.separated(
                                  //   shrinkWrap: true,
                                  //   itemBuilder: (BuildContext context, int index) {
                                  //     return Tweet(
                                  //       avatar: buzzfeedmaincontroller
                                  //           .mylistdetaildata[index].userPicture,
                                  //       username: buzzfeedmaincontroller
                                  //           .mylistdetaildata[index].memberName,
                                  //       name: buzzfeedmaincontroller
                                  //           .mylistdetaildata[index].shortcode,
                                  //       timeAgo: buzzfeedmaincontroller
                                  //           .mylistdetaildata[index].timeStamp,
                                  //       text: buzzfeedmaincontroller
                                  //           .mylistdetaildata[index].description,
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
                                  //       buzzfeedmaincontroller.mylistdetaildata.length,
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
      //             () => buzzfeedmaincontroller.mylistdetaildata.length == 0
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
  BuzzerfeedMainController? buzzerfeedMainController;
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
        onTap: () {
          // Navigator.of(Get.context).push(MaterialPageRoute(
          //     builder: (context) => BuzzerfeedExpanded(
          //         description: text,
          //         avatar: this.avatar,
          //         comments: this.comments,
          //         favorites: this.favorites,
          //         buzzerfeedMainController: this.buzzerfeedMainController,
          //         likeStatus: this.likeStatus,
          //         name: this.name,
          //         posttype: this.posttype,
          //         retweets: this.retweets,
          //         timeAgo: this.timeAgo,
          //         userindex: this.userindex,
          //         username: this.username)));
        },
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
            .mylistdetaildata![this.userindex!].userPicture!),
      ),
    );
  }

  Widget linkCard() {
    return (buzzerfeedMainController!
                .mylistdetaildata[this.userindex!]!.linkDomain!.length ==
            0)
        ? Container(
            height: 0.0,
            width: 0.0,
          )
        :
        // Center(
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        // color: Colors.amber,
        // child:
        ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Container(
              height: 0.1.h,
            ),
            shrinkWrap: true,
            itemCount: buzzerfeedMainController!
                .mylistdetaildata[this.userindex!].linkDesc!.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                launch(
                    '${buzzerfeedMainController!.mylistdetaildata[this.userindex!]!.linkLink![index]}');
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(2.0.h)),
                // child: Padding(
                //   padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0.h))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(2.0.h)),
                    child: Container(
                        width: 80.0.w,
                        child: Column(
                          children: [
                            buzzerfeedMainController!
                                        .mylistdetaildata[this.userindex!]
                                        .linkImages![index] ==
                                    ""
                                ? Card(
                                    elevation: 1.0,
                                    child: Container(
                                      width: 80.0.w,
                                      height: 20.0.h,
                                      child: Image.asset(
                                        'assets/images/buzzfeed.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: buzzerfeedMainController!
                                        .mylistdetaildata[this.userindex!]
                                        .linkImages![index],
                                    fit: BoxFit.fill,
                                  ),
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // '${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkLink[index]}',
                                      '${buzzerfeedMainController!.mylistdetaildata[this.userindex!].linkDomain![index]}',

                                      softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: settingsColor,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Text(
                                      // '${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkLink[index]}',
                                      '${buzzerfeedMainController!.mylistdetaildata[this.userindex!].linkHeader![index]}',

                                      softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                )),
                            // Container(
                            //   alignment: Alignment.center,
                            //   margin:
                            //       EdgeInsets.only(left: 1.5.w),
                            //   child: Text(
                            //     '${buzzerfeedMainController.mylistdetaildata[this.userindex].linkDesc[index]}',
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
                  //       .mylistdetaildata[this.userindex]
                  //       .linkImages[index],
                  //   fit: BoxFit.contain,
                  // ),
                ),
              ),
            ),
            // )),
            // ),
            // ),
          );
  }

  Widget rebuzzTextCard() {
    return this
                .buzzerfeedMainController!
                .mylistdetaildata[this.userindex!]
                .reBuzzerfeedMessage !=
            ''
        ? Container(
            child: Row(
              children: [
                Icon(FontAwesomeIcons.retweet, size: 2.5.h, color: Colors.grey),
                SizedBox(
                  width: 2.0.w,
                ),
                Text(
                    this
                        .buzzerfeedMainController!
                        .mylistdetaildata[this.userindex!]
                        .reBuzzerfeedMessage!,
                    style: TextStyle(color: Colors.grey))
              ],
            ),
          )
        : SizedBox(
            height: 0,
          );
  }

  Widget tweetBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rebuzzTextCard(),
          tweetHeader(),

          InkWell(
            onTap: () {
              print("----tapa tap");
              Navigator.of(Get.context!).push(MaterialPageRoute(
                  builder: (context) => BuzzerfeedExpandedByList(
                      description: text,
                      avatar: this.avatar,
                      comments: this.comments,
                      favorites: this.favorites,
                      buzzerfeedMainController: this.buzzerfeedMainController!,
                      likeStatus: this.likeStatus!,
                      name: this.name,
                      posttype: this.posttype!,
                      retweets: this.retweets,
                      timeAgo: this.timeAgo,
                      userindex: this.userindex!,
                      username: this.username)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Padding(
                  padding: EdgeInsets.only(right: 6.w, top: 5),
                  child: linkCard(),
                ),
                // linkCard(),
                (this
                                .buzzerfeedMainController!
                                .mylistdetaildata[this.userindex!]!
                                .quotes!
                                .length !=
                            0 &&
                        this
                                .buzzerfeedMainController!
                                .mylistdetaildata[this.userindex!]
                                .quotes !=
                            null)
                    ? ReTweet(
                        avatar: this
                            .buzzerfeedMainController!
                            .mylistdetaildata[this.userindex!]
                            .quotes![0]
                            .userPicture!,
                        username: this
                            .buzzerfeedMainController!
                            .mylistdetaildata[this.userindex!]
                            .quotes![0]
                            .memberName!,
                        name: this
                            .buzzerfeedMainController!
                            .mylistdetaildata[this.userindex!]
                            .quotes![0]
                            .shortcode!,
                        timeAgo: this
                            .buzzerfeedMainController!
                            .mylistdetaildata[this.userindex!]
                            .quotes![0]
                            .timeStamp!,
                        text: this
                            .buzzerfeedMainController!
                            .mylistdetaildata[this.userindex!]
                            .quotes![0]
                            .description!,
                        comments: "",
                        retweets: "",
                        userindex: this.userindex,
                        posttype: this
                                    .buzzerfeedMainController!
                                    .mylistdetaildata[this.userindex!]
                                    .quotes![0]
                                    .pollStatus !=
                                ""
                            ? this.posttype
                            : "",
                        quotes: this
                            .buzzerfeedMainController!
                            .mylistdetaildata[this.userindex!]
                            .quotes,
                        favorites: "")
                    : Container()
              ],
            ),
          ),
          // (!this.text.isEmpty)
          //     ? tweetText()
          //     : Container(
          //         width: 0,
          //         height: 0,
          //       ),
          // (!this.text.isEmpty)
          //     ? SizedBox(
          //         height: 2.0.h,
          //       )
          //     : Container(
          //         width: 0,
          //         height: 0,
          //       ),
          // buzzBody(),
          // linkCard(),
          tweetButtons(),
        ],
      ),
    );
  }

  Widget tweetHeader() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    username,
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
                              .mylistdetaildata[this.userindex!]
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
        // Spacer(),
        // IconButton(
        //   icon: Icon(
        //     FontAwesomeIcons.angleDown,
        //     size: 14.0,
        //     color: Colors.grey,
        //   ),
        //   onPressed: () {
        //     if (this
        //             .buzzerfeedMainController
        //             .mylistdetaildata[this.userindex]
        //             .memberId ==
        //         CurrentUser().currentUser.memberID)
        //       showBarModalBottomSheet(
        //           context: Get.context,
        //           builder: (context) => ClipRRect(
        //               child: Container(
        //                 width: 100.w,
        //                 child: Column(
        //                   children: [
        //                     SizedBox(
        //                       height: 3.0.h,
        //                     ),
        //                     ListTile(
        //                       onTap: () async {
        //                         var response = await ApiProvider().fireApi(
        //                             'https://www.bebuzee.com/api/buzzerfeed/listUserAddRemove?user_id=${this.buzzerfeedMainController.mylistdetaildata[this.userindex].memberId}');
        //                         print(
        //                             "response of add to list=${response.data}");
        //                         // this.buzzerfeedMainController.removePost(
        //                         //     this
        //                         //         .buzzerfeedMainController
        //                         //         .mylistdetaildata[this.userindex]
        //                         //         .buzzerfeedId,
        //                         //     this.userindex);
        //                         Navigator.of(context).pop();
        //                       },
        //                       leading: Icon(
        //                         FontAwesomeIcons.list,
        //                         color: Colors.grey,
        //                         size: 2.0.h,
        //                       ),
        //                       title: Text(
        //                         AppLocalizations.of('Add to My List'),
        //                         style: TextStyle(fontSize: 2.0.h),
        //                       ),
        //                     ),
        //                     ListTile(
        //                       onTap: () {
        //                         this.buzzerfeedMainController.removePost(
        //                             this
        //                                 .buzzerfeedMainController
        //                                 .mylistdetaildata[this.userindex]
        //                                 .buzzerfeedId,
        //                             this.userindex);
        //                         Navigator.of(context).pop();
        //                       },
        //                       leading: Icon(
        //                         FontAwesomeIcons.dumpster,
        //                         color: Colors.grey,
        //                         size: 2.0.h,
        //                       ),
        //                       title: Text(
        //                         AppLocalizations.of('Delete Buzz'),
        //                         style: TextStyle(fontSize: 2.0.h),
        //                       ),
        //                     ),
        //                     ListTile(
        //                       onTap: () {
        //                         var file = [];

        //                         if (this.posttype == "images") {
        //                           file = this
        //                               .buzzerfeedMainController
        //                               .mylistdetaildata[this.userindex]
        //                               .images;
        //                         } else if (this.posttype == "gif") {
        //                           file = this
        //                               .buzzerfeedMainController
        //                               .mylistdetaildata[this.userindex]
        //                               .images;
        //                         } else if (this.posttype == "videos") {
        //                           file = [
        //                             this
        //                                 .buzzerfeedMainController
        //                                 .mylistdetaildata[this.userindex]
        //                                 .video
        //                           ];
        //                         } else {}
        //                         var id = this
        //                             .buzzerfeedMainController
        //                             .mylistdetaildata[this.userindex]
        //                             .buzzerfeedId;
        //                         Navigator.of(context).pop();
        //                         Navigator.of(context).push(MaterialPageRoute(
        //                             builder: (context) => BuzzfeedUploadPost(
        //                                 purpose: 'post_edit',
        //                                 editbuzzerfeedid: id,
        //                                 buzzfeedmaincontroller:
        //                                     this.buzzerfeedMainController,
        //                                 editIndex: this.userindex,
        //                                 edittype: this.posttype,
        //                                 editfiles: file,
        //                                 edittext: this.text)));
        //                       },
        //                       leading: Icon(
        //                         FontAwesomeIcons.pen,
        //                         color: Colors.grey,
        //                         size: 2.0.h,
        //                       ),
        //                       title: Text(AppLocalizations.of('Edit Buzz'),
        //                           style: TextStyle(fontSize: 2.0.h)),
        //                     ),
        //                   ],
        //                 ),
        //                 height: 30.0.h,
        //               ),
        //               borderRadius:
        //                   BorderRadius.vertical(top: Radius.circular(20))));
        //     else {
        //       details();
        //     }
        //   },
        // ),
      ],
    );
  }

  Widget tweetText() {
    var newText = text.replaceAll("\$", "~~");
    return FormattedText(
      AppLocalizations.of(newText),
      overflow: TextOverflow.clip,
    );
  }

  Widget pollcontainer(String title, String vote,
      {status: false, selectedPoll: false}) {
    return Container(
      padding: EdgeInsets.all(1.0.h),
      decoration: BoxDecoration(
        color: buzzerfeedMainController!
                .mylistdetaildata[this.userindex!].isvoting!.value
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
                                .mylistdetaildata[this.userindex!]
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
                      .mylistdetaildata[this.userindex!]!.isvoting!.value
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
        .mylistdetaildata[this.userindex!].testpoll!.length;

    return Center(
      child: Container(
          child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 1.0.h),
        itemBuilder: (context, index) {
          var selectedPoll = false;

          for (var element in buzzerfeedMainController!
              .mylistdetaildata![this.userindex!].pollAnswer!) {
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
                          .mylistdetaildata[this.userindex!]
                          .pollAnswer![index]
                          .answerId,
                      this.userindex);
                  // buzzerfeedMainController.mylistdetaildata.refresh();
                },
                child: pollcontainer(
                  '${buzzerfeedMainController!.mylistdetaildata[this.userindex!].pollAnswer![index].answer}',
                  buzzerfeedMainController!.mylistdetaildata[this.userindex!]
                      .testpoll!.value[index].totalVotes,
                  status: buzzerfeedMainController!
                      .mylistdetaildata[this.userindex!]
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

//POLL-START
  Widget pollBody() {
    var polldata = this
        .buzzerfeedMainController!
        .mylistdetaildata[this.userindex!]
        .pollAnswer;

    var polllist = [];
    polldata!.forEach((element) {
      polllist.add(Polls.options(
        title: element.answer!,
        value: 0.2,
      ));
    });

    print("polllist =${polllist}");
    return PollView(
      polllist: polllist,
      buzzerfeedMainController: buzzerfeedMainController!,
      userIndex: this.userindex,
    );
  }

//POLL-END
  Widget videoCard() {
    print(
        "current video=${buzzerfeedMainController!.mylistdetaildata[this.userindex!].video}");
    return ClipRRect(
        borderRadius: BorderRadius.circular(2.0.w),
        child:
            //  DiscoverVideoPlayer(
            //   url:
            //       buzzerfeedMainController.mylistdetaildata[this.userindex].video,
            // )-

            InkWell(
          onTap: () {
            print("clicked on video");
            Navigator.of(Get.context!).push(MaterialWithModalsPageRoute(
                builder: (context) => BuzzfeedNetworkVideoPlayerExpanded(
                      url: this
                          .buzzerfeedMainController!
                          .mylistdetaildata[this.userindex!]
                          .video!,
                    )));
          },
          child: BuzzerFeedPlay(
            image: buzzerfeedMainController!
                .mylistdetaildata![this.userindex!].thumb!,
            url: buzzerfeedMainController!
                .mylistdetaildata![this.userindex!].video!,
            // flickManager:

            //  FlickManager(
            //     videoPlayerController: VideoPlayerController.network(
            //         buzzerfeedMainController
            //             .mylistdetaildata[this.userindex].video)

            //             ),
          ),
        )
        //     BuzzfeedNetworkVideoPlayer(
        //   url:
        //       buzzerfeedMainController.mylistdetaildata[this.userindex].video,
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
                .mylistdetaildata[this.userindex!]
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
                      .mylistdetaildata[this.userindex!]
                      .images!
                      .length ==
                  1
              ? 50.0.h
              : 25.0.h,
          width: this
                      .buzzerfeedMainController!
                      .mylistdetaildata[this.userindex!]
                      .images!
                      .length ==
                  1
              ? 78.0.w
              : 35.0.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.0.w),
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              placeholder: (context, url) => SkeletonAnimation(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0.w),
                  child: Container(
                    width: this
                                .buzzerfeedMainController!
                                .mylistdetaildata[this.userindex!]
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
                  .mylistdetaildata[this.userindex!]
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
            listofimages: this!
                .buzzerfeedMainController!
                .mylistdetaildata[this.userindex!]
                .images!,
            index: 0,
          ),
        ));
      },
      child: Container(
        width: 78.0.w,
        height: this
                    .buzzerfeedMainController!
                    .mylistdetaildata[this.userindex!]
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
                  width: 78.0.w,
                  height: 25.0.h,
                  color: Colors.grey[300],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              imageUrl: this
                  .buzzerfeedMainController!
                  .mylistdetaildata[this.userindex!]
                  .images![0],
              fit: BoxFit.fill,
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
                    .mylistdetaildata[this.userindex!]
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
              .mylistdetaildata[this.userindex!]
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
                  ?
                  // pollBody()
                  testpollBody()
                  : this.posttype == "videos"
                      ?
                      // Container()
                      videoCard()
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
                  ListTile(
                    onTap: () async {
                      // var response = await ApiProvider().fireApi(
                      //     'https://www.bebuzee.com/api/buzzerfeed/listUserAddRemove?user_id=${this.buzzerfeedMainController.mylistdetaildata[this.userindex].memberId}');

                      // print("response of add to list=${response.data}");
                      // this.buzzerfeedMainController.removePost(
                      //     this
                      //         .buzzerfeedMainController
                      //         .mylistdetaildata[this.userindex]
                      //         .buzzerfeedId,
                      //     this.userindex);
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BuzzFeedList(
                          purpose: 'add',
                          memberId: this
                              .buzzerfeedMainController!
                              .mylistdetaildata[this.userindex!]
                              .memberId,
                          buzzfeedmaincontroller: buzzerfeedMainController!,
                        ),
                      ));
                    },
                    leading: Icon(
                      FontAwesomeIcons.list,
                      color: Colors.grey,
                      size: 2.0.h,
                    ),
                    title: Text(
                      AppLocalizations.of('Add to My List'),
                      style: TextStyle(fontSize: 2.0.h),
                    ),
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
                  ListTile(
                    onTap: () {
                      var totbuzz;
                      Navigator.of(context).pop();
                      this
                              .buzzerfeedMainController!
                              .mylistdetaildata[this.userindex!]
                              .reBuzzerfeedStatus!
                              .value =
                          !this
                              .buzzerfeedMainController!
                              .mylistdetaildata[this.userindex!]
                              .reBuzzerfeedStatus!
                              .value;
                      if (this
                          .buzzerfeedMainController!
                          .mylistdetaildata[this.userindex!]
                          .reBuzzerfeedStatus!
                          .value) {
                        totbuzz = int.parse(this
                            .buzzerfeedMainController!
                            .mylistdetaildata[this.userindex!]
                            .totalReBuzzerfeed!
                            .value);
                        print("totbuzz ${totbuzz}");
                        this
                            .buzzerfeedMainController!
                            .mylistdetaildata[this.userindex!]
                            .totalReBuzzerfeed!
                            .value = '${totbuzz + 1}';
                      } else {
                        totbuzz = int.parse(this
                            .buzzerfeedMainController!
                            .mylistdetaildata[this.userindex!]
                            .totalReBuzzerfeed!
                            .value);
                        this
                            .buzzerfeedMainController!
                            .mylistdetaildata[this.userindex!]
                            .totalReBuzzerfeed!
                            .value = '${totbuzz - 1}';
                      }
                      this.buzzerfeedMainController!.rebuzzPost(this
                          .buzzerfeedMainController!
                          .mylistdetaildata[this.userindex!]
                          .buzzerfeedId);
                    },
                    leading: Icon(
                      FontAwesomeIcons.retweet,
                      color: Colors.grey,
                      size: 2.0.h,
                    ),
                    title: Obx(
                      () => Text(
                        this
                                .buzzerfeedMainController!
                                .mylistdetaildata[this.userindex!]
                                .reBuzzerfeedStatus!
                                .value
                            ? AppLocalizations.of('Undo Rebuzz')
                            : AppLocalizations.of('Rebuzz'),
                        style: TextStyle(fontSize: 2.0.h),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BuzzfeedUploadPost(
                          editbuzzerfeedid: buzzerfeedMainController!
                              .mylistdetaildata[this.userindex!].buzzerfeedId!,
                          buzzfeedmaincontroller: buzzerfeedMainController!,
                          purpose: AppLocalizations.of("retweet"),
                          // retweetpost: this,
                        ),
                      ));
                    },
                    leading: Icon(
                      FontAwesomeIcons.penAlt,
                      color: Colors.grey,
                      size: 2.0.h,
                    ),
                    title: Text(AppLocalizations.of('Quote Rebuzz'),
                        style: TextStyle(fontSize: 2.0.h)),
                  ),
                ],
              ),
              height: 20.0.h,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))));
  }

  Widget tweetButtons() {
    return Container(
      // color: Colors.red,
      height: 4.0.h,
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tweetIconButton(FontAwesomeIcons.comment, this.comments, () async {
            Navigator.of(Get.context!).push(MaterialPageRoute(
              builder: (context) => BuzzfeedUploadPost(
                purpose: "comment_upload",
                buzzfeedmaincontroller: this.buzzerfeedMainController!,
                buzzerfeedId: this
                    .buzzerfeedMainController!
                    .mylistdetaildata[this.userindex!]
                    .buzzerfeedId!,
              ),
            ));
          }),
          Obx(
            () => tweetIconButton(
                FontAwesomeIcons.retweet,
                this
                    .buzzerfeedMainController!
                    .mylistdetaildata[this.userindex!]
                    .totalReBuzzerfeed!
                    .value, () {
              retweetOptions();
            },
                color: (this
                        .buzzerfeedMainController!
                        .mylistdetaildata[this.userindex!]
                        .reBuzzerfeedStatus!
                        .isTrue)
                    ? Colors.green
                    : Colors.black45),
          ),
          Obx(
            () => tweetIconButton(
                !this
                        .buzzerfeedMainController!
                        .mylistdetaildata[this.userindex!]
                        .likeStatus!
                        .value
                    ? FontAwesomeIcons.heart
                    : FontAwesomeIcons.solidHeart,
                '${this.buzzerfeedMainController!.mylistdetaildata[this.userindex!].totalLikes}',
                () {
              // print(
              //     "likeunlike=${this.buzzerfeedMainController.mylistdetaildata[this.userindex].likeStatus}");
              this
                      .buzzerfeedMainController!
                      .mylistdetaildata[this.userindex!]
                      .likeStatus!
                      .value =
                  !this
                      .buzzerfeedMainController!
                      .mylistdetaildata[this.userindex!]
                      .likeStatus!
                      .value;
              buzzerfeedMainController!.likeUnlike(this.userindex);
            },
                color: this
                        .buzzerfeedMainController!
                        .mylistdetaildata[this.userindex!]
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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BuzzfeedHashtagView(
              tag: tag,
            ),
          ));
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
          var newText = tag.replaceAll("~~", "\$");
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BuzzfeedHashtagView(
              tag: newText,
            ),
          ));
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

class ReTweet extends StatelessWidget {
  final String avatar;
  final String username;
  final String name;
  final String timeAgo;
  final String text;
  final String comments;
  final String retweets;
  final String favorites;
  bool? likeStatus;

  int? userindex;
  String? posttype;
  BuzzfeedNetworkVideoPlayer? videoPlayer;
  List<Quote>? quotes;
  FlickManager? flickManager;

  ReTweet(
      {Key? key,
      required this.avatar,
      required this.username,
      required this.name,
      required this.timeAgo,
      required this.text,
      required this.comments,
      required this.retweets,
      required this.favorites,
      this.quotes,
      this.posttype,
      this.likeStatus,
      this.flickManager,
      this.videoPlayer,
      this.userindex})
      : super(key: key);

  get featuredColor => null;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5.h,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3.0.w))),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(3.0.w)),
        child: Container(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              // Navigator.of(Get.context).push(MaterialPageRoute(
              //     builder: (context) => BuzzerfeedExpanded(
              //         description: text,
              //         avatar: this.avatar,
              //         comments: this.comments,
              //         favorites: this.favorites,
              //         buzzerfeedMainController: this.buzzerfeedMainController,
              //         likeStatus: this.likeStatus,
              //         name: this.name,
              //         posttype: this.posttype,
              //         retweets: this.retweets,
              //         timeAgo: this.timeAgo,
              //         userindex: this.userindex,
              //         username: this.username)));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tweetAvatar(),
                tweetBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tweetAvatar() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        radius: 5.0.w,
        backgroundColor: Colors.black,
        backgroundImage: NetworkImage(this.quotes![0].userPicture!),
      ),
    );
  }

  Widget linkCard() {
    return (this.quotes![0].linkDesc!.length == 0)
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
                    itemCount: this.quotes![0].linkDesc!.length,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            launch('${this.quotes![0].linkLink![index]}');
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
                                          this.quotes![0].linkImages![index] ==
                                                  ""
                                              ? Card(
                                                  elevation: 1.0,
                                                  child: Container(
                                                    width: 80.0.w,
                                                    height: 20.0.h,
                                                    child: Image.asset(
                                                      'assets/images/buzzfeed.png',
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: this
                                                      .quotes![0]
                                                      .linkImages![index],
                                                  fit: BoxFit.fill,
                                                ),
                                          // Container(
                                          //     alignment: Alignment.centerLeft,
                                          //     margin: EdgeInsets.all(10),
                                          //     child: Column(
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.start,
                                          //       children: [
                                          //         Text(
                                          //           "DATA",
                                          //           // '${buzzerfeedMainController.listbu/zzerfeeddata[this.userindex].linkLink[index]}',
                                          //           // '${this.quotes[0].linkDomain[index]}',

                                          //           softWrap: true,
                                          //           style: TextStyle(
                                          //               fontWeight:
                                          //                   FontWeight.w400,
                                          //               color: settingsColor,
                                          //               overflow: TextOverflow
                                          //                   .ellipsis),
                                          //         ),
                                          //         Text(
                                          //           "DATA",
                                          //           // '${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkLink[index]}',
                                          //           // '${this.quotes[0].linkHeader[index]}',

                                          //           softWrap: true,
                                          //           style: TextStyle(
                                          //               fontWeight:
                                          //                   FontWeight.w400,
                                          //               overflow: TextOverflow
                                          //                   .ellipsis),
                                          //         ),
                                          //       ],
                                          //     )),
                                          Container(
                                            alignment: Alignment.center,
                                            margin:
                                                EdgeInsets.only(left: 1.5.w),
                                            child: Text(
                                              '${this.quotes![0].linkDesc![index]}',
                                              maxLines: 3,
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                                // leading: CachedNetworkImage(
                                //   imageUrl: buzzerfeedMainController
                                //       .mylistdetaildata[this.userindex]
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
          InkWell(
            onTap: () {
              print("tapa tap");
              // Navigator.of(Get.context).push(MaterialPageRoute(
              //     builder: (context) => BuzzerfeedExpanded(
              //         description: text,
              //         avatar: this.avatar,
              //         comments: this.comments,
              //         favorites: this.favorites,
              //         buzzerfeedMainController: this.buzzerfeedMainController,
              //         likeStatus: this.likeStatus,
              //         name: this.name,
              //         posttype: this.posttype,
              //         retweets: this.retweets,
              //         timeAgo: this.timeAgo,
              //         userindex: this.userindex,
              //         username: this.username)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                linkCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tweetHeader() {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.only(right: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@${name} · $timeAgo',
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            )),
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
  Widget pollBody() {
    var polldata = this.quotes![0].pollAnswer;

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
    print("current video=${this.quotes![0].video}");
    return ClipRRect(
        borderRadius: BorderRadius.circular(2.0.w),
        child:
            //  DiscoverVideoPlayer(
            //   url:
            //       this.quotes[0].video,
            // )-

            InkWell(
          onTap: () {
            print("clicked on video");
            Navigator.of(Get.context!).push(MaterialWithModalsPageRoute(
                builder: (context) => BuzzfeedNetworkVideoPlayerExpanded(
                      url: this.quotes![0].video!,
                    )));
          },
          child: BuzzerFeedPlay(
            image: this.quotes![0].thumb!,
            url: this.quotes![0].video!,
            // flickManager:

            //  FlickManager(
            //     videoPlayerController: VideoPlayerController.network(
            //         buzzerfeedMainController
            //             .mylistdetaildata[this.userindex].video)

            //             ),
          ),
        )
        //     BuzzfeedNetworkVideoPlayer(
        //   url:
        //       this.quotes[0].video,
        // )

        );
  }

//Imgae
  Widget imageCard(imageindex) {
    return InkWell(
      onTap: () {
        Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (context) => BuzzfeedExpandedImage(
            listofimages: this.quotes![0].images!,
            index: imageindex,
          ),
        ));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.0.w),
        child: Container(
          height: this.quotes![0].images!.length == 1 ? 50.0.h : 25.0.h,
          width: this.quotes![0].images!.length == 1 ? 82.0.w : 35.0.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.0.w),
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              placeholder: (context, url) => SkeletonAnimation(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0.w),
                  child: Container(
                    width:
                        this.quotes![0].images!.length == 1 ? 75.0.w : 35.0.w,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              imageUrl: this.quotes![0].images![imageindex],
            ),
          ),
        ),
      ),
    );
  }

  Widget gifCard(index) {
    // int indexI = 0;
    // for (int i = 0; i < this.quotes[0].images.length; i++) {
    //   indexI = i;
    // }
    return InkWell(
      onTap: () {
        Navigator.of(Get.context!).push(MaterialPageRoute(
          builder: (context) => BuzzfeedExpandedImage(
            listofimages: this.quotes![0].images!,
            index: 0,
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        // decoration: this.quotes[0].images.length != 1
        //     ? BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         color: Colors.grey[300])
        //     : null,
        width: this.quotes![0].images!.length == 1 ? 35.0.h : 25.0.h,
        height: this.quotes![0].images!.length == 1 ? 45.0.h : 25.0.h,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              placeholder: (context, url) => SkeletonAnimation(
                child: Container(
                  width: 60.0.w,
                  height: 35.0.h,
                  // height: this.quotes[0].images.length == 1 ? 45.0.h : 25.0.h,
                  color: Colors.grey[300],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              imageUrl: this.quotes![0].images![index],
              fit: BoxFit.fill,
              // height: this.quotes[0].images.length == 1 ? 45.0.h : 25.0.h,
              // width: 60.0.w,
            )),
      ),
    );
  }

  Widget listofimagecard() {
    // return Container();
    return Container(
        width: 60.0.w,
        height: this.quotes![0].images!.length == 1 ? 55.0.h : 25.0.h,
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            width: 1.0.w,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: this.quotes![0].images!.length,
          itemBuilder: (context, index) => imageCard(index),
        ));
  }

  Widget testpollBody() {
    return Center(
      child: Container(
          margin: EdgeInsets.all(5),
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 1.0.h),
            itemBuilder: (context, index) {
              return InkWell(
                child: pollcontainer(
                  '${this.quotes![0].pollAnswer![index].answer.toString()}',
                  this.quotes![0].pollAnswer![index].totalVotes!,
                  status: this.quotes![0].pollAnswer![index].status,
                ),
              );
            },
            shrinkWrap: true,
            itemCount: this.quotes![0].pollAnswer!.length,
          )),
    );
  }

  Widget listofgifcard() {
    // return Container();
    return Container(
        // color: settingsColor,
        width: 60.0.w,
        height: this.quotes![0].images!.length == 1 ? 55.0.h : 35.0.h,
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            width: 1.0.w,
          ),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: this.quotes![0].images!.length,
          itemBuilder: (context, index) => gifCard(index),
        ));
  }

  Widget pollcontainer(String title, String vote,
      {status: false, selectedPoll: false}) {
    return Container(
      padding: EdgeInsets.all(1.0.h),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 138, 162, 173),
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
              Text(title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              (status == true)
                  ? Icon(
                      Icons.verified_rounded,
                      size: 2.0.h,
                      color: Colors.white,
                    )
                  : Container()
            ],
          ),
          Text(
            vote,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

//Image end
  Widget buzzBody() {
    print("buzzbody ${this.posttype}");
    return Container(
      child: this.posttype!.isNotEmpty
          ? testpollBody()
          : this.posttype == "text"
              ? Container()
              : this.posttype == "images"
                  ? listofimagecard()
                  : this.posttype == "poll"
                      ? testpollBody()
                      : this.posttype == "videos"
                          ?
                          // Container()
                          videoCard()
                          : listofgifcard(),
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
