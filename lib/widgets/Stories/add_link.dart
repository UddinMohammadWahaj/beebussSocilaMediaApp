import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/simple_web_view.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddLinkToStory extends StatefulWidget {
  final Function? addLink;

  AddLinkToStory({Key? key, this.addLink}) : super(key: key);

  @override
  _AddLinkToStoryState createState() => _AddLinkToStoryState();
}

class _AddLinkToStoryState extends State<AddLinkToStory> {
  TextEditingController _controller = TextEditingController();
  bool isTextEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(right: 4.0.w),
                      child: Icon(
                        Icons.keyboard_backspace_outlined,
                        color: Colors.black,
                        size: 3.5.h,
                      ),
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(
                    "Swipe up Link",
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 15.0.sp),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_controller.text != "") {
                      widget.addLink!(_controller.text);
                      print(_controller.text);
                    }

                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.0.w),
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 3.5.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 2.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 1.5.h),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of("Web link"),
                    style: TextStyle(color: Colors.black, fontSize: 14.0.sp),
                  ),
                  !isTextEmpty
                      ? GestureDetector(
                          onTap: () {
                            _controller.clear();
                            setState(() {
                              isTextEmpty = true;
                            });
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 8.0.w, right: 10.0.w),
                            child: Text(
                              AppLocalizations.of(
                                "Remove Link",
                              ),
                              style: TextStyle(
                                  color: primaryBlueColor, fontSize: 10.0.sp),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Container(
              decoration: new BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: new Border.all(
                  color: Colors.black,
                  width: 0.5,
                ),
                shape: BoxShape.rectangle,
              ),
              height: 50,
              child: TextFormField(
                onChanged: (val) {
                  if (_controller.text == "") {
                    setState(() {
                      isTextEmpty = true;
                    });
                  } else {
                    setState(() {
                      isTextEmpty = false;
                    });
                  }
                },
                maxLines: null,
                controller: _controller,
                cursorHeight: 20,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: AppLocalizations.of("Web Link"),
                  contentPadding: EdgeInsets.only(left: 2.0.w, top: 15),
                  //alignLabelWithHint: true,

                  hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                ),
              ),
            ),
            isTextEmpty == true
                ? Padding(
                    padding: EdgeInsets.only(top: 1.5.h),
                    child: Text(
                      AppLocalizations.of(
                        "Viewers will be able to swipe up to visit the link",
                      ),
                      style: greyNormal.copyWith(fontSize: 10.0.sp),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SimpleWebView(
                                    url: _controller.text,
                                    heading: "",
                                  )));
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(top: 1.5.h, bottom: 3.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                AppLocalizations.of(
                                  "People who will see your story can swipe up to go to this page",
                                ),
                                style: greyNormal.copyWith(fontSize: 10.0.sp)),
                            Text(
                              AppLocalizations.of(
                                "See preview",
                              ),
                              style: TextStyle(
                                  color: primaryBlueColor, fontSize: 10.0.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
