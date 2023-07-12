import 'dart:async';
import 'dart:convert';
import 'dart:io' as i;

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/blogbuzz_list_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/common_appbar.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:zefyrka/zefyrka.dart';

class CreateBlog extends StatefulWidget {
  final String? memberID;
  final String? country;
  final String? logo;

  CreateBlog({Key? key, this.memberID, this.country, this.logo})
      : super(key: key);

  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  List countryList = [];
  List countryLanguageList = [];
  List categoryList = [];
  List recipeCategoryList = [];
  List recipeCountryList = [];
  late String selectedCountryValue;
  late String selectedCategory;
  late String selectedCategoryValue;
  List categoryListValue = [];
  late String selectedRecipeCategory;
  late String selectedRecipeCountry;
  late String selectedCountryLanguage;
  bool uploadVideo = false;
  bool videoUrl = false;
  bool showRecipeMenu = false;
  bool showCountryLanguage = false;
  String imageName = "";
  String videoName = "";
  String thumbnailName = "";
  ZefyrController _controller = ZefyrController();
  String blogTitle = "";
  String blogDescription = "";
  String blogKeywords = "";
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _keywordsController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  TextEditingController _videoUrlController = TextEditingController();

  // ZefyrController _blogContentController;
  late FocusNode _blogNode;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late i.File _image;
  late i.File _video;
  late i.File _thumbnail;

  bool isVideoPicked = false;
  bool imagePicked = false;
  bool isVideoUploaded = false;

  _imgFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _image = i.File(result.files.single.path!);
        imageName = _image.path.split('/').last;
        imagePicked = true;
      });
    } else {
      // User canceled the picker
    }
  }

  _videoFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _video = i.File(result.files.single.path!);
        videoName = _video.path.split('/').last;
      });
      print(_video.path);
    } else {
      // User canceled the picker
    }
  }

  _thumbFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _thumbnail = i.File(result.files.single.path!);
        thumbnailName = _thumbnail.path.split('/').last;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<String> getCategoryList() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=create_user_blog_category_list&country=${widget.country}&user_id=${widget.memberID}");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/blog/blogCategory?action=blog_buz_feed_category_list&user_id=${widget.memberID}&country=${widget.country}');
    String? token = await ApiProvider().refreshToken(widget.memberID!);
    var client = Dio();
    var resBody;
    var resBody2;
    await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) {
      print('create blog category list bia =${value.data}');
      if (value.statusCode == 200) {
        print('category list bia =${value.data}');
        resBody = value.data['category'];
      }
    });

    // var response = await http.get(url);

    // var resBody = json.decode(response.body);

    setState(() {
      categoryList = resBody;
    });

    print(resBody);
    return "Success";
  }

  Future<String> getRecipeCategoryList() async {
    var url =
        "https://www.bebuzee.com/api/blog/receipeData?action=create_user_blog_receipe_category_list&country=${widget.country}&user_id=${widget.memberID}";
    print("edit blog getRecipeCategory list=$url");
    await getRecipeCountryList();
    var res = await Dio().get(url);

    var resBody = res.data['data'];

    setState(() {
      if (recipeCategoryList.length == 0) recipeCategoryList = resBody;

      print("rec category=${recipeCategoryList[0]['category_sub']}");
    });

    print('resBody');

    return "Success";
  }

  Future<String> getRecipeCountryList() async {
    print("get recipe country called");
    var url =
        "https://www.bebuzee.com/api/recipe_country_list.php?action=create_user_blog_receipe_country_list&country=${widget.country}&user_id=${widget.memberID}";
    print("get recipe country called $url");
    var res = await Dio().get(url);

    var resBody = res.data['country'];

    setState(() {
      recipeCountryList = resBody;
    });

    print(resBody);

    return "Success";
  }

  Future<String> getCountryList() async {
    var resBody;
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/localized_countries.php?action=video_country_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}');
    var client = Dio();
    String? token = await ApiProvider().refreshToken(widget.memberID!);
    await client
        .getUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) {
      if (value.statusCode == 200) {
        setState(() {
          resBody = value.data['country'];
          countryList = resBody;
        });
      }
    });

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=create_user_blog_language_country_list&country=${widget.country}&user_id=${widget.memberID}");

    // var res = await http.get(url);
    // var resBody = json.decode(res.body);

    // print("magia ${countryList}");
    // List bal = countryList
    //     .map((e) => {"baal": e['country_name'], "chaal": e['id']})
    //     .toList();
    // print("magia new ${bal}");

    print(resBody);

    return "Success";
  }

  Future<String> getCountryLanguageList(String value) async {
    print("called language");
    var newurl = Uri.parse(
        'https://www.bebuzee.com/api/blog_country_language.php?action=create_user_blog_language_list&country=${value}&user_id=${widget.memberID}');
    print(newurl);
    var client = Dio();
    var resBody;
    String? token = await ApiProvider().refreshToken(widget.memberID!);
    await client
        .postUri(
      newurl,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        .then((value) {
      print("country lang list=${value.data}");
      if (value.statusCode == 200) {
        resBody = value.data['data'];
      }
    });

    print('country language =${resBody}');

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=create_user_blog_language_list&country=${widget.country}&user_id=${widget.memberID}&selected_country=$value");

    // var res = await http.get(url);

    // resBody = json.decode(res.body);

    setState(() {
      resBody = resBody.map((e) => {"blog_country_language": e}).toList();
      countryLanguageList = resBody;
    });

    print(resBody);
    print("languages");

    return "Success";
  }

  String getSelectedCountry() {
    if (selectedCountryValue != null) return selectedCountryValue.toString();
    return widget.country!;
  }

  void _publishBlog() async {
    g.Get.dialog(ProcessingDialog(
      title: "Publishing your blog...",
      heading: "",
    ));

    var country = getSelectedCountry();
    var url = Uri.parse(
        'https://www.bebuzee.com/api/create_blog.php?action=create_user_blog_data&user_id=${widget.memberID}&country=$country&blog_title=${_titleController.text}&category=${selectedCategoryValue.toString()}&content=${_controller.plainTextEditingValue.text}&reference_link=${_referenceController.text}&blog_desc=${_descriptionController.text}&blog_keywords=${_keywordsController.text}&image=asasa&country_lang=${selectedCountryLanguage}&video_url_data=${_videoUrlController.text}&video_file=aadadaa&thumbnail=aaaad&language_name=${selectedCountryLanguage.toString()}&rec_cat=${selectedRecipeCategory.toString()}&rec_country=${selectedRecipeCountry.toString()}');
    print("url of blog= $url");
    var client = new Dio();

    FormData formData = FormData();
    //  new FormData.fromMap({
    //   "image": await MultipartFile.fromFile(_image.path),
    //   "video_file":
    //       _video != null ? await MultipartFile.fromFile(_video.path) : null,
    //   "thumbnail": _thumbnail != null
    //       ? await MultipartFile.fromFile(_thumbnail.path)
    //       : null,
    // });

    formData.files
        .addAll([MapEntry("image", await MultipartFile.fromFile(_image.path))]);
    if (_video != null) {
      formData.files.addAll(
          [MapEntry("video_file", await MultipartFile.fromFile(_video.path))]);
    }
    if (_thumbnail != null) {
      formData.files.addAll([
        MapEntry("video_file", await MultipartFile.fromFile(_thumbnail.path))
      ]);
    }

    String? token = await ApiProvider().refreshToken(widget.memberID!);
    await client
        .postUri(
      url,
      data: formData,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    )
        // await client.post(
        //   "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=create_user_blog_data&user_id=${widget.memberID}&country=${widget.country}&blog_title=${_titleController.text}&category=${selectedCategory.toString()}&content=${_controller.plainTextEditingValue.text}&reference_link=${_referenceController.text}&blog_desc=${_descriptionController.text}&blog_keywords=${_keywordsController.text}&image=asasa&country_lang=${int.parse(selectedCountryValue)}&country_lang=[country language name]&video_url_data=${_videoUrlController.text}&video_file=aadadaa&thumbnail=aaaad&language_name=${selectedCountryLanguage.toString()}&rec_cat=${selectedRecipeCategory.toString()}&rec_country=${selectedRecipeCountry.toString()}",
        //   data: formData,
        //   onSendProgress: (int sent, int total) {
        //     final progress = (sent / total) * 100;
        //     print('location progress: $progress');
        //   },
        // )

        .then((res) {
      g.Get.back();
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
          .showSnackBar(showSnackBar(AppLocalizations.of('Blog published')));
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
      FeedController feedController = g.Get.put(FeedController());
      feedController.refreshFeeds.updateRefresh(true);
      print(url);
      print(res.data.toString());
      print(res.toString());
      print("publish response");
    });
  }

/*  void uploadImage() async {
    final uri = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=create_user_blog_data&user_id=${widget.memberID}&country=${widget.country}&blog_title=${_titleController.text}&category=${selectedCategory.toString()}&content=${_controller.plainTextEditingValue.text}&reference_link=${_referenceController.text}&blog_desc=${_descriptionController.text}&blog_keywords=${_keywordsController.text}&image=asasa&country_lang=${int.parse(selectedCountryValue)}&country_lang=[country language name]&video_url_data=${_videoUrlController.text}&video_file=aadadaa&thumbnail=aaaad&language_name=${selectedCountryLanguage.toString()}&rec_cat=${selectedRecipeCategory.toString()}&rec_country=${selectedRecipeCountry.toString()}");
    final req = new http.MultipartRequest("POST", uri);

    if (_image != null && imagePicked == true) {
      print(imagePicked.toString() + "is image picked");
      final stream = http.ByteStream(Stream.castFrom(_image.openRead()));
      final length = await _image.length();

      final multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: path.basename(_image.path),
      );

      req.files.add(multipartFile);
    }

    if (_video != null) {
      setState(() {
        isVideoPicked = true;
      });
      final stream2 = http.ByteStream(Stream.castFrom(_video.openRead()));
      final length2 = await _video.length();
      final multipartFile2 = http.MultipartFile('video_file', stream2, length2, filename: path.basename(_video.path));

      req.files.add(multipartFile2);
    }

    if (_thumbnail != null) {
      final stream3 = http.ByteStream(Stream.castFrom(_thumbnail.openRead()));
      final length3 = await _thumbnail.length();
      final multipartFile3 = http.MultipartFile('thumbnail', stream3, length3, filename: path.basename(_thumbnail.path));

      req.files.add(multipartFile3);
    }

    final res = await req.send();
    await for (var value in res.stream.transform(utf8.decoder)) {
      print(value);
    }

    if (isVideoPicked == true) {
      setState(() {
        isVideoUploaded = true;
      });

      _scaffoldKey.currentState.showSnackBar(showSnackBar('Blog published successfully'));
    }

    if (res.statusCode == 200 && isVideoPicked == true) {
      setState(() {
        isVideoUploaded = false;
      });
    }

    print("is video picked " + isVideoPicked.toString());

    print(res.statusCode);
    print(res.contentLength);

    print(res);
  }*/

  @override
  void initState() {
    getCategoryList();
    getCountryList();
    getRecipeCategoryList();
    // getCountryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CommonAppbar(
          logo: widget.logo,
          country: widget.country,
          memberID: widget.memberID,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(2.0.h),
          child: Container(
            width: 90.0.w,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0.h),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        AppLocalizations.of(
                          "Create Blog",
                        ),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      AppLocalizations.of(
                        "Create Your Blog",
                      ),
                      style: TextStyle(fontSize: 23),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        AppLocalizations.of(
                          "Create your image or video blog",
                        ),
                        style: TextStyle(fontSize: 17),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            AppLocalizations.of(
                              "Blog Category",
                            ),
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: DropdownButton<dynamic>(
                            isExpanded: true,
                            hint: Text(
                              AppLocalizations.of("Select Category"),
                            ),
                            items: categoryList.map((e) {
                              return DropdownMenuItem(
                                child: Text(e["category_name"]),
                                value: e["category_name"],
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val == "Recipe") {
                                setState(() {
                                  showRecipeMenu = true;
                                });
                              } else {
                                showRecipeMenu = false;
                              }
                              var k = categoryList
                                  .where((element) =>
                                      element['category_name'] == val)
                                  .first;
                              print('category value aha =${k['category_val']}');
                              setState(() {
                                selectedCategory = val;
                                selectedCategoryValue = k['category_val'];
                              });

                              print('category value=$selectedCategory');
                            },
                            value: selectedCategory,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                showRecipeMenu == true
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppLocalizations.of(
                                    "Recipe Category",
                                  ),
                                  style: TextStyle(fontSize: 16),
                                )),
                            Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(
                                    AppLocalizations.of(
                                      "Select Recipe Category",
                                    ),
                                  ),
                                  items: recipeCategoryList.map((e) {
                                    return DropdownMenuItem(
                                      child: Text(e["category_sub"]),
                                      value: e["cateid"],
                                    );
                                  }).toList(),
                                  onChanged: (dynamic val) {
                                    setState(() {
                                      selectedRecipeCategory = val;
                                    });

                                    print(selectedRecipeCategory);
                                  },
                                  value: selectedRecipeCategory,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                showRecipeMenu == true
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppLocalizations.of(
                                    "Recipe Country",
                                  ),
                                  style: TextStyle(fontSize: 16),
                                )),
                            Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(
                                    AppLocalizations.of(
                                        "Select Recipe Country"),
                                  ),
                                  items: recipeCountryList.map((e) {
                                    return DropdownMenuItem(
                                      child: Text(e["country_name"]),
                                      value: e["id"],
                                    );
                                  }).toList(),
                                  onChanged: (dynamic val) {
                                    setState(() {
                                      selectedRecipeCountry = val;
                                    });

                                    print(selectedRecipeCountry);
                                  },
                                  value: selectedRecipeCountry,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            AppLocalizations.of(
                              "Blog Country",
                            ),
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text(
                              AppLocalizations.of("Select Country"),
                            ),
                            items: countryList.map((e) {
                              return DropdownMenuItem(
                                child: Text(e["country_name"]),
                                value: '${e['country_name']}',
                                // child: Text(e["blog_country_name"]),
                                // value: e['blog_country_value'],
                              );
                            }).toList(),
                            onChanged: (val) async {
                              setState(() {
                                selectedCountryValue = val.toString();
                                print(
                                    "selected country=${selectedCountryValue}");
                              });

                              print(getCountryLanguageList);
                              await getCountryLanguageList(val.toString());

                              setState(() {
                                showCountryLanguage = true;
                              });

                              // print(selectedCountryValue);
                              // print(int.parse(selectedCountryValue));
                            },
                            value: selectedCountryValue,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                showCountryLanguage == true
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppLocalizations.of(
                                    "Blog Country Language",
                                  ),
                                  style: TextStyle(fontSize: 16),
                                )),
                            Container(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text(
                                    AppLocalizations.of(
                                      "Select Country Language",
                                    ),
                                  ),
                                  items: countryLanguageList.map((e) {
                                    return DropdownMenuItem(
                                      child: Text(e["blog_country_language"]),
                                      value: e['blog_country_language'],
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedCountryLanguage = val.toString();
                                      print(
                                          "country=$selectedCountryLanguage ");
                                    });

                                    print(selectedCountryLanguage);
                                  },
                                  value: selectedCountryLanguage,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            AppLocalizations.of(
                              "Blog Title",
                            ),
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: TextFormField(
                            onTap: () {},
                            maxLines: null,
                            controller: _titleController,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(
                                "Blog Title",
                              ),
                              // 48 -> icon width
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            AppLocalizations.of(
                              "Description",
                            ),
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: TextFormField(
                            onChanged: (val) {
                              print(val);
                            },
                            onTap: () {
                              setState(() {});
                            },
                            maxLines: 1,
                            controller: _descriptionController,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(
                                "Description",
                              ),
                              // 48 -> icon width
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            AppLocalizations.of(
                              "Keywords (Comma separated)",
                            ),
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: TextFormField(
                            onTap: () {
                              setState(() {});
                            },
                            maxLines: 1,
                            controller: _keywordsController,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(
                                "Keywords",
                              ),

                              // 48 -> icon width
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            AppLocalizations.of(
                              "Cover Image",
                            ),
                            style: TextStyle(fontSize: 16),
                          )),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 90.0.w,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      primaryBlueColor)),
                              onPressed: () {
                                _imgFromGallery();
                              },
                              child: Text(
                                imageName != null && imageName != ""
                                    ? AppLocalizations.of(
                                        "Change Image",
                                      )
                                    : AppLocalizations.of(
                                        "Select Image",
                                      ),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0.h),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          width: 90.0.w,
                          child: Text(
                            AppLocalizations.of(
                              "Selected Image",
                            ),
                            style: TextStyle(fontSize: 16),
                          ))),
                ),
                imageName == null || imageName == ""
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.2.h),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                width: 90.0.w,
                                child: Image.file(i.File(_image.path)))),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    uploadVideo = true;
                                    videoUrl = false;
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(
                                        "Upload a video",
                                      ) +
                                      " ",
                                  style: TextStyle(
                                      fontSize: 16, color: primaryBlueColor),
                                ),
                              ),
                              Text(
                                AppLocalizations.of("or") + " ",
                                style: TextStyle(fontSize: 16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    uploadVideo = false;
                                    videoUrl = true;
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(
                                    "Video URL",
                                  ),
                                  style: TextStyle(
                                      fontSize: 16, color: primaryBlueColor),
                                ),
                              ),
                            ],
                          )),
                      uploadVideo == true
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: 90.0.w,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 90.0.w,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    primaryBlueColor)),
                                        onPressed: () {
                                          _videoFromGallery();
                                        },
                                        child: Text(
                                          videoName != null && videoName != ""
                                              ? videoName
                                              : AppLocalizations.of(
                                                  "Select Video",
                                                ),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(
                                          "Upload up to 100MB mp4 video only"),
                                    ),
                                    videoName != null && videoName != ""
                                        ? GestureDetector(
                                            onTap: () {
                                              _thumbFromGallery();
                                            },
                                            child: Container(
                                                color: Colors.transparent,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.all(1.0.h),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                      "Select Video Thumbnail",
                                                    ),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )))
                                        : Container(),
                                    thumbnailName != null && thumbnailName != ""
                                        ? Text(thumbnailName)
                                        : Container()
                                  ],
                                ),
                              ))
                          : videoUrl == true && uploadVideo == false
                              ? Container(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: TextFormField(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      maxLines: 1,
                                      controller: _videoUrlController,
                                      keyboardType: TextInputType.text,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(
                                          "Please provide a video URL",
                                        ),

                                        // 48 -> icon width
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppLocalizations.of(
                                    "Blog Content",
                                  ),
                                  style: TextStyle(fontSize: 16),
                                )),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0.h),
                              child: Container(
                                  height: 40.0.h,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: new Border.all(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      ZefyrToolbar.basic(
                                          controller: _controller),
                                      Expanded(
                                        child: ZefyrEditor(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          controller: _controller,
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            AppLocalizations.of(
                              "Reference Link",
                            ),
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: TextFormField(
                            onChanged: (val) {
                              print(val);
                            },
                            onTap: () {
                              setState(() {});
                            },
                            maxLines: 1,
                            controller: _referenceController,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(
                                "Reference Link",
                              ),

                              // 48 -> icon width
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: isVideoUploaded == false
                          ? Container(
                              width: 40.0.w,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        primaryBlueColor)),
                                onPressed: () {
                                  if (imagePicked == false) {
                                    ScaffoldMessenger.of(
                                            _scaffoldKey.currentState!.context)
                                        .showSnackBar(showSnackBar(
                                      AppLocalizations.of(
                                        'Please select an Image',
                                      ),
                                    ));
                                  } else if (selectedCategory == null) {
                                    ScaffoldMessenger.of(
                                            _scaffoldKey.currentState!.context)
                                        .showSnackBar(showSnackBar(
                                      AppLocalizations.of(
                                          'Please select a Category'),
                                    ));
                                  } else if (selectedCountryValue == null) {
                                    ScaffoldMessenger.of(
                                            _scaffoldKey.currentState!.context)
                                        .showSnackBar(showSnackBar(
                                      AppLocalizations.of(
                                          'Please select a Country'),
                                    ));
                                  } else if (_titleController.text.isEmpty) {
                                    ScaffoldMessenger.of(
                                            _scaffoldKey.currentState!.context)
                                        .showSnackBar(showSnackBar(
                                      AppLocalizations.of('Please add a Title'),
                                    ));
                                  } else if (_descriptionController
                                      .text.isEmpty) {
                                    ScaffoldMessenger.of(
                                            _scaffoldKey.currentState!.context)
                                        .showSnackBar(showSnackBar(
                                      AppLocalizations.of(
                                          'Please add a Description'),
                                    ));
                                  } else if (_controller
                                      .plainTextEditingValue.text.isEmpty) {
                                    ScaffoldMessenger.of(
                                            _scaffoldKey.currentState!.context)
                                        .showSnackBar(showSnackBar(
                                      AppLocalizations.of(
                                          'Please add Blog Content'),
                                    ));
                                  } else if (_keywordsController.text.isEmpty) {
                                    ScaffoldMessenger.of(
                                            _scaffoldKey.currentState!.context)
                                        .showSnackBar(showSnackBar(
                                      AppLocalizations.of(
                                          'Please add at least one keyword'),
                                    ));
                                  }
                                  //  else if (_referenceController
                                  //     .text.isEmpty) {
                                  //   _scaffoldKey.currentState
                                  //       .showSnackBar(showSnackBar(
                                  //     AppLocalizations.of(
                                  //         'Please add a Reference Link'),
                                  //   ));
                                  // }

                                  else {
                                    _publishBlog();
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(
                                    "Publish Blog",
                                  ),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                loadingAnimation(),
                                SizedBox(width: 4.0.w),
                                Text(
                                  AppLocalizations.of(
                                    "Publish Blog",
                                  ),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
