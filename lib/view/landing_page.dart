import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/country_name.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'package:bizbultest/models/followers.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api/ApiRepo.dart' as ApiRepo;

import '../utilities/colors.dart';
import '../utilities/colors.dart';
import 'edit_profile_page.dart';
import 'homepage.dart';

class LandingPage extends StatefulWidget {
  final String? memberID;
  final String? country;

  LandingPage({Key? key, this.memberID, this.country}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var logo;
  var otherMemberID;
  bool isLogoLoaded = false;
  bool followIndicator = false;
  bool unfollowIndicator = false;
  var unfollowSuccess;
  var followSuccess;
  String status = "Follow";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var name;
  var shortcode;
  var recomendation;
  var userImage;
  var tick;
  bool hasData = false;
  bool hasFollowed = false;
  var data;
  late Followers usersList;
  late Followers filteredFollowers;
  late String url = "";
  List<String> members = [];

  var countryName = '';

  Future<String> getCountry() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    var locationX = jsonDecode(locationSTR);
    if (mounted) {
      setState(() {
        countryName = locationX["country"];
        CurrentUser().currentUser.country = locationX["country"];
      });
    }
    getCountryLogo();

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("country", CurrentUser().currentUser.country!);

    return locationX["country"];
  }

  Future<String?> followers(String otherMemberId) async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope.php?action=follow_user&user_id=${widget.memberID}&user_id_to=$otherMemberId");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_follow.php",
        {"user_id": widget.memberID, "user_id_to": otherMemberId});
    if (response!.status == 1) {
      setState(() {
        hasFollowed = true;
      });
      return followSuccess;
    } else
      return '';
  }

  Future<String> unfollow(String unfollowerID) async {
    // var url = Uri.parse("https://www.bebuzee.com/app_devlope.php?action=unfollow_user&user_id=${widget.memberID}&user_id_to=$unfollowerID");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/member_unfollow.php",
        {"user_id": widget.memberID, "user_id_to": unfollowerID});
    if (response!.status == 1) {
      setState(() {
        unfollowIndicator = true;
      });
      return unfollowSuccess;
    } else
      return '';
  }

  Future<void> checkList() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope.php?action=get_landing_page_data&country=${widget.country}&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/auth/minimumFollowing", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": widget.country
    });

    if (response!.status == 1) {
      Followers followersData = Followers.fromJson(response.data['data']);
      setState(() {
        filteredFollowers = followersData;
        usersList = followersData;
        hasData = true;
      });
    } else {
      setState(() {
        hasData = false;
      });
    }
  }

  Future<String> getCountryLogo() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope.php?action=fetch_location_logo&country=$countryName");

    // var response = await http.get(url);

    // if (response!.statusCode == 200) {
    //   if (mounted) {
    //     setState(() {
    //       isLogoLoaded = true;
    //       var convertJson = json.decode(response!.body);
    //       logo = convertJson['image_url'];
    //       CurrentUser().currentUser.logo = convertJson['image_url'];
    //     });
    //   }
    // }
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setString("logo", CurrentUser().currentUser.logo);
    // return "success";

    var sendData = {"country": countryName};
    var response = await ApiRepo.post("api/country_logo.php", sendData);

    if (response!.status == 1) {
      if (mounted) {
        setState(() {
          isLogoLoaded = true;
          logo = response!.data["image_url"];
          CurrentUser().currentUser.logo = response!.data["image_url"];
        });
      }
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("logo", logo);
      return logo;
    } else
      return '';
  }

  Future<String> getCurrentMember() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope.php?action=member_details_data&user_id=${CurrentUser().currentUser.memberID}");
    // var response = await http.get(url);

    var sendData = {"user_id": CurrentUser().currentUser.memberID};
    var response =
        await ApiRepo.postWithToken("api/user/userDetails", sendData);

    if (response!.status == 1) {
      print(response!.data);
      if (mounted) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        setState(() {
          var res = response!.data;
          CurrentUser().currentUser.image = res['image'];
          CurrentUser().currentUser.shortcode = res['shortcode'];
          CurrentUser().currentUser.fullName = res['member_name'];
          CurrentUser().currentUser.email = pref.getString("email")!;
          // CurrentUser().currentUser.logo = widget.logo;
        });

        pref.setString("image", CurrentUser().currentUser.image!);
        pref.setString("shortcode", CurrentUser().currentUser.shortcode!);
        pref.setString("name", CurrentUser().currentUser.fullName!);
        pref.setString("memberID", CurrentUser().currentUser.memberID!);
      }
    }
    return 'success';
  }

  @override
  void initState() {
    getCurrentMember();
    getCountry();

    checkList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              members.length.toString() + "/8 Followed",
              style: TextStyle(fontSize: 16.0.sp, color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                if (members.length < 8) {
                  ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                      .showSnackBar(showSnackBar(
                    AppLocalizations.of(
                      'Please follow atleast 8 people',
                    ),
                  ));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                memberID: CurrentUser().currentUser.memberID,
                                logo: CurrentUser().currentUser.logo,
                                country: CurrentUser().currentUser.country,
                                currentMemberImage:
                                    CurrentUser().currentUser.image,
                              )));
                }
              },
              child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 5.0.w, top: 1.0.h, bottom: 1.0.h),
                    child: Text(
                      AppLocalizations.of(
                        "Next",
                      ),
                      style: TextStyle(
                          color:
                              members.length < 8 ? Colors.grey : Colors.green,
                          fontSize: 13.0.sp),
                    ),
                  )),
            )
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          //SystemNavigator.pop();
          return true;
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                Container(
                  height: _currentScreenSize.height * 0.12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            AppLocalizations.of(
                              'Please follow atleast 8 members to continue',
                            ),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 12.0.sp),
                          )),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
                hasData == true
                    ? Container(
                        child: Flexible(
                            child: ListView.builder(
                          itemCount: usersList.followers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: new Border.all(
                                              color: Colors.grey,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: NetworkImage(
                                                usersList
                                                    .followers[index].image!),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  usersList
                                                      .followers[index].name!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                usersList.followers[index]
                                                                .varified !=
                                                            "" &&
                                                        usersList
                                                                .followers[
                                                                    index]
                                                                .varified !=
                                                            null
                                                    ? Image.network(
                                                        usersList
                                                            .followers[index]
                                                            .varified!,
                                                        height: 13,
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                            Text(
                                              usersList
                                                  .followers[index].shortcode!,
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            Text(
                                                usersList.followers[index]
                                                    .officalRecommended!,
                                                style: TextStyle(
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 32,
                                      width:
                                          usersList.followers[index].status ==
                                                  "Following"
                                              ? _currentScreenSize.width * 0.3
                                              : _currentScreenSize.width * 0.25,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)))),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(5)),
                                          onPressed: () {
                                            if (usersList
                                                    .followers[index].status !=
                                                "Follow") {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  // return object of type Dialog

                                                  return Dialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    elevation: 5,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Column(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              radius: 25,
                                                              backgroundImage:
                                                                  NetworkImage(usersList
                                                                      .followers[
                                                                          index]
                                                                      .image!),
                                                            ),
                                                            Text(AppLocalizations
                                                                    .of(
                                                                  "Unfollow",
                                                                ) +
                                                                " " +
                                                                usersList
                                                                    .followers[
                                                                        index]
                                                                    .name!),
                                                            ElevatedButton(
                                                                style: ButtonStyle(
                                                                    elevation:
                                                                        MaterialStateProperty.all(
                                                                            0)),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  unfollow(usersList
                                                                      .followers[
                                                                          index]
                                                                      .memberId!);
                                                                  setState(() {
                                                                    usersList
                                                                        .followers[
                                                                            index]
                                                                        .status = "Follow";
                                                                    members.removeWhere((element) =>
                                                                        element ==
                                                                        usersList
                                                                            .followers[index]
                                                                            .memberId);
                                                                  });
                                                                  print(members
                                                                      .join(
                                                                          ","));
                                                                },
                                                                child: Text(
                                                                  AppLocalizations
                                                                      .of(
                                                                    "Unfollow",
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .red),
                                                                )),
                                                            ElevatedButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            primaryBlueColor),
                                                                    elevation:
                                                                        MaterialStateProperty.all(
                                                                            0)),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  AppLocalizations
                                                                      .of(
                                                                    "Cancel",
                                                                  ),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black87),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              followers(usersList
                                                  .followers[index].memberId!);
                                              setState(() {
                                                usersList.followers[index]
                                                    .status = "Following";
                                                members.add(usersList
                                                    .followers[index]
                                                    .memberId!);
                                              });
                                              print(members.join(","));
                                            }
                                          },
                                          child: Text(
                                            usersList.followers[index].status!,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
