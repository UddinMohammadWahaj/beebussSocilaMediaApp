import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:bizbultest/models/highlight_model.dart';
import 'package:bizbultest/models/user_highlights_model.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/widgets/Stories/animated_bars.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:video_player/video_player.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:flutter/cupertino.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:http/http.dart' as http;
import 'package:bizbultest/widgets/story_video_player.dart';

import '../../services/Chat/direct_api.dart';
import '../../utilities/custom_toast_message.dart';
import '../Stories/display_story_tags_and_stickers.dart';
import '../Stories/timeWidget.dart';
import 'edit_highlight.dart';
import 'highlight_bottom_tile.dart';
import 'highlights_bottom_menu.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class ExpandedHighlightsPage extends StatefulWidget {
  final UserHighlightsModel? highlights;
  final Function? setNavBar;
  final Function? changePage;
  final int? index;

  ExpandedHighlightsPage(
      {Key? key, this.setNavBar, this.highlights, this.changePage, this.index})
      : super(key: key);

  @override
  _ExpandedHighlightsPageState createState() => _ExpandedHighlightsPageState();
}

class _ExpandedHighlightsPageState extends State<ExpandedHighlightsPage>
    with SingleTickerProviderStateMixin {
  PausableTimer? timer;
  ExpandedHighlights? highlightsList;
  bool areStoriesLoaded = false;
  PreloadPageController? _pageController;
  AnimationController? _animationController;
  int _currentIndex = 0;
  int length = 0;
  List<FileElement> allFiles = [];
  TextEditingController _messageController = TextEditingController();
  bool animate = true;
  VideoPlayerController? controller;
  bool? keyboardVisible = false;
  GlobalKey _globalKey = new GlobalKey();
  bool addNewHighlight = false;
  var musicplayer = AudioPlayer();
  TextStyle style = GoogleFonts.roboto();
  int duration = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  UserHighlightsList? userHighlightsList;
  bool areUserHighlightsLoaded = false;

  Future<void> getHighlights() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_heighlight_data.php?action=get_highlight_data_details&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&highlight_id=${widget.highlights.highlightId}");

    // var response = await http.get(url);

    var response =
        await ApiRepo.postWithToken("api/highlight_data_details.php", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "highlight_id": widget.highlights!.highlightId,
    });
    print("current highlight id=${widget.highlights!.highlightId}");
    if (response!.success == 1) {
      ExpandedHighlights highLightData =
          ExpandedHighlights.fromJson(response!.data['data']);

      highLightData.highlights.forEach((element) {
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
      _loadStory(animateToPage: false);
      startTimer();
    }
    if (response!.data == null ||
        response!.data['data'] == null ||
        response!.data['data'] == '') {
      if (mounted) {
        setState(() {
          areStoriesLoaded = false;
        });
      }
    }
  }

  void _loadStory({bool animateToPage = true}) {
    _animationController!.stop();
    _animationController!.reset();
    _animationController!.duration = new Duration(seconds: 15);
    _animationController!.forward();
    if (animateToPage && animate) {
      _pageController!.animateToPage(_currentIndex,
          duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
    }
  }

  void playMusic() async {
    await musicplayer.setUrl(allFiles[_currentIndex].musicData!.split('^^')[3]);

    await musicplayer.setLoopMode(LoopMode.all);
    await musicplayer.play();
  }

  void endMusic() async {
    await musicplayer.stop();
  }

  Widget musicCover(String url) {
    url = url.replaceFirst('{w}', '50');
    url = url.replaceFirst('{h}', '50');
    print("music url=$url");
    return

        // ClipRRect(
        //   borderRadius: BorderRadius.all(Radius.circular(15)),
        //   child:

        ClipRRect(
            borderRadius: BorderRadius.circular(4.0.w),
            child: Container(
                child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain))
            //  Image.asset(
            //   AudioManager.instance.info?.coverUrl ??
            //       "assets/images/disc.png",
            //   width: 120.0,
            //   height: 120.0,
            //   fit: BoxFit.cover,
            // )

            // Card(
            //   color: Colors.black,
            //   shape: RoundedRectangleBorder(),
            //   child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
            // ),
            );
    // );
  }

  void startTimer() async {
    print("startttt");
    if (allFiles[_currentIndex].musicData != '' &&
        allFiles[_currentIndex].musicData != null) {
      playMusic();
    }
    if (mounted) {
      duration = allFiles[_currentIndex].musicData != '' &&
              allFiles[_currentIndex].musicData != null
          ? 15
          : allFiles[_currentIndex].video! == 0
              ? 5
              : allFiles[_currentIndex].videoDuration!;
      setState(() {
        timer = PausableTimer(Duration(seconds: 15), () {
          if (mounted) {
            if (_currentIndex + 1 < allFiles.length) {
              setState(() {
                endMusic();
                _currentIndex += 1;
              });
            } else {
              if (timer!.duration >= Duration(seconds: duration)) {
                widget.changePage!();
                endMusic();
              }
              setState(() {
                _currentIndex = 0;
              });
            }
          }
          print("Stateeeee");
          _loadStory();
          duration = allFiles[_currentIndex].musicData!.length != 0
              ? 15
              : allFiles[_currentIndex].video == 0
                  ? 5
                  : allFiles[_currentIndex].videoDuration!;
          print("exeeee");
          startTimer();
        });
      });
    }
    timer!.start();
  }

  void _pause() {
    print("pausssed");

    setState(() {
      _animationController!.stop();
      timer!.pause();
      if (controller != null && allFiles[_currentIndex].video == 1) {
        controller!.pause();
      }
    });
  }

  Future<void> removeStory(
      String storyID, String postID, String highlightID) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_heighlight_data.php?action=delete_highlight_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&story_id=$storyID&story_user_id=${CurrentUser().currentUser.memberID}&highlight_id=$highlightID");

    var response = await http.get(url);

    if (response!.statusCode == 200) {
      print(response!.body);
      print(storyID);
      print(postID);
      print(highlightID);
    }
  }

  Future<void> editHighlightName(
      String storyID, String postID, String highlightID, String name) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/app_devlope_heighlight_data.php?action=edit_highlight_text&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&story_user_id=${CurrentUser().currentUser.memberID}&story_id=$storyID&post_id=$postID&highlight_id=${widget.highlights!.highlightId}&text=$name");

    var response = await http.get(url);

    if (response!.statusCode == 200) {
      print(response!.body);
      print(storyID);
      print(postID);
      print(highlightID);
      print(name);
    }
  }

  final _controller = TextEditingController();

  bool isTapOnQuestion = false;
  @override
  void initState() {
    // getHighlights();
    _pageController = PreloadPageController();
    _animationController = AnimationController(vsync: this);

    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted) {
        setState(() {
          keyboardVisible = visible;
        });
      }
    });
  }

  @override
  void dispose() {
    musicplayer.stop();
    print("disposeeeeee");

    _animationController!.dispose();
    musicplayer.dispose();
    timer!.cancel();
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
        ),
      ),
      body: VisibilityDetector(
        key: ObjectKey(_scaffoldKey),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0) {
            print("pauseeeeeee");
            if (_animationController != null) {
              _animationController!.reset();
            }
            if (timer != null) {
              timer!.cancel();
            }
            if (controller != null && allFiles[_currentIndex].video == 1) {
              controller!.pause();
            }
          } else {
            if (!areStoriesLoaded) {
              getHighlights();
            }
            if (_animationController != null) {
              _animationController!.duration = new Duration(seconds: 15);
              _animationController!.forward();
            }
            if (timer != null) {
              timer!.reset();
              timer!.start();
            }
            if (controller != null && allFiles[_currentIndex].video == 1) {
              controller!.play();
            }
          }
        },
        child: Container(
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                animate = false;
              });
              if (controller != null && allFiles[_currentIndex].video == 1) {
                controller!.pause();
              }
              _animationController!.stop();
              timer!.pause();
            },
            onLongPressStart: (details) {
              setState(() {
                animate = false;
              });
              _animationController!.stop();
              timer!.pause();
              if (controller != null && allFiles[_currentIndex].video == 1) {
                controller!.pause();
              }
            },
            onLongPressMoveUpdate: (details) {
              setState(() {
                animate = false;
              });
              if (controller != null && allFiles[_currentIndex].video == 1) {
                controller!.pause();
              }
              _animationController!.stop();
              timer!.pause();
            },
            onLongPressEnd: (details) {
              setState(() {
                animate = true;
              });
              if (controller != null && allFiles[_currentIndex].video == 1) {
                controller!.play();
              }
              _animationController!.forward();
              timer!.start();
            },
            onVerticalDragUpdate: (details) {
              if (allFiles[_currentIndex].link != "") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebsiteView(
                            url: allFiles[_currentIndex].link, heading: "")));
              }
            },
            child: areStoriesLoaded
                ? Container(
                    height: 100.0.h,
                    child: Stack(
                      children: [
                        Container(
                          height: 89.0.h,
                          child: PreloadPageView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              controller: _pageController,
                              itemCount: allFiles.length,
                              itemBuilder: (context, index) {
                                var musicScale,
                                    musicRotation,
                                    musicPosX,
                                    musicPosY,
                                    musicData;

                                bool ismusicViewOn = false;

                                if (allFiles[index].musicData != null &&
                                    allFiles[index].musicData!.length > 0) {
                                  print(
                                      "music data fetch story abc =${allFiles[index].musicData}");
                                  ismusicViewOn = true;
                                  if (allFiles[index]
                                          .musicData!
                                          .split('^^')
                                          .length !=
                                      0)
                                    musicData =
                                        allFiles[index].musicData!.split('^^');

                                  print("music data fetch story=${musicData}");
                                }
                                if (allFiles[index].musicPosData != null) {
                                  // isimageViewOn = true;
                                  var item = allFiles[index].musicPosData;
                                  musicScale =
                                      double.tryParse(item!.scale ?? "1.0");
                                  musicRotation =
                                      double.tryParse(item.rotation ?? "0.0");
                                  musicPosX =
                                      double.tryParse(item.posx ?? "0.0");
                                  musicPosY =
                                      double.tryParse(item.posy ?? "0.0");

                                  print(
                                      "haha music = x=${musicPosX} y=${musicPosY} ");
                                }

                                var questionsTextScale,
                                    questionsTextRotation,
                                    questionsTextPosX,
                                    questionsTextPosY,
                                    questionsTextTextData;
                                bool isquestionsTextViewOn = false;
                                if (allFiles[index].questionstext != null) {
                                  isquestionsTextViewOn = true;
                                  var item = allFiles[index].questionstext;
                                  questionsTextScale =
                                      double.tryParse(item!.scale!);
                                  questionsTextRotation =
                                      double.tryParse(item!.rotation!);
                                  questionsTextPosX =
                                      double.tryParse(item!.posx!);
                                  questionsTextPosY =
                                      double.tryParse(item!.posy!);
                                  questionsTextTextData =
                                      item!.name!.replaceAll("@@@", "#");
                                  if (questionsTextTextData == "") {
                                    isquestionsTextViewOn = false;
                                  }
                                }

                                var questionsReplyTextScale,
                                    questionsReplyTextRotation,
                                    questionsReplyTextPosX,
                                    questionsReplyTextPosY;
                                String? questionsReplyTextTextData;
                                bool isquestionsReplyTextViewOn = false;

                                var locationTextScale,
                                    locationTextRotation,
                                    locationTextPosX,
                                    locationTextPosY,
                                    locationTextTextData;
                                bool islocationTextViewOn = false;

                                if (allFiles[index].locationtext != null) {
                                  islocationTextViewOn = true;
                                  var item = allFiles[index].locationtext;
                                  locationTextScale =
                                      double.tryParse(item!.scale!);
                                  locationTextRotation =
                                      double.tryParse(item!.rotation!);
                                  locationTextPosX =
                                      double.tryParse(item!.posx!);
                                  locationTextPosY =
                                      double.tryParse(item.posy!);
                                  locationTextTextData =
                                      item.name!.replaceAll("@@@", "");
                                  if (locationTextTextData == "") {
                                    islocationTextViewOn = false;
                                  }
                                }

                                var hashTagScale,
                                    hashTagRotation,
                                    hashTagPosX,
                                    hashTagPosY,
                                    hashTagTextData;
                                bool isHashTagViewOn = false;
                                if (allFiles[index].hashtag != null) {
                                  isHashTagViewOn = true;
                                  var item = allFiles[index].hashtag;
                                  hashTagScale = double.tryParse(item!.scale!);
                                  hashTagRotation =
                                      double.tryParse(item!.rotation!);
                                  hashTagPosX = double.tryParse(item!.posx!);
                                  hashTagPosY = double.tryParse(item!.posy!);
                                  hashTagTextData =
                                      item!.name!.replaceAll("@@@", "#");
                                  if (hashTagTextData == "") {
                                    isHashTagViewOn = false;
                                  }
                                }
                                var scale, rotation, posX, posY;
                                bool isimageViewOn = false;
                                if (allFiles[index].assetImageData != null) {
                                  isimageViewOn = true;
                                  var item = allFiles[index].assetImageData;
                                  scale = double.tryParse(item!.scale ?? "1.0");
                                  rotation =
                                      double.tryParse(item!.rotation ?? "0.0");
                                  posX = double.tryParse(item.posx ?? "0.0");
                                  posY = double.tryParse(item.posy ?? "0.0");
                                }

                                var timeScale,
                                    timeRotation,
                                    timePosX,
                                    timePosY,
                                    timedateTime;
                                bool isTimeViewOn = false;
                                // List<String> time =  allFiles[index].timeView.split("~~~");
                                if (allFiles[index].timeView != null) {
                                  isTimeViewOn = true;
                                  var item = allFiles[index].timeView;
                                  timeScale = double.tryParse(item!.scale!);
                                  timeRotation =
                                      double.tryParse(item!.rotation!);
                                  timePosX = double.tryParse(item!.posx!);
                                  timePosY = double.tryParse(item!.posy!);
                                  timedateTime = item!.name;
                                  if (timedateTime == "") {
                                    isTimeViewOn = false;
                                  }
                                }
                                return Stack(
                                  children: [
                                    Container(
                                      height: 90.0.h,
                                      width: 100.0.w,
                                      child: allFiles[index].video == 0
                                          ?

                                          //  Image.network(
                                          //     allFiles[index].image,
                                          //     fit: BoxFit.cover,
                                          //   )
                                          Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      allFiles[index].image!),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 50, sigmaY: 50),
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      if (isimageViewOn)
                                                        Positioned.fill(
                                                          top: posY,
                                                          left: posX,
                                                          child: Transform(
                                                            transform: new Matrix4
                                                                    .diagonal3(
                                                                new v.Vector3(
                                                                    scale,
                                                                    scale,
                                                                    scale))
                                                              ..rotateZ(
                                                                  rotation),
                                                            alignment:
                                                                FractionalOffset
                                                                    .center,
                                                            child: Transform(
                                                              transform: new Matrix4
                                                                      .diagonal3(
                                                                  new v.Vector3(
                                                                      scale,
                                                                      scale,
                                                                      scale)),
                                                              alignment:
                                                                  FractionalOffset
                                                                      .center,
                                                              child: Image(
                                                                image: CachedNetworkImageProvider(
                                                                    allFiles[
                                                                            index]
                                                                        .image!),
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      else
                                                        Image(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                                  allFiles[
                                                                          index]
                                                                      .image!),
                                                          fit: BoxFit.contain,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : StoryVideoPlayerAutoPlay(
                                              setController: (cntrl) {
                                                setState(() {
                                                  controller = cntrl;
                                                });
                                              },
                                              url: allFiles[index].image!,
                                            ),
                                    ),
                                    allFiles[index].backgroundColors != null &&
                                            allFiles[index].backgroundColors !=
                                                ""
                                        ? Container(
                                            height: 90.0.h,
                                            width: 100.0.w,
                                            decoration: allFiles[index]
                                                            .backgroundColors !=
                                                        null &&
                                                    allFiles[index]
                                                            .backgroundColors !=
                                                        ''
                                                ? BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: "0612FA,E2821E"
                                                          .split(',')
                                                          .map((e) =>
                                                              HexColor(e))
                                                          .toList(),
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                  )
                                                : null,
                                          )
                                        : Container(),
                                    !animate
                                        ? GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              color: Colors.transparent,
                                            ),
                                          )
                                        : Container(),
                                    animate
                                        ? Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: GestureDetector(
                                                onTap: () {
                                                  print("music forward");
                                                  timer!.reset();
                                                  if (_currentIndex - 1 >= 0) {
                                                    setState(() {
                                                      musicplayer.stop();

                                                      duration = allFiles[
                                                                      _currentIndex]
                                                                  .musicData!
                                                                  .length !=
                                                              0
                                                          ? 15
                                                          : allFiles[_currentIndex]
                                                                      .video ==
                                                                  0
                                                              ? 5
                                                              : allFiles[
                                                                      _currentIndex]
                                                                  .videoDuration!;
                                                      _currentIndex -= 1;
                                                    });
                                                    startTimer();
                                                    _loadStory();

                                                    print(
                                                        allFiles[_currentIndex]
                                                            .storyId);
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  width: 50.0.w,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    animate
                                        ? Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  print("music forward 1");
                                                  musicplayer.stop();
                                                  setState(() {
                                                    duration = allFiles[
                                                                    _currentIndex]
                                                                .musicData!
                                                                .length !=
                                                            0
                                                        ? 15
                                                        : allFiles[_currentIndex]
                                                                    .video ==
                                                                0
                                                            ? 5
                                                            : allFiles[
                                                                    _currentIndex]
                                                                .videoDuration!;
                                                  });
                                                  timer!.reset();

                                                  if (_currentIndex + 1 <
                                                      allFiles.length) {
                                                    setState(() {
                                                      _currentIndex += 1;
                                                    });
                                                    startTimer();
                                                    _loadStory();

                                                    print(
                                                        allFiles[_currentIndex]
                                                            .storyId);
                                                  } else {
                                                    widget.changePage!();
                                                    setState(() {
                                                      _currentIndex = 0;
                                                    });
                                                    startTimer();
                                                    _loadStory();

                                                    print(
                                                        allFiles[_currentIndex]
                                                            .storyId);
                                                  }
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  width: 50.0.w,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    if (ismusicViewOn)
                                      Positioned.fill(
                                          top: musicPosY,
                                          left: musicPosX,
                                          child:

                                              //  Transform.scale(
                                              //     scale: musicScale,
                                              //     alignment:
                                              //         FractionalOffset.center,
                                              //     child: Container(
                                              //       color: Colors.transparent,
                                              //       child: Padding(
                                              //         padding:
                                              //             EdgeInsets.symmetric(
                                              //                 horizontal:
                                              //                     6.0.abs(),
                                              //                 vertical: 5.0.h),
                                              //         child: Container(
                                              //           color: Colors.transparent,
                                              //           child: Center(
                                              //             child: Container(
                                              //               alignment:
                                              //                   new FractionalOffset(
                                              //                       0.5, 0.5),
                                              //               padding:
                                              //                   EdgeInsets.all(
                                              //                       10),
                                              //               decoration:
                                              //                   BoxDecoration(
                                              //                 color: Colors.white,
                                              //                 borderRadius:
                                              //                     BorderRadius
                                              //                         .circular(
                                              //                             8),
                                              //                 boxShadow: [
                                              //                   BoxShadow(
                                              //                     color: Colors
                                              //                         .black
                                              //                         .withOpacity(
                                              //                             .2),
                                              //                     offset: Offset(
                                              //                         0, 2),
                                              //                     blurRadius: 3,
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //               child: Row(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment
                                              //                         .spaceBetween,
                                              //                 children: [
                                              //                   Row(
                                              //                     children: [
                                              //                       Padding(
                                              //                         padding:
                                              //                             const EdgeInsets.all(
                                              //                                 8.0),
                                              //                         child: musicCover(
                                              //                             musicData[
                                              //                                 2]),
                                              //                       ),
                                              //                       Container(
                                              //                         color: Colors
                                              //                             .white,
                                              //                         child: Text(
                                              //                             musicData[
                                              //                                 0],
                                              //                             style: TextStyle(
                                              //                                 fontSize:
                                              //                                     20,
                                              //                                 color:
                                              //                                     Colors.black)),
                                              //                       ),
                                              //                     ],
                                              //                   ),

                                              //                   // Column(
                                              //                   //   children: [
                                              //                   //     Text(
                                              //                   //         musicData[
                                              //                   //             0],
                                              //                   //         style: TextStyle(
                                              //                   //             fontSize:
                                              //                   //                 20,
                                              //                   //             color: Colors
                                              //                   //                 .black)),
                                              //                   //   ],
                                              //                   // ),
                                              //                   Padding(
                                              //                     padding:
                                              //                         const EdgeInsets
                                              //                                 .all(
                                              //                             8.0),
                                              //                     child: SpinKitPianoWave(
                                              //                         color: Colors
                                              //                             .deepPurple,
                                              //                         size:
                                              //                             3.0.h),
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     )),

                                              Transform.scale(
                                            scale: musicScale,
                                            child: Container(

                                                // height: 10.0.h,

                                                // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(hashtagViewData.rotation),
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                6.0.abs(),
                                                            vertical: 5.0.h),
                                                    child: Container(
                                                        // width: 100.0.w,
                                                        color:
                                                            Colors.transparent,
                                                        child: Center(
                                                            child: allFiles[_currentIndex]
                                                                        .musicStyle !=
                                                                    "liststyle"
                                                                ? Container(
                                                                    padding: EdgeInsets.all(7),
                                                                    height: 30.0.h,
                                                                    width: 40.0.w,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .transparent,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0),
                                                                          offset: Offset(
                                                                              0,
                                                                              2),
                                                                          blurRadius:
                                                                              3,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: Container(
                                                                      color: Colors
                                                                          .transparent,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          CachedNetworkImage(
                                                                              imageUrl: musicData[2].toString().replaceFirst('{w}', '200').replaceFirst('{h}', '200')),
                                                                          Expanded(
                                                                            child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Text('${musicData[0].toString().substring(0, musicData[0].toString().length <= 9 ? musicData[0].toString().length - 1 : (musicData[0].toString().length / 2).floorToDouble().toInt()) + '..'}', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                                                                    Text(
                                                                                      '${musicData[1]}',
                                                                                      style: TextStyle(fontSize: 1.5.h, color: Colors.white, overflow: TextOverflow.ellipsis),
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                    //     Container(
                                                                    //   color:
                                                                    //       Colors.white,
                                                                    //   child:
                                                                    //       Expanded(
                                                                    //     child:
                                                                    //         Row(
                                                                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    //       children: [
                                                                    //         FittedBox(
                                                                    //           child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                    //             musicCover(musicData[2]),
                                                                    //             Padding(
                                                                    //               padding: const EdgeInsets.all(8.0),
                                                                    //               child: Column(
                                                                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                    //                 children: [
                                                                    //                   Padding(
                                                                    //                     padding: const EdgeInsets.all(2.0),
                                                                    //                     child: Text(
                                                                    //                         // musicData[0].toString(),
                                                                    //                         musicData[0].toString().substring(0, musicData[0].toString().length <= 9 ? musicData[0].toString().length - 1 : (musicData[0].toString().length / 2).floorToDouble().toInt()) + '..',
                                                                    //                         overflow: TextOverflow.ellipsis,
                                                                    //                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 2.5.h)),
                                                                    //                   ),
                                                                    //                   Padding(
                                                                    //                     padding: const EdgeInsets.all(2.0),
                                                                    //                     child: Text(musicData[1], style: TextStyle(color: Colors.grey)),
                                                                    //                   ),
                                                                    //                 ],
                                                                    //               ),
                                                                    //             ),
                                                                    //           ]),
                                                                    //         ),
                                                                    //         Padding(
                                                                    //           padding: const EdgeInsets.all(5.0),
                                                                    //           child: FittedBox(
                                                                    //             child: SpinKitPianoWave(color: Colors.deepPurple, size: 3.0.h),
                                                                    //           ),
                                                                    //         ),
                                                                    //       ],
                                                                    //     ),
                                                                    //   ),
                                                                    // )
                                                                    )
                                                                : Container(
                                                                    padding: EdgeInsets.all(10),
                                                                    decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(.2),
                                                                          offset: Offset(
                                                                              0,
                                                                              2),
                                                                          blurRadius:
                                                                              3,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child:
                                                                        // Stack(
                                                                        //   clipBehavior:
                                                                        //       Clip.none,
                                                                        //   children: [
                                                                        //     ListTile(
                                                                        //   shape: RoundedRectangleBorder(
                                                                        //       borderRadius:
                                                                        //           BorderRadius.circular(
                                                                        //               20)),
                                                                        //   // contentPadding:
                                                                        //   //     EdgeInsets
                                                                        //   //         .all(
                                                                        //   //             18.0),
                                                                        //   tileColor:
                                                                        //       Colors
                                                                        //           .white,
                                                                        //   trailing:
                                                                        //       FittedBox(
                                                                        //     child: SpinKitPianoWave(
                                                                        //         color: Colors
                                                                        //             .deepPurple,
                                                                        //         size: 3.0
                                                                        //             .h),
                                                                        //   ),
                                                                        //   leading:
                                                                        //       musicCover(
                                                                        //           musicData[
                                                                        //               2]),
                                                                        //   title: Text(
                                                                        //       musicData[
                                                                        //           0],
                                                                        //       style: TextStyle(
                                                                        //           fontSize:
                                                                        //               20)),
                                                                        //   subtitle: Text(
                                                                        //       '${musicData[1]}'),
                                                                        // ),
                                                                        //   ],
                                                                        // )

                                                                        Container(
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          Expanded(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            FittedBox(
                                                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                                musicCover(musicData[2]),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(2.0),
                                                                                        child: Text(
                                                                                            // musicData[0].toString(),
                                                                                            musicData[0].toString().substring(0, musicData[0].toString().length <= 9 ? musicData[0].toString().length - 1 : (musicData[0].toString().length / 2).floorToDouble().toInt()) + '..',
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 2.5.h)),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(2.0),
                                                                                        child: Text(musicData[1], style: TextStyle(color: Colors.grey)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: FittedBox(
                                                                                child: SpinKitPianoWave(color: Colors.deepPurple, size: 3.0.h),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )))))),
                                          )),
                                    // Positioned.fill(
                                    //     top: musicPosY,
                                    //     left: musicPosX,
                                    //     child: Transform.scale(
                                    //       scale: musicScale,
                                    //       child: Container(
                                    //           color: Colors.transparent,
                                    //           // height: 10.0.h,

                                    //           // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(hashtagViewData.rotation),
                                    //           child: Padding(
                                    //               padding:
                                    //                   EdgeInsets.symmetric(
                                    //                       horizontal:
                                    //                           6.0.abs(),
                                    //                       vertical: 5.0.h),
                                    //               child: Container(
                                    //                   // width: 100.0.w,
                                    //                   color:
                                    //                       Colors.transparent,
                                    //                   child: Center(
                                    //                       child: Container(
                                    //                           padding:
                                    //                               EdgeInsets
                                    //                                   .all(
                                    //                                       10),
                                    //                           decoration:
                                    //                               BoxDecoration(
                                    //                             color: Colors
                                    //                                 .white,
                                    //                             borderRadius:
                                    //                                 BorderRadius
                                    //                                     .circular(
                                    //                                         8),
                                    //                             boxShadow: [
                                    //                               BoxShadow(
                                    //                                 color: Colors
                                    //                                     .black
                                    //                                     .withOpacity(
                                    //                                         .2),
                                    //                                 offset:
                                    //                                     Offset(
                                    //                                         0,
                                    //                                         2),
                                    //                                 blurRadius:
                                    //                                     3,
                                    //                               ),
                                    //                             ],
                                    //                           ),
                                    //                           child:
                                    //                               // Stack(
                                    //                               //   clipBehavior:
                                    //                               //       Clip.none,
                                    //                               //   children: [
                                    //                               //     ListTile(
                                    //                               //       shape: RoundedRectangleBorder(
                                    //                               //           borderRadius:
                                    //                               //               BorderRadius.circular(20)),
                                    //                               //       // contentPadding:
                                    //                               //       //     EdgeInsets
                                    //                               //       //         .all(
                                    //                               //       //             18.0),
                                    //                               //       tileColor:
                                    //                               //           Colors.white,
                                    //                               //       trailing:
                                    //                               //     FittedBox(
                                    //                               //   child: SpinKitPianoWave(
                                    //                               //       color: Colors.deepPurple,
                                    //                               //       size: 3.0.h),
                                    //                               // ),
                                    //                               //       leading:
                                    //                               //           musicCover(musicData[2]),
                                    //                               //       title: Text(
                                    //                               //           musicData[
                                    //                               //               0],
                                    //                               //           style:
                                    //                               //               TextStyle(fontSize: 20)),
                                    //                               //       subtitle:
                                    //                               //           Text('${musicData[1]}'),
                                    //                               //     ),
                                    //                               //   ],
                                    //                               // )

                                    //                               Wrap(
                                    //                             children: [
                                    //                               FittedBox(
                                    //                                 child: Row(
                                    //                                     children: [
                                    //                                       musicCover(musicData[2]),
                                    //                                       Column(
                                    //                                         children: [
                                    //                                           Padding(
                                    //                                             padding: const EdgeInsets.all(2.0),
                                    //                                             child: Text(musicData[0].toString().substring(0, musicData[0].toString().length <= 5 ? musicData[0].toString().length - 1 : (musicData[0].toString().length / 2).floorToDouble().toInt()) + '..'),
                                    //                                           ),
                                    //                                           Padding(
                                    //                                             padding: const EdgeInsets.all(2.0),
                                    //                                             child: Text(musicData[1], style: TextStyle(color: Colors.grey)),
                                    //                                           ),
                                    //                                         ],
                                    //                                       )
                                    //                                     ]),
                                    //                               )
                                    //                             ],
                                    //                           )))))),
                                    //     )),
                                    if (isquestionsTextViewOn)
                                      Positioned.fill(
                                        top: isTapOnQuestion && keyboardVisible!
                                            ? 0
                                            : questionsTextPosY,
                                        left:
                                            isTapOnQuestion && keyboardVisible!
                                                ? 0
                                                : questionsTextPosX,
                                        // right: isTapOnQuestion && keyboardVisible ? 0 : null,
                                        // bottom: isTapOnQuestion && keyboardVisible ? 0 : null,
                                        child: Container(
                                          color: Colors.transparent,
                                          // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(hashtagViewData.rotation),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6.0.abs(),
                                                vertical: 5.0.h),
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Center(
                                                child: Container(
                                                  padding: EdgeInsets.all(7),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(.2),
                                                        offset: Offset(0, 2),
                                                        blurRadius: 3,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(20),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .70,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          15),
                                                              child: Text(
                                                                questionsTextTextData,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              width: double
                                                                  .infinity,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        TextFormField(
                                                                      onTap:
                                                                          () {
                                                                        isTapOnQuestion =
                                                                            true;
                                                                        _pause();
                                                                      },
                                                                      controller:
                                                                          _controller,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      textCapitalization:
                                                                          TextCapitalization
                                                                              .sentences,
                                                                      maxLines:
                                                                          3,
                                                                      minLines:
                                                                          1,
                                                                      onChanged:
                                                                          (val) {},
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
                                                                        hintText:
                                                                            "Reply here",
                                                                        hintStyle:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await DirectApiCalls().questionReplyFromStory(
                                                                          CurrentUser()
                                                                              .currentUser
                                                                              .memberID!,
                                                                          _controller
                                                                              .text,
                                                                          allFiles[index]
                                                                              .id!,
                                                                          allFiles[index]
                                                                              .storyId
                                                                              .toString());
                                                                      FocusScope.of(
                                                                              context)
                                                                          .requestFocus(
                                                                              FocusNode());
                                                                      isTapOnQuestion =
                                                                          false;
                                                                      timer!
                                                                          .start();
                                                                      _animationController!
                                                                          .forward();
                                                                      if (controller !=
                                                                              null &&
                                                                          allFiles[_currentIndex].video ==
                                                                              1) {
                                                                        controller!
                                                                            .play();
                                                                      }

                                                                      customToastWhite(
                                                                          AppLocalizations
                                                                              .of(
                                                                            "Reply Sent",
                                                                          ),
                                                                          16.0,
                                                                          ToastGravity
                                                                              .CENTER);
                                                                      _controller
                                                                          .clear();
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .send,
                                                                      size: 25,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        right: 0,
                                                        top: -20,
                                                        child: Center(
                                                          child: CircleAvatar(
                                                            radius: 20,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              CurrentUser()
                                                                  .currentUser
                                                                  .image!,
                                                            ),
                                                            backgroundColor:
                                                                Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // height: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (isquestionsReplyTextViewOn)
                                      // ignore: dead_code
                                      Positioned.fill(
                                        top: questionsReplyTextPosY,
                                        left: questionsReplyTextPosX,
                                        child: Container(
                                          color: Colors.transparent,
                                          // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(questionsReplyViewData.rotation),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6.0.w,
                                                vertical: 5.0.h),
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Center(
                                                child: Container(
                                                  // padding: EdgeInsets.all(7),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(.2),
                                                        offset: Offset(0, 2),
                                                        blurRadius: 3,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    // padding: EdgeInsets.all(20),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .70,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 15),
                                                          child: Text(
                                                            questionsReplyTextTextData!
                                                                .split("~~")[0],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade200,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                          ),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  15),
                                                          width:
                                                              double.infinity,
                                                          child: Center(
                                                            child: Text(
                                                              questionsReplyTextTextData
                                                                  .split(
                                                                      "~~")[1],
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  // height: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (islocationTextViewOn)
                                      Positioned.fill(
                                        top: locationTextPosY,
                                        left: locationTextPosX,
                                        child: Container(
                                          color: Colors.transparent,
                                          // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(hashtagViewData.rotation),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6.0.w,
                                                vertical: 5.0.h),
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Center(
                                                child: Container(
                                                  key: ValueKey(
                                                      locationTextScale),
                                                  padding: EdgeInsets.all(7),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(.2),
                                                        offset: Offset(0, 2),
                                                        blurRadius: 3,
                                                      ),
                                                    ],
                                                  ),
                                                  child: ShaderMask(
                                                    shaderCallback:
                                                        (Rect bounds) {
                                                      return LinearGradient(
                                                        colors: <Color>[
                                                          Colors.purple,
                                                          Colors.pinkAccent
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ).createShader(
                                                          Rect.fromLTWH(
                                                              0.0,
                                                              0.0,
                                                              120.0,
                                                              40.0));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                        Text(
                                                          locationTextTextData
                                                              .toUpperCase(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                                  .rajdhani()
                                                              .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          textScaleFactor:
                                                              locationTextScale,
                                                        ),
                                                      ],
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                    ),
                                                  ),
                                                  // height: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    allFiles[index].stickers!.length > 0
                                        ? Stack(
                                            children: allFiles[index]
                                                .stickers!
                                                .map(
                                                    (e) => DisplayStoryStickers(
                                                          s: e,
                                                        ))
                                                .toList(),
                                          )
                                        : Container(),
                                    if (isTimeViewOn)
                                      Positioned.fill(
                                        top: timePosY,
                                        left: timePosX,
                                        child: Transform(
                                          transform: new Matrix4.diagonal3(
                                              new v.Vector3(timeScale,
                                                  timeScale, timeScale))
                                            ..rotateZ(timeRotation),
                                          alignment: FractionalOffset.center,
                                          child: Center(
                                            child: StoryTimeWidget(
                                              dateData:
                                                  DateTime.parse(timedateTime),
                                            ),
                                          ),
                                        ),
                                      ),
                                    allFiles[index].position!.length > 0
                                        ? Stack(
                                            children: allFiles[index]
                                                .position!
                                                .map((e) => Positioned.fill(
                                                      left:
                                                          double.parse(e.posx!),
                                                      top:
                                                          double.parse(e.posy!),
                                                      child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            height:
                                                                double.parse(
                                                                    e.height!),
                                                            width: double.parse(
                                                                e.width!),
                                                            color: Colors
                                                                .transparent,
                                                            child: Center(
                                                              child: Text(
                                                                e.text!,
                                                                style: GoogleFonts.getFont(e.name ==
                                                                            "Raleway_regular"
                                                                        ? "Raleway"
                                                                        : e.name ==
                                                                                "PlayfairDisplay_regular"
                                                                            ? "Playfair Display"
                                                                            : e.name == "OpenSansCondensed_300"
                                                                                ? "Open Sans Condensed"
                                                                                : e.name == "Anton_regular"
                                                                                    ? "Anton"
                                                                                    : e.name == "BebasNeue_regular"
                                                                                        ? "Bebas Neue"
                                                                                        : e.name == "DancingScript_regular"
                                                                                            ? "Dancing Script"
                                                                                            : e.name == "AmaticaSC_regular"
                                                                                                ? "Amatica SC"
                                                                                                : e.name == "Sacramento_regular"
                                                                                                    ? "Sacramento"
                                                                                                    : e.name == "SpecialElite_regular"
                                                                                                        ? "Special Elite"
                                                                                                        : e.name == "PoiretOne_regular"
                                                                                                            ? "Poiret One"
                                                                                                            : e.name == "Monoton_regular"
                                                                                                                ? "Monoton"
                                                                                                                : e.name == "FingerPaint_regular"
                                                                                                                    ? "Finger Paint"
                                                                                                                    : e.name == "VastShadow_regular"
                                                                                                                        ? "Vast Shadow"
                                                                                                                        : e.name == "Flavors_regular"
                                                                                                                            ? "Flavors"
                                                                                                                            : e.name == "RibeyeMarrow_regular"
                                                                                                                                ? "Ribeye Marrow"
                                                                                                                                : e.name == "Jomhuria_regular"
                                                                                                                                    ? "Jomhuria"
                                                                                                                                    : e.name == "ZillaSlabHighlight_regular"
                                                                                                                                        ? "Zilla Slab Highlight"
                                                                                                                                        : e.name == "Monofett_regular"
                                                                                                                                            ? "Monofett"
                                                                                                                                            : "Roboto")
                                                                    .copyWith(fontWeight: FontWeight.bold, color: Color.fromRGBO(int.parse(e.color!.split(",")[0]), int.parse(e.color!.split(",")[1]), int.parse(e.color!.split(",")[2]), 1), fontSize: 16.0.sp),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                textScaleFactor:
                                                                    double.parse(
                                                                        e.scale!),
                                                              ),
                                                            ),
                                                          )),
                                                    ))
                                                .toList(),
                                          )
                                        : Container(),
                                    allFiles[index].link != ""
                                        ? Positioned.fill(
                                            bottom: 10,
                                            child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_up_outlined,
                                                      color: Colors.white,
                                                      size: 4.0.h,
                                                    ),
                                                    Container(
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 8,
                                                                horizontal: 10),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                            "Swipe Up",
                                                          ),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  10.0.sp),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )))
                                        : Container()
                                  ],
                                );
                              }),
                        ),
                        Positioned(
                          top: 10.0,
                          left: 10.0,
                          right: 10.0,
                          child: Row(
                            children: allFiles
                                .asMap()
                                .map((key, value) => MapEntry(
                                    key,
                                    AnimatedBar(
                                      animController: _animationController!,
                                      position: key,
                                      currentIndex: _currentIndex,
                                    )))
                                .values
                                .toList(),
                          ),
                        ),
                        Positioned(
                          top: 30.0,
                          left: 10.0,
                          right: 10.0,
                          child: Row(children: [
                            Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                border: new Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 2.5.h,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(widget
                                    .highlights!.firstImageOrVideo!
                                    .replaceAll(".mp4", ".jpg")),
                              ),
                            ),
                            SizedBox(
                              width: 4.0.w,
                            ),
                            Text(
                              widget.highlights!.highlightText!,
                              style: whiteBold.copyWith(fontSize: 10.0.sp),
                            ),
                            SizedBox(
                              width: 4.0.w,
                            ),
                            Text(
                              allFiles[_currentIndex].timeStamp!,
                              style: whiteNormal.copyWith(fontSize: 10.0.sp),
                            )
                          ]),
                        ),
                        Positioned(
                          right: widget.highlights!.memberId ==
                                  CurrentUser().currentUser.memberID
                              ? 25.0
                              : 10.0,
                          bottom: 8.0,
                          left: 10.0,
                          child: widget.highlights!.memberId ==
                                  CurrentUser().currentUser.memberID
                              ? HighlightBottomMenu(
                                  share: () async {
                                    Uri uri =
                                        await DeepLinks.createHighlightDeepLink(
                                            widget.highlights!.memberId!,
                                            "highlight",
                                            allFiles[_currentIndex]
                                                .image!
                                                .replaceAll(".mp4", ".jpg")
                                                .replaceAll("/compressed", ""),
                                            widget.highlights!.highlightText!,
                                            "${widget.highlights!.shortcode}",
                                            "",
                                            widget.index.toString());
                                    Share.share(
                                      '${uri.toString()}',
                                    );
                                  },
                                  openMore: () {
                                    timer!.pause();
                                    _animationController!.stop();
                                    if (controller != null &&
                                        allFiles[_currentIndex].video == 1) {
                                      controller!.pause();
                                    }
                                    showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20.0),
                                                topRight: const Radius.circular(
                                                    20.0))),
                                        //isScrollControlled:true,
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return HighlightsBottomTile(
                                            shareTo: () async {
                                              Navigator.pop(context);
                                              Uri uri = await DeepLinks
                                                  .createHighlightDeepLink(
                                                      widget.highlights!
                                                          .memberId!,
                                                      "highlight",
                                                      allFiles[_currentIndex]
                                                          .image!
                                                          .replaceAll(
                                                              ".mp4", ".jpg")
                                                          .replaceAll(
                                                              "/compressed", ""),
                                                      widget.highlights!
                                                          .highlightText!,
                                                      "${widget.highlights!.shortcode}",
                                                      "",
                                                      widget.index.toString());
                                              Share.share(
                                                '${uri.toString()}',
                                              );
                                            },
                                            copyLink: () async {
                                              Navigator.pop(context);
                                              Uri uri = await DeepLinks
                                                  .createHighlightDeepLink(
                                                      widget.highlights!
                                                          .memberId!,
                                                      "highlight",
                                                      allFiles[_currentIndex]
                                                          .image!
                                                          .replaceAll(
                                                              ".mp4", ".jpg")
                                                          .replaceAll(
                                                              "/compressed", ""),
                                                      widget.highlights!
                                                          .highlightText!,
                                                      "${widget.highlights!.shortcode}",
                                                      "",
                                                      widget.index.toString());
                                              Clipboard.setData(ClipboardData(
                                                  text: uri.toString()));
                                              Fluttertoast.showToast(
                                                msg: AppLocalizations.of(
                                                  "Link Copied",
                                                ),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.7),
                                                textColor: Colors.white,
                                                fontSize: 18.0,
                                              );
                                            },
                                            remove: () {
                                              Navigator.pop(context);

                                              removeStory(
                                                  allFiles[_currentIndex]
                                                      .storyId!,
                                                  allFiles[_currentIndex]
                                                      .postId!,
                                                  widget.highlights!
                                                      .highlightId!);
                                              Fluttertoast.showToast(
                                                msg: "Removed from " +
                                                    widget.highlights!
                                                        .highlightText!,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.7),
                                                textColor: Colors.white,
                                                fontSize: 13.0,
                                              );
                                              if (allFiles.length > 1) {
                                                setState(() {
                                                  allFiles
                                                      .removeAt(_currentIndex);
                                                });
                                              } else {
                                                Navigator.pop(context);
                                                widget.setNavBar!(false);
                                              }
                                            },
                                            edit: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditHighlightExpandedPage(
                                                            //userHighlight: allFiles[_currentIndex],
                                                            setNavbar: widget
                                                                .setNavBar!,
                                                            highlights: widget
                                                                .highlights!,
                                                          )));
                                            },
                                          );
                                        }).whenComplete(() {
                                      timer!.start();
                                      _animationController!.forward();
                                      if (controller != null) {
                                        controller!.play();
                                      }
                                    });
                                  },
                                  storyImage: allFiles[_currentIndex].image,
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        border: new Border.all(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                        shape: BoxShape.rectangle,
                                      ),
                                      width: 80.0.w,
                                      height: 5.5.h,
                                      child: TextFormField(
                                        onChanged: (val) {},
                                        maxLines: null,
                                        controller: _messageController,
                                        cursorHeight: 3.0.h,
                                        cursorColor: Colors.white,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: AppLocalizations.of(
                                            "Send message",
                                          ),

                                          //alignLabelWithHint: true,
                                          contentPadding: EdgeInsets.only(
                                              left: 4.0.w, top: 1.5.h),
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0.sp),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.send,
                                      size: 3.0.h,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
