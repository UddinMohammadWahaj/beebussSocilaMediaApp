import 'dart:convert';
import 'dart:io' as i;
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/Language/selectLanguage.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/create_adverts.dart';
import 'package:bizbultest/view/create_banner_ads.dart';
import 'package:bizbultest/widgets/ProfileSettings/story_settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:path/path.dart' as path;
import 'package:sizer/sizer.dart';

class ProfileSettingsPage extends StatefulWidget {
  final String logo;
  final String memberID;
  final String country;
  final String currentUserImage;
  final String currentMemberName;
  final Function setNavbar;

  ProfileSettingsPage(
      {required Key key,
      required this.logo,
      required this.memberID,
      required this.country,
      required this.currentUserImage,
      required this.currentMemberName,
      required this.setNavbar})
      : super(key: key);

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  List countryList = [];
  List lastMenuList = [];
  late String countryString;
  late String lastMenuString;
  String url = "bebuzee.com";
  bool countryListLoaded = false;
  bool lastMenuListLoaded = false;
  int people = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<String> getStoryHideCount() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_story_data.php?action=get_all_story_hidden_from_number&user_id=${CurrentUser().currentUser.memberID}");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          people = jsonDecode(response.body)['total_hidden'];
        });
      }
      return "success";
    }
    return "";
  }

  Future<String> getCountryList() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/menu_option_api_call.php?action=bebuzee_menu_option&country=${widget.country}&user_id=${widget.memberID}");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/localized_countries.php?action=bebuzee_menu_option&country=${widget.country}&user_id=${widget.memberID}');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        countryString = json.decode(response.body)['response_data'];
        countryList = countryString.split('~~').toList();
        countryListLoaded = true;
      });
    }

    return "success";
  }

  late i.File _image;

  _imgFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _image = i.File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  Future<String> getLastMenu() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/menu_option_api_call.php?action=bebuzee_menu_option_right&country=${widget.country}&user_id=${widget.memberID}");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      if (this.mounted) {
        setState(() {
          lastMenuString = json.decode(response.body)['response_data'];
          lastMenuList = lastMenuString.split('~~').toList();
          lastMenuListLoaded = true;
        });
      }
    }

    return "success";
  }

  @override
  void initState() {
    getStoryHideCount();
    getCountryList();
    getLastMenu();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          widget.setNavbar(false);
          Navigator.pop(context);
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*     RaisedButton(
                  onPressed: () {
                    _imgFromGallery();
                  },
                  child: Text("select photo"),
                ),
                RaisedButton(
                  onPressed: () {
                    uploadImage();
                  },
                  child: Text("upload photo"),
                ),*/
                Padding(
                  padding: EdgeInsets.only(top: 7.0.h),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(widget.currentUserImage),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.5.h),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      widget.currentMemberName,
                      style: greyBold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2.0.h,
                  ),
                  child: Container(
                    //height: 30.0.h,
                    color: Colors.grey.withOpacity(0.4),
                    child: Padding(
                      padding: EdgeInsets.all(1.5.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.message,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 1.0.w,
                              ),
                              Text(
                                AppLocalizations.of(
                                  "Tell friends about Bebuzee",
                                ),
                                style: whiteBold.copyWith(fontSize: 24),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.0.w),
                            child: Container(
                                width: 50.0.w,
                                child: Text(
                                  AppLocalizations.of(
                                    "Share this link so your friends can join Bebuzee",
                                  ),
                                  style: whiteNormal.copyWith(fontSize: 15),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.5.w),
                            child: Text(
                              AppLocalizations.of(
                                "Terms & Conditions",
                              ),
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white.withOpacity(0.6)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.5.h),
                            child: Stack(
                              children: [
                                Container(
                                  height: 6.0.h,
                                  width: 100.0.w,
                                  color: Colors.black,
                                ),
                                Positioned.fill(
                                  right: 1.0.w,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.0.w),
                                      child: GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(
                                              ClipboardData(text: url));
                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(blackSnackBar(
                                                    AppLocalizations.of(
                                                        'URL Copied')));
                                          });
                                        },
                                        child: Container(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.0.w,
                                                vertical: 1.5.h),
                                            child: Text(
                                              AppLocalizations.of(
                                                "Copy Link",
                                              ),
                                              style: blackBold,
                                            ),
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  right: 1.0.w,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.0.w),
                                      child: Container(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.0.w,
                                              vertical: 1.5.h),
                                          child: Text(
                                            url,
                                            style: whiteNormal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.5.h),
                            child: GestureDetector(
                                onTap: () {
                                  Share.share(url);
                                },
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: new Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.2.h, horizontal: 1.2.h),
                                        child: Icon(
                                          Icons.share_outlined,
                                          size: 27,
                                        )),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.white.withOpacity(0.7),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Adverts(
                        title: AppLocalizations.of(
                          "Create Video Adverts",
                        ),
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoAdverts()));
                        },
                      ),
                      Adverts(
                        title: AppLocalizations.of(
                          "Create Banner Ads",
                        ),
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BannerAds()));
                        },
                      ),
                      Adverts(
                        title: AppLocalizations.of(
                          "Creators Program",
                        ),
                      ),
                      Adverts(
                        title: AppLocalizations.of(
                          "Analytics",
                        ),
                      ),
                      Adverts(
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StorySettingsPage(
                                        people: people,
                                        setNewCount: () {
                                          getStoryHideCount();
                                        },
                                      )));
                        },
                        title: AppLocalizations.of(
                          "Story Settings",
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.white.withOpacity(0.7),
                ),
                countryListLoaded == true
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0.h),
                        child: Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: countryList.length,
                                itemBuilder: (context, index) {
                                  return CountryList(
                                    country: countryList[index].toString(),
                                  );
                                }),
                          ],
                        ),
                      )
                    : Container(),
                Divider(
                  thickness: 0.5,
                  color: Colors.white.withOpacity(0.7),
                ),
                lastMenuListLoaded == true
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.0.h),
                        child: Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: lastMenuList.length,
                                itemBuilder: (context, index) {
                                  return LastMenuList(
                                    button: lastMenuList[index].toString(),
                                  );
                                }),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Adverts extends StatefulWidget {
  final String title;
  final VoidCallback? onPress;

  Adverts({Key? key, required this.title, this.onPress}) : super(key: key);

  @override
  _AdvertsState createState() => _AdvertsState();
}

class _AdvertsState extends State<Adverts> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress ?? () {},
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          child: Text(widget.title,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7), fontSize: 18)),
        ),
      ),
    );
  }
}

class CountryList extends StatefulWidget {
  final String country;
  final VoidCallback? onPress;

  CountryList({Key? key, required this.country, this.onPress})
      : super(key: key);

  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress ?? () {},
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          child: Text(widget.country,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7), fontSize: 18)),
        ),
      ),
    );
  }
}

class LastMenuList extends StatefulWidget {
  final String? button;
  final VoidCallback? onPress;

  const LastMenuList({Key? key, this.button, this.onPress}) : super(key: key);

  @override
  _LastMenuListState createState() => _LastMenuListState();
}

class _LastMenuListState extends State<LastMenuList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress ?? () {},
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          child: Text(widget.button!,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7), fontSize: 18)),
        ),
      ),
    );
  }
}
