import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/Language/selectLanguage.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/services/profile_api_calls.dart';
import 'package:bizbultest/settings_model.dart';
import 'package:bizbultest/utilities/Chat/shared_preferences_helper.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/BebuzeeShop/shopmainview.dart';
import 'package:bizbultest/view/BebuzeeWallet.dart/bebuzee_wallet_view.dart';
import 'package:bizbultest/view/Boards/board_controller.dart';
import 'package:bizbultest/view/Boomarks/analytics.dart';
import 'package:bizbultest/view/Boomarks/saved_boards.dart';
import 'package:bizbultest/view/CreatorsProgram/creators_program_view.dart';
import 'package:bizbultest/view/Profile/change_country_page.dart';
import 'package:bizbultest/view/Profile/select_country_code.dart';
import 'package:bizbultest/view/Streaming/streaming_home.dart';
import 'package:bizbultest/view/Wallet/WalletHomepage.dart';
import 'package:bizbultest/widgets/ProfileSettings/story_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../app.dart';
import '../../models/user.dart';
import '../../services/login_api_calls.dart';
import '../../utilities/Chat/colors.dart';
import '../../utilities/Chat/dialogue_helpers.dart';
import '../create_adverts.dart';
import '../create_banner_ads.dart';
import '../homepage.dart';
import '../login_page.dart';
import '../onboarding/signup_page1.dart';
import '../onboarding/switchaccountsignuppage.dart';

class ProfileSettingsPage extends StatefulWidget {
  final Function? setNavbar;
  final List<SettingsModelCountry>? countryList;
  final String? memberID;

  ProfileSettingsPage(
      {Key? key, this.setNavbar, this.countryList, this.memberID})
      : super(key: key);

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  SettingsModel countryList = new SettingsModel(country: []);
   SettingsModelCountry? currentcountry;
  BoardController boardController = Get.put(BoardController());
  List lastMenuList = [];
  late String countryString;
  late String lastMenuString;
  late String flag;
  String url = "bebuzee.com";
  var isexpanded = false.obs;
  bool countryListLoaded = false;
  bool lastMenuListLoaded = false;
  int people = 0;
  Color _shadowColor = HexColor("#3150cc");
  Color _backgroundColor = HexColor("#191b1f");
  Color _cardColor = HexColor("#212932");
  double _cardBorderRadius = 15;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  get properbuzBlueColor => null;

  void logout() async {
    var data = await getMembers();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("memberID");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    if (data.isNotEmpty) {
      pref.setString('bebuzeememberlist', json.encode(data));
      print("logout data success");
    }
  }

  Future<Map> getMembers() async {
    var pref = await SharedPreferences.getInstance();
    String? encodedMap;
    try {
      encodedMap = pref.getString('bebuzeememberlist');
      print("encodedmap=$encodedMap");
    } catch (e) {
      print('encodedmap=$e');
      return {};
    }
    if (encodedMap == null) return {};
    Map<String, dynamic> decodedMap = json.decode(encodedMap);
    print('logintest length=${decodedMap['data'].length}');
    return decodedMap;
  }

//   void addNewMember(User user) async {
//     var pref = await SharedPreferences.getInstance();
//     List data = [];
//     Map<String, dynamic> memberData = {
//       "user_id": user.memberID,
//       "member_image": user.image,
//     };
// //Check wther member is there or not
//     //if not there

//     if (await getMembers().then((value) => value.isNotEmpty)) {
//       var data = pref.getString('bebuzeememberlist');
//       var decodeddata = json.decode(data);
//       decodeddata['data'].add(memberData);
//       pref.setString('bebuzeememberlist', json.encode(decodeddata));
//     } else {}
//   }

  Future<void> getStoryHideCount() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_story_data.php?action=get_all_story_hidden_from_number&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          people = jsonDecode(response.body)['total_hidden'];
        });
      }
    }
  }

  void _navigateToHome() {
    // SystemNavigator.pop();
    // Navigator.popUntil(context, (route) => route.isFirst);
    // Navigator.of(context).pop();
    Navigator.popUntil(
      context,
      ModalRoute.withName('/login'),
    );
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => LoginPage(
    //               from: "disable",
    //               isSwitch: true,
    //             )));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            hasMemberLoaded: true,
            from: 'disable',
            currentMemberImage: CurrentUser().currentUser.image,
            memberID: CurrentUser().currentUser.memberID,
            country: CurrentUser().currentUser.country,
            logo: CurrentUser().currentUser.logo,
          ),
        ));

// Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => HomePage(
    //               hasMemberLoaded: true,
    //               from: 'disable',
    //               currentMemberImage: CurrentUser().currentUser.image,
    //               memberID: CurrentUser().currentUser.memberID,
    //               country: CurrentUser().currentUser.country,
    //               logo: CurrentUser().currentUser.logo,
    //             )));
  }

  Future<void> getCountryList() async {
    await ProfileApiCalls.getSettingsCountries().then((value) {
      if (mounted) {
        setState(() {
          countryList.country = value!.country;
        });
      }
      currentcountry = countryList.country!
          .where((element) =>
              element.countryName == CurrentUser().currentUser.country)
          .toList()[0];
      return value;
    });
  }

  Widget _sizedBox(double h, double w) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  Future<String> getLastMenu() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/menu_option_api_call.php?action=bebuzee_menu_option_right&country=${CurrentUser().currentUser.country}&user_id=${CurrentUser().currentUser.memberID}");

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

  TextStyle _commonStyle(double size, FontWeight weight) {
    return GoogleFonts.heebo(
        fontSize: size, fontWeight: weight, color: Colors.white);
  }

  TextStyle _dropdowTextStyle(double size, FontWeight weight) {
    return GoogleFonts.heebo(
        fontSize: size, fontWeight: weight, color: Colors.black);
  }

  Widget _title() {
    return Text(
      AppLocalizations.of("Account Settings"),
      style: _commonStyle(24, FontWeight.w500),
    );
  }

  Widget _profilePicture() {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.transparent,
        backgroundImage:
            CachedNetworkImageProvider(CurrentUser().currentUser.image!),
      ),
    );
  }

  Widget _nameCard() {
    return Text(
      CurrentUser().currentUser.fullName!.replaceAll("  ", ""),
      style: _commonStyle(18, FontWeight.normal),
    );
  }

  Widget _divider() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Divider(
          thickness: 0.1,
          color: Colors.grey.shade100,
        ));
  }

  Widget _advertsTile(String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      dense: true,
      title: Text(
        title,
        style: _commonStyle(16, FontWeight.w500),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 16,
      ),
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
//TVISHA START
  // Widget _countryTile(
  //   String title,
  //   String flag,
  //   TextStyle stylee,
  // ) {
  //   return ListTile(
  //     // selected: true,
  //     title: Text(
  //       title,
  //       style: stylee,
  //       // TextStyle(
  //       // color: title == countryString ? Colors.green : Colors.black)
  //       // _dropdowTextStyle(16, FontWeight.w500),
  //     ),
  //     trailing: Container(
  //         decoration: new BoxDecoration(
  //           shape: BoxShape.circle,
  //           border: new Border.all(
  //             color: _shadowColor,
  //             width: 3,
  //           ),
  //         ),
  //         child: CircleAvatar(
  //             radius: 20,
  //             foregroundColor: Colors.white,
  //             backgroundColor: Colors.white,
  //             child: Text(
  //               flag,
  //               style: TextStyle(fontSize: 16),
  //             ))),
  //   )

  //       // index == lastIndex ? Container() : _divider()
  //       ;
  // }
//TVISHA END

  Widget _countryTileDropdown() {
    return Column(
      children: [
        ListTile(
          onTap: () {
            isexpanded.value = !isexpanded.value;
          },
          dense: true,
          title: Text(
            !isexpanded.value ? 'See More' : 'Show less',
            style: _commonStyle(16, FontWeight.w500),
          ),
          trailing: Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(
                  color: _shadowColor,
                  width: 3,
                ),
              ),
              child: Icon(
                !isexpanded.value
                    ? Icons.arrow_drop_down_circle_outlined
                    : Icons.keyboard_arrow_up,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  Widget _countryTile(
      String title, String flag, int index, int lastIndex, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          dense: true,
          title: Text(
            title,
            style: _commonStyle(16, FontWeight.w500),
          ),
          trailing: Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(
                  color: _shadowColor,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                  radius: 20,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white,
                  child: Text(
                    flag,
                    style: TextStyle(fontSize: 16),
                  ))),
        ),
        index == lastIndex ? Container() : _divider()
      ],
    );
  }

  String _flags(int i) {
    if (i == 0) {
      return "🇦🇺";
    } else if (i == 1) {
      return "🇨🇲";
    } else if (i == 2) {
      return "🇨🇦";
    } else if (i == 3) {
      return "🇬🇭";
    } else if (i == 4) {
      return "🇮🇹";
    } else if (i == 5) {
      return "🇰🇪";
    } else if (i == 6) {
      return "🇳🇬";
    } else if (i == 7) {
      return "🇿🇦";
    } else if (i == 8) {
      return "🇹🇿";
    } else if (i == 9) {
      return "🇺🇬";
    } else if (i == 10) {
      return "🇬🇧";
    } else if (i == 11) {
      return "🇺🇸";
    } else {
      return "🌍";
    }
  }

  bool blur = false;
  late String newString;
  // Widget dropDown9(BuildContext context) {
  //   return Container(
  //       alignment: Alignment.center,
  //       width: 88.w,
  //       // height: 20.h,
  //       decoration: new BoxDecoration(
  //         color: _cardColor,
  //         borderRadius: BorderRadius.all(Radius.circular(20)),
  //         // shape: BoxShape.rectangle,
  //       ),
  //       child: Expanded(
  //           child:
  //               Column(mainAxisAlignment: MainAxisAlignment.center, children: [
  //         Container(
  //           decoration: new BoxDecoration(
  //             // color: _cardColor,
  //             borderRadius: BorderRadius.all(Radius.circular(20)),
  //             // shape: BoxShape.rectangle,
  //           ),
  //           alignment: Alignment.center,
  //           height: 8.h,
  //           margin: EdgeInsets.symmetric(horizontal: 15),
  //           child: DropdownButton<SettingsModelCountry>(
  //             borderRadius: BorderRadius.all(Radius.circular(15)),
  //             menuMaxHeight: 75.h,
  //             dropdownColor: _cardColor,
  //             itemHeight: 75,
  //             alignment: AlignmentDirectional.center,
  //             style:
  //                 TextStyle(color: Theme.of(context).textTheme.headline1.color),
  //             underline: Container(),
  //             isExpanded: true,
  //             onTap: () {
  //               setState(() {
  //                 blur = true;
  //               });
  //             },
  //             icon: Icon(
  //               Icons.arrow_drop_down_sharp,
  //               size: 25,
  //               color: Colors.white,
  //             ),
  //             iconSize: 20,
  //             items: (countryList.country)
  //                 .map<DropdownMenuItem<SettingsModelCountry>>(
  //                     (SettingsModelCountry value) {
  //               return DropdownMenuItem<SettingsModelCountry>(
  //                   value: value,
  //                   // child: Container(

  //                   child: WillPopScope(
  //                     onWillPop: () async {
  //                       setState(() {
  //                         blur = false;
  //                       });
  //                       return true;
  //                     },
  //                     child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           _countryTile(value.name, value.flag,
  //                               _commonStyle(16, FontWeight.w500)),
  //                           _divider(),
  //                         ]),
  //                   ));
  //             }).toList(),
  //             onChanged: (val) {
  //               setState(() async {
  //                 countryString = val.name ?? countryString;
  //                 flag = val.flag ?? flag;
  //                 blur = false;
  //                 _scaffoldKey.currentState.showSnackBar(blackSnackBar(
  //                     AppLocalizations.of('Switched to ${val.name}')));
  //                 setState(() {
  //                   CurrentUser().currentUser.country = val.name;
  //                 });
  //                 ProfileApiCalls.changeCountry(val.name);
  //               });
  //             },
  //             hint: Text(
  //               AppLocalizations.of("Country"),
  //               // countryString,
  //               style: _commonStyle(16, FontWeight.w500),
  //               // style:
  //               //   TextStyle(
  //               //       fontSize: 16,
  //               //       color:  Colors.black : null),
  //             ),
  //           ),
  //         ),
  //         CurrentUser().currentUser.country != null &&
  //                 CurrentUser().currentUser.country != ""
  //             ? _divider()
  //             : Container(),
  //         CurrentUser().currentUser.country != null
  //             ? _countryTile(CurrentUser().currentUser.country ?? "",
  //                 flag ?? "", _commonStyle(16, FontWeight.w500))
  //             : Container(),
  //       ])));
  // }

  Widget _settingsTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      dense: true,
      title: Text(
        title,
        style: _commonStyle(16, FontWeight.w500),
      ),
      trailing: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.black,
              width: 3,
            ),
          ),
          child: CircleAvatar(
              radius: 20,
              foregroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(icon, color: Colors.black))),
    );
  }

  falggg() async {
    countryList.country = widget.countryList;
    await getCountryList();
    // if (
    // CurrentUser().currentUser.country != null &&
    // countryList.country.length == 0) {

    for (int i = 0; i < countryList.country!.length; i++) {
      if (countryList.country![i].name == CurrentUser().currentUser.country)
        setState(() async {
          flag = await countryList.country![i].flag;
        });
      // }
    }
  }

  @override
  void initState() {
    print("current country=entered initstate");
    OtherUser().otherUser.memberID = CurrentUser().currentUser.memberID;
    countryList.country = widget.countryList;

    // print("current country=${currentcountry.countryName}");
    // getStoryHideCount();

    falggg();

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
          automaticallyImplyLeading: true,
          brightness: Brightness.dark,
          backgroundColor: _shadowColor,
          elevation: 0,
        ),
      ),
      backgroundColor: _backgroundColor,
      body: WillPopScope(
        onWillPop: () async {
          widget.setNavbar!(false);
          Navigator.pop(context);
          return true;
        },
        child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BackdropFilter(
              blendMode: blur ? BlendMode.softLight : BlendMode.lighten,
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      height: 40.0.h,
                      color: _shadowColor,
                    ),
                    Container(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _sizedBox(40, 0),
                              _title(),
                              //_sizedBox(25, 0),
                              // _profilePicture(),
                              // _sizedBox(10, 0),
                              //  _nameCard(),
                              //_sizedBox(10, 0),
                              _sizedBox(25, 0),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(_cardBorderRadius))),
                                  color: _cardColor,
                                  child: Column(
                                    children: [
                                      _sizedBox(10, 0),
                                      _advertsTile(
                                          AppLocalizations.of(
                                              "Bebuzee Streaming"), () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StreamingHome()));
                                      }),
                                      _divider(),
                                      _advertsTile(
                                          AppLocalizations.of("My Boards"), () {
                                        OtherUser().otherUser.memberID =
                                            CurrentUser().currentUser.memberID;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SavedBoards(
                                              memberID: widget.memberID!,
                                            ),
                                          ),
                                        );
                                      }),
                                      _divider(),
                                      _advertsTile(
                                          AppLocalizations.of(
                                            "Create Video Adverts",
                                          ), () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoAdverts()));
                                      }),
                                      _divider(),
                                      _advertsTile(
                                          AppLocalizations.of(
                                            "Create Banner Ads",
                                          ), () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BannerAds()));
                                      }),
                                      _divider(),
                                      // _advertsTile("Bebuzee Wallet", () {
                                      //   // Navigator.push(
                                      //   //     context,
                                      //   //     MaterialPageRoute(
                                      //   //         builder: (context) =>
                                      //   //             BebuzeeWalletView()
                                                // HomePage()
                                      //   //         ));

                                      // // }),
                                      // _divider(),
                                      _advertsTile(
                                          AppLocalizations.of("Language"), () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Selectlanguage()));
                                      }),
                                      _divider(),
                                      _advertsTile(
                                          AppLocalizations.of(
                                            "Creators Program",
                                          ), () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreatorsProgramView()));
                                      }),
                                      _divider(),
                                      _advertsTile(
                                          AppLocalizations.of("Analytics"), () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Analytics()));
                                      }),
                                      _divider(),
                                      _advertsTile(
                                          AppLocalizations.of("Story Settings"),
                                          () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StorySettingsPage(
                                              people: people,
                                              setNewCount: () {
                                                getStoryHideCount();
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                      _divider(),
                                      _advertsTile(
                                          AppLocalizations.of("Account"), () {
                                        showBarModalBottomSheet(
                                            context: context,
                                            builder: (ctx) => FutureBuilder(
                                                future: getMembers(),
                                                builder: (context,
                                                        AsyncSnapshot<Map>
                                                            snapshot) =>
                                                    (snapshot.data!.isNotEmpty)
                                                        ? Container(
                                                            color:
                                                                _backgroundColor,
                                                            height: 70.0.h,
                                                            width: 100.0.w,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ListTile(
                                                                    leading:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    title: Text(
                                                                      'Your Bebuzee Account',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  ListView
                                                                      .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: snapshot
                                                                        .data![
                                                                            'data']
                                                                        .length,
                                                                    itemBuilder: (context, index) => ListTile(
                                                                        onTap: () async {
                                                                          if (CurrentUser().currentUser.memberID ==
                                                                              snapshot.data!['data'][index]['user_id']) {
                                                                            Navigator.of(context).pop();
                                                                            Get.snackbar('Error',
                                                                                'Already logged in',
                                                                                icon: Icon(
                                                                                  Icons.error_outline,
                                                                                  color: Colors.white,
                                                                                ));
                                                                            return;
                                                                          }
                                                                          print(
                                                                              "email=${snapshot.data!['data'][index]['member_email']} pass=${snapshot.data!['data'][index]['member_password']}");
                                                                          // var pref =
                                                                          //     await SharedPreferences.getInstance();
                                                                          // pref.remove(
                                                                          //     'bebuzeememberlist');
                                                                          // return;
                                                                          // return;
                                                                          Get.dialog(
                                                                              ProcessingDialog(
                                                                            title:
                                                                                "Switching Account...",
                                                                            heading:
                                                                                "",
                                                                          ));
                                                                          logout();

                                                                          await LoginApiCalls.checkLogin(snapshot.data!['data'][index]['member_email'], snapshot.data!['data'][index]['member_password'])
                                                                              .then((value) {
                                                                            if (value[0] ==
                                                                                "success") {
                                                                              setState(() {
                                                                                CurrentUser().currentUser.memberID = value[1];
                                                                              });
                                                                              LoginApiCalls.insertCountry(value[1], CurrentUser().currentUser.country!);

                                                                              LoginApiCalls.getCurrentMember(value[1]).then((data) async {
                                                                                if (mounted) {
                                                                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                                                                  pref.setString("email", CurrentUser().currentUser.email!);
                                                                                  setState(() {
                                                                                    CurrentUser().currentUser.fullName = data[0];
                                                                                    CurrentUser().currentUser.image = data[2];
                                                                                    CurrentUser().currentUser.shortcode = data[1];
                                                                                    CurrentUser().currentUser.memberType = int.parse(data[3]);
                                                                                    CurrentUser().currentUser.email = CurrentUser().currentUser.email;
                                                                                  });
                                                                                  // addNewMember(CurrentUser().currentUser);
                                                                                }
                                                                                Get.back();
                                                                                Navigator.of(context).pop();
                                                                                widget.setNavbar!(true);
                                                                                _navigateToHome();
                                                                                return data;
                                                                              });
                                                                            }
                                                                          });
                                                                        },
                                                                        leading: CircleAvatar(
                                                                          backgroundColor:
                                                                              Colors.grey,
                                                                          backgroundImage:
                                                                              CachedNetworkImageProvider(snapshot.data!['data'][index]['member_image']),
                                                                        ),
                                                                        title: Text('${snapshot.data!['data'][index]['member_name']}', style: TextStyle(color: Colors.white)),
                                                                        subtitle: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text('@${snapshot.data!['data'][index]['member_shortcode']}',
                                                                                style: TextStyle(color: Colors.white)),
                                                                            SizedBox(
                                                                              height: 0.2.h,
                                                                            ),
                                                                            Text(
                                                                                '${snapshot.data!['data'][index]['member_type'] == 0 ? "User" : snapshot.data!['data'][index]['member_type'] == 1 ? "Real Estate Agent Account" : snapshot.data!['data'][index]['member_type'] == 2 ? "Shopping Merchant account" : "Tradesman account"}',
                                                                                style: TextStyle(color: Colors.white))
                                                                          ],
                                                                        ),
                                                                        trailing: IconButton(
                                                                          icon: Icon(
                                                                              Icons.more_vert,
                                                                              color: Colors.white),
                                                                          onPressed:
                                                                              () {
                                                                            showBarModalBottomSheet(
                                                                                context: context,
                                                                                builder: (ctx) => Container(
                                                                                      height: 10.0.h,
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          ListTile(
                                                                                            onTap: () async {
                                                                                              var pref = await SharedPreferences.getInstance();
                                                                                              var encoded = pref.getString('bebuzeememberlist');
                                                                                              var decoded = json.decode(encoded!);
                                                                                              decoded['data'].removeAt(index);
                                                                                              pref.setString('bebuzeememberlist', json.encode(decoded));
                                                                                              Navigator.of(context).pop();
                                                                                              Navigator.of(context).pop();
                                                                                              Get.showSnackbar(
                                                                                                GetSnackBar(message: 'Removed Account', title: 'Success', duration: Duration(milliseconds: 650)),
                                                                                              );
                                                                                            },
                                                                                            leading: Icon(Icons.remove_circle, color: Colors.grey),
                                                                                            title: Text('Remove Account'),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ));
                                                                          },
                                                                        )
                                                                        // Radio(
                                                                        //     value:
                                                                        //         true,
                                                                        //     groupValue:
                                                                        //         true,
                                                                        //     fillColor: MaterialStateProperty.all(Colors
                                                                        //         .white),
                                                                        //     onChanged:
                                                                        //         (v) {}),
                                                                        ),
                                                                  ),
                                                                  // ListTile(
                                                                  //   leading:
                                                                  //       CircleAvatar(
                                                                  //     backgroundImage: CachedNetworkImageProvider(CurrentUser()
                                                                  //         .currentUser
                                                                  //         .image),
                                                                  //   ),
                                                                  //   title: Text(
                                                                  //       '${CurrentUser().currentUser.fullName}',
                                                                  //       style: TextStyle(
                                                                  //           color:
                                                                  //               Colors.white)),
                                                                  //   subtitle:
                                                                  //       Column(
                                                                  //     crossAxisAlignment:
                                                                  //         CrossAxisAlignment
                                                                  //             .start,
                                                                  //     children: [
                                                                  //       Text(
                                                                  //           '@${CurrentUser().currentUser.shortcode}',
                                                                  //           style:
                                                                  //               TextStyle(color: Colors.white)),
                                                                  //       SizedBox(
                                                                  //         height:
                                                                  //             0.2.h,
                                                                  //       ),
                                                                  //       Text(
                                                                  //           'User Account',
                                                                  //           style:
                                                                  //               TextStyle(color: Colors.white))
                                                                  //     ],
                                                                  //   ),
                                                                  //   trailing: Radio(
                                                                  //       value:
                                                                  //           true,
                                                                  //       groupValue:
                                                                  //           true,
                                                                  //       fillColor:
                                                                  //           MaterialStateProperty.all(Colors
                                                                  //               .white),
                                                                  //       onChanged:
                                                                  //           (v) {}),
                                                                  // ),
                                                                  _divider(),
                                                                  ListTile(
                                                                    onTap:
                                                                        () async {
                                                                      Navigator.of(context).push(MaterialPageRoute(
                                                                          builder: (context) => SwitchSignUpPage1(
                                                                                from: 'profile',
                                                                              )));
                                                                      // getMembers();
                                                                      // addNewMember(
                                                                      //     CurrentUser()
                                                                      //         .currentUser);
                                                                    },
                                                                    leading: Icon(
                                                                        Icons
                                                                            .account_circle_sharp,
                                                                        color: Colors
                                                                            .white),
                                                                    title: Text(
                                                                        'Add Another Account',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white)),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        90.0.w,
                                                                    child: ElevatedButton(
                                                                        onPressed: () {
                                                                          Navigator.of(context)
                                                                              .push(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                LoginPage(from: 'switchaccount'),
                                                                          ));
                                                                        },
                                                                        child: Text('Log in to an existing account')),
                                                                  ),
                                                                ],
                                                              ),
                                                            ))
                                                        : Container()));
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             Analytics()));
                                      }),
                                      // _divider(),
                                      // _divider(),
                                      // _advertsTile('Bebuzee Shop', () {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             ShopMainView()),
                                      //   );
                                      // }),
                                      // _sizedBox(10, 0),
                                    ],
                                  ),
                                ),
                              ),

                              _sizedBox(25, 0),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Obx(
                                  () => Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  _cardBorderRadius))),
                                      color: _cardColor,
                                      child: countryList.country!.length > 0 &&
                                              currentcountry != null &&
                                              currentcountry!.countryName !=
                                                  null &&
                                              !isexpanded.value
                                          ? ListView(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              children: [
                                                _countryTile(
                                                    currentcountry!.countryName,
                                                    currentcountry!.flagIcon,
                                                    0,
                                                    1,
                                                    () {}),
                                                _countryTileDropdown()
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                _countryTile(
                                                    currentcountry?.countryName ?? "",
                                                    currentcountry?.flagIcon ?? "",
                                                    0,
                                                    1,
                                                    () {}),
                                                ListView.builder(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: countryList
                                                            .country?.length ??
                                                        0,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (countryList
                                                              .country![index]
                                                              .name ==
                                                          CurrentUser()
                                                              .currentUser
                                                              .country)
                                                        return Container(
                                                            height: 0,
                                                            width: 0);
                                                      return _countryTile(
                                                          countryList
                                                              .country![index]
                                                              .name,
                                                          countryList
                                                              .country![index]
                                                              .flagIcon,
                                                          index,
                                                          countryList.country!
                                                                  .length -
                                                              1, () {
                                                        ScaffoldMessenger.of(
                                                                _scaffoldKey
                                                                    .currentState!
                                                                    .context)
                                                            .showSnackBar(blackSnackBar(
                                                                AppLocalizations.of(
                                                                    'Switched to ${countryList.country![index].name}')));
                                                        setState(() {
                                                          CurrentUser()
                                                                  .currentUser
                                                                  .country =
                                                              countryList
                                                                  .country![
                                                                      index]
                                                                  .value;
                                                          currentcountry =
                                                              countryList
                                                                      .country![
                                                                  index];
                                                        });
                                                        isexpanded.value =
                                                            false;
                                                        ProfileApiCalls
                                                            .changeCountry(
                                                                countryList
                                                                    .country![
                                                                        index]
                                                                    .name);
                                                      });
                                                    }),
                                                _countryTileDropdown()
                                              ],
                                            )),
                                ),
                              ),
                              // Container(
                              //   // height: 50.h,
                              //   child: BackdropFilter(
                              //     filter:
                              //         ImageFilter.blur(sigmaX: 4.0, sigmaY: 10.0),
                              // child:
                              // dropDown9(context),
                              //   ),
                              // ),
                              //   padding: EdgeInsets.symmetric(horizontal: 20),
                              //   child: Card(
                              //       elevation: 10,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(_cardBorderRadius))),
                              //       color: _cardColor,

                              // child: ListView.builder(
                              //     padding: EdgeInsets.symmetric(vertical: 10),
                              //     shrinkWrap: true,
                              //     physics: NeverScrollableScrollPhysics(),
                              //     itemCount: countryList.country?.length ?? 0,
                              //     itemBuilder: (context, index) {
                              //       return _countryTile(
                              // countryList.country[index].name,
                              //           countryList.country[index].flagIcon,
                              //           index,
                              //           countryList.country.length - 1, () {
                              // _scaffoldKey.currentState.showSnackBar(
                              //             blackSnackBar(AppLocalizations.of(
                              //                 'Switched to ${countryList.country[index].name}')));
                              //         setState(() {
                              //           CurrentUser().currentUser.country =
                              //               countryList.country[index].value;
                              //         });
                              //         ProfileApiCalls.changeCountry(
                              //             countryList.country[index].name);
                              //       });
                              //     }),
                              // ),
                              // ),
                              _sizedBox(25, 0),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(_cardBorderRadius))),
                                  color: _cardColor,
                                  child: Column(
                                    children: [
                                      _sizedBox(10, 0),
                                      /*  _settingsTile("Update Info", Icons.info, () {}),
                                    _divider(),*/
                                      _settingsTile(
                                          AppLocalizations.of("Find Hotels"),
                                          Icons.hotel,
                                          () {}),
                                      _divider(),
                                      _settingsTile(
                                          AppLocalizations.of(
                                            "Real Estate Search",
                                          ),
                                          Icons.house,
                                          () {}),
                                      _divider(),
                                      _settingsTile(
                                          AppLocalizations.of(
                                              "Terms And Conditions"),
                                          Icons.privacy_tip_outlined,
                                          () {}),
                                      _divider(),
                                      _settingsTile(
                                          AppLocalizations.of("Share"),
                                          Icons.share, () {
                                        Share.share(url);
                                      }),
                                      _divider(),
                                      _settingsTile(
                                          AppLocalizations.of("Logout"),
                                          Icons.logout, () {
                                        logout();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoginPage(
                                                      from: "disable",
                                                    )));
                                      }),
                                      _sizedBox(10, 0),
                                    ],
                                  ),
                                ),
                              ),

                              _sizedBox(25, 0),
                              Container(
                                child: Text('Your Account'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
