import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AddedToHighlightsPopup extends StatefulWidget {
  final String? highlightImage;
  final VoidCallback? goToProfile;

  const AddedToHighlightsPopup(
      {Key? key, this.highlightImage, this.goToProfile})
      : super(key: key);

  @override
  _AddedToHighlightsPopupState createState() => _AddedToHighlightsPopupState();
}

class _AddedToHighlightsPopupState extends State<AddedToHighlightsPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      backgroundColor: Colors.white,
      elevation: 5,
      child: Container(
        child: Wrap(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.transparent,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(widget.highlightImage!),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  AppLocalizations.of(
                    "Added to Highlight",
                  ),
                  style: blackBold.copyWith(fontSize: 15.0.sp),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 15, left: 25, right: 25),
                child: Text(
                  AppLocalizations.of(
                    "Highlights stay on your profile until you remove them.",
                  ),
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.6), fontSize: 10.0.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: 100.0.w,
              height: 0.3,
              color: Colors.grey.withOpacity(0.4),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.goToProfile!();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    child: Text(
                      AppLocalizations.of(
                        "View on Profile",
                      ),
                      style: TextStyle(
                          fontSize: 12.0.sp,
                          color: primaryBlueColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 100.0.w,
              height: 0.3,
              color: Colors.grey.withOpacity(0.4),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    child: Text(
                      AppLocalizations.of(
                        "Done",
                      ),
                      style: TextStyle(
                          fontSize: 12.0.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
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
