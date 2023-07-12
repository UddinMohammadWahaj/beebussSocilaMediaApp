import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/blogbuz_countries_model.dart';
import 'package:bizbultest/view/blogbuzz_single_category_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LanguageBottomSheet extends StatelessWidget {
  final Datum? data;
  final VoidCallback? onTap;
  final String? recipeCategory;
  final String? category;
  Function? setNavBar;
  LanguageBottomSheet(
      {Key? key,
      this.data,
      this.onTap,
      this.recipeCategory,
      this.category,
      this.setNavBar})
      : super(key: key);

  Widget _header() {
    return Container(
        width: 100.0.w,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 0.8),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          AppLocalizations.of(
            "Select a language",
          ),
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade800),
          textAlign: TextAlign.center,
        ));
  }

  Widget _languageCard(String language, BuildContext context) {
    return ListTile(
      onTap: () {
        print(" Recipe categ ->cat2 =${category} ${recipeCategory}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlogBuzzCategoryMainPage(
                      recipeCategory: recipeCategory!,
                      country: data!.country!,
                      language: language!,
                      category: category!,
                      setNavBar: this.setNavBar!,
                    )));
      },
      title: Text(language),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(),
          Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data!.languages!
                    .map((e) => _languageCard(e.toString(), context))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
