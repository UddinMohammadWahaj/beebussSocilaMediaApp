import 'dart:async';
import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/widgets/recipe_category_card.dart';
import 'package:bizbultest/widgets/large_video_card.dart';
import 'package:bizbultest/models/video_search_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/models/recipe_category_model.dart';

class RecipeCategoryPage extends StatefulWidget {
  @override
  _RecipeCategoryPageState createState() => _RecipeCategoryPageState();
}

class _RecipeCategoryPageState extends State<RecipeCategoryPage> {
  late Recipes recipeList;
  bool areLoaded = false;

  Future<void> _getRecipes() async {
    print(" the get Recipies called");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/blog/receipeData?action=blog_receipe_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}');
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    await client
        .getUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      print("recipie data = ${value.data}");
      if (value.statusCode == 200) {
        Recipes recipeData = Recipes.fromJson(value.data['data']);
        await Future.wait(recipeData.recipes
            .map((e) => PreloadCached.cacheImage(context, e.image!))
            .toList());
        if (mounted) {
          setState(() {
            recipeList = recipeData;
            areLoaded = true;
          });
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("recipe_data", value.data['data'].toString());
      }
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blog_receipe_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

    // var response = await http.get(url);

    // if (response.statusCode == 200) {
    //   Recipes recipeData = Recipes.fromJson(jsonDecode(response.body));
    //   await Future.wait(recipeData.recipes
    //       .map((e) => PreloadCached.cacheImage(context, e.image))
    //       .toList());
    //   if (mounted) {
    //     setState(() {
    //       recipeList = recipeData;
    //       areLoaded = true;
    //     });
    //   }
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString("recipe_data", response.body);
    // }
  }

  void _loadLocalRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? recipeData = prefs.getString("recipe_data");
    try {
      if (recipeData != null) {
        print("data found");
        Recipes recipes = Recipes.fromJson(jsonDecode(recipeData));
        if (mounted) {
          setState(() {
            recipeList = recipes;
            areLoaded = true;
          });
        }
      } else {
        print("no data");
      }
    } catch (e) {
      print("no data");
    }
  }

  @override
  void initState() {
    _loadLocalRecipes();
    _getRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F4F2F2"),
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          constraints: BoxConstraints(),
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.symmetric(horizontal: 0),
        ),
        title: Text(
          AppLocalizations.of(
            "Recipes",
          ),
          style: blackBold.copyWith(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: HexColor("#F4F2F2"),
      ),
      body: areLoaded == true
          ? GridView.builder(
              shrinkWrap: true,
              itemCount: recipeList.recipes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.6,
                crossAxisCount: 3,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemBuilder: (context, index) {
                return RecipeCategoryCard(
                  recipe: recipeList.recipes[index],
                );
              })
          : Container(),
    );
  }
}
