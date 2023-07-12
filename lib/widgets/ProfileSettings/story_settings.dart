import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'hide_story_settings.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

class StorySettingsPage extends StatefulWidget {
  final int people;
  final Function setNewCount;

  StorySettingsPage({Key? key, required this.people, required this.setNewCount})
      : super(key: key);

  @override
  _StorySettingsPageState createState() => _StorySettingsPageState();
}

class _StorySettingsPageState extends State<StorySettingsPage> {
  int people = 0;

  Future getStoryHideCount() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_story_data.php?action=get_all_story_hidden_from_number&user_id=${CurrentUser().currentUser.memberID}");

    // var response = await http.get(url);
    var url =
        'https://www.bebuzee.com/api/storyTotalHide?user_id=${CurrentUser().currentUser.memberID}';
    var response = await ApiProvider().fireApi(url);
    // var response = await ApiRepo.postWithToken("api/story_total_hide.php", {
    //   "action": "get_all_story_hidden_from_number",
    //   "user_id": "${CurrentUser().currentUser.memberID}",
    // });
    print("-------story ${response.data.toString()}");
    if (response.data != null) {
      if (mounted) {
        setState(() {
          people = response.data['total_hidden'];
        });
      }
      return "success";
    }
  }

  @override
  void initState() {
    people = widget.people;
    getStoryHideCount();
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
            widget.setNewCount();
            Navigator.pop(context);
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
                  "Story",
                ),
                style: blackBold.copyWith(fontSize: 16.0.sp),
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          widget.setNewCount();
          return true;
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(
                        "Hide Story From",
                      ),
                      style: blackBold.copyWith(fontSize: 12.0.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HideStorySettingsPage(
                                      setNewCount: () {
                                        getStoryHideCount();
                                      },
                                    )));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                            "${people.toString()} " +
                                AppLocalizations.of(
                                  'people',
                                ),
                            style: TextStyle(
                                fontSize: 12.0.sp, color: Colors.black)),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(
                        "Hide your story from specific people",
                      ),
                      style: greyNormal.copyWith(fontSize: 9.0.sp),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.5,
                color: Colors.grey.withOpacity(0.8),
              )
            ],
          ),
        ),
      ),
    );
  }
}
