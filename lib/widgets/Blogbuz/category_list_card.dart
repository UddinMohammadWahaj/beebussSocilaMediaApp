import 'package:bizbultest/services/Blogs/blogbuzz_category_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/recipe_category_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Recipe/country_selection_page.dart';

class CategoryListCard extends GetView<BlogBuzzCategoryController> {
  Function? setNavBar;
  CategoryListCard({Key? key, this.setNavBar}) : super(key: key);

  Widget _categoryCard(dynamic e, BuildContext context) {
    return Container(
      // color: Colors.pink,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () {
          print("tapped on a ccaty");
          print("category is ${e.categoryVal.toString().toLowerCase()}");

          if (e.categoryName.toString().toLowerCase() == "recipe") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RecipeCategoryPage()));
          }

          // if (e.categoryVal.toString().toLowerCase() == "recipe") {
          //   print("category is ${e.categoryVal.toString().toLowerCase()} baal");
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => RecipeCategoryPage()));
          // }
          else {
            print(e.categoryName.toString().replaceAll(" & ", "and"));
            print('category =$e');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlogBuzzCountryPage(
                          setNavBar: this.setNavBar!,
                          recipeCategory: "",
                          category:
                              e.categoryVal.toString().replaceAll(" & ", "and"),
                        )));
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => BlogBuzzCategoryMainPage(
            //               isChannelOpen: widget.isChannelOpen,
            //               refreshFromShortbuz: widget.refreshFromShortbuz,
            //               refresh: widget.refresh,
            //               setNavBar: widget.setNavBar,
            //               refreshFromMultipleStories: widget.refreshFromMultipleStories,
            //               index: widget.index,
            //               category: e.categoryVal,
            //             )));
          }
        },
        child: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: e.color == true ? primaryBlueColor : Colors.black,
              width: 1,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              e.categoryName.toUpperCase(),
              style: blackBold.copyWith(
                  fontFamily: 'Arial',
                  fontSize: 15,
                  color: e.color == true ? primaryBlueColor : Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Row(
          children: controller.categoryList.value.categories
              .map((e) => _categoryCard(e, context))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(BlogBuzzCategoryController());
    return Container(
      child: _categoryList(context),
    );
  }
}
