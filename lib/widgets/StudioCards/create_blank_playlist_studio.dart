import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class CreateBlankPlaylist extends StatefulWidget {
  final Function? refresh;

  CreateBlankPlaylist({Key? key, this.refresh}) : super(key: key);

  @override
  _CreateBlankPlaylistState createState() => _CreateBlankPlaylistState();
}

class _CreateBlankPlaylistState extends State<CreateBlankPlaylist> {
  TextEditingController _controller = TextEditingController();
  String selectedButton = "Public";
  List buttonList = ["Public", "Private"];
  bool textIsEmpty = false;

  Future<void> createPlayList(String name, String type) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/playlist_data_api_call.php?action=create_blank_playlist&user_id=${CurrentUser().currentUser.memberID}&name=$name&type=$type");
    //
    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/create_member_playlist.php", {
      "action": "create_blank_playlist",
      "user_id": CurrentUser().currentUser.memberID,
      "name": name,
      "type": type
    });

    if (response!.success == 1) {
      print(response!.data);
      widget.refresh;
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
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    overlayColor: MaterialStateProperty.all(
                        Colors.grey.withOpacity(0.3))),
                // splashColor: Colors.grey.withOpacity(0.3),
                // color: Colors.white,
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
                          _controller.text, selectedButton.toLowerCase());
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
