import 'dart:convert';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/shortbuz/shortbuzz_category_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuzz_country_model.dart';
import 'package:bizbultest/models/shortbuz/shortbuzz_language_model.dart';
import 'package:bizbultest/models/update_channel_categories_model.dart';
import 'package:bizbultest/models/update_channel_video_country_model.dart';
import 'package:bizbultest/models/update_channel_video_langiahe_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'change_thumbnail.dart';
import 'edit_video_details.dart';

class EditChannelVideo extends StatefulWidget {
  final VideoModel video;
  final Function refreshChannel;
  final Function delete;

  EditChannelVideo(
      {Key? key,
      required this.video,
      required this.refreshChannel,
      required this.delete})
      : super(key: key);

  @override
  _EditChannelVideoState createState() => _EditChannelVideoState();
}

class _EditChannelVideoState extends State<EditChannelVideo> {
  var selectedCategory;
  var selectedCountry;
  var selectedLanguage;
  var selectedLanguageID;
  var selectedCountryID;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  late ShortbuzzCategoryModel categoriesList;
  bool areCategoriesLoaded = false;
  late ShortbuzzCountryModel countriesList;
  bool areCountriesLoaded = false;
  late ShortbuzzLanguageModel languagesList;
  bool areLanguagesLoaded = false;
  var thumbnail;

  //! api updated
  Future<void> getCategories() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/video_category.php?action=video_category_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      ShortbuzzCategoryModel categoriesData =
          ShortbuzzCategoryModel.fromJson(jsonDecode(response.body));
      // await Future.wait(videoData.videos.map((e) => Preload.cacheImage(context, e.image)).toList());
      if (mounted) {
        setState(() {
          categoriesList = categoriesData;
          areCategoriesLoaded = true;
          selectedCategory = widget.video.categoryIt;
        });
      }
    }
    if (response.body == null || response.statusCode != 200) {
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

    if (response.statusCode == 200) {
      ShortbuzzCountryModel countryData =
          ShortbuzzCountryModel.fromJson(jsonDecode(response.body));
      // await Future.wait(videoData.videos.map((e) => Preload.cacheImage(context, e.image)).toList());
      if (mounted) {
        setState(() {
          countriesList = countryData;
          areCountriesLoaded = true;
          selectedCountry = widget.video.countryId;
        });
      }
    }
    if (response.body == null || response.statusCode != 200) {
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

    if (response.statusCode == 200) {
      ShortbuzzLanguageModel languageData =
          ShortbuzzLanguageModel.fromJson(jsonDecode(response.body));
      // await Future.wait(videoData.videos.map((e) => Preload.cacheImage(context, e.image)).toList());
      if (mounted) {
        setState(() {
          languagesList = languageData;
          areLanguagesLoaded = true;
          selectedLanguage = widget.video.languageId;
        });
      }
    }
    if (response.body == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areLanguagesLoaded = false;
        });
      }
    }
  }

  Future<void> postDelete(String postType, String postID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/post_common_data_api_call.php?action=delete_post_data&post_type=$postType&post_id=$postID&user_id=${CurrentUser().currentUser.memberID}");

    var response = await http.get(url);

    if (response.statusCode == 200) {}
  }

  @override
  void initState() {
    getCategories();
    getLanguageList();
    getCountryList();
    setState(() {
      _titleController.text = widget.video.postContent!;
      _descriptionController.text = widget.video.content!;
      thumbnail = widget.video.image;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeThumbnail(
                            refreshChannel: widget.refreshChannel,
                            postID: widget.video.postId,
                            thumbnail: thumbnail,
                          )));
            },
            title: Text(
              AppLocalizations.of(
                "Change thumbnail",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            leading: Icon(
              Icons.image,
              size: 3.5.h,
              color: Colors.white,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditChannelVideoDetails(
                            refreshChannel: widget.refreshChannel,
                            video: widget.video,
                            title: widget.video.postContent!,
                            description: widget.video.content!,
                            categoryList: categoriesList.category!,
                            countryList: countriesList.country!,
                            languageList: languagesList.language!,
                            selectedCategory: selectedCategory,
                            selectedLanguage: selectedLanguage,
                            selectedCountry: selectedCountry,
                            tags: widget.video.videoTags!,
                          )));
            },
            title: Text(
              AppLocalizations.of(
                "Edit",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            leading: Icon(
              Icons.edit,
              size: 3.5.h,
              color: Colors.white,
            ),
          ),
          ListTile(
            onTap: () {
              postDelete(
                  AppLocalizations.of(
                    'Video',
                  ),
                  widget.video.postId!);
              widget.delete();
              Navigator.pop(context);
            },
            title: Text(
              AppLocalizations.of(
                "Delete",
              ),
              style: whiteNormal.copyWith(fontSize: 12.0.sp),
            ),
            leading: Icon(
              Icons.delete,
              size: 3.5.h,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
