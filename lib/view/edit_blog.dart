import 'dart:async';
import 'dart:convert';
// import 'dart:html';

import 'dart:io' as i;
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/common_appbar.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';

import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';

import 'package:sizer/sizer.dart';

// import 'package:zefyr/zefyr.dart';

import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:zefyrka/zefyrka.dart';

import '../services/FeedAllApi/feed_controller.dart';
import 'create_blog.dart';

class EditBlog extends StatefulWidget {
  final String? memberID;
  final String? country;
  final String? logo;
  final String? blogID;
  final String? blogTitle;
  final String? blogCategory;
  final String? blogImage;
  final String? blogContent;

  EditBlog(
      {Key? key,
      this.memberID,
      this.country,
      this.logo,
      this.blogID,
      this.blogTitle,
      this.blogCategory,
      this.blogImage,
      this.blogContent})
      : super(key: key);

  @override
  _EditBlogState createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  List countryList = [];
  List countryLanguageList = [];
  List categoryList = [];
  List recipeCategoryList = [];
  List recipeCountryList = [];
  late String selectedCountryValue;
  late String selectedCategory;
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
  bool isBlogLoaded = false;
  bool isVideoUploaded = false;
  TextEditingController contentcontroller = TextEditingController();
  String blogTitle = "";
  String blogDescription = "";
  String blogKeywords = "";
  bool imagePicked = false;
  bool isVideoPicked = false;
  RefreshProfile refreshProfile = new RefreshProfile();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _keywordsController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  TextEditingController _videoUrlController = TextEditingController();

  // ZefyrController blogContentController;
  late FocusNode blogNode;

  late i.File _image;
  late i.File _video;
  late i.File _thumbnail;

  _imgFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _image = i.File(result!.files!.single!.path!);
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
        isVideoPicked = true;
      });
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
    var url =
        "https://www.bebuzee.com/api/blog/blogCategory?action=create_user_blog_category_list&country=${widget.country}&user_id=${widget.memberID}";
    print("edit blog getcategorylisturl=$url");
    var res = await ApiProvider().fireApi(url);
    // var res = await http.get(url);

    // var resBody = json.decode(res.body);
    var resBody = res.data['category'];
    print("edit category response=$resBody");
    if (selectedCategory == "Recipe") {
      showRecipeMenu = true;

      getRecipeCategoryList();
      getRecipeCountryList();
    }
    setState(() {
      categoryList = resBody;
    });

    print(resBody);
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
        'https://www.bebuzee.com/api/update_blog.php?user_blog_id=${widget.blogID}&user_id=${widget.memberID}&country=$country&blog_title=${_titleController.text}&category=${selectedCategory.toString()}&content=${contentcontroller.text}&reference_link=${_referenceController.text}&blog_desc=${_descriptionController.text}&blog_keywords=${_keywordsController.text}&image=asasa&country_lang=${selectedCountryLanguage}&country_lang=$selectedCountryLanguage&video_url_data=${_videoUrlController.text}&video_file=aadadaa&thumbnail=aaaad&language_name=${selectedCountryLanguage.toString()}&rec_cat=${selectedRecipeCategory.toString()}&rec_country=${selectedRecipeCountry.toString()}');
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

    if (_image != null) {
      formData.files.addAll(
          [MapEntry("image", await MultipartFile.fromFile(_image.path))]);
      print(
          "image update =${_image.path} formdatalength=${formData.files.length}");
    }

    // try {
    //   if (_video != null) {
    //     formData.files.addAll([
    //       MapEntry("video_file", await MultipartFile.fromFile(_video.path))
    //     ]);
    //   }
    // } catch (e) {
    //   print("video error $e");
    // }
    // if (_thumbnail != null) {
    //   formData.files.addAll([
    //     MapEntry("video_file", await MultipartFile.fromFile(_thumbnail.path))
    //   ]);
    // }

    String? token = await ApiProvider().refreshToken(widget.memberID!);
    try {
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
        print("response =$res");
        g.Get.back();
        ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
            .showSnackBar(showSnackBar(AppLocalizations.of('Blog Updated')));
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
    } catch (e) {
      g.Get.back();
      print("error update $e");
    }
  }

  Future<String> getRecipeCategoryList() async {
    var url =
        "https://www.bebuzee.com/api/blog/receipeData?action=create_user_blog_receipe_category_list&country=${widget.country}&user_id=${widget.memberID}";
    print("edit blog getRecipeCategory list=$url");
    await getRecipeCountryList();
    var res = await Dio().get(url);

    var resBody = res.data['data'];

    setState(() {
      recipeCategoryList = resBody;

      // print("rec category=${recipeCategoryList[0]['category_sub']}");
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
    var url =
        "https://www.bebuzee.com/api/localized_countries.php?action=create_user_blog_language_country_list&country=${widget.country}&user_id=${widget.memberID}";
    print("edit blog getcountrylist=${url}");
    var res = await Dio().get(url);

    var resBody = (res.data['country']);

    setState(() {
      countryList = resBody;
    });

    print(resBody);

    return "Success";
  }

  Future<String> getCountryLanguageList(int value) async {
    var url =
        "https://www.bebuzee.com/api/blog_country_language.php?country=${value}&user_id=${widget.memberID}";
    print("edit blog blog=${url}");
    var res = await ApiProvider().fireApi(url);

    var resBody = res.data['data'];

    setState(() {
      countryLanguageList = resBody;
    });

    print(resBody);
    print("languages");

    return "Success";
  }

  Future<void> getBlogData() async {
    var url =
        "https://www.bebuzee.com/api/edit_blog.php?action=edit_user_blog_data&user_id=${widget.memberID}&blog_id=${widget.blogID}";
    print("edit getblogdata url=$url");
    var response = await ApiProvider().fireApi(url);

    print(response.data);
    if (response.statusCode == 200) {
      setState(() {
        if (selectedCategory == "Recipe") {
          showRecipeMenu = true;

          setState(() {
            print(
                "i am here recipe ${response.data['blog_receipe_country_name']}");
            selectedRecipeCountry = response.data['blog_receipe_country'];
            selectedRecipeCategory = response.data['blog_receipe_category'];
            print("selected rec category=${selectedRecipeCategory}");
          });
          getRecipeCategoryList();
          try {
            getRecipeCountryList();
          } catch (e) {
            print("recipe country error $e");
          }
        }

        _descriptionController.text = response.data['blog_description'];

        selectedCountryValue = response.data['blog_country_id'];
        _referenceController.text = response.data['blog_reference'];
        _keywordsController.text = response.data['blog_keyword'];
      });

      // if (selectedCountryValue == "6" ||
      //     selectedCountryValue == "8" ||
      //     selectedCountryValue == "7") {
      print("i am here blog edit");
      setState(() {
        getCountryLanguageList(int.parse(selectedCountryValue));
        showCountryLanguage = true;
        getCountryLanguageList(int.parse(selectedCountryValue));
        selectedCountryLanguage = response.data['blog_country_lang_name'];
        // Delta delta = Delta().insert("Zefyr Quick Start\n");
        // contentcontroller = ZefyrController(NotusDocument.fromDelta(delta));
      });
      // }
      contentcontroller.value = TextEditingValue(
          text: parse(widget.blogContent).documentElement!.text);
      print("blog data fetched");
      print("blog content is " + widget.blogContent!);
      print(widget.memberID);
      print(widget.blogID);
      print(widget.blogTitle);
      print(widget.blogCategory);

      setState(() {
        isBlogLoaded = true;
      });

      if (response.data == null || response.statusCode != 200) {
        setState(() {
          isBlogLoaded = false;
        });
      }
    }
  }

  // NotusDocument _loadDocument() {
  //   final Delta delta = Delta()..insert(parse(widget.blogContent).documentElement.text + "\n");
  //   return NotusDocument.fromDelta(delta);
  // }

  // void uploadImage() async {
  //   final uri = Uri.parse(
  //       "https://www.bebuzee.com/new_files/all_apis/blog_data_api_call.php?action=blog_edit_submit_data&blog_id=${widget.blogID}&user_id=${widget.memberID}&blog_title=${_titleController.text}&category=${selectedCategory.toString()}&rec_country=${selectedRecipeCountry.toString()}&rec_cat=${selectedRecipeCategory.toString()}&content=${blogContentController.plainTextEditingValue.text}&reference_link=${_referenceController.text}&blog_desc=${_descriptionController.text}&blog_keywords=${_keywordsController.text}&image=fwwfwf&video_file=video&country_lang=${int.parse(selectedCountryValue)}&language_name=${selectedCountryLanguage.toString()}&video_url_dt=${_videoUrlController.text}");
  //   final req = new http.MultipartRequest("POST", uri);
  //   if (_image != null && imagePicked == true) {
  //     print(imagePicked.toString() + "is image picked");
  //     final stream = http.ByteStream(Stream.castFrom(_image.openRead()));
  //     final length = await _image.length();
  //     final multipartFile = http.MultipartFile(
  //       'image',
  //       stream,
  //       length,
  //       filename: path.basename(_image.path),
  //     );
  //     req.files.add(multipartFile);
  //   }
  //   if (_video != null) {
  //     setState(() {
  //       isVideoPicked = true;
  //     });
  //     final stream2 = http.ByteStream(Stream.castFrom(_video.openRead()));
  //     final length2 = await _video.length();
  //     final multipartFile2 = http.MultipartFile('video_file', stream2, length2, filename: path.basename(_video.path));
  //     req.files.add(multipartFile2);
  //   }

  //   if (_thumbnail != null) {
  //     final stream3 = http.ByteStream(Stream.castFrom(_thumbnail.openRead()));
  //     final length3 = await _thumbnail.length();
  //     final multipartFile3 = http.MultipartFile('thumbnail', stream3, length3, filename: path.basename(_thumbnail.path));
  //     req.files.add(multipartFile3);
  //   }
  //   _scaffoldKey.currentState.showSnackBar(showSnackBar('Blog updated successfully'));
  //   final res = await req.send();
  //   await for (var value in res.stream.transform(utf8.decoder)) {
  //     print(value);
  //     print("Resss");
  //     refreshProfile.updateRefresh(true);
  //     Navigator.pop(context);
  //     Navigator.pop(context);
  //   }
  //   if (isVideoPicked == true) {
  //     setState(() {
  //       isVideoUploaded = true;
  //     });
  //     _scaffoldKey.currentState.showSnackBar(showSnackBar('Blog updated successfully'));
  //   }
  //   if (res.statusCode == 200 && isVideoPicked == true) {
  //     print(res.toString() + " responsee");
  //     setState(() {
  //       isVideoUploaded = false;
  //     });
  //   }
  //   print("is video picked " + isVideoPicked.toString());
  //   print(res.statusCode);
  //   print(res);
  // }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print("blog image is " + widget.blogImage!);
    if (selectedCategory == "Recipe") {
      showRecipeMenu = true;
    }
    selectedCategory = widget.blogCategory!;

    _titleController.text = widget.blogTitle!;

    // var document = _loadDocument();
    // blogContentController = ZefyrController(document);
    blogNode = FocusNode();
    getCountryList();
    getBlogData();
    getCategoryList();
    getRecipeCategoryList();
    getCountryList();
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
                          "Edit Blog",
                        ),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
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
                            hint: Text(AppLocalizations.of(
                                  "Select Category",
                                ) +
                                " "),
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

                              setState(() {
                                selectedCategory = val;
                              });

                              print(selectedCategory);
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
                                child: DropdownButton<dynamic>(
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
                                  onChanged: (val) {
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
                                child: DropdownButton<dynamic>(
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
                                  onChanged: (val) {
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
                          child: DropdownButton<dynamic>(
                            isExpanded: true,
                            hint: Text(
                              AppLocalizations.of(
                                    "Select Country",
                                  ) +
                                  " ",
                            ),
                            items: countryList.map((e) {
                              return DropdownMenuItem(
                                child: Text(e["country_name"]),
                                value: e['id'],
                              );
                            }).toList(),
                            onChanged: (val) {
                              print(
                                  "selected countryvalue=$selectedCountryValue");
                              setState(() {
                                selectedCountryValue = val;
                              });
                              print(
                                  "selected countryvalue=$selectedCountryValue");
                              if (selectedCountryValue == "6" ||
                                  selectedCountryValue == "8" ||
                                  selectedCountryValue == "7") {
                                getCountryLanguageList(
                                    int.parse(selectedCountryValue));

                                setState(() {
                                  showCountryLanguage = true;
                                });
                              } else {
                                showCountryLanguage = false;
                              }

                              print(selectedCountryValue);
                              print(int.parse(selectedCountryValue));
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
                                child: DropdownButton<dynamic>(
                                  isExpanded: true,
                                  hint: Text(
                                    AppLocalizations.of(
                                        "Select Country Language"),
                                  ),
                                  items: countryLanguageList.map((e) {
                                    return DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedCountryLanguage = val;
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
                            onTap: () {
                              setState(() {});
                            },
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
                            maxLines: null,
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
                                backgroundColor:
                                    MaterialStateProperty.all(primaryBlueColor),
                              ),
                              onPressed: () {
                                _imgFromGallery();
                              },
                              child: Text(
                                imageName != null && imageName != ""
                                    ? imageName
                                    : "Change Image",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
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
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.2.h),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      width: 90.0.w,
                                      child: Image.network(widget.blogImage!))),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.2.h),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      width: 90.0.w,
                                      child: Image.file(i.File(_image.path)))),
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
                                    AppLocalizations.of('Upload a Video'),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16, color: primaryBlueColor),
                                ),
                              ),
                              Text(
                                AppLocalizations.of('or') + " ",
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
                                                  primaryBlueColor),
                                        ),
                                        onPressed: () {
                                          _videoFromGallery();
                                        },
                                        child: Text(
                                          videoName != null && videoName != ""
                                              ? videoName
                                              : "Select Video",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(
                                        "Upload up to 100MB mp4 video only",
                                      ),
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
                                  child:
                                      // Column(
                                      //   children: [
                                      // ZefyrToolbar.basic(
                                      //     controller: contentcontroller),
                                      Expanded(
                                          child: TextFormField(
                                    controller: contentcontroller,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  )

                                          //  ZefyrEditor(
                                          //   padding: EdgeInsets.symmetric(
                                          //       horizontal: 20),
                                          //   controller: contentcontroller,
                                          // ),
                                          // ),
                                          // ],
                                          )),
                            )
                            // Padding(
                            //   padding: EdgeInsets.symmetric(vertical: 2.0.h),
                            //   child: Container(
                            //     height: 40.0.h,
                            //     decoration: new BoxDecoration(
                            //       shape: BoxShape.rectangle,
                            //       border: new Border.all(
                            //         color: Colors.grey,
                            //         width: 0.5,
                            //       ),
                            //     ),
                            //     child: Align(
                            //       alignment: Alignment.topLeft,
                            //       child: ZefyrScaffold(
                            //         child: ZefyrEditor(
                            //           controller: blogContentController,
                            //           focusNode: blogNode,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // )
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
                      width: 80.0.w,
                      child: Container(
                        width: 45.0.w,
                        child: Row(
                          children: [
                            isVideoUploaded == false
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryBlueColor),
                                    ),
                                    onPressed: () {
                                      if (isVideoPicked == true) {
                                        setState(() {
                                          isVideoUploaded = true;
                                        });
                                      }
                                      _publishBlog();
                                      // uploadImage();
                                    },
                                    child: Text(
                                      AppLocalizations.of(
                                        "Update Blog",
                                      ),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      loadingAnimation(),
                                      SizedBox(width: 4.0.w),
                                      Text(
                                        AppLocalizations.of(
                                          "Publishing Blog",
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 20),
                                      ),
                                    ],
                                  )
                          ],
                        ),
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
