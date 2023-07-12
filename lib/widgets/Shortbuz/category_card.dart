import 'package:bizbultest/models/shortbuz/shortbuzz_category_model.dart';
import 'package:bizbultest/models/update_channel_categories_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShortbuzCategoryCard extends StatelessWidget {
  final ShortbuzzCategoryModelCategory? category;
  final String? selectedCategory;
  final VoidCallback? onTap;

  const ShortbuzCategoryCard(
      {Key? key, this.category, this.selectedCategory, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: onTap ?? () {},
        leading: selectedCategory == category!.cateName
            ? Icon(
                Icons.check,
                size: 3.0.h,
                color: Colors.black,
              )
            : Container(
                height: 0,
                width: 0,
              ),
        title: Text(
          category!.cateName!,
          style: TextStyle(color: Colors.black, fontSize: 12.0.sp),
        ),
      ),
    );
  }
}
