import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/models/personal_blog_model.dart';
import 'package:bizbultest/models/profile_posts_model.dart';
import 'package:bizbultest/models/settings_country_model.dart';
import 'package:bizbultest/services/BuzzfeedControllers/Buzzfeedprofilecontroller.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzerfeedexpandedprofilecontroller.dart';
import 'package:bizbultest/services/Chat/profile_api.dart';
import 'package:bizbultest/services/Wallet/bebuzeewalletcontroller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/services/profile_api_calls.dart';
import 'package:bizbultest/settings_model.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/view/Buzzfeed/buzzerfeedexpandedprofile.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedprofile.dart';
import 'package:bizbultest/view/create_a_shortbuz.dart';
import 'package:bizbultest/view/create_blog.dart';
import 'package:bizbultest/view/create_story_page.dart';
import 'package:bizbultest/view/upload_video.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:bizbultest/widgets/Profile/user_boards.dart';
import 'package:bizbultest/widgets/ProfileSettings/otheruser_menu_bottom_tile.dart';
import 'package:bizbultest/widgets/personal_blog_card.dart';
import 'package:bizbultest/widgets/profile_card.dart';
import 'package:bizbultest/widgets/profile_posts_image_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import 'Profile/profile_settings_page.dart';
import 'channel_page_main.dart';
import 'channel_page_other_user.dart';
import 'feeds_posts_page.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class ProfilePageMain extends StatefulWidget {
  final ScrollController? scrollController;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final String? otherMemberID;
  final String? from;
  final Function? profileOpen;
  final Function? jumpToProfile;
  final Function? refresh;
  final Function? refreshFromShortbuz;
  final Function? refreshFromMultipleStories;

  ProfilePageMain(
      {Key? key,
      this.scrollController,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.otherMemberID,
      this.from,
      this.profileOpen,
      this.jumpToProfile,
      this.refresh,
      this.refreshFromShortbuz,
      this.refreshFromMultipleStories})
      : super(key: key);

  @override
  _ProfilePageMainState createState() => _ProfilePageMainState();
}

class _ProfilePageMainState extends State<ProfilePageMain>
    with TickerProviderStateMixin {
  Future? _postsFuture;
  Future? _blogsFuture;
  var currentProfilePage = 1;
  late BuzzerfeedProfileController buzzerfeedProfileController;
  late TabController _tabController;
  late TabController _channelController;
  final controller = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int initialPage;
  int selectedIndex = 0;
  int currentPage = 1;
  int totalPages = 0;
  var from;
  var currentList;
  late int currentIndex;
  var userImage;
  var totalPosts;
  var followers;
   int hasHighlight=0;
  var followStatus;
   int isPrivate=1;
   int isDirect=0;
  var following;
  var bio;
  var name;
  var shortcode;
  late String verified;
  String token = "";
  var category;
  late String website;
  double dynamicHeight = 450;
  double variableHeight = 480;
  bool profileLoaded = false;

   String? currentId;
  RefreshController _postRefreshController =
      RefreshController(initialRefresh: false);

  Widget _tile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(title),
        onTap: onTap);
  }

  void _bottomTile(context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0))),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  height: 0.8.h,
                  width: 12.0.w,
                ),
              )),
              _tile(
                CustomIcons.upload_photo,
                AppLocalizations.of('Feed Post'),
                () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  widget.setNavBar!(true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedPostMainPage(
                                setNavbar: widget.setNavBar!,
                                refresh: widget.refresh!,
                              )));
                },
              ),
              _tile(
                CustomIcons.upload_video,
                AppLocalizations.of('Upload a Video'),
                () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  widget.setNavBar!(true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadVideo(
                                setNavbar: widget.setNavBar,
                                refresh: widget.refresh,
                              )));
                },
              ),
              _tile(
                CustomIcons.shortbuz1,
                AppLocalizations.of('Shortbuz'),
                () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  widget.setNavBar!(true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateShortbuz(
                                refreshFromShortbuz:
                                    widget.refreshFromShortbuz!,
                                setNavbar: widget.setNavBar!,
                                refresh: widget.refresh!,
                              )));
                },
              ),
              _tile(
                CustomIcons.upload_photo,
                AppLocalizations.of('Story'),
                () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  widget.setNavBar!(true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateStory(
                                setNavbar: widget.setNavBar!,
                                refreshFromMultipleStories:
                                    widget.refreshFromMultipleStories!,
                              )));
                },
              ),
              _tile(
                CustomIcons.create_blog,
                AppLocalizations.of('Write a Blog'),
                () async {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateBlog(
                                logo: CurrentUser().currentUser.logo,
                                country: CurrentUser().currentUser.country,
                                memberID: CurrentUser().currentUser.memberID,
                              )));
                },
              ),

              /*    ListTile(
                leading: Icon(
                  CustomIcons.upload_photo,
                  color: Colors.black,
                  size: 3.0.h,
                ),
                title: Text('Landing'),
                onTap: () async {
                  Navigator.pop(context);
                  widget.setNavBar(true);
                 Navigator.push(context, MaterialPageRoute(builder: (context) => CardsPage()));
                },
              ),*/
            ],
          ),
        );
      },
    );
  }

  void _navigateToChannel() {
    _tabController.animateTo((_tabController.index) % 2);
    setState(() {
      selectedIndex = 0;
    });
    // widget.changeColor(true);
    // widget.isChannelOpen(true);
    if (currentId == CurrentUser().currentUser.memberID) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChannelPageMain(
                    setIndex: () {
                      _tabController.animateTo((_tabController.index) % 2);
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    otherMemberID: currentId,
                    changeColor: widget.changeColor!,
                    setNavBar: widget.setNavBar!,
                    isChannelOpen: widget.isChannelOpen!,
                  )));
    } else {
      // widget.changeColor();
      // widget.isChannelOpen();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChannelPageMainOtherUser(
                    otherMemberID: currentId,
                    changeColor: widget.changeColor!,
                    setNavBar: widget.setNavBar!,
                    isChannelOpen: widget.isChannelOpen!,
                  )));
    }
  }

  void _tabListener() {
    _tabController
      ..addListener(() {
        setState(() {
          selectedIndex = _tabController.index;
        });
        if (_tabController.index == 2) {
          _navigateToChannel();
        }
      });
  }

  String countryString = "";

  SettingsModel countryList = new SettingsModel(country: []);

  void getCountryList() {
    ProfileApiCalls.getSettingsCountries().then((value) {
      if (mounted) {
        setState(() {
          countryList.country = value!.country;
        });
      }
      return value;
    });
  }

/*  void getLocalCountryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String c = prefs.getString("settings_country_list");
    if(countryList != null) {
      if(mounted) {
        setState(() {
          countryList = c.split('~~').toList();
        });
      }
    }
  }*/

  Widget _channelCard() {
    print("------123123---" + currentId!);
    return Container(
      height: 50.0.w,
      child: InkWell(
        onTap: () {
          // _navigateToChannel();
          // _tabController.animateTo(0);
          // setState(() {
          //   selectedIndex = 0;
          // });
          print("------" + currentId!);
          widget.changeColor!(true);
          widget.isChannelOpen!(true);

          if (currentId == CurrentUser().currentUser.memberID) {
            print("prof current id=${currentId} other");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChannelPageMain(
                          setIndex: () {
                            _tabController.animateTo(0);
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                          otherMemberID: currentId,
                          changeColor: widget.changeColor!,
                          setNavBar: widget.setNavBar!,
                          isChannelOpen: widget.isChannelOpen!,
                        )));
          } else {
            print("prof current id=${currentId}");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChannelPageMainOtherUser(
                          otherMemberID: currentId,
                          changeColor: widget.changeColor!,
                          setNavBar: widget.setNavBar!,
                          isChannelOpen: widget.isChannelOpen!,
                        )));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _channelController.dispose();
    Get.delete<BuzzerfeedProfileController>();

    super.dispose();
  }

  int textLength = 0;

  Future<void> getProfile() async {

    var response = await ApiRepo.postWithToken("api/user/userDetails", {
      "user_id": CurrentUser().currentUser.memberID.toString(),
    }).then((response) async{
      SharedPreferences sp = await SharedPreferences.getInstance();
      print("profile is is build mode 123");
      if(response !=null){

        if (response.data['status'] == 1) {
          if (widget.from == "appbar") {
            SharedPreferences sp = await SharedPreferences.getInstance();
            sp.setString("profile", jsonEncode(response.data['data']));
          }
          if (mounted) {
            setState(() {
              verified = response.data['data']['varified'];
              userImage = response.data['data']['user_image'];
              website = response.data['data']['website_url'];
              category = response.data['data']['category'].toString();
              isPrivate = response.data['data']['account_private'] ? 1 : 0;
              isDirect = response.data['data']['direct_message'] ? 1 : 0;
              hasHighlight = response.data['data']['highlight_status'] ? 1 : 0;
              totalPosts = response.data['data']['post_total'];
              followers = response.data['data']['follower_count'];
              following = response.data['data']['following_count'];
              followStatus = response.data['data']['follow_status'];
              bio = response.data['data']['profile_bio'];
              name = response.data['data']['name'];
              token = response.data['data']['member_token'];
              shortcode = response.data['data']['shortcode'];
              variableHeight = 480;
              profileLoaded = true;
            });
            print("profile built successfully");
          }
        }

      }
      else{
        print("Going to else part ---------> profile page");
      }

    });





  }

  void _onLoading() async {
    var page = postsList.feeds[postsList.feeds.length - 1].page;
    if (currentProfilePage != page)
      return;
    else
      currentProfilePage = page! + 1;
    AllFeeds? posts = await ProfileApiCalls.onLoadingPosts(
        postsList, context, _postRefreshController, currentId!,
        page: currentProfilePage);

    if (posts != null) {
      if (mounted) {
        if (posts.feeds.length == 0) {
          print("i am here profile");
          currentProfilePage = page;
        }
        setState(() {
          postsList.feeds.addAll(posts.feeds);
          stringOfPostID =
              postsList.feeds.map((value) => value.postId).toList().join(",");
        });
        // return _postRefreshController.loadComplete();
      }
      // } else {
      //   return _postRefreshController.loadComplete();
    }
  }

  void _onRefresh() async {
    currentProfilePage = 1;
    _getPosts();
    _postRefreshController.refreshCompleted();
  }

  AllFeeds postsList = new AllFeeds([]);
  PersonalBlogs blogsList = new PersonalBlogs([]);
  bool hasPosts = false;
  bool hasBlogs = false;
  var stringOfPostID;

  void _getPosts() {
    _postsFuture =
        ProfileApiCalls.getPosts(context, currentId!, from).then((value) {
      if (mounted) {
        setState(() {
          postsList.feeds = value.feeds;
          // stringOfPostID =
          //     postsList.feeds.map((value) => value.postId).toList().join(",");
        });
      }

      return value;
    });
  }

  void _getPostsLocal() async {
    _postsFuture = ProfileApiCalls.getPostsLocal(context, from).then((value) {
      if (mounted) {
        setState(() {
          postsList.feeds = value.feeds;
          stringOfPostID =
              postsList.feeds.map((value) => value.postId).toList().join(",");
        });
      }
      _getPosts();
      return value;
    });
  }

  void getLocalData() async {
    if (widget.from == "appbar") {
      print("----frommmmm apppbarrr");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? profile = prefs.getString("profile");
      if (profile != null) {
        if (mounted) {
          setState(() {
            verified = jsonDecode(profile)['varified'];
            userImage = jsonDecode(profile)['user_image'];
            website = jsonDecode(profile)['website_url'];
            category = jsonDecode(profile)['category'].toString();
            isPrivate = jsonDecode(profile)['account_private'] ? 1 : 0;
            hasHighlight = jsonDecode(profile)['highlight_status'] ? 1 : 0;
            // hasHighlight = isPrivate == 1 &&
            //         currentId != CurrentUser().currentUser.memberID
            //     ? 1
            //     : 0;
            totalPosts = jsonDecode(profile)['post_total'];
            followers = jsonDecode(profile)['follower_count'];
            following = jsonDecode(profile)['following_count'];
            bio = jsonDecode(profile)['profile_bio'];
            name = jsonDecode(profile)['name'];
            shortcode = jsonDecode(profile)['shortcode'];
            variableHeight = 480;
            hasPosts = true;
            List<String?> stringPost =
                postsList.feeds!.map((value) => value.postId).toList();
            stringOfPostID = stringPost.join(",");
            profileLoaded = true;
          });
        }
      } else {
        //getFeeds();
      }
    }
  }

  var blogLoding = false.obs;
  Future<void> getBlogs(int page) async {
    blogLoding.value = true;
    _blogsFuture = ProfileApiCalls.getBlogs(page, currentId!).then((value) {
      print("reach in blog dataa");
      blogLoding.value = false;
      if (mounted) {
        setState(() {
          blogsList.blogs = value.blogs;
        });
        if (blogsList.blogs.length > 0) {
          setState(() {
            totalPages = value.blogs[0].totalPages!;
          });
        }
        return value;
      }
    });
  }

//TODO :: inSheet 244
  Future<void> getMemberID() async {
    // var url = Uri.parse(
    // "https://www.bebuzee.com/new_files/all_apis/member_profile_api_call.php?action=get_user_id_data&shortcode=${OtherUser().otherUser.shortcode}");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_shortcode_to_id.php", {
      "shortcode": OtherUser().otherUser.shortcode,
    });

    if (response!.success == 1) {
      setState(() {
        currentId = response!.data['data']['user_id'];
      });
      getProfile();
      getBlogs(1);
      _getPostsLocal();
    }
  }

  Widget _forwardBackwardArrow(VoidCallback onTap, IconData icon, Color color) {
    return CircleAvatar(
        radius: 25,
        backgroundColor: color,
        child: IconButton(
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
          onPressed: onTap,
          icon: Icon(
            icon,
            color: Colors.white,
          ),
        ));
  }

  Widget _postLoader() {
    return GridView.builder(
        addAutomaticKeepAlives: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
        itemCount: 15,
        itemBuilder: (context, index) {
          return AspectRatio(
            aspectRatio: 1,
            child: SkeletonAnimation(
                child: Container(
              color: Colors.grey.shade300,
            )),
          );
        });
  }

  Widget _postsGrid() {
    return FutureBuilder(
        future: _postsFuture,
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
                enablePullDown: false,
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
                      body = Text("");
                    } else if (mode == LoadStatus.loading) {
                      body = loadingAnimation();
                    } else if (mode == LoadStatus.failed) {
                      body = Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                new Border.all(color: Colors.black, width: 0.7),
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
                controller: _postRefreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: postsList.feeds.length == 0
                    ? Center(
                        child: Text(
                        AppLocalizations.of("No post uploaded yet."),
                        style: TextStyle(fontSize: 18),
                      ))
                    : GridView.builder(
                        addAutomaticKeepAlives: false,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2),
                        itemCount: postsList.feeds.length,
                        itemBuilder: (context, index) {
                          return ProfilePostImageCard(
                            refresh: () {
                              print("Refresh");
                              Timer(Duration(seconds: 1), () {
                                _getPosts();
                              });
                            },
                            setNavBar: widget.setNavBar!,
                            isChannelOpen: widget.isChannelOpen!,
                            changeColor: widget.changeColor!,
                            index: index,
                            otherMemberID: widget.otherMemberID!,
                            length: postsList.feeds.length,
                            post: postsList.feeds[index],
                            stringOfPostID: stringOfPostID,
                            postsList: postsList,
                          );
                        }),
              ),
            );
            // } else if (snapshot.data == null) {
            // return Container();
          } else {
            return Container();
          }
        });
  }

  Widget _blogsView() {
    return FutureBuilder(
        future: _blogsFuture,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: widget.scrollController,
              itemCount: blogsList.blogs.length + 1,
              itemBuilder: (context, index) {
                if (index == blogsList.blogs.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _forwardBackwardArrow(() {
                          if (currentPage > 1) {
                            setState(() {
                              hasBlogs = false;
                              currentPage = --currentPage;
                            });

                            getBlogs(currentPage);
                          }
                        }, Icons.arrow_back_ios_outlined,
                            currentPage > 1 ? primaryBlueColor : Colors.grey),
                        Text(
                          "Page " +
                              currentPage.toString() +
                              "/" +
                              totalPages.toString(),
                          style: TextStyle(fontSize: 11.0.sp),
                        ),
                        _forwardBackwardArrow(() {
                          if (currentPage < totalPages) {
                            setState(() {
                              hasBlogs = false;
                              currentPage = ++currentPage;
                            });
                            getBlogs(currentPage);
                          }
                        },
                            Icons.arrow_forward_ios_outlined,
                            (currentPage < totalPages)
                                ? primaryBlueColor
                                : Colors.grey),
                      ],
                    ),
                  );
                } else {
                  var blog = blogsList.blogs[index];
                  return PersonalBlogCard(
                    blog: blog,
                    index: index,
                    lastIndex: blogsList.blogs.length - 1,
                  );
                }
              },
            );
          } else {
            return Container(
              // child: Text(
              //   AppLocalizations.of("No Blogs"),
              //   style: TextStyle(fontSize: 15),
              // ),
            );
          }
        });
  }

  bool isCurrentMember() {
    if (widget.otherMemberID == CurrentUser().currentUser.memberID) {
      return true;
    } else {
      return false;
    }
  }

  int tabs = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCountryList();
      from = widget.from;
      _tabController = new TabController(vsync: this, length: 5, initialIndex: selectedIndex);
      _channelController = new TabController(vsync: this, length: 5, initialIndex: selectedIndex);
      getLocalData();
      if (widget.otherMemberID != null) {
        currentId = widget.otherMemberID!;
        print(widget.otherMemberID);
      } else {
        currentId = CurrentUser().currentUser.memberID!;
      }
      print("----currentid --- $currentId");
      _tabListener();

      if (widget.from == "tags") {
        getMemberID();
      } else {
        buzzerfeedProfileController = Get.put(BuzzerfeedProfileController(currentId!));
        getProfile();
        getBlogs(1);
        _getPostsLocal();
      }
      buzzerfeedProfileController =
          Get.put(BuzzerfeedProfileController(currentId!));
      print(
          "----highLightview --- ${buzzerfeedProfileController.highLightview.value}");
    });

    super.initState();
  }

  late File videoImage;
  void _generateThumbnail(String path, index) async {
    // thumbsList = [];
    // File file;
    setState(() async {
      // print("---generating--- " +
      //     widget.post.postImgData.split("~~")[0].toString());
      Uint8List? unit8list;
      unit8list = await VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat
            .JPEG, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 50,
      );

      print("----videoImage11--$unit8list");
      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image$index.jpg').create();
      // file.writeAsBytesSync(_image);
      file.writeAsBytesSync(unit8list!);
      videoImage = file;
      print("----videoImage1122--$videoImage");
    });
  }

  RefreshProfile refreshProfile = new RefreshProfile();

  _tabButton(String title) {
    return Tab(
      child: (title == "My Buzz")
          ? FittedBox(
              child: Text(
                title,
                style:
                    blackBold.copyWith(color: Colors.black, fontSize: 9.0.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : Text(
              title,
              style: blackBold.copyWith(color: Colors.black, fontSize: 9.0.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }

  Widget _buzzer(String title) {
    return Tab(
      child: Text(
        title,
        style: blackBold.copyWith(color: Colors.black, fontSize: 8.sp),
      ),
    );
  }

  Widget _actionButton(VoidCallback onTap, IconData icon) {
    return IconButton(
      splashRadius: 25,
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 28,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(
    //     initialData: refreshProfile.currentSelect,
    //     stream: refreshProfile.observableCart,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         // print("reach in snpshot");
    //         // getProfile();
    //         // getBlogs(1);
    //         refreshProfile.updateRefresh(false);
    //       }
    //       return Scaffold(
    //           // key: _scaffoldKey,
    //           appBar: PreferredSize(
    //             preferredSize: Size.fromHeight(50),
    //             child: AppBar(
    //               automaticallyImplyLeading: false,
    //               titleSpacing: 10,
    //               actions: [
    //                 _actionButton(() {
    //                   _bottomTile(context);
    //                 }, Icons.add_box_outlined),
    //                 _actionButton(() {
    //                   if (currentId == CurrentUser().currentUser.memberID) {
    //                     widget.setNavBar!(true);
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) => ProfileSettingsPage(
    //                                   memberID: widget.otherMemberID!,
    //                                   setNavbar: widget.setNavBar!,
    //                                   countryList: countryList.country!,
    //                                 )));
    //                   } else {
    //                     showModalBottomSheet(
    //                         backgroundColor: Colors.white,
    //                         shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.only(
    //                                 topLeft: const Radius.circular(20.0),
    //                                 topRight: const Radius.circular(20.0))),
    //                         //isScrollControlled:true,
    //                         context: context,
    //                         builder: (BuildContext bc) {
    //                           return OtherUserProfileMenu(
    //                             copyLink: () async {
    //                               Navigator.pop(context);
    //                               Uri uri =
    //                                   await DeepLinks.createProfileDeepLink(
    //                                       currentId,
    //                                       "profile",
    //                                       userImage,
    //                                       "",
    //                                       "$shortcode");
    //                               Clipboard.setData(
    //                                   ClipboardData(text: uri.toString()));
    //                               Fluttertoast.showToast(
    //                                 msg: AppLocalizations.of(
    //                                   "Link Copied",
    //                                 ),
    //                                 toastLength: Toast.LENGTH_SHORT,
    //                                 gravity: ToastGravity.CENTER,
    //                                 backgroundColor:
    //                                     Colors.black.withOpacity(0.7),
    //                                 textColor: Colors.white,
    //                                 fontSize: 18.0,
    //                               );
    //                             },
    //                             shareTo: () async {
    //                               Uri uri =
    //                                   await DeepLinks.createProfileDeepLink(
    //                                       currentId,
    //                                       "profile",
    //                                       userImage,
    //                                       "",
    //                                       "$shortcode");
    //                               Share.share(
    //                                 '${uri.toString()}',
    //                               );
    //                             },
    //                           );
    //                         });
    //                   }
    //                 },
    //                     currentId == CurrentUser().currentUser.memberID
    //                         ? Icons.menu
    //                         : Icons.more_vert_rounded)
    //               ],
    //               title: profileLoaded
    //                   ? Row(
    //                       children: [
    //                         Container(
    //                           height: 50,
    //                           child: Row(
    //                             children: [
    //                               Container(
    //                                   width: 65.w,
    //                                   child: Text(
    //                                     AppLocalizations.of(shortcode),
    //                                     style: blackBold.copyWith(fontSize: 20),
    //                                     maxLines: 1,
    //                                     overflow: TextOverflow.ellipsis,
    //                                   )),
    //                               verified != "" && verified != null ||
    //                                       widget.otherMemberID == "1798019"
    //                                   ? Padding(
    //                                       padding: EdgeInsets.only(left: 6),
    //                                       child: Icon(
    //                                         Icons.check_circle,
    //                                         color: primaryBlueColor,
    //                                         size: 20,
    //                                       ),
    //                                     )
    //                                   : Container()
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     )
    //                   : Container(),
    //               backgroundColor: Colors.white,
    //               elevation: 2,
    //               brightness: Brightness.light,
    //             ),
    //           ),
    //           backgroundColor: Colors.white,
    //           body: WillPopScope(
    //             onWillPop: () async {
    //               buzzerfeedProfileController.highLightview.value = false;
    //               if (widget.from == "shortbuz") {
    //                 widget.changeColor!(true);
    //                 widget.profileOpen!(false);
    //               } else if (widget.from == "story") {
    //                 return true;
    //               }
    //               return true;
    //             },
    //             child: profileLoaded
    //                 ? DefaultTabController(
    //               length: tabs,
    //               child: NestedScrollView(
    //                 controller: widget.scrollController,
    //                 headerSliverBuilder: (context, value) {
    //                   return [
    //                     Obx(
    //                           () => SliverAppBar(
    //                         automaticallyImplyLeading: false,
    //                         backgroundColor: Colors.white,
    //                         bottom: isPrivate == 1 &&
    //                             currentId !=
    //                                 CurrentUser()
    //                                     .currentUser
    //                                     .memberID &&
    //                             followStatus != 1
    //                             ? PreferredSize(
    //                             preferredSize: Size.fromHeight(0),
    //                             child: Container())
    //                             : TabBar(
    //                           indicatorColor: Colors.black,
    //                           tabs: <Tab>[
    //                             _tabButton(
    //                                 AppLocalizations.of('Posts')),
    //                             _tabButton(
    //                                 AppLocalizations.of('Blogs')),
    //                             _tabButton(
    //                                 AppLocalizations.of('Channel')),
    //                             _tabButton(
    //                                 AppLocalizations.of('My Buzz')),
    //                             _tabButton(
    //                                 AppLocalizations.of('Boards')),
    //                           ],
    //                           controller: _tabController,
    //                           onTap: (int index) {
    //                             if (index == 2) {
    //                               print("=== $index");
    //                               _navigateToChannel();
    //                             } else {
    //                               setState(() {
    //                                 selectedIndex = index;
    //                                 _tabController.animateTo(index);
    //                               });
    //                             }
    //                           },
    //                         ),
    //                         pinned: true,
    //                         floating: true,
    //                         expandedHeight: buzzerfeedProfileController
    //                             .highLightview.isFalse
    //                             ? variableHeight + dynamicHeight
    //                             : 320.0,
    //                         flexibleSpace: FlexibleSpaceBar(
    //                           collapseMode: CollapseMode.pin,
    //                           background: profileLoaded
    //                               ? ProfileCard(
    //                             isDirect: isDirect,
    //                             token: token,
    //                             varHeight: variableHeight,
    //                             website: website,
    //                             category: category,
    //                             isPrivate: isPrivate,
    //                             hasHighlight: hasHighlight,
    //                             from: widget.from,
    //                             jumpToProfile: widget.jumpToProfile,
    //                             refresh: () {
    //                               Timer(Duration(seconds: 1), () {
    //                                 getProfile();
    //                               });
    //                             },
    //                             setHeight: (ht) {
    //                               setState(() {
    //                                 dynamicHeight = ht;
    //                               });
    //
    //                               print(dynamicHeight.toString() +
    //                                   " dynamic");
    //                             },
    //                             varified: verified,
    //                             setNavbar: widget.setNavBar,
    //                             isChannelOpen: widget.isChannelOpen,
    //                             changeColor: widget.changeColor,
    //                             memberID: currentId,
    //                             userImage: userImage,
    //                             totalPosts: totalPosts.toString(),
    //                             followers: followers.toString(),
    //                             following: following.toString(),
    //                             bio: bio,
    //                             name: name,
    //                             shortcode: shortcode,
    //                           )
    //                               : Container(), // This is where you build the profile part
    //                         ),
    //                       ),
    //                     ),
    //                   ];
    //                 },
    //                 body: isPrivate == 1 &&
    //                     currentId !=
    //                         CurrentUser().currentUser.memberID &&
    //                     followStatus != 1
    //                     ? Container(height: 100 , color: Colors.amber,)
    //                     : TabBarView(
    //                     controller: _tabController,
    //                     children: [
    //                       _postsGrid(),
    //                       Obx(
    //                             () => blogLoding.isTrue
    //                             ? Container(
    //                           child: Center(
    //                               child: loadingAnimation()),
    //                         )
    //                             : blogsList.blogs.isEmpty
    //                             ? Center(
    //                           child: Container(
    //                             child: Text(
    //                               AppLocalizations.of(
    //                                   "No Blogs"),
    //                               style: TextStyle(
    //                                   fontSize: 18),
    //                             ),
    //                           ),
    //                         )
    //                             : _blogsView(),
    //                       ),
    //                       _channelCard(),
    //                       BuzzfeedViewProfile(
    //                           controller:
    //                           buzzerfeedProfileController,
    //                           memberId:
    //                           OtherUser().otherUser.memberID ?? ""
    //                         //      ??
    //                         // CurrentUser().currentUser.memberID,
    //                       ),
    //                       UserBoards(
    //                         memberID: widget.otherMemberID!,
    //                       )
    //                     ]),
    //               ),
    //             )
    //                 : Container( height: Get.height,color: Colors.cyanAccent,),
    //           ));
    //     });
    return Scaffold(
      // key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 10,
            actions: [
              _actionButton(() {
                _bottomTile(context);
              }, Icons.add_box_outlined),
              _actionButton(() {
                if (currentId == CurrentUser().currentUser.memberID) {
                  widget.setNavBar!(true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileSettingsPage(
                            memberID: widget.otherMemberID!,
                            setNavbar: widget.setNavBar!,
                            countryList: countryList.country!,
                          )));
                } else {
                  showModalBottomSheet(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20.0),
                              topRight: const Radius.circular(20.0))),
                      //isScrollControlled:true,
                      context: context,
                      builder: (BuildContext bc) {
                        return OtherUserProfileMenu(
                          copyLink: () async {
                            Navigator.pop(context);
                            Uri uri =
                            await DeepLinks.createProfileDeepLink(
                                currentId!,
                                "profile",
                                userImage,
                                "",
                                "$shortcode");
                            Clipboard.setData(
                                ClipboardData(text: uri.toString()));
                            Fluttertoast.showToast(
                              msg: AppLocalizations.of(
                                "Link Copied",
                              ),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor:
                              Colors.black.withOpacity(0.7),
                              textColor: Colors.white,
                              fontSize: 18.0,
                            );
                          },
                          shareTo: () async {
                            Uri uri =
                            await DeepLinks.createProfileDeepLink(
                                currentId!,
                                "profile",
                                userImage,
                                "",
                                "$shortcode");
                            Share.share(
                              '${uri.toString()}',
                            );
                          },
                        );
                      });
                }
              },
                  currentId == CurrentUser().currentUser.memberID
                      ? Icons.menu
                      : Icons.more_vert_rounded)
            ],
            title: profileLoaded
                ? Row(
              children: [
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Container(
                          width: 65.w,
                          child: Text(
                            AppLocalizations.of(shortcode),
                            style: blackBold.copyWith(fontSize: 20),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                      verified != "" && verified != null ||
                          widget.otherMemberID == "1798019"
                          ? Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.check_circle,
                          color: primaryBlueColor,
                          size: 20,
                        ),
                      )
                          : Container()
                    ],
                  ),
                ),
              ],
            )
                : Container(),
            backgroundColor: Colors.white,
            elevation: 2,
            brightness: Brightness.light,
          ),
        ),
        backgroundColor: Colors.white,
        body: WillPopScope(
          onWillPop: () async {
            buzzerfeedProfileController.highLightview.value = false;
            if (widget.from == "shortbuz") {
              widget.changeColor!(true);
              widget.profileOpen!(false);
            } else if (widget.from == "story") {
              return true;
            }
            return true;
          },
          child: profileLoaded
              ? DefaultTabController(
               length: tabs,
              child: NestedScrollView(
              controller: widget.scrollController,
              headerSliverBuilder: (context, value) {
                return [
                  Obx(() =>
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.white,
                        bottom: isPrivate == 1 &&
                            currentId !=
                                CurrentUser()
                                    .currentUser
                                    .memberID &&
                            followStatus != 1
                            ? PreferredSize(
                            preferredSize: Size.fromHeight(0),
                            child: Container())
                            : TabBar(
                          indicatorColor: Colors.black,
                          tabs: <Tab>[
                            _tabButton(
                                AppLocalizations.of('Posts')),
                            _tabButton(
                                AppLocalizations.of('Blogs')),
                            _tabButton(
                                AppLocalizations.of('Channel')),
                            _tabButton(
                                AppLocalizations.of('My Buzz')),
                            _tabButton(
                                AppLocalizations.of('Boards')),
                          ],
                          controller: _tabController,
                          onTap: (int index) {
                            if (index == 2) {
                              print("=== $index");
                              _navigateToChannel();
                            } else {
                              setState(() {
                                selectedIndex = index;
                                _tabController.animateTo(index);
                              });
                            }
                          },
                        ),
                        pinned: true,
                        floating: true,
                        expandedHeight: buzzerfeedProfileController
                            .highLightview.isFalse
                            ? variableHeight + dynamicHeight
                            : 320.0,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: profileLoaded ? ProfileCard(
                            isDirect: isDirect,
                            token: token,
                            varHeight: variableHeight,
                            website: website,
                            category: category,
                            isPrivate: isPrivate,
                            hasHighlight: hasHighlight,
                            from: widget.from,
                            jumpToProfile: widget.jumpToProfile,
                            refresh: () {
                              Timer(Duration(seconds: 1), () {
                                getProfile();
                              });
                            },
                            setHeight: (ht) {
                              setState(() {
                                dynamicHeight = ht;
                              });

                              print(dynamicHeight.toString() +
                                  " dynamic");
                            },
                            varified: verified,
                            setNavbar: widget.setNavBar,
                            isChannelOpen: widget.isChannelOpen,
                            changeColor: widget.changeColor,
                            memberID: currentId,
                            userImage: userImage,
                            totalPosts: totalPosts.toString(),
                            followers: followers.toString(),
                            following: following.toString(),
                            bio: bio.toString(),
                            name: name,
                            shortcode: shortcode,
                          )
                              : Container(), // This is where you build the profile part
                        ),
                      ),
                  )
                ];
              },  body: isPrivate == 1 &&
                currentId !=
                    CurrentUser().currentUser.memberID &&
                followStatus != 1
                ? Container(height: 100 , color: Colors.amber,)
                : TabBarView(
                controller: _tabController,
                children: [
                  _postsGrid(),
                  Obx(
                        () => blogLoding.isTrue
                        ? Container(
                      child: Center(
                          child: loadingAnimation()),
                    )
                        : blogsList.blogs.isEmpty
                        ? Center(
                      child: Container(
                        child: Text(
                          AppLocalizations.of(
                              "No Blogs"),
                          style: TextStyle(
                              fontSize: 18),
                        ),
                      ),
                    )
                        : _blogsView(),
                  ),
                  _channelCard(),
                  BuzzfeedViewProfile(
                      controller:
                      buzzerfeedProfileController,
                      memberId:
                      OtherUser().otherUser.memberID ?? ""
                    //      ??
                    // CurrentUser().currentUser.memberID,
                  ),
                  UserBoards(
                    memberID: widget.otherMemberID!,
                  )
                ]),
            
            ),
          )
              : Container(),
        )
    );
  }
}
