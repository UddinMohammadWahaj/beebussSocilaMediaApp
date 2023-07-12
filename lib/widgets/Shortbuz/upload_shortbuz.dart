import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/shortbuz/shortbuzz_category_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuzz_country_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuzz_language_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/onboarding/reset_password.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/models/update_channel_categories_model.dart';
import 'package:bizbultest/models/update_channel_video_country_model.dart';
import 'package:bizbultest/models/update_channel_video_langiahe_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:bizbultest/widgets/Shortbuz/flexible_video_player.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/widgets/Shortbuz/category_card.dart';
import 'package:bizbultest/widgets/Shortbuz/country_card.dart';
import 'package:bizbultest/widgets/Shortbuz/language_card.dart';
import 'package:bizbultest/widgets/Shortbuz/swiych_cards.dart';
import 'package:bizbultest/widgets/Shortbuz/tag_people.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as p;

import '../../api/ApiRepo.dart' as ApiRepo;

class UploadShortbuz extends StatefulWidget {
  final File? video;
  final Function? refreshFromShortbuz;
  final bool? fromShortbuz;
  final String? tags;
  final String? stickers;
  final Uint8List? unit8list;

  UploadShortbuz(
      {Key? key,
        this.video,
        this.refreshFromShortbuz,
        this.fromShortbuz,
        this.tags,
        this.stickers,
        this.unit8list})
      : super(key: key);

  @override
  _UploadShortbuzState createState() => _UploadShortbuzState();
}

class _UploadShortbuzState extends State<UploadShortbuz> {
  TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedCategory = "";
  String selectedCountry = "";
  String selectedLanguage = "";
  String selectedCountryID = "";
  String selectedLanguageID = "";
  late ShortbuzzCategoryModel categoriesList;
  bool areCategoriesLoaded = false;
  late ShortbuzzCountryModel countriesList;
  bool areCountriesLoaded = false;
  late ShortbuzzLanguageModel languagesList;
  bool areLanguagesLoaded = false;
  bool allowComments = true;
  bool saveToDevice = false;
  UserTags videoTagsList = new UserTags([]);
  UserTags tagList = new UserTags([]);
  List<String> mentionedUsersList = [];
  bool areTagsLoaded = false;
  List<String> videoTagsMemberID = [];
  List<String> videoTags = [];
  int videoHeight = 0;
  int videoWidth = 0;

  //! api updated
  Future<void> getCategories() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/video_category.php?action=video_category_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");
    var response = await http.get(url);
    if (response!.statusCode == 200) {
      ShortbuzzCategoryModel categoriesData =
      ShortbuzzCategoryModel.fromJson(jsonDecode(response!.body));
      if (mounted) {
        setState(() {
          categoriesList = categoriesData;
          areCategoriesLoaded = true;
        });
      }
    }
    if (response!.body == null || response!.statusCode != 200) {
      if (mounted) {
        setState(() {
          areCategoriesLoaded = false;
        });
      }
    }
  }

  //! api updated
  Future<void> getCountryList() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/localized_countries.php?action=video_country_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

    var response = await http.get(url);

    if (response!.statusCode == 200) {
      ShortbuzzCountryModel countryData =
      ShortbuzzCountryModel.fromJson(jsonDecode(response!.body));
      if (mounted) {
        setState(() {
          countriesList = countryData;
          areCountriesLoaded = true;
        });
      }
    }
    if (response!.body == null || response!.statusCode != 200) {
      if (mounted) {
        setState(() {
          areCountriesLoaded = false;
        });
      }
    }
  }

  //! api updated
  Future<void> getLanguageList() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/video_language.php?action=video_language_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

    var response = await http.get(url);

    if (response!.statusCode == 200) {
      ShortbuzzLanguageModel languageData =
      ShortbuzzLanguageModel.fromJson(jsonDecode(response!.body));
      if (mounted) {
        setState(() {
          languagesList = languageData;
          areLanguagesLoaded = true;
        });
      }
    }
    if (response!.body == null || response!.statusCode != 200) {
      if (mounted) {
        setState(() {
          areLanguagesLoaded = false;
        });
      }
    }
  }

  Future<void> getUserTags(String searchedTag) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=search_mention_users_data&user_id=${CurrentUser().currentUser.memberID}&searchword=$searchedTag");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/user/userSearchFollowers", {
      "user_id": CurrentUser().currentUser.memberID,
      "keyword": searchedTag
    });

    // print(response!.body);
    if (response!.success == 1 &&
        response!.data['data'] != "" &&
        response!.data['data'] != null &&
        response!.data['data'] != "null") {
      UserTags tagsData = UserTags.fromJson(response!.data['data']);

      if (mounted) {
        setState(() {
          tagList = tagsData;
          areTagsLoaded = true;
        });
      }
    }

    if (response!.data == null ||
        response!.data['data'] == null ||
        response!.data['data'] == []) {
      setState(() {
        areTagsLoaded = false;
      });
    }
  }

  Future<void> test(String allHashtags, int commentStatus) async {
    var url = Uri.parse(
        "https://www.upload.bebuzee.com/short_video.php?action=upload_short_video&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&category=$selectedCategory&title_data=${_descriptionController.text.replaceAll("#", "~~~")}&video_country=$selectedCountryID&language=$selectedLanguageID&video_height=$videoHeight&video_width=$videoWidth&video_tagged_people_string=${videoTagsMemberID.join("~~~")}&video_tagged_people=${videoTags.join(",")}&comment_off=$commentStatus&all_hastags=$allHashtags&all_mentioned=${mentionedUsersList.join(",")}");

    var response = await http.get(url);

    if (response!.statusCode == 200) {
      print(response!.body);
    }
  }

  //! api updated
  Future<void> uploadShortVideo(String allHashtags, int commentStatus) async {
    print(videoHeight.toString() + " height");
    print(videoWidth.toString() + " width");
    String url =
        "https://www.bebuzee.com/api/upload_short_video.php?action=upload_short_video&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&category=$selectedCategory&title_data=${_descriptionController.text.replaceAll("#", "~~~").replaceAll("&", "^^^")}&video_country=$selectedCountryID&language=$selectedLanguageID&video_height=$videoHeight&video_width=$videoWidth&video_tagged_people_string=${videoTags.join("~~~")}&video_tagged_people=${videoTagsMemberID.join(",")}&comment_off=$commentStatus&all_hastags=$allHashtags&tagged_member=${widget.tags}&stickers=${widget.stickers}&all_mentioned=${mentionedUsersList.join(',')}";
    if (saveToDevice) {
      await widget.video!.copy(
          "/storage/emulated/0/Bebuzee/Bebuzee Videos/${p.basename(widget.video!.path!)}");
    }
    var feedController = Get.put(FeedController());
    feedController.uploadShortVideo(widget.video!, url, widget.fromShortbuz!);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void validation() {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context!).showSnackBar(
          customSnackBar(AppLocalizations.of("Please add a description"),
              Colors.white, 15, Colors.black87, 2));
    } else if (selectedCategory == "") {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context!).showSnackBar(
          customSnackBar(AppLocalizations.of("Please select a video category"),
              Colors.white, 15, Colors.black87, 2));
    } else if (selectedCountry == "") {
      ScaffoldMessenger.of(_scaffoldKey.currentState!.context!).showSnackBar(
          customSnackBar(AppLocalizations.of("Please select a country"),
              Colors.white, 15, Colors.black87, 2));
    } else {
      List<String> hashtags = [];
      _descriptionController.text.split(" ").forEach((element) {
        if (element.startsWith("#")) {
          hashtags.add(element);
          print(hashtags.join(',').replaceAll("#", ""));
        }
      });
      // print(widget.video.path);
      // print(videoTags.join("~~~"));
      // print(videoTagsMemberID.join(","));
      // print(mentionedUsersList.join(","));
      // print(videoHeight);
      // print(videoWidth);
      // print(selectedCountryID);
      // print(selectedLanguageID);
      // print(selectedCategory);
      // print(_descriptionController.text);
      //test(hashtags.join(',').replaceAll("#", "~~~"), allowComments ? 1 : 0);
      uploadShortVideo(
          hashtags.join(',').replaceAll("#", "~~~"), allowComments ? 1 : 0);
    }
  }

  Widget _switchToggle(bool value, ValueChanged<bool?> onChanged) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: primaryBlueColor.withOpacity(0.4),
      activeColor: primaryBlueColor,
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap, Color color) {
    return IconButton(
        splashRadius: 20,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        constraints: BoxConstraints(),
        icon: Icon(
          icon,
          color: color,
          size: 25,
        ),
        onPressed: onTap);
  }

  Widget _simpleTile(String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      dense: true,
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      subtitle: subtitle == ""
          ? null
          : Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.black54),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down_sharp,
        color: Colors.black,
      ),
    );
  }

  Widget _leadingTile(
      String title, IconData icon, bool value, ValueChanged<bool?> onChanged) {
    return ListTile(
      leading: Icon(icon),
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      subtitle: null,
      trailing: _switchToggle(value, onChanged),
    );
  }

  Widget _categoryList() {
    return ListView.builder(
        itemCount: categoriesList.category!.length,
        itemBuilder: (context, index) {
          var category = categoriesList.category![index];
          return ShortbuzCategoryCard(
            category: category,
            selectedCategory: selectedCategory,
            onTap: () {
              Navigator.pop(context);
              setState(() {
                selectedCategory = category.cateName!;
              });
            },
          );
        });
  }

  Widget _countryList() {
    return ListView.builder(
        itemCount: countriesList.country!.length,
        itemBuilder: (context, index) {
          var country = countriesList.country![index];
          return ShortbuzCountryCard(
            country: country,
            selectedCountry: selectedCountry,
            onTap: () {
              Navigator.pop(context);
              setState(() {
                selectedCountry = country.countryName!;
                selectedCountryID = country.id!;
              });
            },
          );
        });
  }

  Widget _languageList() {
    return ListView.builder(
        itemCount: languagesList.language!.length,
        itemBuilder: (context, index) {
          var language = languagesList.language![index];

          return ShortbuzLanguageCard(
            language: language,
            selectedLanguage: selectedLanguage,
            onTap: () {
              Navigator.pop(context);
              setState(() {
                selectedLanguage = language.languageName!;
                selectedLanguageID = language.id!;
              });
            },
          );
        });
  }

  late VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.file(widget.video!);
    controller.initialize().then((_) {
      setState(() {
        videoHeight = controller.value.size.height.toInt();
        videoWidth = controller.value.size.width.toInt();
      });
    });
    getCategories();
    getCountryList();
    getLanguageList();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 1,
          leading: _iconButton(Icons.keyboard_backspace, () {
            Navigator.pop(context);
          }, Colors.black),
          title: Text(
            AppLocalizations.of(
              "Upload shortbuz",
            ),
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          actions: [
            _iconButton(Icons.check, () {
              validation();
            }, Colors.green)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 1.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70.0.w,
                        child: TextFormField(
                          onChanged: (val) {
                            print(val);
                            if (val == "") {
                              setState(() {
                                mentionedUsersList.clear();
                              });
                              print(mentionedUsersList);
                            }
                            print(val);
                            String str = "";
                            List<String> words = val.split(" ");
                            if (words[words.length - 1].startsWith("@")) {
                              getUserTags(
                                  words[words.length - 1].replaceAll("@", ""));
                            } else {
                              setState(() {
                                tagList.userTags = [];
                              });
                            }
                          },
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: AppLocalizations.of(
                              "Description",
                            ),
                            hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      ),
                      Container(
                          color: Colors.white,
                          height: 15.0.h,
                          width: 20.0.w,
                          child: Image.memory(
                            widget.unit8list!,
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                ),
              ),
              tagList != null &&
                  tagList.userTags.length > 0 &&
                  _descriptionController.text.isNotEmpty
                  ? Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border(
                        top: BorderSide(width: 0.3, color: Colors.grey))),
                height: 80.0.h - 50,
                child: SingleChildScrollView(
                  child: Column(
                      children: tagList.userTags.map((s) {
                        return SearchedUserCard(
                          onTap: () {
                            mentionedUsersList.add(s.memberId!);
                            print(mentionedUsersList);
                            String? str;
                            _descriptionController.text
                                .split(" ")
                                .forEach((element) {
                              if (element.startsWith("@")) {
                                str = element;
                              }
                            });
                            String data = _descriptionController.text;
                            data = _descriptionController.text
                                .substring(0, data.length - str!.length + 1);
                            data += s.shortcode!;
                            data += " ";
                            setState(() {
                              _descriptionController.text = data;
                              tagList.userTags = [];
                            });
                            _descriptionController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset:
                                    _descriptionController.text.length));
                          },
                          s: s,
                        );
                      }).toList()),
                ),
              )
                  : Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TagPeopleShortbuz(
                                unit8list: widget.unit8list!,
                                videoTags: videoTags,
                                videoTagsMemberID: videoTagsMemberID,
                                saveList: (usesTagsList,
                                    videoTagsMemberIDList,
                                    videoTagList) {
                                  setState(() {
                                    videoTagsList = usesTagsList;
                                    videoTagsMemberID =
                                        videoTagsMemberIDList;
                                    videoTags = videoTagList;
                                  });
                                },
                                video: widget.video!,
                                userTags: videoTagsList,
                              )));
                    },
                    child: Container(
                        width: 100.0.w,
                        decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.3, color: Colors.grey),
                                top: BorderSide(
                                    width: 0.3, color: Colors.grey))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          child: Text(
                            AppLocalizations.of(
                              "Tag people",
                            ),
                            style: TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        )),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _simpleTile(
                          AppLocalizations.of(
                            "Select video category",
                          ),
                          selectedCategory, () {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20.0),
                                    topRight:
                                    const Radius.circular(20.0))),
                            context: context,
                            builder: (BuildContext bc) {
                              return Container(
                                child: _categoryList(),
                              );
                            });
                      }),
                      _simpleTile(
                          AppLocalizations.of(
                            "Select a country",
                          ),
                          selectedCountry, () {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20.0),
                                    topRight:
                                    const Radius.circular(20.0))),
                            //isScrollControlled:true,
                            context: context,
                            builder: (BuildContext bc) {
                              return Container(child: _countryList());
                            });
                      }),
                      _simpleTile(
                          AppLocalizations.of(
                            "Select a language",
                          ),
                          selectedLanguage, () {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20.0),
                                    topRight:
                                    const Radius.circular(20.0))),
                            //isScrollControlled:true,
                            context: context,
                            builder: (BuildContext bc) {
                              return Container(child: _languageList());
                            });
                      }),
                    ],
                  ),
                  _leadingTile(
                      AppLocalizations.of(
                        "Allow comments",
                      ),
                      Icons.comment_outlined,
                      allowComments, (val) {
                    setState(() {
                      allowComments = val!;
                    });
                  }),
                  _leadingTile(
                      AppLocalizations.of(
                        "Save to device",
                      ),
                      Icons.save_outlined,
                      saveToDevice, (val) {
                    setState(() {
                      saveToDevice = val!;
                    });
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}