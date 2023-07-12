import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/feeds_hashtag_model.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/models/related_blog_model.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/utilities/toast_message.dart';
import 'package:bizbultest/view/expanded_blog_comment_page.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/widgets/Blogbuz/category_list_card.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:bizbultest/widgets/related_blog_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';
import 'package:bizbultest/view/expanded_feed.dart';
import 'package:bizbultest/models/feeds_model.dart' as nfm;
import 'package:sizer/sizer.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/common_appbar.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/widgets/expanded_blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:skeleton_text/skeleton_text.dart';

import '../models/personal_blog_model.dart';
import '../utilities/constant.dart';
import '../utilities/simple_web_view.dart';
import 'Profile/profile_settings_page.dart';

class ExpandedBlogPage extends StatefulWidget {
  final String? blogID;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final String? from;

  final Function? refresh;
  final Function? refreshFromShortbuz;
  final Function? refreshFromMultipleStories;
  PersonalBlogModel? personalblog;
  ExpandedBlogPage(
      {Key? key,
      this.blogID,
      this.changeColor,
      this.personalblog,
      this.isChannelOpen,
      this.setNavBar,
      this.from,
      this.refresh,
      this.refreshFromShortbuz,
      this.refreshFromMultipleStories})
      : super(key: key);

  @override
  _ExpandedBlogPageState createState() => _ExpandedBlogPageState();
}

class _ExpandedBlogPageState extends State<ExpandedBlogPage> {
  bool isBlogLoaded = false;
  bool areRelatedBlogsLoaded = false;
  String? blogId;
  String? blogContent;
  String? image;
  String? views;
  String? blogCategory;
  String? blogTitle;
  String? byUser;
  String? timeStamp;
  dynamic videoUrl;
  dynamic videPoster;
  dynamic video;
  String? referenceLink;
  String? blogKeyword;
  String? fullUrl;
  String? fb;
  String? whatsapp;
  String? twitter;
  String? pinterest;
  String? blogDesc;
  List keywordList = [];
  String? memberID;
  String? shortcode;
  RelatedBlogs? blogList;
  String? langcode;
  List totlangcode = [];
  nfm.NewsFeedModel? blogcomment;
  nfm.AllFeeds? feedData;
  bool likeStatus = false;
  var isBannerLoaded = false;
  var banneradImage = '';
  var banneradButton = '';
  var banneradUrl = '';
  var banneradContent = '';
  var bannerid = '';
  Future<void> likeUnlike(String postType, String postID) async {
    print(postType);
    print(postID);
    var url = Uri.parse(
        "https://www.bebuzee.com/api/newsfeed/postLikeUnlike?action=post_like_data&user_id=${CurrentUser().currentUser.memberID!}&post_type=$postType&post_id=$postID");
    var client = Dio();
    String? token = await ApiProvider().getTheToken();

    await client
        .postUri(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) {
      print('like unlike ${value.data}');
      if (value.statusCode == 200) {
        setState(() {
          blogcomment!.postLikeIcon = value.data['image_data'];
          blogcomment!.postTotalLikes =
              value.data['total_likes'].toString() + ' Likes';
        });
        print(value.data['total_likes']);
      } else {}
    });
  }

  void showCommentCard(child) {
    showBarModalBottomSheet(
        useRootNavigator: true,
        context: this.context,
        builder: (context) {
          var _currentScreenSize = MediaQuery.of(context).size;
          return child;
        });
  }

  Future<void> getBlogData() async {
    print("get blog data called");
    String? token = await ApiProvider().getTheToken();

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/blog/blogData?action=blogbuzfeed_detail_page&blog_id=${widget.blogID}&user_id=${CurrentUser().currentUser.memberID}');
    var client = Dio();
    print("blogdata uel=${newurl} $token");

    try {
      await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) {
        print("blog expanded=${value.data}");
        if (value.statusCode == 200) {
          print("getBlogData()=${value.data['data']}");
          if (mounted) {
            setState(() {
              isBlogLoaded = true;
              likeStatus = value.data['data']["like_status"] ?? false;
              shortcode = value.data['data']["shortcode"];
              memberID = value.data['data']["member_id"].toString();
              blogId = value.data['data']["blog_id"].toString();
              blogContent = value.data['data']["blog_content"];
              image = value.data['data']["blog_image"];
              views = value.data['data']["blog_views"].toString();
              blogCategory = value.data['data']["blog_category"];
              blogTitle = value.data['data']["blog_title"];
              // byUser = value.data['data']["byuser"];
              byUser = value.data['data']['user_name'];
              timeStamp = value.data['data']["blog_time_stamp"];
              videoUrl = value.data['data']["blog_video_url"];
              videPoster = value.data['data']["blog_video_poster"];
              video = value.data['data']["blog_video"];
              referenceLink = value.data['data']["blog_reference_link"];
              blogKeyword = value.data['data']["blog_keywords"];
              fullUrl = value.data['data']["blog_full_url"];
              fb = "facebook";
              whatsapp = "whatsapp";
              twitter = "twitter";
              pinterest = "pinterest";
              fb = value.data['data']["fb"];
              whatsapp = value.data['data']["whatsapp"];
              twitter = value.data['data']["twitter"];
              pinterest = value.data['data']["pinterest"];
              blogDesc = value.data['data']["blog_desc"];

              langcode = value.data['data']['langcode'];
              totlangcode = value.data['data']['totlangcode'];
              if (blogKeyword != null || blogKeyword != '') {
                keywordList = blogKeyword!.split(',').toList();
              }
              try {
                feedData = nfm.AllFeeds.fromJson([value.data['data1']]);
                blogcomment = feedData!.feeds[0];
                print("blog comment=${blogcomment!.postType}");
              } catch (e) {
                print("blog err=$e}");
              }
              print("setstate success");
            });
          } else {}
        }
      });
    } catch (e) {
      print("blog error==${e}");
    }
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blogbuzfeed_detail_page&blog_id=${widget.blogID}");

    // var response = await http.get(url);

    // print(response.body);
    // if (response.statusCode == 200) {
    //   if (mounted) {
    //     setState(() {
    //       isBlogLoaded = true;
    //       shortcode = value.data['data']["shortcode"];
    //       memberID = value.data['data']["user_id"];
    //       blogId = value.data['data']["blog_id"];
    //       blogContent = value.data['data']["blog_content"];
    //       image = value.data['data']["image"];
    //       views = value.data['data']["views"];
    //       blogCategory = value.data['data']["blog_category"];
    //       blogTitle = value.data['data']["blog_title"];
    //       byUser = value.data['data']["byuser"];
    //       timeStamp = value.data['data']["time_stamp"];
    //       videoUrl = value.data['data']["video_url"];
    //       videPoster = value.data['data']["vide_poster"];
    //       video = value.data['data']["video"];
    //       referenceLink = value.data['data']["reference_link"];
    //       blogKeyword = value.data['data']["blog_keyword"];
    //       fullUrl = value.data['data']["full_url"];
    //       fb = value.data['data']["fb"];
    //       whatsapp = value.data['data']["whatsapp"];
    //       twitter = value.data['data']["twitter"];
    //       pinterest = value.data['data']["pinterest"];
    //       blogDesc = value.data['data']["blog_desc"];
    //       if (blogKeyword != null) {
    //         keywordList = blogKeyword.split(',').toList();
    //       }
    //     });
    //   }
    //   return "success";
    // }
  }

  RefreshProfile refreshProfile = new RefreshProfile();

  Future<void> getRelatedBlogs() async {
    print("get related blog data called");
    print(widget.blogID! + "iddddddddd");

    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/blog/blogbuzDetailRelated?blog_id=${widget.blogID}&country=${CurrentUser().currentUser.country}&user_id=${CurrentUser().currentUser.memberID}');
    print("related blog url=$newurl");
    var client = Dio();
    String? token = await ApiProvider().getTheToken();
    print("related blog url=$newurl $token");
    await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      print("get related blog data=${value.data}");
      if (value.statusCode == 200) {
        print("related blogs data = ${value.data}");
        RelatedBlogs blogData = RelatedBlogs.fromJson(value.data['data']);
        await Future.wait(blogData.blogs
            .map((e) => Preload.cacheImage(this.context, e.image!))
            .toList());
        if (mounted) {
          setState(() {
            blogList = blogData;
            areRelatedBlogsLoaded = true;
          });
        }
      } else {}
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blogbuzfeed_detail_page_related&blog_id=${widget.blogID}");
    // var response = await http.get(url);
    // if (response.statusCode == 200 &&
    //     response.body != null &&
    //     response.body != "" &&
    //     response.body != "null") {
    //   RelatedBlogs blogData = RelatedBlogs.fromJson(jsonDecode(response.body));
    //   await Future.wait(blogData.blogs
    //       .map((e) => Preload.cacheImage(this.context, e.image))
    //       .toList());
    //   if (mounted) {
    //     setState(() {
    //       blogList = blogData;
    //       areRelatedBlogsLoaded = true;
    //     });
    //   }
    // }
  }

  Future<void> deleteBlog(String blogID) async {
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/delete_blog.php?user_id=${CurrentUser().currentUser.memberID!}&post_type=blog&country=${CurrentUser().currentUser.memberID!}&blog_id=$blogID');

    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope.php?action=delete_blog&user_id=${CurrentUser().currentUser.memberID!}&post_type=blog&country=${CurrentUser().currentUser.memberID!}&blog_id=$blogID");
    // var response = await http.get(url);
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var client = Dio();
    var response = await client
        .postUri(newurl,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }))
        .then((value) => value);

    if (response.statusCode == 200) {
      // print(response.body);
      print('delete blog response=${response.data}');

      refreshProfile.updateRefresh(true);
    }
  }

  void updateblogbuzpage(int totblogcomments) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        blogcomment!.postTotalComments = totblogcomments;
      });
    });
  }

  Future getAdBanner() async {
    var url =
        'https://www.bebuzee.com/api/campaign/singleBannerAds?user_id=${CurrentUser().currentUser.memberID!}&country=${CurrentUser().currentUser.country}';
    print("url of banner ad=${url}");
    var response = await ApiProvider().fireApi(url).then((value) => value);
    if (response.data['success'] == 1)
      setState(() {
        isBannerLoaded = true;
        banneradImage = response.data['data']['image'];
        banneradButton = response.data['data']['category_val'];
        banneradUrl = response.data['data']['url'];
        banneradContent = response.data['data']['post_content'];
        bannerid = response.data['data']['blog_id'].toString();
      });
    print("response banner=${response.data}");
  }

  @override
  void initState() {
    print(widget.blogID);

    getBlogData();
    // getAdBanner();
    getRelatedBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("widget.blogContent buiding again");
    Widget LikeAndCommentBar() {
      return Card(
        margin: EdgeInsets.only(top: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
        child: Container(
          height: 10.0.h,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              likeStatus = !likeStatus;
                              var totlikes;
                              if (likeStatus) {
                                print(
                                    "total likes--=${blogcomment!.postTotalLikes}");
                                totlikes = int.parse(blogcomment!
                                        .postTotalLikes!
                                        .split(' ')[0]) +
                                    1;
                              } else {
                                print(
                                    "total likes=${blogcomment!.postTotalLikes}");
                                totlikes = int.parse(blogcomment!
                                        .postTotalLikes!
                                        .split(' ')[0]) -
                                    1;
                              }
                              blogcomment!.postTotalLikes =
                                  '${totlikes}' + ' Likes';
                            });
                            likeUnlike(
                                blogcomment!.postType, blogcomment!.postId!);
                          },
                          child: Container(
                            height: 30,
                            child: Icon(
                                likeStatus
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                color: likeStatus ? Colors.red : Colors.black,
                                size: 4.0.h),
                            // decoration: BoxDecoration(
                            //     image: DecorationImage(
                            //         image: NetworkImage(
                            //             '${blogcomment.postLikeIcon}'))),
                          ),
                        ),

                        // IconButton(
                        //   onPressed: () {
                        //     print("blog hear ${blogcomment}");
                        //   },
                        //   icon: blogcomment.postLikeIcon,
                        // ),
                        Text(
                          '${blogcomment!.postTotalLikes}',
                          style: TextStyle(
                              fontFamily: 'SpecialElite',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            showCommentCard(ExpandedFeed(
                              // setNavBar: widget.setNavBar,
                              // isChannelOpen: widget.isChannelOpen,
                              // changeColor: widget.changeColor,
                              updateblogbuz: (int totblogcomments) {
                                print("update blogbuz called $totblogcomments");
                                updateblogbuzpage(totblogcomments);
                              },
                              from: "blogbuzz",
                              postType: 'blog',
                              feed: blogcomment,
                              logo: CurrentUser().currentUser.logo,
                              country: CurrentUser().currentUser.country,
                              memberID: CurrentUser().currentUser.memberID!,
                              currentMemberImage:
                                  CurrentUser().currentUser.image,
                              currentMemberShortcode:
                                  CurrentUser().currentUser.shortcode,
                            ));
                            //  Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ExpandedFeed(
                            //               // setNavBar: widget.setNavBar,
                            //               // isChannelOpen: widget.isChannelOpen,
                            //               // changeColor: widget.changeColor,
                            //               from: "blogbuzz",
                            //               postType: 'blog',
                            //               feed: blogcomment,
                            //               logo: CurrentUser().currentUser.logo,
                            //               country:
                            //                   CurrentUser().currentUser.country,
                            //               memberID:
                            //                   CurrentUser().currentUser.memberID!,
                            //               currentMemberImage:
                            //                   CurrentUser().currentUser.image,
                            //               currentMemberShortcode:
                            //                   CurrentUser().currentUser.shortcode,
                            //             )));
                          },
                          icon: Icon(
                            CustomIcons.comment,
                            size: 30,
                          ),
                        ),
                        Text(
                          '${blogcomment!.postTotalComments}',
                          style: TextStyle(
                              fontFamily: 'SpecialElite',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                    // Expanded(
                    //   child: IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(
                    //       CustomIcons.share_1,
                    //       size: 30,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    print("entered blog");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CommonAppbar(
          setNavbar: widget.setNavBar,
          changeColor: widget.changeColor,
          isChannelOpen: widget.isChannelOpen,
          refreshFromShortbuz: widget.refreshFromShortbuz,
          refresh: widget.refresh,
          refreshFromMultipleStories: widget.refreshFromMultipleStories,
          logo: CurrentUser().currentUser.logo,
          country: CurrentUser().currentUser.country,
          memberID: CurrentUser().currentUser.memberID!,
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          CategoryListCard(setNavBar: widget.setNavBar),
          isBannerLoaded
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.h, vertical: 3.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image(
                            image: CachedNetworkImageProvider(banneradImage),
                            fit: BoxFit.cover,
                            width: 50.0.w,
                            height: 20.0.h,
                          ),
                          Card(
                            elevation: 0.0,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 1.5.h),
                                    child: Text(
                                      banneradContent == ""
                                          ? "Test Ad Bebuzee"
                                          : banneradContent,
                                      style: TextStyle(
                                          fontSize: 10, fontFamily: 'Georgie'),
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 0.0.h),
                                        child: Text(
                                          'Sponsored',
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontFamily: 'Arial'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 1.0.w,
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(1.0.w),
                                        child: Container(
                                          color: Colors.amber,
                                          child: Text('AD',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ),
                                      // IconButton(
                                      //   icon: Icon(Icons.bookmark_border_outlined,
                                      //       color: Colors.black),
                                      //   onPressed: () {},
                                      // )
                                    ],
                                  ),
                                  TextButton.icon(
                                      icon: Icon(Icons.arrow_circle_right,
                                          color: Colors.white),
                                      label: Text(
                                        AppLocalizations.of(banneradButton),
                                        style: whiteNormal.copyWith(
                                            fontSize: 2.0.h,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Georgie'),
                                        textAlign: TextAlign.center,
                                      ),
                                      style: ButtonStyle(
                                          // padding: MaterialStateProperty.all<EdgeInsets>(
                                          //     EdgeInsets.all(
                                          //         2.0.h)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  HexColor('#0110FF')),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      5.0),
                                                  side: BorderSide(
                                                      color: Colors.white)))),
                                      onPressed: () async {
                                        // print(
                                        //     "urll of ad=${blogList.blogs[index].url}");

                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SimpleWebView(
                                                        url: banneradUrl,
                                                        heading: "")));
                                        var adClickResponse = await ApiProvider()
                                            .fireApiWithParams(
                                                'https://www.bebuzee.com/api/click_ads.php',
                                                params: {
                                              "data_id": bannerid,
                                              "ad_type": 'banner',
                                              "user_id": CurrentUser()
                                                  .currentUser
                                                  .memberID
                                            }).then((value) => value);
                                        print(
                                            "ad clic response=${adClickResponse}");
                                      }),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )

              //  Banner(
              //     message: 'Ad',
              //     location: BannerLocation.topStart,
              //     child: Container(
              //       height: 30.0.h,
              //       child: Column(
              //         children: [
              //           Stack(
              //             children: [
              //               Image(
              //                 image:
              //                     CachedNetworkImageProvider(banneradImage),
              //                 fit: BoxFit.cover,
              //                 width: 100.0.w,
              //               ),
              //               Positioned.fill(
              //                 bottom: 2.0.h,
              //                 child: Align(
              //                   alignment: Alignment.bottomCenter,
              //                   child: Container(
              //                     width: 80.0.w,
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.center,
              //                       mainAxisAlignment: MainAxisAlignment.end,
              //                       children: [
              //                         Text(
              //                           banneradContent,
              //                           style: whiteNormal.copyWith(
              //                               fontSize: 20,
              //                               fontWeight: FontWeight.bold,
              //                               fontFamily: 'Georgie'),
              //                           textAlign: TextAlign.center,
              //                         ),
              //                         TextButton.icon(
              //                             icon:
              //                                 Icon(Icons.arrow_circle_right),
              //                             label: Text(
              //                               banneradButton,
              //                               style: whiteNormal.copyWith(
              //                                   fontSize: 20,
              //                                   color: Colors.black,
              //                                   fontWeight: FontWeight.bold,
              //                                   fontFamily: 'Georgie'),
              //                               textAlign: TextAlign.center,
              //                             ),
              //                             style: ButtonStyle(
              //                                 padding:
              //                                     MaterialStateProperty.all<EdgeInsets>(
              //                                         EdgeInsets.all(15)),
              //                                 backgroundColor:
              //                                     MaterialStateProperty.all<Color>(
              //                                         Colors.amber),
              //                                 foregroundColor:
              //                                     MaterialStateProperty.all<Color>(
              //                                         Colors.black),
              //                                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //                                     RoundedRectangleBorder(
              //                                         borderRadius:
              //                                             BorderRadius.circular(18.0),
              //                                         side: BorderSide(color: Colors.amber)))),
              //                             onPressed: () {
              //                               // print(
              //                               //     "urll of ad=${blogList.blogs[index].url}");
              //                               Navigator.of(context).push(
              //                                   MaterialPageRoute(
              //                                       builder: (context) =>
              //                                           SimpleWebView(
              //                                               url: banneradUrl,
              //                                               heading: "")));
              //                             }),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   )
              : Container(),
          isBlogLoaded == true
              ? ExpandedBlogCard(
                  personalblog: widget.personalblog,
                  totlangcode: totlangcode,
                  langcode: langcode,
                  setNavbar: widget.setNavBar,
                  delete: () {
                    deleteBlog(blogId!);
                    ToastMessage().toastMessage(
                        AppLocalizations.of(
                          "Blog Deleted Successfully",
                        ),
                        14.0);

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  from: widget.from,
                  onTap: () {
                    setState(() {
                      OtherUser().otherUser.memberID = memberID!;
                      OtherUser().otherUser.shortcode = shortcode!;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePageMain(
                                  setNavBar: widget.setNavBar,
                                  isChannelOpen: widget.isChannelOpen,
                                  changeColor: widget.changeColor,
                                  otherMemberID: memberID,
                                )));
                  },
                  blogId: blogId,
                  memberID: memberID,
                  shortcode: shortcode,
                  blogContent: blogContent == " " || blogContent == ""
                      ? blogDesc
                      : blogContent,
                  image: image,
                  views: views,
                  blogCategory: blogCategory,
                  blogTitle: blogTitle,
                  byUser: byUser,
                  timeStamp: timeStamp,
                  videoUrl: videoUrl,
                  videPoster: videPoster,
                  video: video,
                  referenceLink: referenceLink,
                  blogKeyword: blogKeyword,
                  fullUrl: fullUrl,
                  fb: fb,
                  whatsapp: whatsapp,
                  twitter: twitter,
                  keywordList: keywordList,
                  pinterest: pinterest,
                  blogDesc: blogDesc)
              : SkeletonAnimation(
                  child: Container(
                  height: 250,
                  color: Colors.transparent,
                )),
          isBlogLoaded == true && blogcomment != null
              ? LikeAndCommentBar()
              : Container(),
          areRelatedBlogsLoaded == true && widget.from != "personal"
              ? Column(
                  children: blogList!.blogs
                      .asMap()
                      .map((i, value) =>

                          // value.category == 'banner'
                          // ? MapEntry(
                          //     i,
                          //     Banner(
                          //       message: 'Sponsored',
                          //       location: BannerLocation.topStart,
                          //       child: Container(
                          //         child: Column(
                          //           children: [
                          //             Stack(
                          //               children: [
                          //                 Image(
                          //                   image: CachedNetworkImageProvider(
                          //                       value.image),
                          //                   fit: BoxFit.cover,
                          //                   width: 100.0.w,
                          //                 ),
                          //                 Positioned.fill(
                          //                   bottom: 2.0.h,
                          //                   child: Align(
                          //                     alignment:
                          //                         Alignment.bottomCenter,
                          //                     child: Container(
                          //                       width: 80.0.w,
                          //                       child: Column(
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment
                          //                                 .center,
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment.end,
                          //                         children: [
                          //                           Text(
                          //                             value.blogTitle,
                          //                             style: whiteNormal
                          //                                 .copyWith(
                          //                                     fontSize: 20,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .bold,
                          //                                     fontFamily:
                          //                                         'Georgie'),
                          //                             textAlign:
                          //                                 TextAlign.center,
                          //                           ),
                          //                           TextButton.icon(
                          //                               icon: Icon(Icons
                          //                                   .arrow_circle_right),
                          //                               label: Text(
                          //                                 value.userUrl,
                          //                                 style: whiteNormal.copyWith(
                          //                                     fontSize: 20,
                          //                                     color: Colors
                          //                                         .black,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .bold,
                          //                                     fontFamily:
                          //                                         'Georgie'),
                          //                                 textAlign: TextAlign
                          //                                     .center,
                          //                               ),
                          //                               style: ButtonStyle(
                          //                                   padding: MaterialStateProperty.all<EdgeInsets>(
                          //                                       EdgeInsets.all(
                          //                                           15)),
                          //                                   backgroundColor: MaterialStateProperty.all<Color>(
                          //                                       Colors.amber),
                          //                                   foregroundColor: MaterialStateProperty.all<Color>(
                          //                                       Colors.black),
                          //                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          //                                       RoundedRectangleBorder(
                          //                                           borderRadius:
                          //                                               BorderRadius.circular(18.0),
                          //                                           side: BorderSide(color: Colors.amber)))),
                          //                               onPressed: () {
                          //                                 print(
                          //                                     "urll of ad=${value.url}");
                          //                                 Navigator.of(context).push(MaterialPageRoute(
                          //                                     builder: (context) =>
                          //                                         SimpleWebView(
                          //                                             url: value
                          //                                                 .url,
                          //                                             heading:
                          //                                                 "")));
                          //                               }),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   )
                          // :
                          MapEntry(
                              i,
                              RelatedBlogCard(
                                index: i,
                                blog: blogList!.blogs[i],
                              )))
                      .values
                      .toList(),
                )
              : Container(),
        ],
      ),
      // bottomNavigationBar: widget.setNavBar == null
      //     ? BottomAppBar(
      //         elevation: 1,
      //         color: Colors.pink,
      //         child:
      //             Container(height: kToolbarHeight, width: double.infinity),
      //       )
      //     : null
    );
  }
}
