import 'dart:convert';
import 'dart:developer';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/new_wallet/wallet_main_screen.dart';
import 'package:bizbultest/view/BebuzeeShop/shopmainview.dart';
import 'package:bizbultest/view/Properbuz/location_reviews_view.dart';
import 'package:bizbultest/view/Properbuz/properbuz_home_view.dart';
import 'package:bizbultest/view/Properbuz/properpuz_bottom_stack_view.dart';
import 'package:bizbultest/view/Streaming/streaming_home.dart';
import 'package:bizbultest/view/Websocketdemo/websocketmainpage.dart';
import 'package:bizbultest/view/login_page.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
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
import '../api/api.dart';
import '../models/Activity/activity_model.dart';
import '../view/BebuzeeWallet.dart/bebuzee_wallet_view.dart';
import '../view/Bebuzeesearch/bebuzeesearchview.dart';
import '../view/Buzzfeed/shopbuz_logo_icon.dart';
import '../view/Properbuz/reviews/newlocationreviewpage.dart';
import '../view/tradesmanviews/tradesmanmainview.dart';
import '../widgets/FeedPosts/record_video.dart';
import '../widgets/all_cat_icons.dart';
import '../widgets/wallet_icon_icons.dart';
import 'colors.dart';
import 'custom_icons.dart';
import 'package:bizbultest/widgets/test.dart';
import '../api/ApiRepo.dart' as ApiRepo;

class CommonAppbar extends StatefulWidget {
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

  CommonAppbar(
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
  _CommonAppbarState createState() => _CommonAppbarState();
}

class _CommonAppbarState extends State<CommonAppbar>
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
          topRight: const Radius.circular(20.0),
        ),
      ),
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
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

                log("dharmik");
                Get.to(()=>FeedPostMainPage(
                                setNavbar: widget.setNavbar,
                                refresh: widget.refresh,
                              ));
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => FeedPostMainPage(
                //                 setNavbar: widget.setNavbar!,
                //                 refresh: widget.refresh!,
                //               )));
                },
              ),
              _tile(
                CustomIcons.upload_video,
                AppLocalizations.of("Upload a Video"),
                () async {
                  Navigator.pop(context);
                  widget.setNavbar!(true);
                  
                   Get.to(()=>UploadVideo(
                                setNavbar: widget.setNavbar,
                                refresh: widget.refresh,
                              ));
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => UploadVideo(
                  //       setNavbar: widget.setNavbar!,
                  //       refresh: widget.refreshBigVideo!,
                  //     ),
                  //   ),
                  // );
                },
              ),
              _tile(
                CustomIcons.shortbuz1,
                AppLocalizations.of("Shortbuz"),
                () {
                  Navigator.pop(context);
                  widget.setNavbar!(true);
                    Get.to(()=>CreateShortbuz(
                                from: false,
                                refreshFromShortbuz:
                                    widget.refreshFromShortbuz!,
                                setNavbar: widget.setNavbar!,
                                refresh: widget.refresh!,
                              ));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => CreateShortbuz(
                  //               from: false,
                  //               refreshFromShortbuz:
                  //                   widget.refreshFromShortbuz!,
                  //               setNavbar: widget.setNavbar!,
                  //               refresh: widget.refresh!,
                  //             )));
                },
              ),
              _tile(
                CustomIcons.upload_photo,
                AppLocalizations.of("Story"),
                () async {
                  Navigator.pop(context);
                  widget.setNavbar!(true);
                   Get.to(()=>CreateStory(
                                setNavbar: widget.setNavbar!,
                                refreshFromMultipleStories:
                                    widget.refreshFromMultipleStories!,
                              ));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => CreateStory(
                  //               setNavbar: widget.setNavbar!,
                  //               refreshFromMultipleStories:
                  //                   widget.refreshFromMultipleStories!,
                  //             )));
                },
              ),
              _tile(
                CustomIcons.create_blog,
                AppLocalizations.of("Write a Blog"),
                () async {
                  Navigator.pop(context);
                   Get.to(()=>MaterialPageRoute(
                          builder: (context) => CreateBlog(
                                logo: widget.logo!,
                                country: widget.country!,
                                memberID: widget.memberID!,
                              )));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => CreateBlog(
                  //               logo: widget.logo!,
                  //               country: widget.country!,
                  //               memberID: widget.memberID!,
                  //             )));
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

  Widget _iconButton(
      IconData icon, VoidCallback onTap, double padding, double size) {
    return IconButton(
        splashRadius: 20,
        padding: EdgeInsets.symmetric(horizontal: padding),
        constraints: BoxConstraints(),
        icon: Icon(
          icon,
          color: Colors.black,
          size: size,
        ),
        onPressed: onTap);
  }

  Future<void> checkNotifications() async {
    var response = await ApiRepo.postWithToken("api/check_notification.php", {
      "user_id": {CurrentUser().currentUser.memberID},
    });

    if (response!.success == 1 &&
        response.data['data'] != null &&
        response.data['data'] != "" &&
        response.data['data'] != "null") {
      print(response.data['data']);
      setState(() {
        newNotification = response.data['data']['count'];
      });
    }
  }

  // Future<void> viewNotifications() async {
  //   var url = Uri.parse(
  //       "https://www.bebuzee.com/app_develope_notification.php?action=change_status_for_follow_request_notification&user_id=${CurrentUser().currentUser.memberID}");

  //   var response = await http.get(url);

  //   if (response!.statusCode == 200) {
  //     print(response!.body);
  //     setState(() {
  //       newNotification = jsonDecode(response!.body)['count'];
  //     });
  //   }
  //   return "Success";
  // }

  var ActivityNotifyList = <ActivityNotifyData>[].obs;

  Future<List<ActivityNotifyData>> activityNotifications() async {
    var response = await ApiRepo.postWithToken("api/notification_list.php",
        {"user_id": CurrentUser().currentUser.memberID, "page": 1});
    print("====###11 responssss --- ${response!.data}");
    if (response!.success == 1 &&
        response!.data['data'] != null &&
        response!.data['data'] != "" &&
        response!.data['data'] != "null") {
      print("========= ${response!.data['data']}");

      response!.data['data'].forEach((element) {
        ActivityNotifyData objPropertyBuyingModel = new ActivityNotifyData();
        objPropertyBuyingModel = ActivityNotifyData.fromJson(element);
        ActivityNotifyList.add(objPropertyBuyingModel);
      });
    } else {
      return [];
    }
    print("=========1111 ${ActivityNotifyList.length}");
    return ActivityNotifyList;
  }

  Future<void> viewNotifications() async {
    var response = await ApiRepo.postWithToken("api/view_notification.php", {
      "user_id": CurrentUser().currentUser.memberID,
    });
    print("====### responssss --- ${response!.data}");
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.toString() == "AppLifecycleState.resumed") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkNotifications();
      });
    }
  }

  @override
  void initState() {
    checkNotifications();
    getLogos();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<Map<String, dynamic>> getLogos() async {
    var url =
        'https://www.bebuzee.com/api/country/logoList?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}';
    print("response of logo=${url}");
    var response;

    try {
      response = await ApiProvider().fireApi(url);
      print("response of logo=${response}");
      if (response!.data['success'] == 1) {
        return {
          "properbuz_logo": response!.data['properbuz_url'],
          "shoppingbuz_logo": response!.data['shoppingbuz_url'],
          "tradesmen_logo": response!.data['tradesman_url']
        };
      }
    } catch (e) {
      print("response of logo error=$e");
    }

    return {};
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _iconButton(CustomIcons.plusthin, () {
        _bottomTile(context);
      }, 0, 28),
      title: Container(
        height: 42,
        child: Image.network(
          CurrentUser().currentUser.logo ?? "",
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        _iconButton(Icons.search, () {
          showBarModalBottomSheet(
            context: context,
            builder: (context) => BebuzeeSearchView(),
          );
        }, 10, 30),
        // Icon(
        //   Icons.search,
        //   size: 20,
        //   color: Colors.black,
        // ),
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
                        }, 14, 30),
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
                        leading: _iconButton(
                            ShopbuzLogo.img_20221026_wa0009__2___1_,
                            () {},
                            14,
                            30),
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
                        leading:
                            _iconButton(CustomIcons.properbuz, () {}, 14, 30),
                        title: Text('Properbuz'),
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.setNavbar!(true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProperbuzBottomStackView(
                                setNavbar: widget.setNavbar!,
                                isChannelOpen: widget.isChannelOpen!,
                                changeColor: widget.changeColor!,
                              ),
                            ),
                          );
                        },
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

                        // Container(
                        //     decoration: BoxDecoration(
                        //         image: DecorationImage(
                        //             fit: BoxFit.contain,
                        //             alignment: Alignment.bottomRight,
                        //             image: AssetImage(
                        //                 'assets/icons/tradesmaniconimage.png'))),
                        //     // child: Image.asset(
                        //     //     'assets/icons/tradesmaniconimage.png'),
                        //     height: 35,
                        //     width: 30),
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
                                    // WalletMainScreen()
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
                        leading: _iconButton(CustomIcons.review, () {}, 14, 30),
                        title: Text('Location Reviews'),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => NewLocationViewPage()));
                        },
                      )
                      // ListTile(
                      //   title: CachedNetworkImage(
                      //       imageUrl:
                      //           'https://www.bebuzee.com/img/logo/shopping/20220215145542_620bbeee3c47e.png'),
                      // )
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
        }, 10, 30),
        // _iconButton(CustomIcons.properbuz, () {
        //   widget.setNavbar(true);
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => ProperbuzBottomStackView(
        //         setNavbar: widget.setNavbar,
        //         isChannelOpen: widget.isChannelOpen,
        //         changeColor: widget.changeColor,
        //       ),
        //     ),
        //   );
        // }, 7, 22),
        SizedBox(
          width: 3.w,
        ),
        // Stack(
        //   fit: StackFit.passthrough,
        //   children: [
        //     _iconButton(CustomIcons.notification, () {
        //       viewNotifications();
        //       // activityNotifications();
        //       setState(() {
        //         newNotification = 0;
        //       });
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) =>

        //                   // SocketPage()

        //                   ActivityPage(
        //                     setNavBar: widget.setNavbar!,
        //                     isChannelOpen: widget.isChannelOpen!,
        //                     changeColor: widget.changeColor!,
        //                   )));
        //     }, 10, 28),
        //     newNotification == 1
        //         ? Positioned(
        //             right: 9.5,
        //             top: 14.8,
        //             child: Icon(
        //               Icons.circle,
        //               color: Colors.redAccent.shade700,
        //               size: 10,
        //             ),
        //           )
        //         : Container()
        //   ],
        // ),
        // _iconButton(CustomIcons.blogg, () {
        //   print("Clicked on blog buzz");

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
        // }, 7, 20
        //     //  14, 28
        //     ),
        // _iconButton(ShopbuzLogo.img_20221026_wa0009__2___1_, () {
        //   print("Clicked on blog buzz");
        //   widget.setNavbar(true);
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => ShopMainView(
        //                 setNavbar: widget.setNavbar,
        //               )));
        // }, 7, 24),

        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePageMain(
                          refresh: widget.refresh ?? (){},
                          refreshFromMultipleStories:
                              widget.refreshFromMultipleStories ?? (){},
                          refreshFromShortbuz: widget.refreshFromShortbuz ,
                          from: "appbar",
                          setNavBar: widget.setNavbar,
                          isChannelOpen: widget.isChannelOpen,
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
