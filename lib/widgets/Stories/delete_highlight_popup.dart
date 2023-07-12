import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DeleteHighlightPopup extends StatelessWidget {
  final VoidCallback? delete;

  const DeleteHighlightPopup({Key? key, this.delete}) : super(key: key);

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
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  AppLocalizations.of(
                    "Delete Highlight?",
                  ),
                  style: blackBold.copyWith(fontSize: 15.0.sp),
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
                onTap: delete ?? () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    child: Text(
                      AppLocalizations.of(
                        "Delete",
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
                        "Cancel",
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
