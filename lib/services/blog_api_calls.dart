import 'dart:async';
import 'dart:io';

import 'package:bizbultest/models/blogbuzz_category_model.dart';
import 'package:bizbultest/models/blogbuzz_list_model.dart';
import 'package:bizbultest/models/blogbuzz_model.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'current_user.dart';

class BlogApiCalls {
  static Future<BlogCategories> geBlogCategories(BuildContext context,
      String category, String cateID, int currentPage) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blogbuzfeed_category&user_id=${CurrentUser().currentUser.memberID}&category_data=$category&cateid=$cateID&country=${CurrentUser().currentUser.country}&page=$currentPage");

    var response = await http.get(url);
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body != "") {
      print(response.body);
      print("got blogss");
      BlogCategories blogData =
          BlogCategories.fromJson(jsonDecode(response.body));
      await Future.wait(blogData.categories
          .map((e) => Preload.cacheImage(context, e.blogImage!))
          .toList());
      return blogData;
    } else {
      print(" got nooooooooo blogss");
      return BlogCategories([]);
    }
  }

  static Future<Blogs> getBlogs(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? blogs = prefs.getString("all_blogs");
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blogbuz_data&country=${CurrentUser().currentUser.country}&category_data=");

      var response = await http.get(url);

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body != "") {
        Blogs blogData = Blogs.fromJson(jsonDecode(response.body));
        await Future.wait(blogData.blogs
            .map((e) => Preload.cacheImage(context, e.image!))
            .toList());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("all_blogs", response.body);
        return blogData;
      } else {
        return Blogs([]);
      }
    } on SocketException {
      if (blogs != null) {
        Blogs blogData = Blogs.fromJson(jsonDecode(blogs));
        await Future.wait(blogData.blogs
            .map((e) => PreloadCached.cacheImage(context, e.image!))
            .toList());
        return blogData;
      } else {
        return Blogs([]);
      }
    }
  }

  static Future<Blogs> getBlogsLocal(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? blogs = prefs.getString("all_blogs");

    if (blogs != null) {
      Blogs blogData = Blogs.fromJson(jsonDecode(blogs));
      await Future.wait(blogData.blogs
          .map((e) => Preload.cacheImage(context, e.image!))
          .toList());
      return blogData;
    } else {
      return Blogs([]);
    }
  }

  static Future<Blogs?> onLoading(
    Blogs blogList,
    BuildContext context,
    RefreshController _refreshController,
  ) async {
    int len = blogList.blogs.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += blogList.blogs[i].categoryVal!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php");

      final response = await http.post(url, body: {
        "country": CurrentUser().currentUser.country,
        "category_data": urlStr.split(',').last,
        "action": "blogbuz_data",
      });
      if (response.statusCode == 200 &&
          response.body != null &&
          response.body != "" &&
          response.body != "null") {
        Blogs blogData = Blogs.fromJson(jsonDecode(response.body));
        await Future.wait(blogData.blogs
            .map((e) => Preload.cacheImage(context, e.image!))
            .toList());
        _refreshController.loadComplete();
        return blogData;
      } else {
        _refreshController.loadComplete();
        return Blogs([]);
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't load blog",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _refreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          // return object of type Dialog
          return Container();
        },
      );
    }
    _refreshController.loadComplete();
    return null;
  }

  static Future<Categories> getBlogCategoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categories = prefs.getString("blog_categories");
    try {
      var url = Uri.parse(
          "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blog_buz_feed_category_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

      var response = await http.get(url);

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body != "") {
        Categories categoryData =
            Categories.fromJson(jsonDecode(response.body));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("blog_categories", response.body);
        return categoryData;
      } else {
        return Categories([]);
      }
    } on SocketException {
      if (categories != null) {
        Categories categoryData = Categories.fromJson(jsonDecode(categories));
        return categoryData;
      } else {
        return Categories([]);
      }
    }
  }

  static Future<Categories> getBlogCategoryListLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categories = prefs.getString("blog_categories");
    if (categories != null) {
      Categories categoryData = Categories.fromJson(jsonDecode(categories));
      return categoryData;
    } else {
      return Categories([]);
    }
  }
}
