import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/blogbuzz_single_category_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:bizbultest/models/recipe_category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import 'Blogbuz/Recipe/country_bottom_sheet.dart';
import 'Blogbuz/Recipe/country_selection_page.dart';

class RecipeCategoryCard extends StatefulWidget {
  final RecipeCategoryModel recipe;

  RecipeCategoryCard({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeCategoryCardState createState() => _RecipeCategoryCardState();
}

class _RecipeCategoryCardState extends State<RecipeCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /*  Get.bottomSheet(CountryBottomSheet(),
            isScrollControlled: false,
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: const Radius.circular(30.0), topRight: const Radius.circular(30.0))));
*/
        print(
            'Recipe category data category:${widget.recipe.category} recipeCategory:${widget.recipe.categorySub}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlogBuzzCountryPage(
                      category: widget.recipe.category!,
                      recipeCategory: widget.recipe.categorySub!,
                    )));
        /*  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlogBuzzCategory(
                  category: widget.recipe.category,
                  cateID: widget.recipe.cateID,
                )));*/
      },
      child: Container(
        // color: Colors.pink,/
        child: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                  aspectRatio: 9 / 16,
                  child: Image(
                    image: CachedNetworkImageProvider(
                      widget.recipe.image!,
                    ),
                    fit: BoxFit.cover,
                  )),
              Positioned(
                bottom: 5,
                left: 5,
                right: 5,

                // .fromRelativeRect(
                // rect: RelativeRect.fromLTRB(5, 177, 5, 10),
                //  fill(
                // top: 26.h,
                child: Container(
                    height: 6.2.h,
                    alignment: Alignment.center,
                    // color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${widget.recipe.categorySub}',
                        // style: TextStyle(),
                        // textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
