import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/view/shortbuz_main_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../services/current_user.dart';

class ShortbuzSearchView extends StatefulWidget {
  const ShortbuzSearchView({Key? key}) : super(key: key);

  @override
  State<ShortbuzSearchView> createState() => _ShortbuzSearchViewState();
}

class _ShortbuzSearchViewState extends State<ShortbuzSearchView> {
  late ShortbuzSearchController controller;

  @override
  void initState() {
    controller = Get.put(ShortbuzSearchController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget customCardSuggestion(String suggestion) {
      return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShortbuzMainPage(
                  // profileOpen:
                  //     widget.profileOpen,
                  // setNavBar: widget.setNavBar,
                  // isChannelOpen:
                  //     widget.isChannelOpen,
                  // changeColor:
                  //     widget.changeColor,
                  from: "discover",
                  keyword: suggestion,
                  // postID: posts
                  //     .feeds[index - 1]
                  //     .postId,
                ),
              ));
        },
        leading: Container(
          height: 5.0.h,
          width: 10.0.w,
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
        ),
        title: Text(
          '${suggestion}',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'DomaineDisplay'),
        ),
      );
    }

    Widget customCard(ShortbuzCatModel shortbuzCatModel) {
      return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShortbuzMainPage(
                  // profileOpen:
                  //     widget.profileOpen,
                  // setNavBar: widget.setNavBar,
                  // isChannelOpen:
                  //     widget.isChannelOpen,
                  // changeColor:
                  //     widget.changeColor,
                  from: "discover",
                  keyword: shortbuzCatModel.title,
                  // postID: posts
                  //     .feeds[index - 1]
                  //     .postId,
                ),
              ));
        },
        leading: Container(
          height: 5.0.h,
          width: 10.0.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                fit: BoxFit.contain,
                image: CachedNetworkImageProvider(shortbuzCatModel.icon)),
            color: Colors.white,
          ),
        ),
        title: Text(
          '${shortbuzCatModel.title}',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'DomaineDisplay'),
        ),
      );
    }

    Widget customTextBox() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 70, 65, 65),
              borderRadius: BorderRadius.circular(20)),
          child: TextField(
            cursorColor: Colors.white,
            enabled: true,
            onChanged: (v) {
              controller.search.value = v;
            },
            style: TextStyle(
                fontFamily: 'LeagueSpartan',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12),
            decoration: InputDecoration(
              focusColor: Color.fromARGB(255, 70, 65, 65),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 70, 65, 65),
                      width: 2,
                      style: BorderStyle.solid)),
              fillColor: Color.fromARGB(255, 70, 65, 65),
              // filled: true,
              disabledBorder: InputBorder.none,
              hintText: 'Search shortbuz',
              hintStyle: TextStyle(
                  fontFamily: 'LeagueSpartanMedium',
                  color: Colors.white,
                  fontWeight: FontWeight.w100),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
        ),
      );
    }

    Widget searchBar() {
      return Stack(
        alignment: Alignment.centerLeft,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.centerLeft,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.height * 0.6,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      size: 30,
                    ),
                  ),
                  Text('Search shortbuz',
                      style: TextStyle(color: Colors.black, fontSize: 15)),
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
            ),
          ),
        ],
      );
    }

    Widget tagCard(String shorbuzTags) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShortbuzMainPage(
                    // profileOpen:
                    //     widget.profileOpen,
                    // setNavBar: widget.setNavBar,
                    // isChannelOpen:
                    //     widget.isChannelOpen,
                    // changeColor:
                    //     widget.changeColor,
                    from: "discover",
                    keyword: shorbuzTags,
                    // postID: posts
                    //     .feeds[index - 1]
                    //     .postId,
                  ),
                ));
          },
          child: Container(
            // height: 0.5.h,
            // width: 24.0.w,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Text('   #${shorbuzTags}     ',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'DomaineDisplay')),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 26, 25, 25),
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            title: customTextBox(),
            centerTitle: true,

            // actions: [Icon(Icons.mic)],
            // bottom: AppBar(
            //   centerTitle: true,
            //   elevation: 0,
            //   leadingWidth: 0,
            //   toolbarHeight: kToolbarHeight,
            //   backgroundColor: Color.fromARGB(255, 26, 25, 25),
            //   title: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: controller.shortbuztaglist.value.length == 0
            //         ? Container()
            //         : Container(
            //             height: 5.5.h,
            //             child: ListView(
            //               scrollDirection: Axis.horizontal,
            //               shrinkWrap: true,
            //               children: [
            //                 Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Container(
            //                     height: 0.5.h,
            //                     width: 20.0.w,
            //                     decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         borderRadius: BorderRadius.circular(30)),
            //                     child: Center(
            //                       child: Text('#fashion',
            //                           style: TextStyle(
            //                               fontSize: 12,
            //                               color: Colors.black,
            //                               fontFamily: 'DomaineDisplay',
            //                               fontWeight: FontWeight.bold)),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Container(
            //                     height: 0.5.h,
            //                     width: 20.0.w,
            //                     decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         borderRadius: BorderRadius.circular(30)),
            //                     child: Center(
            //                       child: Text('#art',
            //                           style: TextStyle(
            //                               fontSize: 12,
            //                               color: Colors.black,
            //                               fontFamily: 'DomaineDisplay',
            //                               fontWeight: FontWeight.bold)),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Container(
            //                     height: 0.5.h,
            //                     width: 20.0.w,
            //                     decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         borderRadius: BorderRadius.circular(30)),
            //                     child: Center(
            //                       child: Text('#comedy',
            //                           style: TextStyle(
            //                               fontSize: 12,
            //                               color: Colors.black,
            //                               fontFamily: 'DomaineDisplay',
            //                               fontWeight: FontWeight.bold)),
            //                     ),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Container(
            //                     height: 0.5.h,
            //                     width: 20.0.w,
            //                     decoration: BoxDecoration(
            //                         color: Colors.white,
            //                         borderRadius: BorderRadius.circular(30)),
            //                     child: Center(
            //                       child: Text('#photography',
            //                           style: TextStyle(
            //                               fontSize: 12,
            //                               color: Colors.black,
            //                               fontFamily: 'DomaineDisplay',
            //                               fontWeight: FontWeight.bold)),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             )),
            //   ),
            // ),
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: Colors.white)),
            backgroundColor: Color.fromARGB(255, 26, 25, 25)),
        body: Container(
            height: 100.0.h,
            width: 100.0.w,
            child: SingleChildScrollView(
              child: Obx(
                () => Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: controller.shortbuztaglist.value.length == 0
                        ? Container()
                        : Container(
                            height: 5.5.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: controller.shortbuztaglist.length,
                              itemBuilder: (context, index) =>
                                  tagCard(controller.shortbuztaglist[index]),
                              // children: [
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Container(
                              //       height: 0.5.h,
                              //       width: 24.0.w,
                              //       decoration: BoxDecoration(
                              //           color: Colors.white,
                              //           borderRadius:
                              //               BorderRadius.circular(30)),
                              //       child: Center(
                              //         child: Text('#fashion',
                              //             style: TextStyle(
                              //                 fontSize: 15,
                              //                 color: Colors.black,
                              //                 fontFamily: 'DomaineDisplay',
                              //                 fontWeight: FontWeight.bold)),
                              //       ),
                              //     ),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Container(
                              //       height: 0.5.h,
                              //       width: 24.0.w,
                              //       decoration: BoxDecoration(
                              //           color: Colors.white,
                              //           borderRadius:
                              //               BorderRadius.circular(30)),
                              //       child: Center(
                              //         child: Text('#art',
                              //             style: TextStyle(
                              //                 fontSize: 13,
                              //                 color: Colors.black,
                              //                 fontFamily: 'DomaineDisplay',
                              //                 fontWeight: FontWeight.bold)),
                              //       ),
                              //     ),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Container(
                              //       height: 0.5.h,
                              //       width: 25.0.w,
                              //       decoration: BoxDecoration(
                              //           color: Colors.white,
                              //           borderRadius:
                              //               BorderRadius.circular(30)),
                              //       child: Center(
                              //         child: Text('#comedy',
                              //             style: TextStyle(
                              //                 fontSize: 13,
                              //                 color: Colors.black,
                              //                 fontFamily: 'DomaineDisplay',
                              //                 fontWeight: FontWeight.bold)),
                              //       ),
                              //     ),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: Container(
                              //       height: 0.5.h,
                              //       width: 24.0.w,
                              //       decoration: BoxDecoration(
                              //           color: Colors.white,
                              //           borderRadius:
                              //               BorderRadius.circular(30)),
                              //       child: Center(
                              //         child: Text('#photography',
                              //             style: TextStyle(
                              //                 fontSize: 13,
                              //                 color: Colors.black,
                              //                 fontFamily: 'DomaineDisplay',
                              //                 fontWeight: FontWeight.bold)),
                              //       ),
                              //     ),
                              //   ),
                              // ],
                            )),
                  ),
                  controller.shortbuzsuggestionlist.value.length == 0 ||
                          controller.search.value == ''
                      ? Container()
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              controller.shortbuzsuggestionlist.value.length,
                          itemBuilder: (context, index) => customCardSuggestion(
                              controller.shortbuzsuggestionlist.value[index])),
                  controller.shortbuzcatlist.value.length == 0
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.shortbuzcatlist.value.length,
                          itemBuilder: (context, index) => customCard(
                              controller.shortbuzcatlist.value[index])),
                ]),
              ),
            )));
  }
}

class ShortbuzSearchController extends GetxController {
  var url =
      'https://www.bebuzee.com/api/shortbuz/shortbuzCategory?country=${CurrentUser().currentUser.country}';
  var search = ''.obs;
  var shortbuzcatlist = <ShortbuzCatModel>[].obs;
  var shortbuztaglist = <String>[].obs;
  var shortbuzsuggestionlist = <String>[].obs;
  void getData() async {
    print("short data");
    try {
      var response = await ApiProvider().fireApi(url).then((value) => value);
      var data = response.data;
      print("short data=${data['data'].length}");

      List<ShortbuzCatModel> list = [];
      if (data != null) {
        data['data'].forEach((e) {
          var dat = ShortbuzCatModel.fromJson(e);
          list.add(dat);
        });

        print("short data list=${list.length}");
        shortbuzcatlist.value = list;
      } else {}
    } catch (e) {
      print('short data $e');
    }
  }

  void getTags() async {
    print("short data");
    try {
      var response = await ApiProvider()
          .fireApi(
              'https://www.bebuzee.com/api/shortbuz/hashtagList?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}')
          .then((value) => value);
      var data = response.data;
      print("short data=${data['data'].length}");

      List<String> list = [];
      if (data != null) {
        data['data'].forEach((e) {
          var dat = e;
          list.add(dat);
        });

        print("short data list=${list.length}");
        shortbuztaglist.value = list;
      } else {}
    } catch (e) {
      print('short data $e');
    }
  }

  void getSuggestions(key) async {
    print("short data");
    try {
      var response = await ApiProvider()
          .fireApi(
              'https://www.bebuzee.com/api/shortbuz/searchSuggestion?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&search=$key')
          .then((value) => value);
      var data = response.data;
      print("short data=${data['data'].length}");

      List<String> list = [];
      if (data != null) {
        data['data'].forEach((e) {
          var dat = e;
          list.add(dat);
        });

        print("short data list=${list.length}");
        shortbuzsuggestionlist.value = list;
      } else {}
    } catch (e) {
      shortbuzsuggestionlist.value = [];
      print('short data $e');
    }
  }

  @override
  void onInit() {
    getTags();
    getData();
    debounce(search, (callback) async {
      if (search.value.isNotEmpty) getSuggestions(search.value);
    }, time: Duration(milliseconds: 500));
    super.onInit();
  }
}

class ShortbuzCatModel {
  String id;
  String title;
  String titleIt;
  String icon;
  ShortbuzCatModel(
      {this.id = '', this.title = '', this.titleIt = '', this.icon = ''});
  factory ShortbuzCatModel.fromJson(json) {
    return ShortbuzCatModel(
        id: json['id'].toString(),
        title: json['title'],
        icon: json['icon'],
        titleIt: json['title_it']);
  }
}

class ShorbuzTags {
  ShorbuzTags({
    required this.postId,
    required this.blogId,
    required this.postType,
    required this.video,
    required this.postVideoData,
    required this.color,
    required this.boostData,
    required this.boostedCount,
    required this.boostedButton,
    required this.boostedTitle,
    required this.boostedLink,
    required this.boostedDomain,
    required this.boostedDescription,
    required this.postTotalReach,
    required this.postTotalEngagement,
    required this.postPromotePost,
    required this.postViewInsight,
    required this.postPromotedSlider,
    required this.postContent,
    required this.blogContent,
    required this.postBlogCategory,
    required this.postBlogData,
    required this.postPostbyuser,
    required this.postPostonuser,
    required this.postUserId,
    required this.postUserFirstname,
    required this.postUserLastname,
    required this.postUserName,
    required this.postUserPicture,
    required this.postHeaderImage,
    required this.postShortcode,
    required this.postHeaderUrl,
    required this.postNumViews,
    required this.postTotalLikes,
    required this.postTotalComments,
    required this.postLikeIcon,
    required this.postCommentIcon,
    required this.postImgData,
    required this.thumbnailUrl,
    required this.postImgSmall,
    required this.postVideoThumb,
    required this.postMultiImage,
    required this.postRebuz,
    required this.postRebuzData,
    required this.postHeaderLocation,
    required this.postUrlData,
    required this.postUrlNam,
    required this.postDomainName,
    required this.postUrlToShare,
    required this.postCommentResult,
    required this.postEmbedData,
    required this.postVideoHeight,
    required this.postVideoWidth,
    required this.postVideoReso,
    required this.postDataLong,
    required this.postDataLat,
    required this.postImageWidth,
    required this.postImageHeight,
    required this.videoTag,
    required this.videoTaggedDetails,
    required this.postTaggedData,
    required this.postTaggedDataDetails,
    required this.postSingle,
    required this.cropped,
    required this.varified,
    required this.position,
    required this.stickers,
    required this.timeStamp,
    required this.postDate,
    required this.page,
  });
  late final int postId;
  late final int blogId;
  late final String postType;
  late final String video;
  late final String postVideoData;
  late final String color;
  late final int boostData;
  late final int boostedCount;
  late final String boostedButton;
  late final String boostedTitle;
  late final String boostedLink;
  late final String boostedDomain;
  late final String boostedDescription;
  late final int postTotalReach;
  late final int postTotalEngagement;
  late final String postPromotePost;
  late final String postViewInsight;
  late final int postPromotedSlider;
  late final String postContent;
  late final String blogContent;
  late final String postBlogCategory;
  late final String postBlogData;
  late final int postPostbyuser;
  late final int postPostonuser;
  late final int postUserId;
  late final String postUserFirstname;
  late final String postUserLastname;
  late final String postUserName;
  late final String postUserPicture;
  late final String postHeaderImage;
  late final String postShortcode;
  late final String postHeaderUrl;
  late final int postNumViews;
  late final String postTotalLikes;
  late final int postTotalComments;
  late final String postLikeIcon;
  late final String postCommentIcon;
  late final String postImgData;
  late final String thumbnailUrl;
  late final String postImgSmall;
  late final String postVideoThumb;
  late final int postMultiImage;
  late final int postRebuz;
  late final String postRebuzData;
  late final String postHeaderLocation;
  late final int postUrlData;
  late final String postUrlNam;
  late final String postDomainName;
  late final String postUrlToShare;
  late final String postCommentResult;
  late final String postEmbedData;
  late final int postVideoHeight;
  late final int postVideoWidth;
  late final String postVideoReso;
  late final String postDataLong;
  late final String postDataLat;
  late final int postImageWidth;
  late final int postImageHeight;
  late final int videoTag;
  late final String videoTaggedDetails;
  late final int postTaggedData;
  late final String postTaggedDataDetails;
  late final int postSingle;
  late final int cropped;
  late final String varified;
  late final List<dynamic> position;
  late final List<dynamic> stickers;
  late final String timeStamp;
  late final String postDate;
  late final int page;

  ShorbuzTags.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    blogId = json['blog_id'];
    postType = json['post_type'];
    video = json['video'];
    postVideoData = json['post_video_data'];
    color = json['color'];
    boostData = json['boost_data'];
    boostedCount = json['boosted_count'];
    boostedButton = json['boosted_button'];
    boostedTitle = json['boosted_title'];
    boostedLink = json['boosted_link'];
    boostedDomain = json['boosted_domain'];
    boostedDescription = json['boosted_description'];
    postTotalReach = json['post_total_reach'];
    postTotalEngagement = json['post_total_engagement'];
    postPromotePost = json['post_promote_post'];
    postViewInsight = json['post_view_insight'];
    postPromotedSlider = json['post_promoted_slider'];
    postContent = json['post_content'];
    blogContent = json['blog_content'];
    postBlogCategory = json['post_blog_category'];
    postBlogData = json['post_blog_data'];
    postPostbyuser = json['post_postbyuser'];
    postPostonuser = json['post_postonuser'];
    postUserId = json['post_user_id'];
    postUserFirstname = json['post_user_firstname'];
    postUserLastname = json['post_user_lastname'];
    postUserName = json['post_user_name'];
    postUserPicture = json['post_user_picture'];
    postHeaderImage = json['post_header_image'];
    postShortcode = json['post_shortcode'];
    postHeaderUrl = json['post_header_url'];
    postNumViews = json['post_num_views'];
    postTotalLikes = json['post_total_likes'];
    postTotalComments = json['post_total_comments'];
    postLikeIcon = json['post_like_icon'];
    postCommentIcon = json['post_comment_icon'];
    postImgData = json['post_img_data'];
    thumbnailUrl = json['thumbnail_url'];
    postImgSmall = json['post_img_small'];
    postVideoThumb = json['post_video_thumb'];
    postMultiImage = json['post_multi_image'];
    postRebuz = json['post_rebuz'];
    postRebuzData = json['post_rebuz_data'];
    postHeaderLocation = json['post_header_location'];
    postUrlData = json['post_url_data'];
    postUrlNam = json['post_url_nam'];
    postDomainName = json['post_domain_name'];
    postUrlToShare = json['post_url_to_share'];
    postCommentResult = json['post_comment_result'];
    postEmbedData = json['post_embed_data'];
    postVideoHeight = json['post_video_height'];
    postVideoWidth = json['post_video_width'];
    postVideoReso = json['post_video_reso'];
    postDataLong = json['post_data_long'];
    postDataLat = json['post_data_lat'];
    postImageWidth = json['post_image_width'];
    postImageHeight = json['post_image_height'];
    videoTag = json['video_tag'];
    videoTaggedDetails = json['video_tagged_details'];
    postTaggedData = json['post_tagged_data'];
    postTaggedDataDetails = json['post_tagged_data_details'];
    postSingle = json['post_single'];
    cropped = json['cropped'];
    varified = json['varified'];
    position = List.castFrom<dynamic, dynamic>(json['position']);
    stickers = List.castFrom<dynamic, dynamic>(json['stickers']);
    timeStamp = json['time_stamp'];
    postDate = json['post_date'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['post_id'] = postId;
    _data['blog_id'] = blogId;
    _data['post_type'] = postType;
    _data['video'] = video;
    _data['post_video_data'] = postVideoData;
    _data['color'] = color;
    _data['boost_data'] = boostData;
    _data['boosted_count'] = boostedCount;
    _data['boosted_button'] = boostedButton;
    _data['boosted_title'] = boostedTitle;
    _data['boosted_link'] = boostedLink;
    _data['boosted_domain'] = boostedDomain;
    _data['boosted_description'] = boostedDescription;
    _data['post_total_reach'] = postTotalReach;
    _data['post_total_engagement'] = postTotalEngagement;
    _data['post_promote_post'] = postPromotePost;
    _data['post_view_insight'] = postViewInsight;
    _data['post_promoted_slider'] = postPromotedSlider;
    _data['post_content'] = postContent;
    _data['blog_content'] = blogContent;
    _data['post_blog_category'] = postBlogCategory;
    _data['post_blog_data'] = postBlogData;
    _data['post_postbyuser'] = postPostbyuser;
    _data['post_postonuser'] = postPostonuser;
    _data['post_user_id'] = postUserId;
    _data['post_user_firstname'] = postUserFirstname;
    _data['post_user_lastname'] = postUserLastname;
    _data['post_user_name'] = postUserName;
    _data['post_user_picture'] = postUserPicture;
    _data['post_header_image'] = postHeaderImage;
    _data['post_shortcode'] = postShortcode;
    _data['post_header_url'] = postHeaderUrl;
    _data['post_num_views'] = postNumViews;
    _data['post_total_likes'] = postTotalLikes;
    _data['post_total_comments'] = postTotalComments;
    _data['post_like_icon'] = postLikeIcon;
    _data['post_comment_icon'] = postCommentIcon;
    _data['post_img_data'] = postImgData;
    _data['thumbnail_url'] = thumbnailUrl;
    _data['post_img_small'] = postImgSmall;
    _data['post_video_thumb'] = postVideoThumb;
    _data['post_multi_image'] = postMultiImage;
    _data['post_rebuz'] = postRebuz;
    _data['post_rebuz_data'] = postRebuzData;
    _data['post_header_location'] = postHeaderLocation;
    _data['post_url_data'] = postUrlData;
    _data['post_url_nam'] = postUrlNam;
    _data['post_domain_name'] = postDomainName;
    _data['post_url_to_share'] = postUrlToShare;
    _data['post_comment_result'] = postCommentResult;
    _data['post_embed_data'] = postEmbedData;
    _data['post_video_height'] = postVideoHeight;
    _data['post_video_width'] = postVideoWidth;
    _data['post_video_reso'] = postVideoReso;
    _data['post_data_long'] = postDataLong;
    _data['post_data_lat'] = postDataLat;
    _data['post_image_width'] = postImageWidth;
    _data['post_image_height'] = postImageHeight;
    _data['video_tag'] = videoTag;
    _data['video_tagged_details'] = videoTaggedDetails;
    _data['post_tagged_data'] = postTaggedData;
    _data['post_tagged_data_details'] = postTaggedDataDetails;
    _data['post_single'] = postSingle;
    _data['cropped'] = cropped;
    _data['varified'] = varified;
    _data['position'] = position;
    _data['stickers'] = stickers;
    _data['time_stamp'] = timeStamp;
    _data['post_date'] = postDate;
    _data['page'] = page;
    return _data;
  }
}
