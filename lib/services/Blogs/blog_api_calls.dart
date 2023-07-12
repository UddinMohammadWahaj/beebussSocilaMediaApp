import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/blogbuz_countries_model.dart';
import 'package:bizbultest/models/blogbuzz_category_model.dart';
import 'package:bizbultest/models/blogbuzz_list_model.dart';
import 'package:bizbultest/models/blogbuzz_model.dart';
import 'package:bizbultest/models/related_blog_model.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../current_user.dart';

class BlogApiCalls {
  static Future<BlogCategories> geBlogCategories(
      BuildContext context,
      String category,
      String resCategory,
      int currentPage,
      String country,
      String language) async {
    print('callllllllllllllllllllleddddddddddd ');
    var newurl = 'https://www.bebuzee.com/api/blog/listCategoryBase';
    var endurl =
        '?user_id=${CurrentUser().currentUser.memberID}&category=$category&recipe_category=$resCategory&country=$country&page=$currentPage&country_val=$country&language=$language';
    print('callllllllllllllllllllleddddddddddd $newurl+$endurl');
    var client = Dio();
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    return await client
        .post(
      newurl,
      queryParameters: {
        'user_id': CurrentUser().currentUser.memberID,
        'category': '$category',
        'recipe_category': '$resCategory',
        'country': country,
        'page': '$currentPage',
        'country_val': '$country',
        "language": '$language'
      },
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) async {
      if (value.statusCode == 200) {
        print("blog cat data new=${value.data}");
        BlogCategories blogData = BlogCategories.fromJson(value.data['data']);
        await Future.wait(blogData.categories
            .map((e) => Preload.cacheImage(context, e.blogImage!))
            .toList());
        return blogData;
      } else {
        print(" got nooooooooo blogss");
        return BlogCategories([]);
      }
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blogbuzfeed_category&user_id=${CurrentUser().currentUser.memberID}&category=$category&recipe_category=$resCategory&country=${CurrentUser().currentUser.country}&page=$currentPage&country_val=$country&language=$language");
    // print(url);
    // var response = await http.get(url);
    // if (response.statusCode == 200 &&
    //     response.body != null &&
    //     response.body != "") {
    //   print(response.body);
    //   print("got blogss");
    //   BlogCategories blogData =
    //       BlogCategories.fromJson(jsonDecode(response.body));
    //   await Future.wait(blogData.categories
    //       .map((e) => Preload.cacheImage(context, e.blogImage))
    //       .toList());
    //   return blogData;
    // } else {
    //   print(" got nooooooooo blogss");
    //   return BlogCategories([]);
    // }
  }

  static Future<Blogs> getBlogs(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? blogs = prefs.getString("all_blogs");
    try {
      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/blog/list?action=blogbuz_data&country=${CurrentUser().currentUser.country}&category_data=');
      print("blog url=${newurl}");
      var client = Dio();
      String? token =
          await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
      return await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        print("getblogs output ${value.data}");

        if (value.statusCode == 200) {
          Blogs blogData = Blogs.fromJson(value.data['data']);
          await Future.wait(blogData.blogs
              .map((e) => Preload.cacheImage(context, e.image!))
              .toList());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("all_blogs", value.data['data'].toString());
          return blogData;
        } else {
          return Blogs([]);
        }
      });
      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blogbuz_data&country=${CurrentUser().currentUser.country}&category_data=");

      // var response = await http.get(url);

      // if (response.statusCode == 200 &&
      //     response.body != null &&
      //     response.body != "") {
      //   Blogs blogData = Blogs.fromJson(jsonDecode(response.body));
      //   await Future.wait(blogData.blogs
      //       .map((e) => Preload.cacheImage(context, e.image))
      //       .toList());
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString("all_blogs", response.body);
      //   return blogData;
      // } else {
      //   return Blogs([]);
      // }
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
    try {
      if (blogs != null) {
        Blogs blogData = Blogs.fromJson(jsonDecode(blogs));
        await Future.wait(blogData.blogs
            .map((e) => Preload.cacheImage(context, e.image!))
            .toList());
        print("blogata = ${blogData} ${blogData.blogs.length}");
        return blogData;
      } else {
        return Blogs([]);
      }
    } catch (e) {
      return Blogs([]);
    }
  }

  static Future<Blogs?> onLoading(Blogs blogList, BuildContext context,
      RefreshController _refreshController,
      {currentUrlStr: ""}) async {
    int len = blogList.blogs.length;
    print("on bia nia ${len}");
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      if (blogList.blogs[i].category == 'banner') {
        continue;
      }

      var blogcategory = blogList.blogs[i].category;
      print("on bia nia ${blogcategory}");
      blogcategory = blogcategory!.replaceFirst('&', '@');
      urlStr += blogcategory;
      if (i != len - 1) {
        urlStr += ",";
      }
    }

    try {
      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/blog/list?action=blogbuz_data&country=${CurrentUser().currentUser.country}&category_data=$currentUrlStr');
      print("onLoading  aha $newurl");
      var client = Dio();
      String? token =
          await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
      return await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        print("getblogs output ${value.data}");

        if (value.statusCode == 200) {
          Blogs blogData = Blogs.fromJson(value.data['data']);
          await Future.wait(blogData.blogs
              .map((e) => Preload.cacheImage(context, e.image!))
              .toList());
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString("all_blogs", value.data['data'].toString());
          _refreshController.loadComplete();
          return blogData;
        } else {
          _refreshController.loadComplete();
          return Blogs([]);
        }
      });

      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php");

      // final response = await http.post(url, body: {
      //   "country": CurrentUser().currentUser.country,
      //   "category_data": urlStr.split(',').last,
      //   "action": "blogbuz_data",
      // });
      // if (response.statusCode == 200 &&
      //     response.body != null &&
      //     response.body != "" &&
      //     response.body != "null") {
      //   Blogs blogData = Blogs.fromJson(jsonDecode(response.body));
      //   await Future.wait(blogData.blogs
      //       .map((e) => Preload.cacheImage(context, e.image))
      //       .toList());
      //   _refreshController.loadComplete();
      //   return blogData;
      // } else {
      //   _refreshController.loadComplete();
      //   return Blogs([]);
      // }
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
      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/blog/blogCategory?action=blog_buz_feed_category_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}');

      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blog_buz_feed_category_list&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

      var client = Dio();
      String? token = await ApiProvider().getTheToken();
      print('get category url=${newurl} &token=${token}');
      return await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        try {
          if (value.statusCode == 200) {
            print("blogbuzz category datalist=${value.data}");
            Categories categoryData = Categories.fromJson(value.data['data']);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("blog_categories", value.data['data'].toString());
            return categoryData;
          } else {
            return Categories([]);
          }
        } catch (e) {
          print("category listt error=$e");
          return Categories([]);
        }
      });

      // var response = await http.get(url);

      // if (response.statusCode == 200 &&
      //     response.body != null &&
      //     response.body != "") {
      //   Categories categoryData =
      //       Categories.fromJson(jsonDecode(response.body));
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString("blog_categories", response.body);
      //   return categoryData;
      // } else {
      //   return Categories([]);
      // }
    } on SocketException {
      if (categories != null) {
        Categories categoryData = Categories.fromJson(jsonDecode(categories));
        return categoryData;
      } else {
        return Categories([]);
      }
    }
  }

  static Future getAdBanner() async {
    var url =
        'https://www.bebuzee.com/api/single_banner_ads.php?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.memberID}';
    print("url of banner ad=${url}");
    var response = await ApiProvider().fireApi(url).then((value) => value);
    print("response=${response.data}");
  }

  static Future<Categories> getBlogCategoryListLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? categories = prefs.getString("blog_categories");
    // return Categories([]);
    try {
      if (categories != null) {
        Categories categoryData = Categories.fromJson(jsonDecode(categories));
        return categoryData;
      } else {
        return Categories([]);
      }
    } catch (e) {
      return Categories([]);
    }
  }

  static Future<List<RelatedBlogModel>> getRelatedBlogs(String keyword) async {
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/blog/blogbuzDetailRelated?action=blogbuzfeed_detail_category_related&blog_category=$keyword&country=${CurrentUser().currentUser.country}');
    var client = Dio();
    String? token = await ApiProvider().getTheToken();
    print("url related=${newurl} ${token}");
    return await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) {
      if (value.statusCode == 200) {
        print("related blogs data = ${value.data}");
        RelatedBlogs blogData = RelatedBlogs.fromJson(value.data['data']);
        return blogData.blogs;
      } else {
        return <RelatedBlogModel>[];
      }
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blogbuzfeed_detail_category_related&blog_category=$keyword");
    // var response = await http.get(url);
    // if (response.statusCode == 200 &&
    //     response.body != null &&
    //     response.body != "" &&
    //     response.body != "null") {
    //   RelatedBlogs blogData = RelatedBlogs.fromJson(jsonDecode(response.body));
    //   return blogData.blogs;
    // } else {
    //   return <RelatedBlogModel>[];
    // }
  }

  static Future<BlogCountries> getBlogCountries(String category,
      {String recipe = "", String searchCountry = ''}) async {
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/blog_category_country_list.php?category_name=$category&recipe_category=${recipe}&user_id=${CurrentUser().currentUser.memberID}&search_country=${searchCountry}');
    var client = Dio();
    print("blog country yurl=${newurl}");
    String? token =
        await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
    return await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) {
      if (value.statusCode == 200) {
        print("blog countries =${value.data}");
        BlogCountries countryData =
            BlogCountries.fromJson(value.data['country_list']);
        return countryData;
      } else {
        print("blog countries =no data");
        return BlogCountries([]);
      }
    });

    // var url = Uri.parse(
    //     "https://bebuzee.com/webservices/blog_category_country_list.php?category_name=$category&recipe_category=&user_id=${CurrentUser().currentUser.memberID}");
    // print(category);
    // print(url);
    // var response = await http.get(url);

    // if (response.statusCode == 200 &&
    //     response.body != null &&
    //     response.body != "") {
    //   print(response.body);
    //   print("got languages");
    //   BlogCountries countryData =
    //       BlogCountries.fromJson(jsonDecode(response.body));
    //   return countryData;
    // } else {
    //   print("got no languages");
    //   return BlogCountries([]);
    // }
  }
}
