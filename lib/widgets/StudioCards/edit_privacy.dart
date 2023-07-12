import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/studio_video_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/StudioCards/update_details.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class EditPlaylistPrivacy extends StatefulWidget {
  final VideoStudioModel? playlists;
  String? privacy;

  final Function? refresh;

  EditPlaylistPrivacy({Key? key, this.playlists, this.privacy, this.refresh})
      : super(key: key);

  @override
  _EditPlaylistPrivacyState createState() => _EditPlaylistPrivacyState();
}

class _EditPlaylistPrivacyState extends State<EditPlaylistPrivacy> {
  List buttonList = ["PUBLIC", "PRIVATE"];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4.0.w,
        ),
        child: Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 3.5.h),
              child: Text(
                AppLocalizations.of(
                  "Edit Privacy",
                ),
                style: whiteNormal.copyWith(fontSize: 14.0.sp),
              ),
            ),
            DropdownButton(
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
                  widget.privacy = val as String?;
                });
              },
              value: widget.privacy!.toUpperCase(),
            ),
            Padding(
              padding: EdgeInsets.only(right: 3.0.w, top: 2.0.h, bottom: 2.0.h),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      overlayColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                    UpdateStudioDetails().updatePrivacy(
                        widget.playlists!.playlistId!,
                        widget.privacy!.toLowerCase());
                    widget.refresh!();
                  },
                  child: Text(
                    AppLocalizations.of(
                      "Update",
                    ),
                    style: TextStyle(fontSize: 10.0.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
