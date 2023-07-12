import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:bizbultest/models/user_highlights_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
// import 'package:charts_flutter/flutter.dart' as a;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../api/api.dart';
import 'added_to_highlights_popup.dart';

class AddToExistingHighlight extends StatefulWidget {
  final List<UserHighlightsModel>? highlight;
  final FileElement? allFiles;
  final VoidCallback? addNew;
  final VoidCallback? goToProfile;

  const AddToExistingHighlight(
      {Key? key, this.highlight, this.allFiles, this.addNew, this.goToProfile})
      : super(key: key);

  @override
  _AddToExistingHighlightState createState() => _AddToExistingHighlightState();
}

class _AddToExistingHighlightState extends State<AddToExistingHighlight> {
  Future<void> addToExistingHighlight(
      int storyID, String postID, String highlightID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/api/add_story_to_hightlight_data.php?action=add_story_to_hightlight_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.memberID}&post_id=$postID&story_id=$storyID&hightlight_id=$highlightID");

    var url =
        'https://www.bebuzee.com/api/storyAddToHighlight?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.memberID}&post_id=$postID&story_id=$storyID&hightlight_id=$highlightID';

    print("existing highlight =$url");
    var response = await ApiProvider().fireApi(url.toString());

    if (response.statusCode == 200) {
      print('success existing highlight $url ${response.data}');
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
        Center(
            child: Padding(
          padding: EdgeInsets.only(top: 2.5.h, bottom: 1.0.h),
          child: Text(
              AppLocalizations.of(
                "Add to Highlights",
              ),
              style: blackBold.copyWith(fontSize: 13.0.sp)),
        )),
        Divider(
          thickness: 0.5,
          color: Colors.grey,
        ),
        Container(
          height: 110,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.highlight!.length + 1,
              itemBuilder: (context, index) {
                if (index != (widget.highlight!.length)) {
                  return Padding(
                    padding: EdgeInsets.only(top: 1.0.h, bottom: 0.5.h),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            addToExistingHighlight(
                                widget.allFiles!.storyId!,
                                widget.allFiles!.id!,
                                widget.highlight![index].highlightId!);
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog

                                return AddedToHighlightsPopup(
                                  goToProfile: widget.goToProfile,
                                  highlightImage: widget
                                      .highlight![index].firstImageOrVideo
                                      ?.replaceAll(".mp4", ".jpg"),
                                );
                              },
                            );
                          },
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
                                backgroundImage: NetworkImage(widget
                                    .highlight![index].firstImageOrVideo!
                                    .replaceAll(".mp4", ".jpg")),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(
                            width: 80,
                            child: Text(
                              widget.highlight![index].highlightText!,
                              style: TextStyle(fontSize: 10.0.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(top: 1.0.h, bottom: 0.5.h),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: widget.addNew ?? () {},
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: new Border.all(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                              child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 30,
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(
                            width: 80,
                            child: Text(
                              AppLocalizations.of(
                                "New",
                              ),
                              style: TextStyle(fontSize: 10.0.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              }),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              height: 55,
              width: 100.0.w,
              child: Center(
                  child: Text(
                AppLocalizations.of(
                  "Cancel",
                ),
                style: blackBold.copyWith(fontSize: 10.0.sp),
              )),
            ),
          ),
        ),
      ],
    );
  }
}
