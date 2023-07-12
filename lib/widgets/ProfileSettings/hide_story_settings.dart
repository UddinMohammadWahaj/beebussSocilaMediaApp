import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/story_hidden_members_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../api/ApiRepo.dart' as ApiRepo;
import '../../api/api.dart';

class HideStorySettingsPage extends StatefulWidget {
  final Function? setNewCount;

  const HideStorySettingsPage({Key? key, this.setNewCount}) : super(key: key);

  @override
  _HideStorySettingsPageState createState() => _HideStorySettingsPageState();
}

class _HideStorySettingsPageState extends State<HideStorySettingsPage> {
  TextEditingController _searchController = TextEditingController();
  StoryHiddenMembers? membersList;
  bool areMembersLoaded = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> getMembers(String search) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_story_data.php?action=get_all_followers_data_with_hide_status&user_id=${CurrentUser().currentUser.memberID!}&keyword=$search&all_user_ids=");
    // print("-------Strory uri -- $url");

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/api/get_all_followers_data_with_hide_status.php?action=get_all_followers_data_with_hide_status&user_id=${CurrentUser().currentUser.memberID!}&keyword=$search&all_user_ids=");
    // print("-------Strory uri -- $url");

    // var response = await ApiRepo.getWithToken(
    //   "api/get_all_followers_data_with_hide_status.php",
    // {
    //   "action": "get_all_followers_data_with_hide_status",
    //   "user_id": "${CurrentUser().currentUser.memberID!}",
    //   "keyword": search,
    //   "all_user_ids": "",
    // }
    // );
    // var response = await http.get(url);

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("get people called ");
    var newurl = Uri.parse(
        "https://www.bebuzee.com/api/get_all_followers_data_with_hide_status.php?action=get_all_followers_data_with_hide_status&user_id=${CurrentUser().currentUser.memberID!}&keyword=$search&all_user_ids=");
    print("object----url--- $newurl");

    var client = Dio();
    await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      if (value.data['success'] == 1) {
        print("-----get people response=${value.data}");
        StoryHiddenMembers memberData =
            StoryHiddenMembers.fromJson(value.data['data']);
        //print(peopleData.people[0].name);
        setState(() {
          membersList = memberData;
          membersList!.users.forEach((element) {
            if (element.hiddenStatus == 1) {
              setState(() {
                element.isHidden = true;
              });
            }
          });
          areMembersLoaded = true;
        });

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString("hiddenMemberData", membersList.users.);
      } else {
        setState(() {
          areMembersLoaded = false;
        });
      }
    });

    // print("---- ${response}");

    // if (response.statusCode == 200) {
    //   StoryHiddenMembers memberData =
    //       StoryHiddenMembers.fromJson(jsonDecode(response.body));
    //   if (mounted) {
    //     setState(() {
    //       membersList = memberData;
    //       membersList.users.forEach((element) {
    //         if (element.hiddenStatus == 1) {
    //           setState(() {
    //             element.isHidden = true;
    //           });
    //         }
    //       });
    //       areMembersLoaded = true;
    //     });
    //   }
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString("hiddenMemberData", response.body);
    // }
    // if (response.statusCode == null || response.statusCode != 200) {
    //   if (mounted) {
    //     setState(() {
    //       areMembersLoaded = false;
    //     });
    //   }
    // }
  }

  void getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("hiddenMemberData");

    if (data != null) {
      StoryHiddenMembers memberData =
          StoryHiddenMembers.fromJson(jsonDecode(data));

      if (mounted) {
        setState(() {
          membersList = memberData;
          membersList!.users.forEach((element) {
            if (element.hiddenStatus == 1) {
              setState(() {
                element.isHidden = true;
              });
            }
          });
          areMembersLoaded = true;
        });
      }
    } else {
      getMembers("");
    }
  }

  Future<void> hideStory(String otherMemberID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_story_data.php?action=story_hide_data&user_id=${CurrentUser().currentUser.memberID!}&user_id_story_to_hide=$otherMemberID");

    // var response = await http.get(url);

    // if (response.statusCode == 200) {
    //   print(response.body);
    // }

    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("get people called ");
    var newurl = Uri.parse(
        "https://www.bebuzee.com/api/get_all_followers_data_with_hide_status.php?action=story_hide_data&user_id=${CurrentUser().currentUser.memberID!}&user_id_story_to_hide=$otherMemberID");
    print("object----url--- $newurl");
    var client = Dio();
    await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      if (value.data['success'] == 1) {
        print("-----get people response=${value.data}");
      }
    });
  }

  Future<void> unhideStory(String otherMemberID) async {
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    var newurl = Uri.parse(
        "https://www.bebuzee.com/get_all_followers_data_with_hide_status.php?action=story_unhide_hide_data&user_id=${CurrentUser().currentUser.memberID!}&user_id_story_to_hide=$otherMemberID");

    // var response = await http.get(url);
    print("object----url--- $newurl");
    var client = Dio();
    await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((response) async {
      if (response.data['success'] == 200) {
        print(response.data);
      }
      return "success";
    });
  }

  void _onLoading() async {
    int len = membersList!.users.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += membersList!.users[i].memberId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    print(urlStr);
    try {
      // var url = Uri.parse(
      //     "https://www.bebuzee.com/app_devlope_story_data.php?action=get_all_followers_data_with_hide_status&user_id=${CurrentUser().currentUser.memberID!}&keyword=&all_user_ids=$urlStr");

      // var response = await http.get(url);
      String? token =
          await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
      print("get people called ");
      var newurl = Uri.parse(
          "https://www.bebuzee.com/api/get_all_followers_data_with_hide_status.php?action=get_all_followers_data_with_hide_status&user_id=${CurrentUser().currentUser.memberID!}&keyword=&all_user_ids=$urlStr");
      print("object----url--- $newurl");
      var client = Dio();
      await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((response) async {
        if (response.data['success'] == 1) {
          print("-------${response.data}");
          StoryHiddenMembers memberData =
              StoryHiddenMembers.fromJson(jsonDecode(response.data));

          // await Future.wait(feedData.feeds.map((e) => PreloadUserImage.cacheImage(context, e.postUserPicture)).toList());
          if (mounted) {
            setState(() {
              membersList!.users.addAll(memberData.users);
              areMembersLoaded = true;
            });
          }
        }
        if (response.data == null || response.data['success'] != 1) {
          if (mounted) {
            setState(() {
              areMembersLoaded = false;
            });
          }
        }
      });
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(
          "Couldn't Load",
        ),
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
          return Container();
        },
      );
    }
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    getLocalData();
    getMembers("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            getMembers("");
            Navigator.pop(context);

            widget.setNewCount!();
          },
          child: Row(
            children: [
              Icon(
                Icons.keyboard_backspace_outlined,
                color: Colors.black,
                size: 3.7.h,
              ),
              SizedBox(
                width: 6.0.w,
              ),
              Text(
                AppLocalizations.of(
                  "Hide Story From",
                ),
                style: blackBold.copyWith(fontSize: 16.0.sp),
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          getMembers("");
          Navigator.pop(context);

          widget.setNewCount!();
          return true;
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 15, left: 3.0.w, right: 3.0.w),
            child: Column(
              children: [
                Container(
                  height: 35,
                  decoration: new BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.rectangle,
                  ),
                  child: TextFormField(
                    onChanged: (val) {
                      if (val == "") {
                        getMembers("");
                      } else {
                        getMembers(val);
                      }
                    },
                    maxLines: null,
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 25,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: AppLocalizations.of('Search'),
                      contentPadding: EdgeInsets.only(top: 0),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    child: areMembersLoaded
                        ? SmartRefresher(
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
                              builder:
                                  (BuildContext context, LoadStatus? mode) {
                                Widget body;

                                if (mode == LoadStatus.idle) {
                                  body = Text("");
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
                            onRefresh: () {},
                            onLoading: () {
                              _onLoading();
                            },
                            child: ListView.builder(
                                itemCount: membersList!.users.length,
                                itemBuilder: (context, index) {
                                  var member = membersList!.users[index];
                                  return Container(
                                    child: MemberCard(
                                      member: member,
                                      onTap: () {
                                        setState(() {
                                          member.isHidden = !member.isHidden!;
                                        });
                                        if (member.isHidden!) {
                                          hideStory(member.memberId!);
                                        } else {
                                          unhideStory(member.memberId!);
                                        }
                                      },
                                    ),
                                  );
                                }),
                          )
                        : Container(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final StoryHiddenMembersModel? member;
  final VoidCallback? onTap;

  const MemberCard({Key? key, this.member, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: onTap ??
            () {
              print("---#33");
            },
        splashColor: Colors.grey.withOpacity(0.3),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      radius: 27,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(member!.userImage!),
                    ),
                  ),
                  SizedBox(
                    width: 4.0.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60.0.w,
                        child: Text(
                          member!.shortcode!,
                          style:
                              TextStyle(color: Colors.black, fontSize: 10.0.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 60.0.w,
                        child: Text(
                          member!.shortcode!,
                          style:
                              TextStyle(color: Colors.grey, fontSize: 10.0.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  member!.isHidden!
                      ? CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        )
                      : Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.transparent,
                          ),
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
