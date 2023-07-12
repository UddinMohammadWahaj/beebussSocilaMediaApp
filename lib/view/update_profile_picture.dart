import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/profile_picture_picker_model.dart';
import 'package:bizbultest/models/shortbuz_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';

import 'package:bizbultest/widgets/select_image_from_camera.dart';
import 'package:bizbultest/widgets/gallery_test.dart';

import 'package:bizbultest/widgets/select_image_from_gallery.dart';
import 'package:bizbultest/widgets/shortbuz_comment_page.dart';
import 'package:bizbultest/widgets/shortbuz_report_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
// import 'package:simple_image_crop/simple_image_crop.dart';
import 'dart:math' as math;
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/shortbuz_video_player.dart';
import 'package:storage_path/storage_path.dart';

class UpdateProfilePicture extends StatefulWidget {
  final VoidCallback? changePhoto;

  UpdateProfilePicture({Key? key, this.changePhoto}) : super(key: key);

  @override
  _UpdateProfilePictureState createState() => _UpdateProfilePictureState();
}

class _UpdateProfilePictureState extends State<UpdateProfilePicture> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  getPermission() async {
    if (await Permission.storage.request().isDenied) {
      await Permission.storage.request();
      await Permission.camera.request();
      await Permission.microphone.request();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: Container(
          height: 50,
          child: TabBar(
            onTap: (index) {
              print(index);
            },
            tabs: [
              Tab(
                child: Text(
                  AppLocalizations.of(
                    "Gallery",
                  ),
                  style: blackBold.copyWith(
                      color: Colors.black, fontSize: 10.0.sp),
                ),
              ),
              Tab(
                child: Text(
                  AppLocalizations.of(
                    "Camera",
                  ),
                  style: blackBold.copyWith(
                      color: Colors.black, fontSize: 10.0.sp),
                ),
              ),
            ],
            labelColor: primaryBlueColor,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(1.0.w),
            indicatorColor: Colors.black,
            // indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 2.0), insets: EdgeInsets.symmetric(horizontal: 0.0)),
          ),
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
        body: TabBarView(
          children: <Widget>[
            SelectImageFromGallery(
              sKey: _scaffoldKey,
            ),
            PictureFromCamera(),
          ],
        ),
      ),
    );
  }
}
