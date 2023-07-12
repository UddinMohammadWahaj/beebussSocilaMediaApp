import 'dart:developer';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/widgets/FeedPosts/feed_post_gallery.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/select_image_from_camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/FeedPosts/record_video.dart';
import 'package:bizbultest/widgets/FeedPosts/capture_photo.dart';
import 'package:get/get.dart';
class FeedPostMainPage extends StatefulWidget {
  final Function? setNavbar;
  final Function? refresh;

  // final VoidCallback? changePhoto;

  FeedPostMainPage({Key? key, //this.changePhoto,
   this.setNavbar, this.refresh})
      : super(key: key);

  @override
  _FeedPostMainPageState createState() => _FeedPostMainPageState();
}

class _FeedPostMainPageState extends State<FeedPostMainPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  getPermission() async {
    if (await Permission.storage.request().isDenied) {
      await Permission.storage.request();
      await Permission.camera.request();
      await Permission.microphone.request();
    }
  }

  late TabController _tabController;

  int selectedIndex = 0;

  @override
  void initState() {

    log("dharmik1   ");
    super.initState();
    _tabController = new TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: TabBar(
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });

            if (selectedIndex == 1) {
              Get.to(()=>CapturePhoto(
                            refresh: widget.refresh,
                            back: () {
                              _tabController.animateTo(0);
                            },
                          ));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CapturePhoto(
              //               refresh: widget.refresh,
              //               back: () {
              //                 _tabController.animateTo(0);
              //               },
              //             )));
            } else if (selectedIndex == 2) {
              Get.to(()=>CaptureVideo(
                            refresh: widget.refresh,
                            back: () {
                              _tabController.animateTo(0);
                            },
                          ));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CaptureVideo(
              //               refresh: widget.refresh,
              //               back: () {
              //                 _tabController.animateTo(0);
              //               },
              //             )));
            }
          },
          tabs: [
            Tab(
              child: Text(
                AppLocalizations.of(
                  "Gallery",
                ),
                style:
                    blackBold.copyWith(color: Colors.black, fontSize: 10.0.sp),
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(
                  "Camera",
                ),
                style:
                    blackBold.copyWith(color: Colors.black, fontSize: 10.0.sp),
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(
                  "Video",
                ),
                style:
                    blackBold.copyWith(color: Colors.black, fontSize: 10.0.sp),
              ),
            ),
          ],
          labelColor: primaryBlueColor,
          unselectedLabelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(1.0.w),
          indicatorColor: Colors.black,
          controller: _tabController,
          // indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 2.0), insets: EdgeInsets.symmetric(horizontal: 0.0)),
        ),
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
        ),
        body: WillPopScope(
          // ignore: missing_return
          onWillPop: () async {
            // ignore: missing_return
            widget.setNavbar!(false);
            Navigator.pop(context);
            return true;
          },
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              FeedPostGallery(
                refresh: widget.refresh,
                setNavbar: widget.setNavbar,
              ),
              Container(),
              Container(),
              // CameraExampleHome(),
            ],
          ),
        ),
      ),
    );
  }
}
