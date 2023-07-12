import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/business_categories_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/Edit%20Profile%20Cards/edit_profile_cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'edit_profile_page.dart';

class SelectProfileCategory extends StatefulWidget {
  final Function? setCategory;

  SelectProfileCategory({Key? key, this.setCategory}) : super(key: key);

  @override
  _SelectProfileCategoryState createState() => _SelectProfileCategoryState();
}

class _SelectProfileCategoryState extends State<SelectProfileCategory> {
  TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    _categoryController.text = CurrentUser().currentUser.category!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          widget.setCategory!();
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.0.w, vertical: 1.5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.keyboard_backspace_outlined,
                            size: 3.5.h,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2.0.w),
                          child: Text(
                            AppLocalizations.of(
                              "Change Category",
                            ),
                            style: blackBold.copyWith(fontSize: 15.0.sp),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            widget.setCategory!();
                          },
                          child: Icon(
                            Icons.check,
                            size: 3.5.h,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Center(
                    child: Padding(
                  padding: EdgeInsets.only(top: 7.0.h, bottom: 5.0.h),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(
                          "Select a Category",
                        ),
                        style: TextStyle(fontSize: 22.0.sp),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0.w, vertical: 1.0.h),
                        child: Text(
                          AppLocalizations.of(
                            "Choose a category that best describes what you do. You'll have the option to display or hide this on your Bebuzee profile",
                          ),
                          style: greyNormal.copyWith(fontSize: 10.5.sp),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )),
                CategorySelection(
                  setCategory: widget.setCategory,
                  hintText: AppLocalizations.of(
                    "Search Categories",
                  ),
                  controller: _categoryController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
