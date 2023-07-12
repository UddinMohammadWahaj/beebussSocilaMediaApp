import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/studio_video_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/StudioCards/update_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class EditTitleAndDescription extends StatefulWidget {
  final VideoStudioModel? playlists;
  final String title;
  final String description;
  final Function refresh;

  EditTitleAndDescription(
      {Key? key,
      this.playlists,
      required this.title,
      required this.description,
      required this.refresh})
      : super(key: key);

  @override
  _EditTitleAndDescriptionState createState() =>
      _EditTitleAndDescriptionState();
}

class _EditTitleAndDescriptionState extends State<EditTitleAndDescription> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _titleController.text = widget.title;
      _descriptionController.text = widget.description;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.0.w),
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.5.h),
            child: Text(
              AppLocalizations.of(
                "Title",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.0.h),
            child: Container(
              height: 5.0.h,
              child: TextFormField(
                onChanged: (val) {},
                maxLines: 1,
                controller: _titleController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Colors.white, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0.sp),
                  contentPadding: EdgeInsets.only(left: 2.0.w),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.5.h),
            child: Text(
              AppLocalizations.of(
                "Description",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.0.h),
            child: TextFormField(
              onChanged: (val) {},
              maxLines: 4,
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.white, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0.sp),
                contentPadding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
              ),
            ),
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
                  UpdateStudioDetails().updatePlaylistTitle(
                      widget.playlists!.playlistId!, _titleController.text);
                  UpdateStudioDetails().updatePlaylistDescription(
                      widget.playlists!.playlistId!,
                      _descriptionController.text);
                  widget.refresh();
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
    );
  }
}
