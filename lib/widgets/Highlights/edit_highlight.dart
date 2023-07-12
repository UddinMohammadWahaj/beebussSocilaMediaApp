import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:bizbultest/models/add_multiple_stories_model.dart';
import 'package:bizbultest/models/user_highlights_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'add_multiple_stories.dart';
import 'edit_highlight_cover.dart';
import 'multiple_stories_tabbar.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class EditHighlightExpandedPage extends StatefulWidget {
  final UserHighlightsModel? highlights;
  final Function? setNavbar;
  final String? from;

  EditHighlightExpandedPage({
    Key? key,
    this.highlights,
    this.setNavbar,
    this.from,
  }) : super(key: key);

  @override
  _EditHighlightExpandedPageState createState() =>
      _EditHighlightExpandedPageState();
}

class _EditHighlightExpandedPageState extends State<EditHighlightExpandedPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _controller = TextEditingController();
  TabController? _tabController;

  Future<void> editHighlightName(String name) async {
    var url = 'https://www.bebuzee.com/api/editHighlight';
    var params = {
      "user_id": '${CurrentUser().currentUser.memberID}',
      'country': '${CurrentUser().currentUser.country}',
      'highlight_id': '${widget.highlights!.highlightId}',
      'text': '$name'
    };
    var response = await ApiProvider()
        .fireApiWithParamsPost(url, params: params)
        .then((value) => value);
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_heighlight_data.php?action=edit_highlight_text&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&highlight_id=${widget.highlights.highlightId}&text=$name");

    // var response = await http.get(url);

    if (response.statusCode == 200) {
      print('edit hgghlight response=${response.data}');
    }
  }

//TODO :: inSheet 243
  Future<void> removeHighlight() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_heighlight_data.php?action=delete_full_highlight&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&highlight_id=${widget.highlights.highlightId}");

    // var response = await http.get(url);
    var url = 'https://www.bebuzee.com/api/deleteHighlight';
    var response = await ApiProvider().fireApiWithParamsPost(url, params: {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "highlight_id": widget.highlights!.highlightId,
    });
    // var response =
    //     await ApiRepo.postWithToken("api/delete_full_highlight.php", {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "country": CurrentUser().currentUser.country,
    //   "highlight_id": widget.highlights.highlightId,
    // });

    print('delete response=s${response.data}');
  }

  Future<void> updateHighlight() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_heighlight_data.php?action=update_highlight_stories&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_ids_story_ids=${selectedStoriesID.join(",")}&default=$selectedCoverID&highlight_id=${widget.highlights!.highlightId}");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      print(widget.highlights!.highlightId);
    }
  }

  Future<void> customCover() async {
    var request = mp.MultipartRequest();
    request.setUrl(
        "https://www.bebuzee.com/app_devlope_heighlight_data.php?action=update_highlight_default_picture&highlight_id=${widget.highlights!.highlightId}&user_id=${CurrentUser().currentUser.memberID}&file1=");
    request.addFile("file1", cover!.path);
    mp.Response response = request.send();
    response.onError = () {
      print("Error");
    };
    response.onComplete = (response) {
      print(response);
    };
    response.progress.listen((int progress) {
      print("progress from response object " + progress.toString());
    });
  }

  MultipleStories? storiesList;
  bool areStoriesLoaded = false;
  MultipleStories? storiesListHighlights;
  bool areHighlightStoriesLoaded = false;
  List<String> selectedStoriesID = [];
  List<String> selectedStoriesImages = [];
  List<FileElement> allFiles = [];
  List<FileElement> allFilesHighlights = [];
  String defaultCoverID = "";
  List<FileElement> selectedFiles = [];
  String selectedCoverID = "";
  String selectedCoverImage = "";
  File? cover;
  bool isCoverFromGallery = false;

  Future<void> getStoriesFromHighlight() async {
    print(widget.highlights!.highlightId);

    // var url = Uri.parse(
    //     "https://www.bebuzee.com/api/story_data_details_data_highlight.php?action=story_data_details_data_all_with_highlight&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&highlight_id=${widget.highlights.highlightId}");

    var url = 'https://www.bebuzee.com/api/storyDataDetailHighlight';

    var params = {
      "user_id": "${CurrentUser().currentUser.memberID}",
      "country": "${CurrentUser().currentUser.country}",
      "highlight_id": "${widget.highlights!.highlightId}"
    };

    print("get story from highlight url=$url");
    var response =
        await ApiProvider().fireApiWithParamsPost(url, params: params);

    // var response =
    //     await ApiProvider().fireApi(url.toString()).then((value) => value);

    if (response.statusCode == 200) {
      MultipleStories storyData =
          MultipleStories.fromJson(response.data['data']);

      storyData.stories.forEach((element) {
        element.files!.forEach((file) {
          /*List<FileElement> all = [];
          await Future.wait(all.map((e) => Preload.cacheImage(context, e.image)).toList());*/
          if (mounted) {
            setState(() {
              allFilesHighlights.add(file);
              areHighlightStoriesLoaded = true;
            });
          }
          allFilesHighlights.forEach((element) {
            if (mounted) {
              setState(() {
                element.isSelected = true;
              });
            }
          });
        });
      });
    }
    if (response.data == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areHighlightStoriesLoaded = false;
        });
      }
    }
  }

  Future<void> getAllStories() async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/story_data_details_data_all.php?action=story_data_details_data_all&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_ids=");
    print("get all stories called $url");
    var response =
        await ApiProvider().fireApi(url.toString()).then((value) => value);

    if (response.statusCode == 200) {
      MultipleStories storyData =
          MultipleStories.fromJson(response.data['data']);

      storyData.stories.forEach((element) {
        element.files!.forEach((file) {
          /*List<FileElement> all = [];
          await Future.wait(all.map((e) => Preload.cacheImage(context, e.image)).toList());*/
          if (mounted) {
            setState(() {
              allFiles.add(file);
              areStoriesLoaded = true;
            });
          }
        });
      });
    }
    if (response.data == null || response.statusCode != 200) {
      if (mounted) {
        setState(() {
          areStoriesLoaded = false;
        });
      }
    }
  }

  @override
  void initState() {
    getStoriesFromHighlight();
    getAllStories();
    selectedCoverImage =
        widget.highlights!.firstImageOrVideo!.replaceAll(".mp4", ".jpg");
    _controller.text = widget.highlights!.highlightText!;
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(6.0.h),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.setNavbar!(false);
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.keyboard_backspace_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Text(
                      AppLocalizations.of("Edit"),
                      style: blackBold.copyWith(fontSize: 14.0.sp),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      allFilesHighlights.forEach((element) {
                        if (element.isSelected!) {
                          setState(() {
                            selectedFiles.add(element);

                            selectedStoriesID.add(element.id! +
                                "^^" +
                                element.storyId.toString());
                            if (selectedCoverID == "") {
                              selectedCoverID = selectedStoriesID[0];
                            }
                          });
                        }
                      });
                      print(selectedStoriesID.join(",") + " joingggg");
                      print(selectedFiles.length.toString() +
                          " beforeeeeeeee clearrrrrrr");

                      if (selectedFiles.length == 0) {
                        removeHighlight();
                      } else {
                        editHighlightName(_controller.text.isNotEmpty
                            ? _controller.text
                            : "Highlights");
                        updateHighlight();
                        if (isCoverFromGallery) {
                          customCover();
                        }
                      }

                      Fluttertoast.showToast(
                        msg: AppLocalizations.of(
                          "Highlight Updated",
                        ),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      Timer(Duration(seconds: 1), () {
                        if (widget.from == "profile") {
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                        widget.setNavbar!(false);
                      });
                    },
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          AppLocalizations.of("Done"),
                          style: TextStyle(
                              color: primaryBlueColor, fontSize: 12.0.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          widget.setNavbar!(false);
          return true;
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 1.0.h, bottom: 0.0.h),
                        child: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.transparent,
                            child: isCoverFromGallery && cover != null
                                ? CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: FileImage(cover!),
                                  )
                                : CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        NetworkImage(selectedCoverImage),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        allFilesHighlights.forEach((element) {
                          if (element.isSelected!) {
                            setState(() {
                              selectedFiles.add(element);
                              print(selectedFiles.length.toString() +
                                  " beforeeeeeeee clearrrrrrr");
                              selectedStoriesID.add(element.id! +
                                  "^^" +
                                  element.storyId.toString());
                              selectedCoverID = selectedStoriesID[0];
                            });
                            print(selectedStoriesID.join(","));
                          }
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditHighlightCover(
                                      selectedFiles: selectedFiles,
                                      selectedStoriesID: selectedStoriesID,
                                      isImageFromGallery: () {
                                        setState(() {
                                          cover = null;
                                          isCoverFromGallery = false;
                                        });
                                      },
                                      coverFromGallery: (coverFile) {
                                        setState(() {
                                          cover = coverFile;
                                          isCoverFromGallery = true;
                                        });
                                      },
                                      setCover: (coverID, coverImage) {
                                        setState(() {
                                          selectedCoverID = coverID;
                                          selectedCoverImage = coverImage;
                                        });
                                      },
                                      clear: () {
                                        setState(() {
                                          selectedStoriesID.clear();
                                          selectedFiles.clear();
                                        });
                                        print(selectedFiles.length.toString() +
                                            " after clearrrrrrr");
                                      },
                                    )));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 2.0.h, top: 1.0.h),
                        child: Text(
                          AppLocalizations.of(
                            "Edit cover",
                          ),
                          style: TextStyle(
                              color: primaryBlueColor, fontSize: 10.0.sp),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of("Title"),
                            style: greyNormal.copyWith(fontSize: 10.0.sp),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        child: TextFormField(
                          autofocus: false,
                          textAlign: TextAlign.start,
                          onChanged: (val) {},
                          maxLines: null,
                          controller: _controller,
                          cursorColor: Colors.grey.withOpacity(0.4),
                          keyboardType: TextInputType.text,
                          style:
                              TextStyle(color: Colors.black, fontSize: 9.0.sp),
                          decoration: InputDecoration(
                            isDense: true,
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),
                              //  when the TextFormField in unfocused
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.5),

                              //  when the TextFormField in focused
                            ),
                            border: UnderlineInputBorder(),
                            hintText: AppLocalizations.of(
                              "Highlights",
                            ),

                            //alignLabelWithHint: true,
                            hintStyle: TextStyle(
                                color: Colors.black, fontSize: 9.0.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: TabBar(
                indicatorWeight: 1,
                indicatorColor: Colors.black,
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Text(
                      AppLocalizations.of("Selected"),
                      style: greyBold.copyWith(fontSize: 12.0.sp),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of("Add"),
                      style: greyBold.copyWith(fontSize: 12.0.sp),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                GridView.builder(
                    addAutomaticKeepAlives: true,
                    itemCount: allFilesHighlights.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        childAspectRatio: 9 / 16),
                    itemBuilder: (context, index) {
                      return MultipleStoriesTabBar(
                        select: () {
                          setState(() {
                            allFilesHighlights[index].isSelected =
                                !allFilesHighlights[index].isSelected!;
                          });

                          if (allFilesHighlights[index].isSelected!) {
                            setState(() {
                              selectedStoriesImages.add(
                                  allFilesHighlights![index]
                                      .image!
                                      .replaceAll(".mp4", ".jpg"));
                              // selectedFiles.add(allFilesHighlights[index]);
                              allFiles[index].isSelected = true;
                            });
                          } else {
                            setState(() {
                              selectedStoriesImages.removeWhere((element) =>
                                  element ==
                                  allFilesHighlights[index]
                                      .image!
                                      .replaceAll(".mp4", ".jpg"));
                              //selectedFiles.removeWhere((element) => element == allFilesHighlights[index]);
                              allFiles[index].isSelected = false;
                            });
                          }
                          print(allFilesHighlights.length.toString() +
                              "alll highlightssssss");
                        },
                        allFiles: allFilesHighlights[index],
                      );
                    }),
                GridView.builder(
                    addAutomaticKeepAlives: true,
                    itemCount: allFiles.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        childAspectRatio: 9 / 16),
                    itemBuilder: (context, index) {
                      return MultipleStoriesTabBar(
                        select: () {
                          setState(() {
                            allFiles[index].isSelected =
                                !allFiles[index].isSelected!;
                          });

                          if (allFiles[index].isSelected!) {
                            bool found = false;
                            for (int i = 0;
                                i < allFilesHighlights.length;
                                i++) {
                              if (allFilesHighlights[i].image ==
                                  allFiles[index].image) {
                                found = true;
                                setState(() {
                                  allFilesHighlights[i].isSelected = true;
                                });
                              }
                            }
                            if (!found) {
                              setState(() {
                                selectedStoriesImages.add(allFiles[index]
                                    .image!
                                    .replaceAll(".mp4", ".jpg"));
                                allFilesHighlights.add(allFiles[index]);
                              });
                            }
                          } else {
                            setState(() {
                              selectedStoriesImages.removeWhere((element) =>
                                  element ==
                                  allFiles[index]
                                      .image!
                                      .replaceAll(".mp4", ".jpg"));
                              allFilesHighlights.removeWhere(
                                  (element) => element == allFiles[index]);
                            });
                          }
                          print(selectedFiles);
                        },
                        allFiles: allFiles[index],
                      );
                    }),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
