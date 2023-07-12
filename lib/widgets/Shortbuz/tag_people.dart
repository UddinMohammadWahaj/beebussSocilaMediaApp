import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/widgets/Shortbuz/flexible_video_player.dart';
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

// ignore: must_be_immutable
class TagPeopleShortbuz extends StatefulWidget {
  final File? video;
  UserTags? userTags;
  final Function? saveList;
  List<String>? videoTagsMemberID;
  List<String>? videoTags;
  final Uint8List? unit8list;

  TagPeopleShortbuz(
      {Key? key,
      this.video,
      this.userTags,
      this.saveList,
      this.videoTagsMemberID,
      this.videoTags,
      this.unit8list})
      : super(key: key);

  @override
  _TagPeopleShortbuzState createState() => _TagPeopleShortbuzState();
}

class _TagPeopleShortbuzState extends State<TagPeopleShortbuz> {
  TextEditingController _videoUserSearchController = TextEditingController();
  bool showUsersList = false;
  late UserTags tagList;
  bool areTagsLoaded = false;

  Future<void> getUserTags(String searchedTag) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_mention_users_data&user_id=${CurrentUser().currentUser.memberID}&searchword=$searchedTag");

    // var response = await http.get(url);
    print(
        "https://www.bebuzee.com/api/user/userSearchFollowers?user_id=${CurrentUser().currentUser.memberID}&searchword=${searchedTag}");
    var response = await ApiRepo.postWithToken("api/user/userSearchFollowers", {
      "user_id": CurrentUser().currentUser.memberID,
      "searchword": searchedTag
    });

    // print(response!.body);
    if (response!.success == 1) {
      UserTags tagsData = UserTags.fromJson(response!.data['data']);
      if (mounted) {
        setState(() {
          tagList = tagsData;
          areTagsLoaded = true;
        });
      }
    }
    if (response!.data == null ||
        response!.data['data'] == null ||
        response!.data['data'] == []) {
      setState(() {
        areTagsLoaded = false;
      });
    }
  }

  Widget _iconButton(IconData icon, VoidCallback onTap, Color color) {
    return IconButton(
        splashRadius: 20,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        constraints: BoxConstraints(),
        icon: Icon(
          icon,
          color: color,
          size: 25,
        ),
        onPressed: onTap);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 1,
          leading: _iconButton(Icons.keyboard_backspace, () {
            Navigator.pop(context);
          }, Colors.black),
          title: Text(
            AppLocalizations.of(
              "Tag People",
            ),
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          actions: [
            _iconButton(Icons.check, () {
              Navigator.pop(context);
              widget.saveList!(
                  widget.userTags, widget.videoTagsMemberID, widget.videoTags);
            }, Colors.green)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 100.0.h,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  height: 35,
                  decoration: new BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    shape: BoxShape.rectangle,
                  ),
                  child: TextFormField(
                    cursorColor: Colors.grey,
                    autofocus: false,
                    onTap: () {
                      setState(() {
                        showUsersList = true;
                      });
                    },
                    onChanged: (val) {
                      getUserTags(val);
                      if (val == "") {
                        setState(() {
                          showUsersList = false;
                        });
                      } else {
                        setState(() {
                          showUsersList = true;
                        });
                      }
                    },
                    controller: _videoUserSearchController,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: AppLocalizations.of('Search'),
                        contentPadding: EdgeInsets.only(left: 20, bottom: 12),
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey)
                        // 48 -> icon width
                        ),
                  ),
                ),
              ),
              tagList != null &&
                      tagList.userTags.length > 0 &&
                      _videoUserSearchController.text.isNotEmpty
                  ? Container(
                      height: 100.0.h - 50 - 55,
                      child: SingleChildScrollView(
                        child: Column(
                            children: tagList.userTags.map((s) {
                          return InkWell(
                            splashColor: Colors.grey.withOpacity(0.3),
                            onTap: () {},
                            child: SearchedUserCard(
                              onTap: () {
                                setState(() {
                                  tagList.userTags = [];
                                  _videoUserSearchController.clear();
                                  widget.userTags!.userTags!.add(s);
                                  widget.videoTagsMemberID!.add(s.memberId!);
                                  widget.videoTags!
                                      .add("video_0" + "^^" + s.memberId!);
                                });
                              },
                              s: s,
                            ),
                          );
                        }).toList()),
                      ),
                    )
                  : Container(
                      color: Colors.black,
                      height: 50.0.h,
                      width: 100.0.w,
                      child: Image.memory(
                        widget.unit8list!,
                        fit: BoxFit.cover,
                      )),
              widget.userTags!.userTags!.isNotEmpty &&
                      _videoUserSearchController.text.isEmpty
                  ? Container(
                      height: 100.0.h - 50.0.h - 50 - 55,
                      child: ListView.builder(
                          itemCount: widget.userTags!.userTags.length,
                          itemBuilder: (context, index) {
                            var user = widget.userTags!.userTags[index];
                            return AddedUserCard(
                              user: user,
                              onTap: () {
                                setState(() {
                                  widget.userTags!.userTags.removeAt(index);
                                  widget.videoTagsMemberID!.removeAt(index);
                                  widget.videoTags!.removeAt(index);
                                });
                              },
                            );
                          }),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class AddedUserCard extends StatelessWidget {
  final TagModel? user;
  final VoidCallback? onTap;

  AddedUserCard({Key? key, this.user, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity(horizontal: 0, vertical: -2),
      dense: true,
      leading: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(user!.image!),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      title: Wrap(
        direction: Axis.horizontal,
        children: [
          Text(
            user!.name!,
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          user!.varifiedStatus! == 1
              ? Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.check_circle,
                    color: primaryBlueColor,
                    size: 12,
                  ))
              : Container(
                  height: 0,
                  width: 0,
                )
        ],
      ),
      subtitle: Text(
        user!.shortcode!,
        style: TextStyle(
            fontSize: 13, color: Colors.black54, fontWeight: FontWeight.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
          splashRadius: 15,
          constraints: BoxConstraints(),
          padding: EdgeInsets.zero,
          onPressed: onTap,
          icon: Icon(
            Icons.close,
            color: Colors.black,
          )),
    );
  }
}

class SearchedUserCard extends StatelessWidget {
  final TagModel? s;
  final VoidCallback? onTap;

  SearchedUserCard({Key? key, this.s, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity(horizontal: 0, vertical: -2),
      dense: true,
      onTap: onTap,
      leading: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(s!.image!),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      title: Wrap(
        direction: Axis.horizontal,
        children: [
          Text(
            s!.name!,
            style: TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          s!.varifiedStatus == 1
              ? Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.check_circle,
                    color: primaryBlueColor,
                    size: 12,
                  ))
              : Container(
                  height: 0,
                  width: 0,
                )
        ],
      ),
      subtitle: Text(
        s!.shortcode!,
        style: TextStyle(
            fontSize: 13, color: Colors.black54, fontWeight: FontWeight.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
