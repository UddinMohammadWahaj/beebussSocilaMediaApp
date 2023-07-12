import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/report/common_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomYesNoSheet extends StatelessWidget {
  final String? title;
  final String? yesButton;
  final String? noButton;
  final VoidCallback? onYes;
  final VoidCallback? onNo;
  final String? header;

  const CustomYesNoSheet(
      {Key? key,
      this.title,
      this.yesButton,
      this.noButton,
      this.onYes,
      this.onNo,
      this.header})
      : super(key: key);

  Widget _titleTextCard() {
    return Text(
      title!,
      style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
    );
  }

  Widget _yesButton() {
    return GestureDetector(
      onTap: onYes,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: 100.0.w,
        child: Center(
            child: Text(
          yesButton!,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
        )),
        color: hotPropertiesThemeColor,
      ),
    );
  }

  Widget _noButton() {
    return GestureDetector(
      onTap: onNo,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: new Border.all(
            color: hotPropertiesThemeColor,
            width: 1,
          ),
        ),
        height: 50,
        width: 100.0.w - 2,
        child: Center(
            child: Text(
          noButton!,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: hotPropertiesThemeColor),
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReportCommonHeader(title: header!),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _titleTextCard(),
              SizedBox(
                height: 25,
              ),
              Column(
                children: [
                  _noButton(),
                  SizedBox(
                    height: 10,
                  ),
                  _yesButton(),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
