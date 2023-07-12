import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/add_items_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_menu_controller.dart';
import 'package:bizbultest/services/Properbuz/report_controller.dart';
import 'package:bizbultest/view/Properbuz/properbuz_home_view.dart';
import 'package:bizbultest/view/Streaming/streaming_home.dart';
import 'package:bizbultest/view/login_page.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/activity_page.dart';
import 'package:bizbultest/view/blogbuzz_main_page.dart';
import 'package:bizbultest/view/create_blog.dart';
import 'package:bizbultest/view/create_a_shortbuz.dart';
import 'package:bizbultest/view/create_story_page.dart';
import 'package:bizbultest/view/upload_video.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/view/feeds_posts_page.dart';
import '../new_wallet/wallet_main_screen.dart';
import '../view/BebuzeeShop/shopmainview.dart';
import '../view/BebuzeeWallet.dart/bebuzee_wallet_view.dart';
import '../view/Buzzfeed/shopbuz_logo_icon.dart';
import '../view/Properbuz/location_reviews_view.dart';
import '../view/Properbuz/reviews/newlocationreviewpage.dart';
import '../view/Websocketdemo/websocketmainpage.dart';
import '../view/tradesmanviews/tradesmanmainview.dart';
import '../widgets/all_cat_icons.dart';
import '../widgets/wallet_icon_icons.dart';
import 'colors.dart';
import 'custom_icons.dart';
import 'package:bizbultest/widgets/test.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

class CustomAppbar extends StatefulWidget {
  final String? logo;
  final String? memberID;
  final String? country;
  final VoidCallback? profileButton;
  final double? elevation;
  final Function? setNavbar;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? refresh;
  final Function? refreshFromShortbuz;
  final Function? refreshFromMultipleStories;
  final Function? refreshBigVideo;

  CustomAppbar(
      {Key? key,
      this.logo,
      this.memberID,
      this.country,
      this.profileButton,
      this.elevation,
      this.setNavbar,
      this.changeColor,
      this.isChannelOpen,
      this.refresh,
      this.refreshFromShortbuz,
      this.refreshFromMultipleStories,
      this.refreshBigVideo})
      : super(key: key);

  @override
  _CustomAppbarState createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar>
    with WidgetsBindingObserver {
  HomepageRefreshState refresh = new HomepageRefreshState();

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

                  widget.setNavbar!(true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedPostMainPage(
                                setNavbar: widget.setNavbar!,
                                refresh: widget.refresh!,
                              )));
                },
              ),
              _tile(
                CustomIcons.upload_video,
                AppLocalizations.of('Upload a Video'),
                () async {
                  Navigator.pop(context);
                  widget.setNavbar!(true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadVideo(
                                setNavbar: widget.setNavbar!,
                                refresh: widget.refreshBigVideo!,
                              )));
                },
              ),
              _tile(
                CustomIcons.shortbuz1,
                AppLocalizations.of('Shortbuz'),
                () {
                  Navigator.pop(context);
                  widget.setNavbar!(true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateShortbuz(
                                from: false,
                                refreshFromShortbuz:
                                    widget.refreshFromShortbuz!,
                                setNavbar: widget.setNavbar!,
                                refresh: widget.refresh!,
                              )));
                },
              ),
              _tile(
                CustomIcons.upload_photo,
                AppLocalizations.of('Story'),
                () async {
                  Navigator.pop(context);
                  widget.setNavbar!(true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateStory(
                                setNavbar: widget.setNavbar!,
                                refreshFromMultipleStories:
                                    widget.refreshFromMultipleStories!,
                              )));
                },
              ),
              _tile(
                CustomIcons.create_blog,
                AppLocalizations.of("Write a Blog"),
                () async {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateBlog(
                                logo: widget.logo!,
                                country: widget.country!,
                                memberID: widget.memberID!,
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
                  widget.setNavbar(true);
                 Navigator.push(context, MaterialPageRoute(builder: (context) => CardsPage()));
                },
              ),*/
            ],
          ),
        );
      },
    );
  }

  int newNotification = 0;

  Widget _iconButton(IconData icon, VoidCallback onTap, double padding) {
    return IconButton(
        splashRadius: 20,
        padding: EdgeInsets.symmetric(horizontal: padding),
        constraints: BoxConstraints(),
        icon: Icon(
          icon,
          color: Colors.black,
          size: 28,
        ),
        onPressed: onTap);
  }

  // Future<void> checkNotifications() async {
  //   var url = Uri.parse(
  //       "https://www.bebuzee.com/app_develope_notification.php?action=check_if_user_has_new_notification&user_id=${CurrentUser().currentUser.memberID}");

  //   var response = await http.get(url);
  //   if (response!.statusCode == 200) {
  //     print(response!.body);
  //     setState(() {
  //       newNotification = jsonDecode(response!.body)['count'];
  //     });
  //   }
  //   return "Success";
  // }
  Future<void> checkNotifications() async {
    var response = await ApiRepo.postWithToken("api/check_notification.php", {
      "user_id": {CurrentUser().currentUser.memberID},
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "" &&
        response!.data['data'] != "null") {
      print(response!.data['data']);
      setState(() {
        newNotification = response!.data['data']['count'];
      });
    }
  }

  // Future<void> viewNotifications() async {
  //      var response =await ApiRepo.postWithToken("api/follow_accept_request.php", {
  //       "user_id":{CurrentUser().currentUser.memberID},

  //     });

  //  if (response!.success == 1 && response!.data['data'] != null && response!.data['data'] != "" && response!.data['data'] != "null") {
  //     print(response!.data['data']);
  //     setState(() {
  //       newNotification = response!.data['data']['count'];
  //     });
  //   }
  //   return "Success";
  // }

  Future<void> viewNotifications() async {
    var response = await ApiRepo.postWithToken("api/view_notification.php", {
      "user_id": {CurrentUser().currentUser.memberID},
    });

    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "" &&
        response!.data['data'] != "null") {
      print(response!.data['data']);
      setState(() {
        newNotification = response!.data['data'][0];
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.toString() == "AppLifecycleState.resumed") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //checkNotifications();
      });
    }
  }

  @override
  void initState() {
    //checkNotifications();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          height: 30,
          child:
              // CurrentUser().currentUser.properbuzLogo != null &&
              //         CurrentUser().currentUser.properbuzLogo != ''
              //     ?
              CachedNetworkImage(
                  fit: BoxFit.contain,
                  width: double.infinity,
                  imageUrl: CurrentUser().currentUser.properbuzLogo!)
          // :
          //  Image.asset(
          //     "assets/images/new_logo.png",
          //     fit: BoxFit.cover,
          //     width: double.infinity,
          //   ),
          ),
      actions: [
        _iconButton(AllCatIcon.menu_icon, () {
          // widget.setNavbar(true);
          showBarModalBottomSheet(
              context: context,
              builder: (ctx) => Column(
                    children: [
                      ListTile(
                        leading: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.close, color: Colors.black)),
                      ),
                      ListTile(
                        leading: _iconButton(CustomIcons.blogg, () {
                          print("Clicked on blog buzz");
                        }, 14),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlogBuzzMainPage(
                                        refreshFromMultipleStories:
                                            widget.refreshFromMultipleStories!,
                                        refresh: widget.refresh!,
                                        refreshFromShortbuz:
                                            widget.refreshFromShortbuz!,
                                        setNavBar: widget.setNavbar!,
                                        isChannelOpen: widget.isChannelOpen!,
                                        changeColor: widget.changeColor!,
                                        currentMemberImage:
                                            CurrentUser().currentUser.image,
                                        memberID:
                                            CurrentUser().currentUser.memberID,
                                        logo: CurrentUser().currentUser.logo,
                                        country:
                                            CurrentUser().currentUser.country,
                                      )));
                        },
                        title: Text('Blogbuz'),
                      ),
                      ListTile(
                        onTap: () {
                          Get.delete<ProperbuzController>();
                          Get.delete<ProperbuzFeedController>();
                          Get.delete<AddItemsController>();
                          Get.delete<ProperbuzMenuController>();
                          Get.delete<ReportController>();
                          widget.setNavbar!(false);
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        leading: _iconButton(CustomIcons.home, () {
                          // Get.delete<ProperbuzController>();
                          // Get.delete<ProperbuzFeedController>();
                          // Get.delete<AddItemsController>();
                          // Get.delete<ProperbuzMenuController>();
                          // Get.delete<ReportController>();
                          // widget.setNavbar(false);
                          // Navigator.of(context).popUntil((route) => route.isFirst);
                        }, 14),
                        title: Text('Home'),
                      ),
                      ListTile(
                        leading: _iconButton(
                            ShopbuzLogo.img_20221026_wa0009__2___1_, () {}, 14),
                        onTap: () {
                          Navigator.of(context).pop();
                          print("Clicked on blog buzz");
                          widget.setNavbar!(true);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopMainView(
                                        setNavbar: widget.setNavbar!,
                                      )));
                        },
                        title: Text('Shoppingbuz'),
                      ),
                      ListTile(
                        onTap: () {
                          // Navigator.of(context).pop();
                          widget.setNavbar!(true);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => TradesmenMainView(
                                    setNavbar: widget.setNavbar!,
                                  )));
                        },
                        leading: IconButton(
                            splashRadius: 20,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            onPressed: () {},
                            icon: Icon(
                              TradeIicon.app_icon_black_3d__1_,
                              color: Colors.black,
                              size: 40,
                            )),

                        //  _iconButton(
                        //     TradeIicon.app_icon_black_3d__1_, () {}, 20),

                        //  Container(
                        //     decoration: BoxDecoration(
                        //         image: DecorationImage(
                        //             fit: BoxFit.contain,
                        //             alignment: Alignment.bottomRight,
                        //             image: AssetImage(
                        //                 'assets/icons/tradesmaniconimage.png'))),
                        // child: Image.asset(
                        //     'assets/icons/tradesmaniconimage.png'),
                        // height: 35,
                        // width: 30),
                        title: Text(' Tradesman'),
                      ),
                      ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StreamingHome()));
                          },
                          leading: IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              onPressed: () {},
                              icon: Icon(
                                Icons.video_library,
                                color: Colors.black,
                                size: 30,
                              )),
                          title: Text('Bebuzee Streaming')),
                      ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Container()
                                    // BebuzeeWalletView()
                                    // HomePage()
                                    ));
                          },
                          leading: IconButton(
                              splashRadius: 20,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              onPressed: () {},
                              icon: Icon(
                                WalletIcon.wallet_icon,
                                color: Colors.black,
                                size: 30,
                              )),
                          title: Text('Bebuzee Wallet')),
                      ListTile(
                        leading: _iconButton(CustomIcons.review, () {}, 14),
                        title: Text('Location Reviews'),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => NewLocationViewPage()));
                        },
                      ),
                    ],
                  ));
          // // Navigator.push(
          // //   context,
          // //   MaterialPageRoute(
          // //     builder: (context) => ProperbuzBottomStackView(
          // //       setNavbar: widget.setNavbar,
          // //       isChannelOpen: widget.isChannelOpen,
          // //       changeColor: widget.changeColor,
          // //     ),
          // //   ),
          // );
        }, 14),
        // _iconButton(CustomIcons.home, () {
        //   Get.delete<ProperbuzController>();
        //   Get.delete<ProperbuzFeedController>();
        //   Get.delete<AddItemsController>();
        //   Get.delete<ProperbuzMenuController>();
        //   Get.delete<ReportController>();
        //   widget.setNavbar(false);
        //   Navigator.of(context).popUntil((route) => route.isFirst);
        // }, 14),
        Stack(
          fit: StackFit.passthrough,
          children: [
            _iconButton(CustomIcons.notification, () {
              // viewNotifications();
              setState(() {
                newNotification = 0;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>

                          // SocketPage()
                          ActivityPage(
                            setNavBar: widget.setNavbar!,
                            isChannelOpen: widget.isChannelOpen!,
                            changeColor: widget.changeColor!,
                          )));
            }, 14),
            newNotification == 1
                ? Positioned(
                    right: 9.5,
                    top: 14.8,
                    child: Icon(
                      Icons.circle,
                      color: Colors.redAccent.shade700,
                      size: 10,
                    ),
                  )
                : Container()
          ],
        ),
        // _iconButton(CustomIcons.blogg, () {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => BlogBuzzMainPage(
        //                 refreshFromMultipleStories:
        //                     widget.refreshFromMultipleStories,
        //                 refresh: widget.refresh,
        //                 refreshFromShortbuz: widget.refreshFromShortbuz,
        //                 setNavBar: widget.setNavbar,
        //                 isChannelOpen: widget.isChannelOpen,
        //                 changeColor: widget.changeColor,
        //                 currentMemberImage: CurrentUser().currentUser.image,
        //                 memberID: CurrentUser().currentUser.memberID,
        //                 logo: CurrentUser().currentUser.logo,
        //                 country: CurrentUser().currentUser.country,
        //               )));
        // }, 14),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePageMain(
                          refresh: widget.refresh!,
                          refreshFromMultipleStories:
                              widget.refreshFromMultipleStories!,
                          refreshFromShortbuz: widget.refreshFromShortbuz!,
                          from: "appbar",
                          setNavBar: widget.setNavbar!,
                          isChannelOpen: widget.isChannelOpen!,
                          changeColor: widget.changeColor!,
                          otherMemberID: CurrentUser().currentUser.memberID,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.transparent,
                  backgroundImage: CachedNetworkImageProvider(
                      CurrentUser().currentUser.image!),
                )),
          ),
        )
      ],
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: widget.elevation == null ? 3 : widget.elevation,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
