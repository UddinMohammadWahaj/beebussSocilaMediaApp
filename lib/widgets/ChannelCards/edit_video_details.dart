import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class EditChannelVideoDetails extends StatefulWidget {
  final VideoModel video;
  final String title;
  final String description;
  final List categoryList;
  final List countryList;
  final List languageList;
  String selectedCountry;
  String selectedLanguage;
  String selectedCategory;
  String tags;
  final Function refreshChannel;

  EditChannelVideoDetails(
      {Key? key,
      required this.title,
      required this.description,
      required this.categoryList,
      required this.countryList,
      required this.languageList,
      required this.selectedCountry,
      required this.selectedLanguage,
      required this.tags,
      required this.selectedCategory,
      required this.video,
      required this.refreshChannel})
      : super(key: key);

  @override
  _EditChannelVideoDetailsState createState() =>
      _EditChannelVideoDetailsState();
}

class _EditChannelVideoDetailsState extends State<EditChannelVideoDetails> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _tagsController = TextEditingController();
  List tagsList = [];

  @override
  void initState() {
    print(widget.video.postId);
    print(_titleController.text);
    print(_descriptionController.text);
    print(_tagsController.text);
    print(widget.selectedCountry);
    print(widget.selectedLanguage);
    print(widget.selectedCategory);
    print(widget.video.image);

    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    tagsList = widget.tags.split(',').toList();
    super.initState();
  }

  Future<void> updateVideoDetails() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/new_files/all_apis/channel_apis_calls.php?action=video_edit_page_data_update&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=${widget.video.postId}&title=${_titleController.text}&description=${_descriptionController.text}&country_post=${widget.selectedCountry}&tags=${tagsList.join(",")}&image=${widget.video.image}&category=${widget.selectedCategory}&language=${widget.selectedLanguage}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
    }

    print(widget.video.postId);
    print(_titleController.text);
    print(_descriptionController.text);
    print(_tagsController.text);
    print(widget.selectedCountry);
    print(widget.selectedLanguage);
    print(widget.selectedCategory);
    print(widget.video.image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: InkWell(
          splashColor: Colors.grey.withOpacity(0.3),
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_backspace_outlined,
                  size: 3.5.h,
                ),
                SizedBox(
                  width: 3.0.w,
                ),
                Text(
                  AppLocalizations.of(
                    "Edit Details",
                  ),
                  style: whiteBold.copyWith(fontSize: 16.0.sp),
                ),
              ],
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[900],
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.0.w),
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.5.h),
                child: Text(
                  AppLocalizations.of(
                    "Title",
                  ),
                  style: whiteNormal.copyWith(fontSize: 12.0.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: Container(
                  height: 5.0.h,
                  child: TextFormField(
                    onChanged: (val) {},
                    maxLines: 1,
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: AppLocalizations.of(
                        "Title",
                      ),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontSize: 12.0.sp),
                      contentPadding: EdgeInsets.only(left: 2.0.w),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.5.h),
                child: Text(
                  AppLocalizations.of(
                    "Select video category",
                  ),
                  style: whiteNormal.copyWith(fontSize: 12.0.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: DropdownButton<String?>(
                  dropdownColor: Colors.grey[900],
                  isExpanded: true,
                  items: widget.categoryList.map((e) {
                    return DropdownMenuItem(
                      child: Text(
                        e.dataCategory,
                        style: whiteNormal.copyWith(fontSize: 12.0.sp),
                      ),
                      value: e.dataCategory.toString(),
                    );
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      widget.selectedCategory = val!;
                    });
                    print(widget.selectedCategory);
                  },
                  value: widget.selectedCategory,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.5.h),
                child: Text(
                  AppLocalizations.of(
                    "Select country",
                  ),
                  style: whiteNormal.copyWith(fontSize: 12.0.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: DropdownButton(
                  dropdownColor: Colors.grey[900],
                  isExpanded: true,
                  items: widget.countryList.map((e) {
                    return DropdownMenuItem<String>(
                      child: Text(
                        e.countryName,
                        style: whiteNormal.copyWith(fontSize: 12.0.sp),
                      ),
                      value: e.countryId,
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      widget.selectedCountry = val.toString();
                    });
                    print(widget.selectedCountry);
                  },
                  value: widget.selectedCountry,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.5.h),
                child: Text(
                  AppLocalizations.of(
                    "Select language",
                  ),
                  style: whiteNormal.copyWith(fontSize: 12.0.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: DropdownButton<dynamic>(
                  dropdownColor: Colors.grey[900],
                  isExpanded: true,
                  items: widget.languageList.map((e) {
                    return DropdownMenuItem(
                      child: Text(
                        e.countryName,
                        style: whiteNormal.copyWith(fontSize: 12.0.sp),
                      ),
                      value: e.countryId,
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      widget.selectedLanguage = val.toString();
                    });
                    print(widget.selectedLanguage);
                  },
                  value: widget.selectedLanguage,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.5.h),
                child: Text(
                  AppLocalizations.of(
                    "Description",
                  ),
                  style: whiteNormal.copyWith(fontSize: 12.0.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.0.h),
                child: Container(
                  child: TextFormField(
                    onChanged: (val) {},
                    maxLines: 5,
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.white, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: "",
                      hintStyle:
                          TextStyle(color: Colors.grey, fontSize: 12.0.sp),
                      contentPadding: EdgeInsets.only(left: 2.0.w, top: 2.0.h),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.5.h),
                child: Text(
                  AppLocalizations.of(
                    "Tags",
                  ),
                  style: whiteNormal.copyWith(fontSize: 12.0.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Container(
                  height: 3.7.h,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tagsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 1.5.w),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                tagsList.removeAt(index);
                              });
                            },
                            splashColor: Colors.grey.withOpacity(0.3),
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.0.w, vertical: 1.0.w),
                                child: Row(
                                  children: [
                                    Text(
                                      tagsList[index],
                                      style: TextStyle(fontSize: 12.0.sp),
                                    ),
                                    SizedBox(
                                      width: 0.5.w,
                                    ),
                                    Icon(
                                      Icons.cancel,
                                      size: 2.5.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Container(
                  child: TextFormField(
                    onChanged: (val) {},
                    maxLines: 1,
                    controller: _tagsController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintText: AppLocalizations.of(
                          "Enter tags",
                        ),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0.sp),
                        //contentPadding: EdgeInsets.only(right: 2.0.w,),
                        suffixIcon: FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              tagsList.add(
                                  _tagsController.text.replaceAll(" ", ""));
                            });
                            _tagsController.clear();
                            print(tagsList.join(","));
                          },
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          child: Text(
                            AppLocalizations.of("Add"),
                            style: whiteNormal.copyWith(fontSize: 10.0.sp),
                          ),
                        )),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(right: 3.0.w, top: 2.0.h, bottom: 2.0.h),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        overlayColor: MaterialStateProperty.all(Colors.white)),
                    // color: Colors.white,
                    // focusColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.refreshChannel();
                      updateVideoDetails();
                    },
                    child: Text(
                      AppLocalizations.of(
                        "Update",
                      ),
                      style: TextStyle(fontSize: 10.0.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
