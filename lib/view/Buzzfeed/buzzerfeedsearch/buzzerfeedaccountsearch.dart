import 'dart:convert';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/Buzzfeed/buzzfeedsearch.dart';
import 'package:bizbultest/view/discover_search_page.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/widgets/test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/models/people_search_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class BuzzerfeedAccountsSearch extends StatefulWidget {
  final String? search;
  final String? memberID;
  final TagsSearch? people;
  final bool? hasData;
  final BuzzerfeedSearchPageState? parent;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  BuzzerfeedAccountsSearch(
      {Key? key,
      this.search,
      this.memberID,
      this.people,
      this.hasData,
      this.parent,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  _BuzzerfeedAccountsSearchState createState() =>
      _BuzzerfeedAccountsSearchState();
}

class _BuzzerfeedAccountsSearchState extends State<BuzzerfeedAccountsSearch> {
  late TagsSearch accounts;
  bool hasData = false;
  String searchCurrent = "";

  Future<void> getPeople(text) async {
    print("get people called");
    print("text is:" + text);
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    print("get people called ");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/user/userSearch?searchword=$text&user_id=${widget.memberID}');

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
        .then((value) {
      if (value.statusCode == 200) {
        print("get people response=${value.data}");
        TagsSearch peopleData = TagsSearch.fromJson(value.data['data']);
        //print(peopleData.people[0].name);
        setState(() {
          accounts = peopleData;
          hasData = true;
        });
      } else {
        setState(() {
          hasData = false;
        });
      }
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope.php?action=get_user_search_results&searchword=$text&user_id=${widget.memberID}");

    // var response = await http.get(url);

    // //print(response.body);
    // if (response.statusCode == 200) {
    //   TagsSearch peopleData = TagsSearch.fromJson(jsonDecode(response.body));
    //   //print(peopleData.people[0].name);
    //   setState(() {
    //     accounts = peopleData;
    //     hasData = true;
    //   });

    //   if (response.body == null || response.statusCode != 200) {
    //     setState(() {
    //       hasData = false;
    //     });
    //   }
    // }
  }

  @override
  void initState() {
    print(widget.memberID);
    print(widget.search);
    accounts = TagsSearch([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parent!.searchText != "") {
      if (searchCurrent != widget.parent!.searchText) {
        print("inside get people called ");
        getPeople(widget.parent!.searchText);
      }
      searchCurrent = widget.parent!.searchText;
    } else {
      accounts.people = [];
    }
    return Container(
      child: hasData == true
          ? ListView.builder(
              itemCount: accounts.people.length,
              itemBuilder: (context, index) {
                var account = accounts.people[index];
                return ListTile(
                  dense: false,
                  onTap: () {
                    setState(() {
                      OtherUser().otherUser.memberID = account.memberId;
                      OtherUser().otherUser.shortcode = account.shortcode;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePageMain(
                                  setNavBar: widget.setNavBar,
                                  isChannelOpen: widget.isChannelOpen,
                                  changeColor: widget.changeColor,
                                  otherMemberID: account.memberId,
                                )));
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  leading: Container(
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
                      backgroundImage: NetworkImage(account.image!),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        account.shortcode!,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      account.varified != "" && account.varified != null
                          ? Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(
                                Icons.check_circle,
                                color: primaryBlueColor,
                                size: 12,
                              ),
                            )
                          : Container()
                    ],
                  ),
                  subtitle: Text(
                    account.name!,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                );
              },
            )
          : Container(),
    );
  }
}
