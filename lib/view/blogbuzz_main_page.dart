import 'dart:async';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/add_multiple_stories_model.dart';
import 'package:bizbultest/models/blogbuzz_list_model.dart';
import 'package:bizbultest/models/blogbuzz_model.dart';
import 'package:bizbultest/services/Blogs/blog_api_calls.dart';
import 'package:bizbultest/services/Blogs/blogbuzz_category_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/common_appbar.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/view/blogbuzz_single_category_page.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/widgets/Blogbuz/detailed_category_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../utilities/simple_web_view.dart';
import 'Profile/profile_settings_page.dart';

class BlogBuzzMainPage extends StatefulWidget {
  final String? logo;
  final String? memberID;
  final String? country;
  final String? currentMemberImage;
  final bool? isMemberLoaded;
  final ScrollController? scrollController;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final Function? setNavbar;
  final Function? refresh;
  final Function? refreshFromShortbuz;
  final Function? refreshFromMultipleStories;

  const BlogBuzzMainPage(
      {Key? key,
      this.logo,
      this.memberID,
      this.country,
      this.currentMemberImage,
      this.isMemberLoaded,
      this.scrollController,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.setNavbar,
      this.refresh,
      this.refreshFromShortbuz,
      this.refreshFromMultipleStories})
      : super(key: key);

  @override
  _BlogBuzzMainPageState createState() => _BlogBuzzMainPageState();
}

class _BlogBuzzMainPageState extends State<BlogBuzzMainPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Blogs blogList = new Blogs([]);
  Categories categoryList = Categories([]);
  var isBannerLoaded = false;
  var banneradImage = '';
  var banneradButton = '';
  var banneradUrl = '';
  var banneradContent = '';
  var bannerid = '';
  late Future _blogsFuture;
  var currentUrlStr = "";
  void _getCategoryList() {
    BlogApiCalls.getBlogCategoryList().then((value) {
      setState(() {
        categoryList.categories = value.categories;
        print("i am here blog");
      });
      print('_categoryList=${categoryList.categories}');
      return value;
    });
  }

  void _getCategoryListLocal() {
    BlogApiCalls.getBlogCategoryListLocal().then((value) {
      setState(() {
        categoryList.categories = value.categories;
        print("boubia catlist=${categoryList.categories}");
      });
      _getCategoryList();
      return value;
    });
  }

  void _getLocalBlogs() {
    _blogsFuture = BlogApiCalls.getBlogsLocal(context).then((value) {
      setState(() {
        blogList.blogs = value.blogs;
      });

      _getBlogs();
      return value;
    });
  }

  void _getBlogs() {
    _blogsFuture = BlogApiCalls.getBlogs(context).then((value) {
      setState(() {
        blogList.blogs = value.blogs;
      });
      print('_blogFuture=$_blogsFuture');
      return value;
    });
  }

  void _onRefresh() {
    currentUrlStr = "";
    _getBlogs();
    _refreshController.refreshCompleted();
  }

  Future<Blogs?> onLoading(Blogs blogList, BuildContext context,
      RefreshController _refreshController,
      {currentUrlStr: ""}) async {
    int len = blogList.blogs.length;
    String urlStr = "";

    for (int i = 0; i < len; i++) {
      var blogcategory = blogList.blogs[i].category;
      if (blogList.blogs[i].category == 'banner') {
      } else {
        blogcategory = blogcategory!.replaceFirst('&', '@');
        urlStr += blogcategory;
        if (i != len - 1) {
          urlStr += ",";
        }
      }
    }

    try {
      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/blog/list?action=blogbuz_data&country=${CurrentUser().currentUser.country}&category_data=$currentUrlStr');
      print("onLoading  aha $newurl");
      var client = Dio();
      String? token =
          await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
      return await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        print("getblogs output ${value.data}");

        if (value.statusCode == 200) {
          Blogs blogData = Blogs.fromJson(value.data['data']);
          await Future.wait(blogData.blogs
              .map((e) => Preload.cacheImage(context, e.image!))
              .toList());
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString("all_blogs", value.data['data'].toString());
          _refreshController.loadComplete();
          return blogData;
        } else {
          _refreshController.loadComplete();
          return Blogs([]);
        }
      });

      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php");

      // final response = await http.post(url, body: {
      //   "country": CurrentUser().currentUser.country,
      //   "category_data": urlStr.split(',').last,
      //   "action": "blogbuz_data",
      // });
      // if (response!.statusCode == 200 &&
      //     response!.body != null &&
      //     response!.body != "" &&
      //     response!.body != "null") {
      //   Blogs blogData = Blogs.fromJson(jsonDecode(response!.body));
      //   await Future.wait(blogData.blogs
      //       .map((e) => Preload.cacheImage(context, e.image))
      //       .toList());
      //   _refreshController.loadComplete();
      //   return blogData;
      // } else {
      //   _refreshController.loadComplete();
      //   return Blogs([]);
      // }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't load blog",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _refreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          // return object of type Dialog
          return Container();
        },
      );
    }
    _refreshController.loadComplete();
    return null;
  }

  void _onLoading() async {
    int len = blogList.blogs.length;
    var urlStr = "";
    print("bia onloading called length=${len}");
    for (int i = 0; i < len; i++) {
      if (blogList.blogs[i].category == 'banner') continue;

      var blogcategory = blogList.blogs[i].category;
      print("bia on loading ${blogcategory}");
      blogcategory = blogcategory!.replaceFirst('&', '@');
      urlStr += blogcategory;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    print(
        "bia on prev urlstr=${urlStr} substrin=${urlStr.endsWith(',') ? urlStr.substring(0, urlStr.length - 1) : urlStr}");
    urlStr =
        urlStr.endsWith(',') ? urlStr.substring(0, urlStr.length - 1) : urlStr;

    urlStr = urlStr.split(',').last;

    print("bia on current url=${currentUrlStr} urlstr=${urlStr}");
    if (currentUrlStr != urlStr) {
      currentUrlStr = urlStr.split(',').last;
    } else
      return;
    print("bia on reached here");
    Blogs? blogData = await BlogApiCalls.onLoading(
        blogList, context, _refreshController,
        currentUrlStr: currentUrlStr);
    if (blogData != null) {
      // var tempurlStr = "";
      // for (int i = 0; i < len; i++) {
      //   var blogcategory = blogData.blogs[i].category;
      //   blogcategory = blogcategory.replaceFirst('&', '@');
      //   tempurlStr += blogcategory;
      //   if (i != len - 1) {
      //     tempurlStr += ",";
      //   }
      // }
      setState(() {
        // print("tempUrlStr=${tempurlStr.split(',').last}");
        // currentUrlStr = tempurlStr.split(',').last;
        blogList.blogs.addAll(blogData.blogs);
      });
    }
  }

  Future getAdBanner() async {
    var url =
        'https://www.bebuzee.com/api/campaign/singleBannerAds?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}';
    print("url of banner ad=${url}");
    var response = await ApiProvider().fireApi(url).then((value) => value);
    setState(() {
      isBannerLoaded = true;
      banneradImage = 'image';
      banneradButton = 'category_val';
      banneradUrl = response!.data['url'];
      banneradContent = response!.data['post_content'];
      bannerid = response!.data['blog_id'].toString();
    });
    print("response=${response!.data}");
  }

  @override
  void initState() {
    _getCategoryListLocal();
    // _getLocalBlogs();
    print("here blog ${blogList.blogs}");
    // getAdBanner();
    _getBlogs();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<BlogBuzzCategoryController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          elevation: 0,
          profileButton: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSettingsPage(
                  setNavbar: widget.setNavBar!,
                ),
              ),
            );
          },
          logo: widget.logo,
          country: widget.country,
          memberID: widget.memberID,
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _blogsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return NotificationListener<UserScrollNotification>(
                onNotification: (v) {
                  if (v.direction == ScrollDirection.reverse) {
                    _onLoading();
                  }
                  return true;
                },
                child: SmartRefresher(
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
                      builder: (BuildContext context, LoadStatus? mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Center(
                              child: Text(
                            "",
                          ));
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
                            AppLocalizations.of("No more Data"),
                          );
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: (blogList.blogs.length > 0)
                        ? ListView.builder(
                            controller: widget.scrollController,
                            itemCount: blogList.blogs.length,
                            itemBuilder: (context, index) {
                              var blog = blogList.blogs[index];
                              print("blogaaaa ${blog.url}");

                              return Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  (blogList.blogs[index].category == 'banner')
                                      ? Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Card(
                                              elevation: 0.5.h,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 1.5.h,
                                                    vertical: 2.0.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Image(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              blogList
                                                                  .blogs[index]
                                                                  .image!),
                                                      fit: BoxFit.cover,
                                                      width: 35.0.w,
                                                      height: 50.0.w,
                                                    ),
                                                    Container(
                                                      width: 55.0.w,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        1.5.h),
                                                            child: Text(
                                                              blogList
                                                                          .blogs[
                                                                              index]
                                                                          .postContent ==
                                                                      ""
                                                                  ? "Test Ad Bebuzee"
                                                                  : blogList
                                                                      .blogs[
                                                                          index]
                                                                      .postContent!,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                  fontFamily:
                                                                      'Georgie'),
                                                            ),
                                                          ),
                                                          Wrap(
                                                            children: [
                                                              Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        'Sponsored',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                1.5.h,
                                                                            color: Colors.black.withOpacity(0.6),
                                                                            fontFamily: 'Arial'),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            1.0.w,
                                                                      ),
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(1.0.w),
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Colors.amber,
                                                                          child: Text(
                                                                              'AD',
                                                                              style: TextStyle(fontWeight: FontWeight.w600)),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                              // Padding(
                                                              //   padding:
                                                              //       const EdgeInsets
                                                              //               .all(
                                                              //           8.0),
                                                              //   child:
                                                              //       ClipRRect(
                                                              //     borderRadius:
                                                              //         BorderRadius
                                                              //             .circular(
                                                              //                 1.0.w),
                                                              //     child:
                                                              //         Container(
                                                              //       color: Colors
                                                              //           .amber,
                                                              //       child: Text(
                                                              //           'AD',
                                                              //           style: TextStyle(
                                                              //               fontWeight:
                                                              //                   FontWeight.w600)),
                                                              //     ),
                                                              //   ),
                                                              // ),

                                                              // IconButton(
                                                              //   icon: Icon(Icons.bookmark_border_outlined,
                                                              //       color: Colors.black),
                                                              //   onPressed: () {},
                                                              // )
                                                            ],
                                                          ),
                                                          // TextButton.icon(
                                                          //     icon: Icon(
                                                          //         Icons
                                                          //             .arrow_circle_right,
                                                          //         color: Colors
                                                          //             .white),
                                                          //     label: Text(
                                                          //       blogList
                                                          //           .blogs[
                                                          //               index]
                                                          //           .categoryVal,
                                                          //       style: whiteNormal.copyWith(
                                                          //           fontSize:
                                                          //               2.0.h,
                                                          //           color: Colors
                                                          //               .white,
                                                          //           fontWeight:
                                                          //               FontWeight
                                                          //                   .bold,
                                                          //           fontFamily:
                                                          //               'Georgie'),
                                                          //       textAlign:
                                                          //           TextAlign
                                                          //               .center,
                                                          //     ),
                                                          //     style:
                                                          //         ButtonStyle(
                                                          //             // padding: MaterialStateProperty.all<EdgeInsets>(
                                                          //             //     EdgeInsets.all(
                                                          //             //         2.0.h)),
                                                          //             backgroundColor:
                                                          //                 MaterialStateProperty.all<Color>(HexColor(
                                                          //                     '#0110FF')),
                                                          //             foregroundColor:
                                                          //                 MaterialStateProperty.all<Color>(Colors
                                                          //                     .black),
                                                          //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                          //                 borderRadius: BorderRadius.circular(
                                                          //                     5.0),
                                                          //                 side:
                                                          //                     BorderSide(color: Colors.white)))),
                                                          //     onPressed: () async {
                                                          //       print(
                                                          //           "urll of ad=${blogList.blogs[index].url}");
                                                          //       Navigator.of(context).push(MaterialPageRoute(
                                                          //           builder: (context) => SimpleWebView(
                                                          //               url: blogList
                                                          //                   .blogs[
                                                          //                       index]
                                                          //                   .url,
                                                          //               heading:
                                                          //                   "")));
                                                          //       await ApiProvider()
                                                          //           .fireApiWithParams(
                                                          //               'https://www.bebuzee.com/api/click_ads.php',
                                                          //               params: {
                                                          //             "data_id":
                                                          //                 bannerid,
                                                          //             "ad_type":
                                                          //                 'sponsor',
                                                          //             "user_id": CurrentUser()
                                                          //                 .currentUser
                                                          //                 .memberID
                                                          //           });
                                                          //     }),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            TextButton.icon(
                                                icon: Icon(
                                                    Icons.arrow_circle_right,
                                                    color: Colors.white),
                                                label: Text(
                                                  blogList.blogs[index]
                                                      .categoryVal!,
                                                  style: whiteNormal.copyWith(
                                                      fontSize: 2.0.h,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Georgie'),
                                                  textAlign: TextAlign.center,
                                                ),
                                                style: ButtonStyle(
                                                    // padding: MaterialStateProperty.all<EdgeInsets>(
                                                    //     EdgeInsets.all(
                                                    //         2.0.h)),
                                                    backgroundColor: MaterialStateProperty.all<Color>(
                                                        HexColor('#0110FF')),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.black),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(5.0),
                                                            side: BorderSide(color: Colors.white)))),
                                                onPressed: () async {
                                                  print(
                                                      "urll of ad=${blogList.blogs[index].url}");
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SimpleWebView(
                                                                  url: blogList
                                                                      .blogs[
                                                                          index]
                                                                      .url!,
                                                                  heading:
                                                                      "")));
                                                  await ApiProvider()
                                                      .fireApiWithParams(
                                                          'https://www.bebuzee.com/api/click_ads.php',
                                                          params: {
                                                        "data_id": bannerid,
                                                        "ad_type": 'sponsor',
                                                        "user_id": CurrentUser()
                                                            .currentUser
                                                            .memberID
                                                      });
                                                }),
                                          ],
                                        )

                                      //  Banner(
                                      //     message: 'Ad',
                                      //     location: BannerLocation.topStart,
                                      //     child: Container(
                                      //       child: Column(
                                      //         children: [
                                      //           Stack(
                                      //             children: [
                                      //               Image(
                                      //                 image:
                                      //                     CachedNetworkImageProvider(
                                      //                         blogList
                                      //                             .blogs[index]
                                      //                             .image),
                                      //                 fit: BoxFit.cover,
                                      //                 width: 100.0.w,
                                      //               ),
                                      //               Positioned.fill(
                                      //                 bottom: 2.0.h,
                                      //                 child: Align(
                                      //                   alignment: Alignment
                                      //                       .bottomCenter,
                                      //                   child: Container(
                                      //                     width: 80.0.w,
                                      //                     child: Column(
                                      //                       crossAxisAlignment:
                                      //                           CrossAxisAlignment
                                      //                               .center,
                                      //                       mainAxisAlignment:
                                      //                           MainAxisAlignment
                                      //                               .end,
                                      //                       children: [
                                      //                         Text(
                                      //                           blogList
                                      //                               .blogs[
                                      //                                   index]
                                      //                               .postContent,
                                      //                           style: whiteNormal.copyWith(
                                      //                               fontSize:
                                      //                                   20,
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .bold,
                                      //                               fontFamily:
                                      //                                   'Georgie'),
                                      //                           textAlign:
                                      //                               TextAlign
                                      //                                   .center,
                                      //                         ),
                                      //                         TextButton.icon(
                                      //                             icon: Icon(Icons
                                      //                                 .arrow_circle_right),
                                      //                             label: Text(
                                      //                               blogList
                                      //                                   .blogs[
                                      //                                       index]
                                      //                                   .categoryVal,
                                      //                               style: whiteNormal.copyWith(
                                      //                                   fontSize:
                                      //                                       20,
                                      //                                   color: Colors
                                      //                                       .black,
                                      //                                   fontWeight:
                                      //                                       FontWeight
                                      //                                           .bold,
                                      //                                   fontFamily:
                                      //                                       'Georgie'),
                                      //                               textAlign:
                                      //                                   TextAlign
                                      //                                       .center,
                                      //                             ),
                                      //                             style: ButtonStyle(
                                      //                                 padding: MaterialStateProperty.all<EdgeInsets>(
                                      //                                     EdgeInsets.all(
                                      //                                         15)),
                                      //                                 backgroundColor:
                                      //                                     MaterialStateProperty.all<Color>(Colors
                                      //                                         .amber),
                                      //                                 foregroundColor:
                                      //                                     MaterialStateProperty.all<Color>(Colors
                                      //                                         .black),
                                      //                                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      //                                     borderRadius: BorderRadius.circular(18.0),
                                      //                                     side: BorderSide(color: Colors.amber)))),
                                      //                             onPressed: () {
                                      //                               print(
                                      //                                   "urll of ad=${blogList.blogs[index].url}");
                                      //                               Navigator.of(context).push(MaterialPageRoute(
                                      //                                   builder: (context) => SimpleWebView(
                                      //                                       url:
                                      //                                           blogList.blogs[index].url,
                                      //                                       heading: "")));
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
                                      : BlogBuzzMultipleCategoriesCard(
                                          refreshFromMultipleStories:
                                              widget.refreshFromMultipleStories,
                                          refresh: widget.refresh,
                                          refreshFromShortbuz:
                                              widget.refreshFromShortbuz,
                                          setNavBar: widget.setNavBar,
                                          isChannelOpen: widget.isChannelOpen,
                                          changeColor: widget.changeColor,
                                          firstIndex: index,
                                          categoryList: categoryList.categories,
                                          blog: blog,
                                          index: blog.index,
                                        ),
                                  blogList.blogs[index].category == 'banner'
                                      ? Container()
                                      : (blogList.blogs.length - 1 == index)
                                          ? Positioned(
                                              child: ElevatedButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(FontAwesomeIcons
                                                      .solidEye),
                                                  label: Text('See More')))
                                          : (blogList.blogs[index + 1]
                                                      .category !=
                                                  blogList
                                                      .blogs[index].category)
                                              ? Positioned(
                                                  child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BlogBuzzCategoryMainPage(
                                                                          country: CurrentUser()
                                                                              .currentUser
                                                                              .country,
                                                                          language:
                                                                              "",
                                                                          refreshFromShortbuz:
                                                                              widget.refreshFromShortbuz,
                                                                          refresh:
                                                                              widget.refresh,
                                                                          refreshFromMultipleStories:
                                                                              widget.refreshFromMultipleStories,
                                                                          setNavBar:
                                                                              widget.setNavBar,
                                                                          isChannelOpen:
                                                                              widget.isChannelOpen,
                                                                          changeColor:
                                                                              widget.changeColor,
                                                                          category: blogList
                                                                              .blogs[index]
                                                                              .categoryVal,
                                                                        )));
                                                      },
                                                      icon: Icon(
                                                          FontAwesomeIcons
                                                              .solidEye),
                                                      label: Text('See More')))
                                              : Container()
                                ],
                              );

                              return BlogBuzzMultipleCategoriesCard(
                                refreshFromMultipleStories:
                                    widget.refreshFromMultipleStories,
                                refresh: widget.refresh,
                                refreshFromShortbuz: widget.refreshFromShortbuz,
                                setNavBar: widget.setNavBar,
                                isChannelOpen: widget.isChannelOpen,
                                changeColor: widget.changeColor,
                                firstIndex: index,
                                categoryList: categoryList.categories,
                                blog: blog,
                                index: blog.index,
                              );
                            },
                          )
                        : Center(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Text("Loading Blogs"),
                                loadingAnimation()
                              ]))),
              );
            } else {
              return Center(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Loading Blogs"), loadingAnimation()]));
            }
          },
        ),
      ),
    );
  }
}
