import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class AddStoryToHighlight extends StatefulWidget {
  final FileElement? allFiles;
  final String? from;

  const AddStoryToHighlight({Key? key, this.allFiles, this.from})
      : super(key: key);

  @override
  _AddStoryToHighlightState createState() => _AddStoryToHighlightState();
}

class _AddStoryToHighlightState extends State<AddStoryToHighlight> {
  TextEditingController _controller = TextEditingController();

  Future<void> addToNewHighlight(
      int storyID, String postID, String highlightName) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_heighlight_data.php?action=add_new_heightlight_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&story_id=$storyID&hightlight_name=$highlightName");
    var newurl =
        'https://www.bebuzee.com/api/add_new_heightlight_data.php?action=add_new_heightlight_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&story_id=$storyID&hightlight_name=$highlightName';

    var response = await ApiProvider().fireApi(newurl).then((value) => value);

    if (response.statusCode == 200) {
      print("add high api success $newurl");
      print(response.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              height: 4,
              width: 40,
              decoration: new BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                shape: BoxShape.rectangle,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 2.5.h, bottom: 1.0.h, left: 3.0.w, right: 3.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.all(0),
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.keyboard_backspace_outlined,
                  size: 30,
                ),
              ),
              Container(
                child: Text(
                  AppLocalizations.of(
                    "New Highlight",
                  ),
                  style: blackBold.copyWith(fontSize: 13.0.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(
                Icons.keyboard_backspace_outlined,
                size: 30,
                color: Colors.transparent,
              ),
            ],
          ),
        ),
        Divider(
          thickness: 0.5,
          color: Colors.grey,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 1.0.h, bottom: 0.5.h),
            child: Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.transparent,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                      widget.allFiles!.image!.replaceAll(".mp4", ".jpg")),
                ),
              ),
            ),
          ),
        ),
        Container(
          child: TextFormField(
            autofocus: true,
            textAlign: TextAlign.center,
            onChanged: (val) {},
            maxLines: null,
            controller: _controller,
            cursorColor: Colors.grey.withOpacity(0.4),
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.grey, fontSize: 9.0.sp),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: AppLocalizations.of(
                "Highlight",
              ),

              //alignLabelWithHint: true,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 9.0.sp),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              addToNewHighlight(
                  widget.allFiles!.storyId!,
                  widget.allFiles!.id!,
                  _controller.text.isNotEmpty
                      ? _controller.text
                      : "Highlights");
              Fluttertoast.showToast(
                msg: AppLocalizations.of(
                      "Added to",
                    ) +
                    " ${_controller.text.isNotEmpty ? _controller.text : "Highlights"}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.black.withOpacity(0.7),
                textColor: Colors.white,
                fontSize: 13.0,
              );
            },
            child: Container(
              color: primaryBlueColor,
              height: 55,
              width: 100.0.w,
              child: Center(
                  child: Text(
                AppLocalizations.of("Add"),
                style: whiteBold.copyWith(fontSize: 10.0.sp),
              )),
            ),
          ),
        )
      ],
    );
  }
}
