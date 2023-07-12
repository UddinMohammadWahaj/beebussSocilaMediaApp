import 'dart:convert';
import 'package:bizbultest/models/tags_search_model.dart';
import 'package:bizbultest/models/tags_search_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/discover_people_from_tags.dart';
import 'package:bizbultest/view/discover_people_main.dart';
import 'package:bizbultest/view/discover_search_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../api/ApiRepo.dart' as ApiRepo;

class TagsSearchPage extends StatefulWidget {
  final String search;
  final String memberID;
  final String? logo;
  final String? country;
  final bool? hasData;
  final DiscoverSearchPageState? parent;

  TagsSearchPage(
      {Key? key,
      required this.search,
      required this.memberID,
      this.hasData,
      this.parent,
      this.logo,
      this.country})
      : super(key: key);

  @override
  _TagsSearchPageState createState() => _TagsSearchPageState();
}

class _TagsSearchPageState extends State<TagsSearchPage> {
  late TagPlaces tags;
  bool hasData = false;
  String searchCurrent = "";

  Future<void> getHashtags(text) async {
    print("text is:" + text);

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_hashtags_tags_data&user_id=${widget.memberID}&keyword=$text");
    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/search_hastag_list.php",
        {"user_id": widget.memberID, "keyword": text});

    //print(response.body);
    if (response!.success == 1) {
      TagPlaces tagData = TagPlaces.fromJson(response.data['data']);
      //print(peopleData.people[0].name);
      setState(() {
        tags = tagData;
        hasData = true;
      });

      if (response.data == null ||
          response.data['data'] == null ||
          response.data['data'] == []) {
        setState(() {
          hasData = false;
        });
      }
    }
  }

  @override
  void initState() {
    print(widget.memberID);
    print(widget.search);
    tags = TagPlaces([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parent!.searchText != "") {
      if (searchCurrent != widget.parent!.searchText) {
        getHashtags(widget.parent!.searchText);
      }
      searchCurrent = widget.parent!.searchText;
    } else {
      tags.searchTags = [];
    }
    return Container(
        child: hasData == true
            ? ListView.builder(
                itemCount: tags.searchTags.length,
                itemBuilder: (context, index) {
                  var tag = tags.searchTags[index];

                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    onTap: () {
                      print("tagname=${tag.name}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscoverFromTagsView(
                              tag: tag.name,
                            ),
                          ));
                    },
                    leading: Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        border: new Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.tag,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    dense: false,
                    title: Text(
                      tag.name!,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  );
                },
              )
            : Container());
  }
}
