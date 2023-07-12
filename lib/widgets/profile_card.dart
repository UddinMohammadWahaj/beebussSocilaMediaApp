import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/profile_posts_model.dart';
import 'package:bizbultest/models/user_highlights_model.dart';
import 'package:bizbultest/models/user_story_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/services/profile_api_calls.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:bizbultest/utilities/simple_web_view.dart';
import 'package:bizbultest/view/Chat/detailed_direct_screen.dart';
import 'package:bizbultest/view/create_story_page.dart';
import 'package:bizbultest/view/edit_profile_page.dart';
import 'package:bizbultest/view/profile_followers_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../api/ApiRepo.dart' as ApiRepo;
import '../services/BuzzfeedControllers/Buzzfeedprofilecontroller.dart';
import 'Highlights/add_multiple_stories.dart';
import 'Highlights/edit_highlight.dart';
import 'Highlights/highlights_profile_menu.dart';
import 'Highlights/main_highlights_page.dart';
import 'Highlights/user_highlight_card.dart';
import 'Newsfeeds/publish_state.dart';
import 'Stories/delete_highlight_popup.dart';
import 'Stories/main_stories_page.dart';

class ProfileCard extends StatefulWidget {
  final ProfilePostModel? post;
  final String? userImage;
  final String? totalPosts;
  final String? followers;
  final String? following;
  final String? bio;
  final String? name;
  final String? shortcode;
  final List? list;
  final String? memberID;
  final String? from;
  final String? category;
  final Function? setNavbar;
  final String? varified;
  final Function? setHeight;
  final Function? refresh;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? jumpToProfile;
  final int? hasHighlight;
  final int? isPrivate;
  final int? isDirect;
  final String? website;
  double? varHeight;
  final String? contactEmail;
  final String? token;

  ProfileCard(
      {Key? key,
      this.post,
      this.userImage,
      this.totalPosts,
      this.followers,
      this.following,
      this.bio,
      this.name,
      this.shortcode,
      this.list,
      this.memberID,
      this.setNavbar,
      this.changeColor,
      this.isChannelOpen,
      this.varified,
      this.setHeight,
      this.refresh,
      this.jumpToProfile,
      this.from,
      this.hasHighlight,
      this.isPrivate,
      this.category,
      this.website,
      this.varHeight,
      this.contactEmail,
      this.token,
      this.isDirect})
      : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  var keyText = GlobalKey();
  int textLength = 0;
  bool more = false;
  var visibleKey = GlobalKey();
  int storyExists = 0;
  late UserStoryList userStoryList;
  bool areUsersLoaded = false;
  String from = "";
  String contactEmail = "";

  void showMore() {
    if (widget.bio!.length > 110) {
      setState(() {
        more = true;
      });
    } else {
      setState(() {
        more = false;
      });
    }
  }

  bool showEmail = false;

  HomepageRefreshState refresh = new HomepageRefreshState();
//DONE :: inSheet 236
  Future<void> getProfileData() async {
    // var url = Uri.parse("https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=edit_profile_data&user_id=${widget.memberID}");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/user_id_to_email.php", {
      "user_id": widget.memberID,
    });

    if (response!.success == 1) {
      if (mounted) {
        setState(() {
          contactEmail = response.data['data']['public_email'];
        });
      }
    }
  }

  void _launchURL(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

//DONE :: inSheet 237
  Future<void> optionsStatus() async {
    // var url = Uri.parse("https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=get_contact_display_data&user_id=${widget.memberID}");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_privacy_status.php", {
      "user_id": widget.memberID,
    });
    print("----- ${response!.data['data']}");
    if (response.success == 1) {
      var contact = (response.data['data']['contact'] ?? false) ? 1 : 0;
      if (contact == 1) {
        getProfileData();
        if (mounted) {
          setState(() {
            showEmail = true;
          });
        }
      }
    }
  }

  UserHighlightsList userHighlightsList = UserHighlightsList([]);
   Future? _userHighlightsFuture;
  bool areUserHighlightsLoaded = false;
  BuzzerfeedProfileController ctr = Get.put(BuzzerfeedProfileController(''));

  void _getUserHighlights() {
    print('first image or vide b');
    _userHighlightsFuture =
        ProfileApiCalls.getUserHighlights(widget.memberID!, context, from)
            .then((value) {
      if (mounted) {
        setState(() {
          userHighlightsList.highlights = value.highlights;
          ctr.highLightview.value =
              userHighlightsList.highlights.length == 0 ? true : false;
        });
      }
      print(
          userHighlightsList.highlights.length.toString() + " network length");
      if (from == "highlight") {
        print(OtherUser().otherUser.index);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainHighlightsPage(
                      highlights: userHighlightsList.highlights,
                      index: int.parse(OtherUser().otherUser.index!),
                      setNavBar: widget.setNavbar!,
                    )));
        if (mounted) {
          setState(() {
            from = "";
          });
        }
      }
      return value.highlights;
    });
  }

  void _getLocalHighlights() {
    _userHighlightsFuture =
        ProfileApiCalls.getLocalHighlights(from, context).then((value) {
      if (mounted) {
        setState(() {
          userHighlightsList.highlights = value.highlights;
          ctr.highLightview.value =
              userHighlightsList.highlights.length == 0 ? true : false;
        });
      }
      _getUserHighlights();
      return value;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      from = widget.from!;
      _getUserHighlights();
      showMore();
      calculateHeight();
      optionsStatus();
      _getLocalHighlights();
      checkFollowStatus();
      checkStory();
      getStoryUserList();
      print("----highLightview--11 --- ${ctr.highLightview.value}");
    });

    super.initState();
  }

  GlobalKey bioKey = new GlobalKey();
  Size size = Size(0, 0);
  Offset position = Offset(100, 100);

  String buzz =
      "https://www.bebuzee.com/images/profile/wall-images/2015_11_30_04_30_48955.png,https://www.bebuzee.com/images/profile/wall-images/2015_03_09_01_58_0183b96860c37c53d50feb04fcea82f6d6.jpg,https://www.bebuzee.com/images/profile/wall-images/2016_01_31_08_00_55619.png,https://www.bebuzee.com/images/profile/wall-images/2019_04_12_06_58_32507.png,https://www.bebuzee.com/images/profile/wall-images/user_image-1598607093-25737548.jpg,https://www.bebuzee.com/images/profile/wall-images/user_image-1598605870-1672035771.jpg,https://www.bebuzee.com/images/profile/wall-images/user_image-1596817052-96605846.jpg,https://www.bebuzee.com/images/profile/wall-images/user_image-1603362442-816012343.jpg,https://www.bebuzee.com/images/profile/wall-images/user_image-1603360050-265945260.jpg,https://www.bebuzee.com/images/profile/wall-images/user_image-1600414214-485493327.jpg,https://www.bebuzee.com/images/profile/wall-images/user_image-1600412056-29597536.jpg,https://www.bebuzee.com/images/profile/wall-images/user_image-1598607093-25737548.jpg,https://www.bebuzee.com/images/profile/wall-images/user_image-1598605870-1672035771.jpg,https://www.bebuzee.com/images/profile/wall-images/user_image-1596817052-96605846.jpg";
  var followStatus;

//TODO :: inSheet 238
  Future<void> checkFollowStatus() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope.php?action=check_user_to_follow&user_id=${CurrentUser().currentUser.memberID}&user_id_to=${widget.memberID}");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken(
        "api/member_follow_check_status.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "user_id_to": widget.memberID
    });

    if (response!.success == 1) {
      print("-----#########---- ${response!.data['data']}");
      if (mounted) {
        setState(() {
          followStatus = response!.data['data']['follow_status'];
        });
      }
    }
  }

//TODO :: inSheet 239
  Future<String> followUser(String otherMemberId) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=follow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_follow_unfollow.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "user_id_to": otherMemberId,
      "follow_status": followStatus,
    });

    print(response!.data['data']);
    if (response!.success == 1) {
      setState(() {
        print("followed user =${response!.data['data']}");
        followStatus = response!.data['data']['follow_status'];
      });
    }
    return "success";
  }

//TODO :: inSheet 240
  Future<String> cancelRequest(String otherMemberId) async {
    // // var url = Uri.parse(
    // //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=cancel_follow_request&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$otherMemberId");

    // // var response = await http.get(url);

    // var response = await ApiRepo.postWithToken(
    //     "api/member_cancel_follow1.php", {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "user_id_to": otherMemberId
    // });

    // print(response!.data);
    // if (response!.success == 1) {
    //   setState(() {
    //     followStatus = response!.data['data']['followStatus'];
    //   });
    // }
    return "success";
  }

//DONE :: inSheet 10+
  Future<void> getStoryUserList() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_story_data.php?action=story_data_member_only&user_id=${widget.memberID}&country=${CurrentUser().currentUser.country}");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/story_data_member.php", {
      "user_id": widget.memberID,
      "country": CurrentUser().currentUser.country
    });

    if (response!.success == 1) {
      UserStoryList userData = UserStoryList.fromJson(response!.data['data']);
      if (mounted) {
        setState(() {
          userStoryList = userData;
          areUsersLoaded = true;
        });
      }

      if (from == "home") {
        print("from homeeeeeeeee");
        widget.setNavbar!(true);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainStoriesPage(
                    index: 0,
                    users: userStoryList.users,
                    user: userStoryList.users[0],
                    setNavBar: widget.setNavbar!,
                    id: widget.memberID!)));
        setState(() {
          from = "";
        });
        print("after  " + from);
      }
    }
    if (response!.data == null ||
        response!.data['data'] == null ||
        response!.data['data'] == "") {
      if (mounted) {
        setState(() {
          areUsersLoaded = false;
        });
      }
    }
  }

//TODO :: inSheet 241
  Future<String> unfollow(String unfollowerID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_develope_follow_unfollow.php?action=unfollow_user&user_id=${CurrentUser().currentUser.memberID}&user_id_to=$unfollowerID");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/member_follow_unfollow.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "user_id_to": unfollowerID,
      "follow_status": followStatus,
    });

    if (response!.success == 1) {
      print("unfollow user =${response!.data}");
      setState(() {
        followStatus = response!.data['data']['follow_status'];
      });
      print(response!.data['data']);
    }

    return "success";
  }

//TODO :: inSheet 242
  Future<String> checkStory() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_story_data.php?action=story_data_last_one_daya&user_id=${widget.memberID}");

    // var response = await http.get(url);
    var url = 'https://www.bebuzee.com/api/storyCheckLastOneDay';
    var response = await ApiProvider().fireApiWithParamsPost(url, params: {
      "user_id": widget.memberID,
    }).then((value) => value);
    // var response =
    //     await ApiRepo.postWithToken("api/check_story_last_one_day.php", {
    //   "user_id": widget.memberID,
    // });

    if (response!.data != null) {
      if (mounted) {
        setState(() {
          storyExists = response!.data['data']['story_exist'] ? 1 : 0;
        });
      }
      print(response!.data['data']);
    }

    return "success";
  }

  void calculateHeight() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final RenderBox? box =
          keyText.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        size = box!.size;
      });
      widget.setHeight!(size.height);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Container(
          // color: Colors.yellow,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 1.0.h, horizontal: 2.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (storyExists == 1) {
                                    widget.setNavbar!(true);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainStoriesPage(
                                                  index: 0,
                                                  users: userStoryList.users,
                                                  user: userStoryList.users[0],
                                                  setNavBar: widget.setNavbar!,
                                                )));
                                  }

                                  if (storyExists == 0 &&
                                      widget.memberID ==
                                          CurrentUser().currentUser.memberID) {
                                    widget.setNavbar!(true);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CreateStory(
                                              whereFrom: "profile",
                                              setNavbar: widget.setNavbar!,
                                              refreshFromMultipleStories:
                                                  () {
                                                widget.jumpToProfile!(true);
                                                refresh.updateRefresh(true);

                                                print("Aaaaaaaaaa");
                                                setState(() {
                                                  CurrentUser()
                                                      .currentUser
                                                      .refreshStory = true;
                                                });
                                              },
                                            )));
                                  }
                                },
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                              colors: areUsersLoaded &&
                                                  userStoryList.users[0]
                                                      .viewStatus ==
                                                      0
                                                  ? [
                                                HexColor("#2B25CC"),
                                                HexColor("#A6635B"),
                                                HexColor("#91596F"),
                                                HexColor("#B46A4D"),
                                                HexColor("#F18910"),
                                                HexColor("#A6635B")
                                              ]
                                                  : [Colors.grey, Colors.grey]),
                                          border: new Border.all(
                                            color: Colors.grey.withOpacity(0.3),
                                            width: 2,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(0.5.h),
                                            child: CircleAvatar(
                                              radius: 45,
                                              backgroundColor:
                                              Colors.transparent,
                                              backgroundImage:
                                              CachedNetworkImageProvider(
                                                  widget
                                                      .memberID ==
                                                      CurrentUser()
                                                          .currentUser
                                                          .memberID
                                                      ? CurrentUser()
                                                      .currentUser
                                                      .image!
                                                      : widget.userImage!),
                                            ),
                                          ),
                                        ),
                                      ),
                                      widget.memberID ==
                                          CurrentUser()
                                              .currentUser
                                              .memberID &&
                                          storyExists == 0
                                          ? Positioned.fill(
                                        child: Align(
                                            alignment:
                                            Alignment.bottomRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 35, left: 25),
                                              child: Container(
                                                decoration:
                                                new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: new Border.all(
                                                    color: Colors.white,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Material(
                                                  // pause button (round)
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      50), // change radius size
                                                  color:
                                                  primaryBlueColor, //button colour
                                                  child: InkWell(
                                                    splashColor:
                                                    primaryBlueColor, // inkwell onPress colour
                                                    child: SizedBox(
                                                      //customisable size of 'button'
                                                      child: Icon(
                                                        Icons.add,
                                                        color:
                                                        Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    onTap:
                                                        () {}, // or use onPressed: () {}
                                                  ),
                                                ),
                                              ),
                                            )),
                                      )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                              Wrap(
                                direction: Axis.vertical,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    NumberFormat.compact().format(num.parse(
                                        widget.totalPosts
                                            .toString()
                                            .split(" ")[0])),
                                    style:
                                    blackBold.copyWith(fontSize: 14.0.sp),
                                  ),
                                  Text(
                                    AppLocalizations.of('Posts'),
                                    style: TextStyle(fontSize: 11.0.sp),
                                  )
                                ],
                              ),
                              InkWell(
                                splashColor: Colors.grey.withOpacity(0.3),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileFollowersPage(
                                                shortCode: widget.shortcode!,
                                                memberID: widget.memberID!,
                                                initialIndex: 0,
                                              )));
                                },
                                child: Wrap(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      NumberFormat.compact().format(num.parse(
                                          widget.followers
                                              .toString()
                                              .split(" ")[0])),
                                      style:
                                      blackBold.copyWith(fontSize: 14.0.sp),
                                    ),
                                    Text(
                                      AppLocalizations.of('Followers'),
                                      style: TextStyle(fontSize: 11.0.sp),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.grey.withOpacity(0.3),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileFollowersPage(
                                                shortCode: widget.shortcode!,
                                                memberID: widget.memberID!,
                                                setNavBar: widget.setNavbar!,
                                                initialIndex: 1,
                                              )));
                                },
                                child: Wrap(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      NumberFormat.compact().format(num.parse(
                                          widget.following
                                              .toString()
                                              .split(" ")[0])),
                                      style:
                                      blackBold.copyWith(fontSize: 14.0.sp),
                                    ),
                                    Text(
                                      AppLocalizations.of('Following'),
                                      style: TextStyle(fontSize: 11.0.sp),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              AppLocalizations.of(widget.name!),
                              style: blackBold.copyWith(fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            key: keyText,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.category != ""
                                    ? Text(
                                  AppLocalizations.of(widget.category!),
                                  style: TextStyle(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                                    : Container(height: 0),
                                  widget.website != ""
                                    ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SimpleWebView(
                                                    url: widget.website!,
                                                    heading: "")));
                                  },
                                  child: Container(
                                    child: Text(
                                      AppLocalizations.of(
                                          widget.website!),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                    : Container(
                                  height: 0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    more
                                        ? Text(
                                      AppLocalizations.of(widget.bio!),
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                        : Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(
                                              widget.bio!),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    more
                                        ? GestureDetector(
                                        onTap: () {
                                          calculateHeight();
                                          setState(() {
                                            more = false;
                                          });
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Padding(
                                            padding:
                                            EdgeInsets.only(top: 0.7.h),
                                            child: Text(
                                              AppLocalizations.of('More'),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ))
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    showEmail &&
                            widget.memberID !=
                                CurrentUser().currentUser.memberID &&
                            widget.isPrivate != 1
                        ? Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: GestureDetector(
                              onTap: () {
                                _launchURL(contactEmail);
                              },
                              child: Container(
                                width: 100.0.w,
                                decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  shape: BoxShape.rectangle,
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 1.0.h),
                                    child: Text(
                                      AppLocalizations.of(
                                        'Email',
                                      ),
                                      style: TextStyle(
                                          color: primaryBlueColor,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    widget.memberID == CurrentUser().currentUser.memberID
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                            setNavbar: widget.setNavbar!,
                                            refresh: widget.refresh!,
                                            calculate: () {
                                              Timer(Duration(milliseconds: 150),
                                                  () {
                                                showMore();
                                                calculateHeight();
                                              });
                                            },
                                          )));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    shape: BoxShape.rectangle,
                                    border: new Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(1.0.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of('Edit Profile'),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          )
                        : Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 2.0.h),
                                  child: InkWell(
                                    onTap: () {
                                      if (followStatus == 0 ||
                                          followStatus == 4) {
                                        print("follow user bia");
                                        followUser(widget.memberID!);
                                      }
                                      //  else if (followStatus ==) {
                                      //   cancelRequest(widget.memberID);
                                      // }
                                      else {
                                        unfollow(widget.memberID!);
                                      }
                                    },
                                    child: Container(
                                        width: widget.isPrivate == 1 &&
                                                widget.memberID !=
                                                    CurrentUser()
                                                        .currentUser
                                                        .memberID &&
                                                followStatus != 1
                                            ? 92.0.w
                                            : 45.0.w,
                                        decoration: new BoxDecoration(
                                          color: followStatus == 3
                                              ? Colors.white
                                              : primaryBlueColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          shape: BoxShape.rectangle,
                                          border: new Border.all(
                                            color: Colors.grey,
                                            width: followStatus == 3 ? 0.3 : 0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(1.0.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              followStatus != null
                                                  ? Text(
                                                      AppLocalizations.of(
                                                        followStatus == 0
                                                            ? "Follow"
                                                            : followStatus == 1
                                                                ? "Following"
                                                                : followStatus ==
                                                                        4
                                                                    ? "Follow Back"
                                                                    : "Requested",
                                                      ),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: followStatus ==
                                                                  3
                                                              ? Colors.black
                                                              : Colors.white),
                                                    )
                                                  : Text(""),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                widget.isPrivate == 1 &&
                                        widget.memberID !=
                                            CurrentUser()
                                                .currentUser
                                                .memberID &&
                                        followStatus != 1
                                    ? Container()
                                    : widget.isDirect == 0
                                        ? Container()
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0.h),
                                            child: GestureDetector(
                                              onTap: () {
                                                widget.setNavbar!(true);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailedDirectScreen(
                                                              from: "profile",
                                                              setNavbar: widget
                                                                  .setNavbar!,
                                                              token:
                                                                  widget.token!,
                                                              name:
                                                                  widget.name!,
                                                              image: widget
                                                                  .userImage!,
                                                              memberID: widget
                                                                  .memberID!,
                                                            )));
                                              },
                                              child: Container(
                                                  width: 45.0.w,
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    shape: BoxShape.rectangle,
                                                    border: new Border.all(
                                                      color: Colors.grey,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(1.0.h),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          AppLocalizations.of(
                                                            "Message",
                                                          ),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          )
                              ],
                            ),
                          ),
                    widget.isPrivate == 1 &&
                            widget.memberID !=
                                CurrentUser().currentUser.memberID &&
                            followStatus != 1
                        ? Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: new Border.all(
                                          color: Colors.grey,
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.lock_open,
                                          color: Colors.grey,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 3.0.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(
                                          "This Account is Private",
                                        ),
                                        style: blackBold.copyWith(
                                            fontSize: 10.0.sp),
                                      ),
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                      Text(
                                        AppLocalizations.of(
                                          "Follow this account to see their photos and videos.",
                                        ),
                                        style: greyNormal.copyWith(
                                            fontSize: 10.0.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              // widget.hasHighlight == 1
              // userHighlightsList.highlights.length > 0

              /*highlight changess*/

               // widget.isPrivate == 1 &&
               //        widget.memberID != CurrentUser().currentUser.memberID &&
               //        followStatus != 1
               //    ? Container()
               //    : FutureBuilder(
               //        future: _userHighlightsFuture,
               //        builder: (context, snapshot) {
               //          widget.varHeight =
               //              userHighlightsList.highlights.length == 0
               //                  ? 120
               //                  : 480;
               //          print(
               //              "------ has data -- out ${userHighlightsList.highlights.length}");
               //          if (/*snapshot.hasData*/userHighlightsList.highlights.length>0) {
               //            print(
               //                "------ has data -- ${userHighlightsList.highlights.length}");
               //            return Padding(
               //              padding: EdgeInsets.only(top: 0, bottom: 0),
               //              child: VisibilityDetector(
               //                  key: ObjectKey(visibleKey),
               //                  onVisibilityChanged: (visibility) {
               //                    if (visibility.visibleFraction > 0.5) {
               //                      /*getStoryUserList();
               //                  checkStory();
               //                  Timer(Duration(seconds: 1), () {
               //                    _getUserHighlights();
               //                  });*/
               //                    }
               //                  },
               //                  child: userHighlightsList.highlights.length > 0
               //                      ? Container(
               //                          // color: Colors.red,
               //                          height: 140,
               //                          child: ListView.builder(
               //                              scrollDirection: Axis.horizontal,
               //                              itemCount: userHighlightsList
               //                                      .highlights.length +
               //                                  1,
               //                              itemBuilder: (context, index) {
               //                                if (index !=
               //                                    userHighlightsList
               //                                        .highlights.length) {
               //                                  print("first image or vide");
               //                                  return UserHighlightCard(
               //                                    onTap: () {
               //                                      widget.setNavbar!(true);
               //                                      Navigator.push(
               //                                          context,
               //                                          MaterialPageRoute(
               //                                              builder: (context) =>
               //                                                  MainHighlightsPage(
               //                                                    highlights:
               //                                                        userHighlightsList
               //                                                            .highlights,
               //                                                    index: index,
               //                                                    setNavBar: widget
               //                                                        .setNavbar!,
               //                                                  )));
               //                                    },
               //                                    onLongTap: () {
               //                                      // if (widget.memberID ==
               //                                      //     CurrentUser()
               //                                      //         .currentUser
               //                                      //         .memberID) {
               //                                      showModalBottomSheet(
               //                                          backgroundColor:
               //                                              Colors.white,
               //                                          shape: RoundedRectangleBorder(
               //                                              borderRadius: BorderRadius.only(
               //                                                  topLeft:
               //                                                      const Radius
               //                                                              .circular(
               //                                                          20.0),
               //                                                  topRight:
               //                                                      const Radius
               //                                                              .circular(
               //                                                          20.0))),
               //                                          //isScrollControlled:true,
               //                                          context: context,
               //                                          builder:
               //                                              (BuildContext bc) {
               //                                            return HighlightsProfileMenu(
               //                                              shareTo: () async {
               //                                                Navigator.pop(
               //                                                    context);
               //                                                Uri uri = await DeepLinks.createHighlightDeepLink(
               //                                                    userHighlightsList
               //                                                        .highlights[
               //                                                            index]
               //                                                        .memberId!,
               //                                                    AppLocalizations.of(
               //                                                        'highlight'),
               //                                                    userHighlightsList
               //                                                        .highlights[
               //                                                            index]
               //                                                        .firstImageOrVideo!
               //                                                        .replaceAll(
               //                                                            ".mp4",
               //                                                            ".jpg"),
               //                                                    userHighlightsList
               //                                                        .highlights[
               //                                                            index]
               //                                                        .highlightText!,
               //                                                    "${userHighlightsList.highlights[index].shortcode}",
               //                                                    "",
               //                                                    index
               //                                                        .toString());
               //                                                Share.share(
               //                                                  '${uri.toString()}',
               //                                                );
               //                                              },
               //                                              copyLink: () async {
               //                                                Navigator.pop(
               //                                                    context);
               //                                                Uri uri = await DeepLinks.createHighlightDeepLink(
               //                                                    userHighlightsList
               //                                                        .highlights[
               //                                                            index]
               //                                                        .memberId!,
               //                                                    AppLocalizations.of(
               //                                                        'highlight'),
               //                                                    userHighlightsList
               //                                                        .highlights[
               //                                                            index]
               //                                                        .firstImageOrVideo!
               //                                                        .replaceAll(
               //                                                            ".mp4",
               //                                                            ".jpg"),
               //                                                    userHighlightsList
               //                                                        .highlights[
               //                                                            index]
               //                                                        .highlightText!,
               //                                                    "${userHighlightsList.highlights[index].shortcode}",
               //                                                    "",
               //                                                    index
               //                                                        .toString());
               //                                                Clipboard.setData(
               //                                                    ClipboardData(
               //                                                        text: uri
               //                                                            .toString()));
               //                                                Fluttertoast
               //                                                    .showToast(
               //                                                  msg:
               //                                                      AppLocalizations
               //                                                          .of(
               //                                                    "Link Copied",
               //                                                  ),
               //                                                  toastLength: Toast
               //                                                      .LENGTH_SHORT,
               //                                                  gravity:
               //                                                      ToastGravity
               //                                                          .CENTER,
               //                                                  backgroundColor:
               //                                                      Colors.black
               //                                                          .withOpacity(
               //                                                              0.7),
               //                                                  textColor:
               //                                                      Colors
               //                                                          .white,
               //                                                  fontSize: 18.0,
               //                                                );
               //                                              },
               //                                              edit: () {
               //                                                Navigator.pop(
               //                                                    context);
               //                                                widget.setNavbar!(
               //                                                    true);
               //                                                Navigator.push(
               //                                                    context,
               //                                                    MaterialPageRoute(
               //                                                        builder: (context) =>
               //                                                            EditHighlightExpandedPage(
               //                                                              from:
               //                                                                  "profile",
               //                                                              setNavbar:
               //                                                                  widget.setNavbar!,
               //                                                              highlights:
               //                                                                  userHighlightsList.highlights[index],
               //                                                            )));
               //                                              },
               //                                              delete: () {
               //                                                Navigator.pop(
               //                                                    context);
               //
               //                                                showDialog(
               //                                                  context:
               //                                                      context,
               //                                                  builder:
               //                                                      (BuildContext
               //                                                          context) {
               //                                                    // return object of type Dialog
               //
               //                                                    return DeleteHighlightPopup(
               //                                                      delete:
               //                                                          () async {
               //                                                        Navigator.pop(
               //                                                            context);
               //                                                        Fluttertoast
               //                                                            .showToast(
               //                                                          msg: AppLocalizations
               //                                                              .of(
               //                                                            "Highlight Deleted",
               //                                                          ),
               //                                                          toastLength:
               //                                                              Toast.LENGTH_SHORT,
               //                                                          gravity:
               //                                                              ToastGravity.CENTER,
               //                                                          backgroundColor: Colors
               //                                                              .black
               //                                                              .withOpacity(0.7),
               //                                                          textColor:
               //                                                              Colors.white,
               //                                                          fontSize:
               //                                                              15.0,
               //                                                        );
               //                                                        //TODO :: inSheet 243
               //                                                        // var url = Uri.parse(
               //                                                        //     "https://www.bebuzee.com/app_devlope_heighlight_data.php?action=delete_full_highlight&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&highlight_id=${userHighlightsList.highlights[index].highlightId}");
               //
               //                                                        // var response =
               //                                                        //     await http
               //                                                        //         .get(url);
               //                                                        var url =
               //                                                            'https://www.bebuzee.com/api/deleteHighlight';
               //                                                        var response =
               //                                                            await ApiProvider().fireApiWithParamsPost(
               //                                                                url,
               //                                                                params: {
               //                                                              "user_id":
               //                                                                  CurrentUser().currentUser.memberID,
               //                                                              "country":
               //                                                                  CurrentUser().currentUser.country,
               //                                                              "highlight_id":
               //                                                                  userHighlightsList.highlights[index].highlightId,
               //                                                            });
               //                                                        // var response =
               //                                                        //     await ApiRepo.postWithToken(
               //                                                        //         "api/delete_full_highlight.php",
               //                                                        //         {
               //                                                        //       "user_id":
               //                                                        //           CurrentUser().currentUser.memberID,
               //                                                        //       "country":
               //                                                        //           CurrentUser().currentUser.country,
               //                                                        //       "highlight_id":
               //                                                        //           userHighlightsList.highlights[index].highlightId,
               //                                                        //     });
               //
               //                                                        print(response
               //                                                            .data);
               //
               //                                                        _getUserHighlights();
               //                                                      },
               //                                                    );
               //                                                  },
               //                                                );
               //                                              },
               //                                            );
               //                                          });
               //                                      // } else {
               //                                      //   return null;
               //                                      // }
               //                                    },
               //                                    e: index,
               //                                    highlight: userHighlightsList
               //                                        .highlights[index],
               //                                  );
               //                                } else {
               //                                  print("first image or vide a");
               //                                  return Container(
               //                                    child: widget.memberID ==
               //                                            CurrentUser()
               //                                                .currentUser
               //                                                .memberID
               //                                        ? Column(
               //                                            crossAxisAlignment:
               //                                                CrossAxisAlignment
               //                                                    .center,
               //                                            mainAxisAlignment:
               //                                                MainAxisAlignment
               //                                                    .center,
               //                                            children: [
               //                                              GestureDetector(
               //                                                onTap: () {
               //                                                  widget.setNavbar!(
               //                                                      true);
               //                                                  Navigator.push(
               //                                                      context,
               //                                                      MaterialPageRoute(
               //                                                          builder: (context) =>
               //                                                              AddMultipleStories(
               //                                                                setNavbar: widget.setNavbar!,
               //                                                              )));
               //                                                },
               //                                                child: Container(
               //                                                  height: 100,
               //                                                  width: 72,
               //                                                  decoration:
               //                                                      new BoxDecoration(
               //                                                    borderRadius:
               //                                                        BorderRadius
               //                                                            .circular(
               //                                                                15),
               //                                                    shape: BoxShape
               //                                                        .rectangle,
               //                                                    border:
               //                                                        new Border
               //                                                            .all(
               //                                                      color: Colors
               //                                                          .grey,
               //                                                      width: 2,
               //                                                    ),
               //                                                  ),
               //                                                  child: Padding(
               //                                                    padding:
               //                                                        EdgeInsets
               //                                                            .all(0.5
               //                                                                .w),
               //                                                    child: Icon(
               //                                                      Icons.add,
               //                                                      color: Colors
               //                                                          .black,
               //                                                      size: 40,
               //                                                    ),
               //                                                  ),
               //                                                ),
               //                                              ),
               //                                              Padding(
               //                                                padding: EdgeInsets
               //                                                    .only(
               //                                                        top: 1.5
               //                                                            .w),
               //                                                child: Container(
               //                                                  width: 80,
               //                                                  child: Text(
               //                                                    AppLocalizations
               //                                                        .of('New'),
               //                                                    style: TextStyle(
               //                                                        fontSize:
               //                                                            10.0.sp),
               //                                                    maxLines: 1,
               //                                                    overflow:
               //                                                        TextOverflow
               //                                                            .ellipsis,
               //                                                    textAlign:
               //                                                        TextAlign
               //                                                            .center,
               //                                                  ),
               //                                                ),
               //                                              )
               //                                            ],
               //                                          )
               //                                        : Container(),
               //                                  );
               //                                }
               //                              }),
               //                        )
               //                      : Container()),
               //            );
               //          } else {
               //            return Container(
               //              height: 140,
               //              child: ListView.builder(
               //                  scrollDirection: Axis.horizontal,
               //                  itemCount: 10,
               //                  itemBuilder: (context, index) {
               //                    return Padding(
               //                      padding: const EdgeInsets.symmetric(
               //                          horizontal: 8),
               //                      child: Container(
               //                        child: SkeletonAnimation(
               //                          child: Container(
               //                            width: 80,
               //                            height: 100 + 1.0.w,
               //                            decoration: new BoxDecoration(
               //                              color: Colors.grey.withOpacity(0.3),
               //                              border:
               //                              Border.all(color: Colors.white),
               //                              borderRadius:
               //                              BorderRadius.circular(15),
               //                            ),
               //                          ),
               //                        ),
               //                      ),
               //                    );
               //                  }),
               //            );
               //          }
               //        })
            ],
          ),
        ),
      ),
    );
  }
}
