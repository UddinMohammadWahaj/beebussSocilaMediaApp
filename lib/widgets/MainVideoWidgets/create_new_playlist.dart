import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/AgoraCallDetailModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

class CreateNewPlayList extends StatefulWidget {
  final String? postID;
  final List? videoList;
  final Function? refresh;

  CreateNewPlayList({Key? key, this.postID, this.videoList, this.refresh})
      : super(key: key);

  @override
  _CreateNewPlayListState createState() => _CreateNewPlayListState();
}

class _CreateNewPlayListState extends State<CreateNewPlayList> {
  TextEditingController _controller = TextEditingController();
  String selectedButton = "Public";
  List buttonList = ["Public", "Private"];
  bool textIsEmpty = false;

  Future<void> createPlayList(String type, String title) async {
    var url =
        "https://www.bebuzee.com/api/create_new_playlist.php?action=create_new_playlist_and_addavid&user_id=${CurrentUser().currentUser.memberID}&post_id=${widget.postID}&country=${CurrentUser().currentUser.country}&type=$type&title=$title";

    var client = new dio.Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);

    // Logger().e("token : $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    //Logger().e("head $head");
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );

    if (response.statusCode == 200) {
      print(response.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.0.h, bottom: 1.0.h),
            child: Center(
                child: Text(
              AppLocalizations.of(
                "New Playlist",
              ),
              style: whiteNormal.copyWith(fontSize: 15.0.sp),
            )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: 2.0.h),
            child: TextFormField(
              onTap: () {},
              maxLines: 1,
              controller: _controller,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: AppLocalizations.of(
                    "Title",
                  ),
                  hintStyle: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                  contentPadding: EdgeInsets.zero,
                  errorText: textIsEmpty
                      ? AppLocalizations.of("Title cannot be empty")
                      : ""),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.0.w,
            ),
            child: Text(
              AppLocalizations.of(
                "Privacy",
              ),
              style: whiteNormal.copyWith(fontSize: 10.0.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.0.w,
            ),
            child: DropdownButton(
              dropdownColor: Colors.grey[900],
              isExpanded: true,
              //hint: Text("Select Category "),
              items: buttonList.map((e) {
                return DropdownMenuItem(
                  child: Text(
                    e,
                    style: whiteNormal.copyWith(fontSize: 12.0.sp),
                  ),
                  value: e,
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedButton = val.toString();
                });
              },
              value: selectedButton,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 2.0.h, top: 1.5.h, bottom: 1.5.h),
              child: ElevatedButton(
                // splashColor: Colors.grey.withOpacity(0.3),
                // color: Colors.white,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    overlayColor: MaterialStateProperty.all(
                        Colors.grey.withOpacity(0.3))),
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    setState(() {
                      textIsEmpty = true;
                    });
                  } else {
                    setState(() {
                      textIsEmpty = false;
                      print(selectedButton.toLowerCase());
                      widget.refresh!();
                      createPlayList(
                          selectedButton.toLowerCase(), _controller.text);
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text(
                  AppLocalizations.of(
                    "Create",
                  ),
                  style: TextStyle(fontSize: 13.0.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
