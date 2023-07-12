import 'package:bizbultest/models/Buzzerfeed/buzzerfeedmainpagemodel.dart';
import 'package:bizbultest/services/BuzzfeedControllers/BuzzerfeedApi.dart';
import 'package:bizbultest/services/BuzzfeedControllers/Buzzfeedprofilecontroller.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedcontroller.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/view/Buzzfeed/buzfeedexpanded.dart';
import 'package:bizbultest/view/Buzzfeed/buzzerfeedexpandedprofile.dart';
import 'package:bizbultest/view/Buzzfeed/buzzerfeedhashtagpage.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeed_logo_icons.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeednetworkvideoplayer.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedpoll.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedpostupload.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedview.dart';
import 'package:bizbultest/view/Buzzfeed/playground/buzzfeedvideoplay.dart';
import 'package:bizbultest/widgets/main_video_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:polls/polls.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Language/appLocalization.dart';
import '../../utilities/colors.dart';
import 'buzzerfeedexpandedvideoplayer.dart';
import 'buzzfeedexpandedimage.dart';

class BuzzfeedViewProfile extends StatefulWidget {
  String? memberId;
  BuzzerfeedProfileController? controller;
  BuzzfeedViewProfile({Key? key, this.memberId, this.controller})
      : super(key: key);

  @override
  _BuzzfeedViewProfileState createState() => _BuzzfeedViewProfileState();
}

class _BuzzfeedViewProfileState extends State<BuzzfeedViewProfile> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  // var tweets = [
  //   Tweet(
  //     avatar:
  //         'https://pbs.twimg.com/profile_images/1187814172307800064/MhnwJbxw_400x400.jpg',
  //     username: 'Flutter',
  //     name: 'FlutterDev',
  //     timeAgo: '5m',
  //     text:
  //         'Google’s UI @Sammy #fashion toolkit to build apps for mobile, web, & desktop from a single codebase.',
  //     comments: '243',
  //     retweets: '23K',
  //     favorites: '112K',
  //   ),
  //   Tweet(
  //     avatar:
  //         'https://pbs.twimg.com/profile_images/1033695141901623301/W-VnxCiG_400x400.jpg',
  //     username: 'Flutter en Español',
  //     name: 'EsFlutter',
  //     timeAgo: '12m',
  //     text: 'Comunidad Flutter de habla hispana!',
  //     comments: '46',
  //     retweets: '4K',
  //     favorites: '17K',
  //   ),
  //   Tweet(
  //     avatar:
  //         'https://pbs.twimg.com/profile_images/1168932726461935621/VRtfrDXq_400x400.png',
  //     username: 'Android Dev',
  //     name: 'AndroidDev',
  //     timeAgo: '20m',
  //     text: 'News and announcements for developers from the Android team.',
  //     comments: '305',
  //     retweets: '20K',
  //     favorites: '1M',
  //   ),
  //   Tweet(
  //     avatar:
  //         'https://pbs.twimg.com/profile_images/808350098178670592/bYyZI8Bp_400x400.jpg',
  //     username: 'Google Play',
  //     name: 'GooglePlay',
  //     timeAgo: '21m',
  //     text:
  //         'We’re exploring the world’s greatest stories through movies, TV, games, apps, books and so much more. Up for new adventures and discoveries? Let’s play.',
  //     comments: '1K',
  //     retweets: '70K',
  //     favorites: '2M',
  //   ),
  //   Tweet(
  //     avatar:
  //         'https://pbs.twimg.com/profile_images/1253792323051204608/QiaT93TQ_400x400.jpg',
  //     username: 'Google',
  //     name: 'Google',
  //     timeAgo: '26m',
  //     text: 'HeyGoogle',
  //     comments: '10K',
  //     retweets: '500K',
  //     favorites: '22M',
  //   ),
  // ];

  @override
  void dispose() {
    print("disposed buzzfeedprofile");
    Get.delete<BuzzerfeedProfileController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("profile currentId=${widget.memberId}");
    var buzzfeedmaincontroller = widget.controller;
    var testmaincontroller = Get.find<BuzzerfeedMainController>();

    if (testmaincontroller != null) {
      print("not initialised maincontroller");
    } else {
      print("initiallised");
    }
    Widget listOfTweets() {
      return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Tweet(
            avatar:
                buzzfeedmaincontroller!.listbuzzerfeeddata[index].userPicture!,
            username:
                buzzfeedmaincontroller.listbuzzerfeeddata[index].memberName!,
            name: buzzfeedmaincontroller.listbuzzerfeeddata[index].shortcode!,
            timeAgo:
                buzzfeedmaincontroller.listbuzzerfeeddata[index].timeStamp!,
            text:
                buzzfeedmaincontroller.listbuzzerfeeddata[index].description!,
            comments:
                '  ${buzzfeedmaincontroller.listbuzzerfeeddata[index].totalComments}',
            retweets:
                '${buzzfeedmaincontroller.listbuzzerfeeddata[index].totalReBuzzerfeed}',
            favorites:
                '  ${buzzfeedmaincontroller.listbuzzerfeeddata[index].totalLikes}',
            likeStatus:
                buzzfeedmaincontroller.listbuzzerfeeddata[index].likeStatus!,
            userindex: index,
            buzzerfeedMainController: buzzfeedmaincontroller,
            posttype: buzzfeedmaincontroller.listbuzzerfeeddata[index].type,
            videoPlayer: BuzzfeedNetworkVideoPlayer(
              url: buzzfeedmaincontroller.listbuzzerfeeddata[index].video!,
            ),
          );

          // tweets[0];
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 0,
        ),
        itemCount: buzzfeedmaincontroller!.listbuzzerfeeddata.length,
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.white,
        title: Container(
          width: Get.width,
          child: Center(
            child: Row(
              children: [
                Icon(
                  BuzzfeedLogo.buzzfeedlogo,
                  color: Colors.black,
                  size: 7.0.h,
                ),
                SizedBox(
                  width: 2.0.h,
                ),
                Text(
                  'M y b u z z',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.bold),
                ),
                Text(' '),
                Text(
                  'z z',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'HelveticaNeue',
                      fontSize: 3.0.h,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 2.0.h,
                ),
                Icon(
                  BuzzfeedLogo.buzzfeedlogo,
                  color: Colors.black,
                  size: 7.0.h,
                ),
              ],
            ),
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
                      height: buzzfeedmaincontroller!.isUpload.value
                          ? kToolbarHeight
                          : 0,
                      width: 100.0.w,
                      child: Center(
                        child: loadingAnimation(),
                      ),
                    ),
                  );
                return Container(
                  height: 100.0.h - 15.0.h,
                  child: Obx(
                      () => buzzfeedmaincontroller!.listbuzzerfeeddata.length ==
                              0
                          ? Center(
                              child: Container(
                                child: Text(
                                  AppLocalizations.of("No Buzz"),
                                  style: TextStyle(fontSize: 18),
                                ),
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
                                buzzfeedmaincontroller!.fetchData();
                                buzzfeedmaincontroller!.listbuzzerfeeddata
                                    .refresh();
                                _refreshController.refreshCompleted();
                              },
                              onLoading: () {
                                print("loading tweet");
                                buzzfeedmaincontroller!.fetchLoadData();
                                buzzfeedmaincontroller.listbuzzerfeeddata
                                    .refresh();
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
              }, childCount: 2),
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
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => BuzzfeedView()));

          // controller.fetchData(tag: tag);
          // controller.searchbarText.value = tag;
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

class Tweet extends StatelessWidget {
  final String avatar;
  final String username;
  final String name;
  final String timeAgo;
  final String text;
  final String comments;
  final String retweets;
  final String favorites;
  final RxBool likeStatus;
  BuzzfeedNetworkVideoPlayer? videoPlayer;
  BuzzerfeedProfileController? buzzerfeedMainController;
  int? userindex;
  String? posttype;
  // var testmaincontroller = GetInstance().call<BuzzerfeedMainController>();
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
      required this.likeStatus,
      this.posttype,
      this.videoPlayer,
      this.buzzerfeedMainController,
      this.userindex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(Get.context!).push(MaterialPageRoute(
              builder: (context) => BuzzerfeedExpandedProfile(
                  description: text,
                  avatar: this.avatar,
                  comments: this.comments,
                  favorites: this.favorites,
                  buzzerfeedMainController: this.buzzerfeedMainController,
                  likeStatus: this.likeStatus.value,
                  name: this.name,
                  posttype: this.posttype,
                  retweets: this.retweets,
                  timeAgo: this.timeAgo,
                  userindex: this.userindex,
                  username: this.username)));
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
      // color: Colors.pink,
      margin: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        backgroundColor: Colors.black,
        backgroundImage: NetworkImage(this.avatar),
      ),
    );
  }

  Widget rebuzzTextCard() {
    return this
                .buzzerfeedMainController!
                .listbuzzerfeeddata[this.userindex!]
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
                        .listbuzzerfeeddata[this.userindex!]
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          rebuzzTextCard(),
          tweetHeader(),
          !this.text.isEmpty
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
                          .listbuzzerfeeddata[this.userindex!]
                          .quotes!
                          .length !=
                      0 &&
                  this
                          .buzzerfeedMainController!
                          .listbuzzerfeeddata[this.userindex!]
                          .quotes !=
                      null)
              ? ReTweet(
                  avatar: this
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
                  posttype: this
                              .buzzerfeedMainController!
                              .listbuzzerfeeddata[this.userindex!]
                              .quotes![0]
                              .pollStatus !=
                          ""
                      ? this.posttype
                      : "",
                  comments: "",
                  retweets: "",
                  quotes: this
                      .buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .quotes!,
                  favorites: "",
                  userindex: this.userindex,
                  // buzzerfeedMainController: this.buzzerfeedMainControll,
                )
              : Container(),
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
        // Spacer(),
        Container(
          width: 8.5.w,
          height: 3.5.h,
          // color: Colors.pink,
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.angleDown,
              size: 1.5.h,
              color: Colors.grey,
            ),
            onPressed: () {
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
                                AppLocalizations.of('Delete') +
                                    ' ' +
                                    AppLocalizations.of('Buzz'),
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
                              title: Text(
                                  AppLocalizations.of('Edit') +
                                      ' ' +
                                      AppLocalizations.of('Buzz'),
                                  style: TextStyle(fontSize: 2.0.h)),
                            ),
                          ],
                        ),
                        height: 20.0.h,
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))));
            },
          ),
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
    //  Text(
    //   text,
    //   overflow: TextOverflow.clip,
    // ),
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
                          .listbuzzerfeeddata[this.userindex!]
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
    // var polldata =
    //  PollDatum.fromJson(json)   ;
    // print('polldata=${polldata[0]['answer_id']}');
    var polllist = [];
    polldata!.forEach((element) {
      polllist.add(Polls.options(
        title: element.answer!,
        value: 0,
      ));
    });

    // var polllist = polldata
    //     .map((e) => Polls.options(
    //           title: e.answer,
    //           value: 0,
    //         ))
    //     .toList();
    print("polllist =${polllist}");
    return PollView(
      polllist: polllist,
    );
  }

//POLL-END

//Imgae
  Widget imageCard(imageindex) {
    return ClipRRect(
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
            ? 78.0.w
            : 35.0.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2.0.w),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: this
                .buzzerfeedMainController!
                .listbuzzerfeeddata[this.userindex!]
                .images![imageindex],
          ),
        ),
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
        :
        //  Center(
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
                .listbuzzerfeeddata[this.userindex!].linkDesc!.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                launch(
                    '${buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].linkLink![index]}');
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
                                        .listbuzzerfeeddata[this.userindex!]
                                        .linkImages![index] ==
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
                                    imageUrl: buzzerfeedMainController!
                                        .listbuzzerfeeddata[this.userindex!]
                                        .linkImages![index],
                                    fit: BoxFit.contain,
                                  ),
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // '${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkLink[index]}',
                                      '${buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].linkDomain![index]}',

                                      softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: settingsColor,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Text(
                                      // '${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkLink[index]}',
                                      '${buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].linkHeader![index]}',

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
            // )),
            // ),
            // ),
          );
  }

  Widget gifCard() {
    return Container(
      width: 78.0.w,
      height: 45.0.h,
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
    );
  }

  Widget listofimagecard() {
    // return Container();
    return ClipRRect(
      borderRadius: BorderRadius.circular(2.0.w),
      child: Container(
          width: 83.0.w,
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
          )),
    );
  }

  Widget videoCard() {
    print(
        "current video=${buzzerfeedMainController!.listbuzzerfeeddata[this.userindex!].video}");
    return ClipRRect(
        borderRadius: BorderRadius.circular(2.0.w),
        child:
            //  DiscoverVideoPlayer(
            //   url:
            //       buzzerfeedMainController.listbuzzerfeeddata[this.userindex].video,
            // )
            BuzzerFeedPlay(
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
        )
        //     BuzzfeedNetworkVideoPlayer(
        //   url:
        //       buzzerfeedMainController.listbuzzerfeeddata[this.userindex].video,
        // )

        );
  }

//Image end
  Widget buzzBody() {
    print("buzzbody ${this.posttype}");
    return Container(
      // margin: EdgeInsets.only(left: 4.0.w, right: 2.0.w),
      child: this.posttype == "text"
          ? Container()
          : this.posttype == "images"
              ? listofimagecard()
              : this.posttype == "poll"
                  ? testpollBody()
                  : this.posttype == "videos"
                      ? videoCard()
                      : gifCard(),
    );
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
                      Navigator.of(context).pop();
                      this
                              .buzzerfeedMainController!
                              .listbuzzerfeeddata[this.userindex!]
                              .reBuzzerfeedStatus!
                              .value =
                          !this
                              .buzzerfeedMainController!
                              .listbuzzerfeeddata[this.userindex!]
                              .reBuzzerfeedStatus!
                              .value;
                      if (this
                              .buzzerfeedMainController!
                              .listbuzzerfeeddata[this.userindex!]
                              .reBuzzerfeedStatus!
                              .value ==
                          false) {
                        print("deleted buzz");
                        this
                            .buzzerfeedMainController!
                            .listbuzzerfeeddata
                            .remove(this.userindex);
                        this
                            .buzzerfeedMainController!
                            .listbuzzerfeeddata
                            .refresh();
                      }
                      this.buzzerfeedMainController!.rebuzzPost(this
                          .buzzerfeedMainController!
                          .listbuzzerfeeddata[this.userindex!]
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
                                .listbuzzerfeeddata[this.userindex!]
                                .reBuzzerfeedStatus!
                                .value
                            ? AppLocalizations.of('Undo') +
                                ' ' +
                                AppLocalizations.of('Rebuzz')
                            : AppLocalizations.of('Rebuzz'),
                        style: TextStyle(fontSize: 2.0.h),
                      ),
                    ),
                  ),
                  // ListTile(
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => BuzzfeedUploadPost(
                  //         editbuzzerfeedid: buzzerfeedMainController
                  //             .listbuzzerfeeddata[this.userindex].buzzerfeedId,
                  //         buzzfeedmaincontroller: buzzerfeedMainController,
                  //         purpose: "retweet",
                  //         retweetpost: this,
                  //       ),
                  //     ));
                  //   },
                  //   leading: Icon(
                  //     FontAwesomeIcons.penAlt,
                  //     color: Colors.grey,
                  //     size: 2.0.h,
                  //   ),
                  //   title:
                  //       Text('Quote Rebuzz', style: TextStyle(fontSize: 2.0.h)),
                  // ),
                ],
              ),
              height: 20.0.h,
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))));
  }

  Widget tweetButtons() {
    return Container(
      // color: Colors.pink,
      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tweetIconButton(
              FontAwesomeIcons.comment,
              this
                  .buzzerfeedMainController!
                  .listbuzzerfeeddata[this.userindex!]
                  .totalComments!,
              () {}),
          tweetIconButton(
              FontAwesomeIcons.retweet,
              this
                  .buzzerfeedMainController!
                  .listbuzzerfeeddata[this.userindex!]
                  .totalReBuzzerfeed!
                  .value, () {
            retweetOptions();
          },
              color: this
                      .buzzerfeedMainController!
                      .listbuzzerfeeddata[this.userindex!]
                      .reBuzzerfeedStatus!
                      .value
                  ? Colors.green
                  : Colors.black45),
          tweetIconButton(
              likeStatus.isTrue
                  ? FontAwesomeIcons.solidHeart
                  : FontAwesomeIcons.heart,
              this.favorites,
              () {},
              color: likeStatus.isTrue ? Colors.red : Colors.black45),
          tweetIconButton(FontAwesomeIcons.share, '', () {
            Share.share(
              'Sharing Buzz ',
            );
          }),
        ],
      ),
    );
  }

  Widget tweetIconButton(IconData icon, String text, VoidCallback tap,
      {color: Colors.black45}) {
    return InkWell(
      onTap: tap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.0,
            color: color,
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
      ),
    );
  }
}

/*--------------------------------------Requote----------------------------------------------------*/
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
  BuzzerfeedMainController? buzzerfeedMainController;

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
      this.userindex,
      this.buzzerfeedMainController})
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
    return
        // (this.quotes[0].linkDesc.length == 0)
        //     ? Container(
        //         height: 0.0,
        //         width: 0.0,
        //       )
        //     :
        Center(
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
                      borderRadius: BorderRadius.all(Radius.circular(2.0.h)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0.h))),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0.h)),
                            child: Container(
                                width: 80.0.w,
                                child: Column(
                                  children: [
                                    this.quotes![0].linkImages![index] == ""
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
                                            imageUrl: this
                                                .quotes![0]
                                                .linkImages![index],
                                            fit: BoxFit.contain,
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
                                    //           // '${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkLink[index]}',
                                    //           // '${this.quotes[0].linkDomain[index]}',

                                    //           softWrap: true,
                                    //           style: TextStyle(
                                    //               fontWeight: FontWeight.w400,
                                    //               color: settingsColor,
                                    //               overflow:
                                    //                   TextOverflow.ellipsis),
                                    //         ),
                                    //         Text(
                                    //           "DATA",
                                    //           // '${buzzerfeedMainController.listbuzzerfeeddata[this.userindex].linkLink[index]}',
                                    //           // '${this.quotes[0].linkHeader[index]}',

                                    //           softWrap: true,
                                    //           style: TextStyle(
                                    //               fontWeight: FontWeight.w400,
                                    //               overflow:
                                    //                   TextOverflow.ellipsis),
                                    //         ),
                                    //       ],
                                    //     )),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: 1.5.w),
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
            margin: const EdgeInsets.only(right: 5.0, top: 5, bottom: 5),
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
      AppLocalizations.of(newText),
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
            //             .listbuzzerfeeddata[this.userindex].video)

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

  Widget gifCard() {
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
        width: 60.0.w,
        height: this.quotes![0].images!.length == 1 ? 45.0.h : 25.0.h,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              placeholder: (context, url) => SkeletonAnimation(
                child: Container(
                  width: 60.0.w,
                  height: 25.0.h,
                  color: Colors.grey[300],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              imageUrl: this.quotes![0].images![0],
              fit: BoxFit.fill,
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
          itemBuilder: (context, index) => gifCard1(index),
        ));
  }

  Widget gifCard1(index) {
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
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => BuzzerFeedReport(),
                    // ));
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
