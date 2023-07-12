import 'dart:async';
import 'package:bizbultest/api/api.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:bizbultest/widgets/Stories/stories_view_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sizer/sizer.dart';

import '../story_video_player.dart';

class StoryViewsMainPage extends StatefulWidget {
  final List<FileElement>? allFiles;
  final int? index;
  final Function? startTimer;
  final Function? goToProfile;
  final Function? setNavbar;
  // final Function refreshFromMultipleStories;

  StoryViewsMainPage(
      {Key? key,
      this.allFiles,
      this.index,
      this.startTimer,
      this.goToProfile,
      this.setNavbar})
      : super(key: key);

  @override
  _StoryViewsMainPageState createState() => _StoryViewsMainPageState();
}

class _StoryViewsMainPageState extends State<StoryViewsMainPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  CarouselController carouselController = CarouselController();
  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.index!;
    _tabController =
        new TabController(length: widget.allFiles!.length, vsync: this);
    _tabController.animateTo(widget.index!);
    _tabController.addListener(() {
      carouselController.jumpToPage(_tabController.index);
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    super.initState();
  }

  Future<void> deleteStory(int storyID, String postID) async {
    var url = "https://agora.propberbuz.com/storyDataDelete";
    var params = {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "post_id": postID,
      "story_id": storyID,
    };
    print("delete story called 2  ");
    var response = await ApiProvider()
        .fireApiWithParamsPost(url, params: params)
        .then((value) => value);
    // var url =
    //     "https://www.bebuzee.com/api/delete_story_data.php?action=delete_story_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&story_id=$storyID";

    // var response = await ApiProvider().fireApi(url);

    if (response.statusCode == 200) {
      print(response.data + 'deleted story');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5.0.h),
        child: AppBar(
          backgroundColor: Colors.grey.withOpacity(0.06),
          brightness: Brightness.light,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              widget.startTimer!();
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(right: 4.0.w),
                child: Icon(
                  Icons.close,
                  size: 4.0.h,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          widget.startTimer!();
          return true;
        },
        child: Container(
          child: Column(
            children: [
              Container(
                  height: 30.0.h,
                  color: Colors.grey.withOpacity(0.06),
                  child: CarouselSlider.builder(
                    carouselController: carouselController,
                    itemCount: widget.allFiles!.length,
                    itemBuilder: (context, index, ind) {
                      return Card(
                        elevation: 15,
                        child: GestureDetector(
                          onTap: () {
                            _tabController.animateTo(index);
                            carouselController.jumpToPage(index);
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: "0612FA,E2821E"
                                    .split(',')
                                    .map((e) => HexColor(e))
                                    .toList(),
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: widget.allFiles![index].video == 0
                                ? widget.allFiles![index].memoryFile != null
                                    ? Image.memory(
                                        widget.allFiles![index].memoryFile!,
                                        fit: BoxFit.cover,
                                      )
                                    : widget.allFiles![index].image != null &&
                                            widget.allFiles![index].image != ''
                                        ? Image.network(
                                            widget.allFiles![index].image!,
                                            fit: BoxFit.cover,
                                          )
                                        : SizedBox()
                                : StoryVideoPlayerPaused(
                                    url: widget.allFiles![index].image!,
                                    setController: () {},
                                  ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      initialPage: widget.index!,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.2,
                      height: 130,
                      onPageChanged: (val, reason) {
                        _tabController.animateTo(val);
                        setState(() {
                          _selectedIndex = val;
                        });
                      },
                    ),
                  )),
              Expanded(
                child: Card(
                  elevation: 20,
                  margin: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                  child: Container(
                    child: TabBarView(
                      controller: _tabController,
                      children: widget.allFiles!
                          .map(
                            (e) => StoriesViewsCard(
                              delete: () {
                                if (widget.allFiles!.length > 1) {
                                  deleteStory(e.storyId!, e.id!);
                                  setState(() {
                                    widget.allFiles!.removeAt(_selectedIndex);
                                  });
                                  setState(() {
                                    _tabController = new TabController(
                                        length: widget.allFiles!.length,
                                        vsync: this);
                                  });
                                  _tabController.animateTo(0);
                                  carouselController.jumpToPage(0);
                                  Fluttertoast.showToast(
                                    msg: "Story Deleted",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.7),
                                    textColor: Colors.white,
                                    fontSize: 15.0,
                                  );
                                } else {
                                  deleteStory(e.storyId!, e.id!);
                                  Timer(Duration(milliseconds: 500), () {
                                    print("backkkkk");
                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                    Fluttertoast.showToast(
                                      msg: "Deleted",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.7),
                                      textColor: Colors.white,
                                      fontSize: 15.0,
                                    );
                                  });
                                }
                              },
                              setNavbar: widget.setNavbar!,
                              onTap: widget.goToProfile!,
                              allFiles: e,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
