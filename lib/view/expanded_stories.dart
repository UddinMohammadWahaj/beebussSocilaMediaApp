import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:bizbultest/models/user_highlights_model.dart';
import 'package:bizbultest/models/user_story_list_model.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/utilities/deep_links.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_post.dart';
import 'package:bizbultest/widgets/FeedPosts/upload_video_post_story.dart';
import 'package:bizbultest/widgets/MainPlaylists/single_video_card_playlists.dart';
import 'package:bizbultest/widgets/Newsfeeds/single_feed_post.dart';
import 'package:bizbultest/widgets/Stories/add_to_existing_highlight.dart';
import 'package:bizbultest/widgets/Stories/add_to_highlight.dart';
import 'package:bizbultest/widgets/Stories/animated_bars.dart';
import 'package:bizbultest/widgets/Stories/display_story_tags_and_stickers.dart';
import 'package:bizbultest/widgets/Stories/emojis.dart';
import 'package:bizbultest/widgets/Stories/story_bottom_menu.dart';
import 'package:bizbultest/widgets/Stories/story_bottom_tile_otheruser.dart';
import 'package:bizbultest/widgets/Stories/story_menu_bottom_tile.dart';
import 'package:bizbultest/widgets/Stories/story_views.dart';
import 'package:bizbultest/widgets/Stories/story_widgets.dart';
import 'package:bizbultest/widgets/Stories/timeWidget.dart';
import 'package:bizbultest/widgets/story_video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:preload_page_view/preload_page_view.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../api/ApiRepo.dart' as ApiRepo;

class ExpandedStoriesPage extends StatefulWidget {
  final UserStoryListModel? user;
  final Function? setNavBar;
  final Function? animate;
  final VoidCallback? goToProfile;
  final Function? profilePage;
  final Function? refreshFeeds;
  final Function? changePage;
  AudioPlayer? musicplayer;
  ExpandedStoriesPage(
      {Key? key,
      this.setNavBar,
      this.user,
      this.animate,
      this.changePage,
      this.goToProfile,
      this.musicplayer,
      this.profilePage,
      this.refreshFeeds})
      : super(key: key);

  @override
  _ExpandedStoriesPageState createState() => _ExpandedStoriesPageState();
}

class _ExpandedStoriesPageState extends State<ExpandedStoriesPage>
    with SingleTickerProviderStateMixin {
  late PausableTimer timer;
  late ExpandedStories storiesList;
  bool areStoriesLoaded = false;
  late PreloadPageController _pageController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  int length = 0;
  List<FileElement> allFiles = [];
  var musicplayer = AudioPlayer();
  TextEditingController _messageController = TextEditingController();
  bool animate = true;
  late VideoPlayerController controller;
  bool keyboardVisible = false;
  GlobalKey _globalKey = new GlobalKey();
  bool addNewHighlight = false;
  bool isBack = false;

  TextStyle style = GoogleFonts.roboto();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  late UserHighlightsList userHighlightsList;
  bool areUserHighlightsLoaded = false;

  late String dir;

  Future getDirectory() async {
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/MyImages';
    setState(() {
      dir = myImagePath;
    });
    final myImgDir = await new Directory(myImagePath).create();
  }

  Future<void> getUserHighlights() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_heighlight_data.php?action=get_highlight_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}");

    // var response = await http.get(url);

    var response = await ApiRepo.postWithToken("api/storyDataDetailHighlight", {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
    });

    if (response!.success == 1) {
      UserHighlightsList userHighlightData =
          UserHighlightsList.fromJson(response!.data['data']);
      /*   await Future.wait(
          userHighlightData.highlights.map((e) => Preload.cacheImage(context, e.firstImageOrVideo?.replaceAll(".mp4", ".jpg"))).toList());*/
      if (mounted) {
        setState(() {
          userHighlightsList = userHighlightData;
          areUserHighlightsLoaded = true;
        });
      }
    }
    if (response!.data == null ||
        response!.data['data'] == null ||
        response!.data['data'] == "") {
      if (mounted) {
        setState(() {
          areUserHighlightsLoaded = false;
        });
      }
    }
  }

  // ignore: missing_return
  Future<Uint8List?> _capturePng() async {
    try {
      print('inside');
      // RenderObject? boundary = _globalKey.currentContext!.findRenderObject();

      final RenderRepaintBoundary? boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary!.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      print('png done');
      final newImage = img.decodeImage(pngBytes);
      final directory = await getExternalStorageDirectory();
      final myImagePath = '${directory!.path}/MyImages';
      final myImgDir = await new Directory(myImagePath).create();
      File finalImage = new File("$myImagePath/${generateRandomString(10)}.jpg")
        ..writeAsBytesSync(img.encodeJpg(newImage!, quality: 95));
      GallerySaver.saveImage(finalImage.path);
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getStories() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_story_data.php?action=story_data_details&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&story_user_id=${widget.user.memberId}");

    // var response = await http.get(url);

    var newurl = 'https://www.bebuzee.com/api/storyDataDetails';
    print("story--get stories called");
    var response = await ApiProvider().fireApiWithParamsPost(newurl, params: {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "story_user_id":
          widget.user!.memberId ?? CurrentUser().currentUser.memberID,
    }).then((value) => value);

    // var response = await ApiRepo.postWithToken("api/story_data_details.php", {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "country": CurrentUser().currentUser.country,
    //   "story_user_id": widget.user.memberId,
    // });
    print(
        "expanded story responsea=${response!.data} userid=${CurrentUser().currentUser.memberID} story_user_id=${widget.user!.memberId} country=${CurrentUser().currentUser.country} ");
    if (response != null && response!.data['success'] == 1) {
      ExpandedStories storyData =
          ExpandedStories.fromJson(response!.data['data']);
      allFiles = [];

      for (int i = 0; i < storyData.stories.length; i++) {
        for (int j = 0; j < storyData.stories[i].files!.length; j++) {
          if (mounted) {
            print("story id =${storyData.stories[i].files![j].storyId}");
            setState(() {
              allFiles.add(storyData.stories[i].files![j]);
            });
          }
        }
      }
      print("story--get stories called length=${allFiles.length}");
      await Future.wait(allFiles
          .map((e) => PreloadCached.cacheImage(
              context,
              e.image!
                  .replaceAll(".mp4", ".jpg")
                  .replaceAll("/compressed", "")))
          .toList());
      print("story--get stories called length=${allFiles.length} aha");

      if (mounted) {
        setState(() {
          areStoriesLoaded = true;
          allFiles.forEach((element) {
            screenshotController.add(new ScreenshotController());
          });
        });
        setState(() {
          duration = new Duration(
                  seconds: allFiles[_currentIndex].musicData!.length != 0
                      ? 15
                      : allFiles[_currentIndex].video == 0
                          ? 5
                          : 15)
              .inSeconds;

          print("story--get stories called duration=${duration}");
        });
      }

      print(allFiles.length.toString() + "  lenghttttt of alll filesssss");
      _loadStory(animateToPage: false);
      startTimer();
      viewCount(allFiles[0].storyId!, allFiles[0].id!);
    }
  }

  void _loadStory({bool animateToPage = true}) {
    if (mounted) {
      setState(() {
        duration = (allFiles[_currentIndex].musicData!.length != 0
            ? 15
            : allFiles[_currentIndex].video == 0
                ? 5
                : allFiles[_currentIndex].videoDuration)!;
      });
    }
    _animationController.stop();
    _animationController.reset();
    _animationController.duration = new Duration(seconds: duration);
    _animationController.forward();
    if (animateToPage && animate) {
      _pageController.animateToPage(_currentIndex,
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

  void startTimer() async {
    if (allFiles[_currentIndex].musicData != '' &&
        allFiles[_currentIndex].musicData != null) {
      playMusic();
    }
    print("start timer caller");
    if (mounted) {
      setState(() {
        duration = (allFiles[_currentIndex].musicData != '' &&
                allFiles[_currentIndex].musicData != null
            ? 15
            : allFiles[_currentIndex].video == 0
                ? 5
                : allFiles[_currentIndex].videoDuration)!;

        print("start timer caller $duration");
        timer = PausableTimer(Duration(seconds: duration), () {
          if (mounted) {
            if (_currentIndex + 1 < allFiles.length) {
              endMusic();
              _currentIndex += 1;
            } else {
              if (timer.duration >= Duration(seconds: duration)) {
                musicplayer.dispose();
                widget.changePage!(msg: 'here in change page 3');
              }
              _currentIndex = 0;
            }
          }
          _loadStory();
          duration = (allFiles[_currentIndex].musicData!.length != 0
              ? 15
              : allFiles[_currentIndex].video == 0
                  ? 5
                  : allFiles[_currentIndex].videoDuration)!;
          viewCount(
              allFiles[_currentIndex].storyId!, allFiles[_currentIndex].id!);
          print("exeeee");
          startTimer();
        });
      });
    }
    timer.start();
  }

  int duration = 0;
//TODO :: inSheet 122
  Future<void> viewCount(int storyID, String postID) async {
    // var url =
    //     "https://www.bebuzee.com/api/story_update_view.php?action=story_update_view&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&story_user_id=${widget.user.memberId}&post_id=$postID&story_id=$storyID";

    var url =
        "https://www.bebuzee.com/api/storyViewUpdate?action=story_update_view&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&story_user_id=${widget.user!.memberId}&post_id=$postID&story_id=$storyID";
    print("view countr url=${url}");
    var response = await ApiProvider().fireApi(url);

    if (response!.statusCode == 200) {
      print('view count= ${response!.data['data']}');
    }
  }

//TODO :: inSheet 245
  Future<void> deleteStory(int storyID, String postID) async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_story_data.php?action=delete_story_data&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&post_id=$postID&story_id=$storyID");

    // var response = await http.get(url);
    print("delete story called");
    var url = "https://www.bebuzee.com/api/storyDataDelete";
    var params = {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "post_id": postID,
      "story_id": storyID,
    };
    var response;
    try {
      response = await ApiProvider()
          .fireApiWithParamsPost(url, params: params)
          .then((value) => value);
    } catch (e) {
      print("story delete respsonse=${e}");
    }
    // var response = await ApiRepo.postWithToken("api/delete_story_data.php", {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "country": CurrentUser().currentUser.country,
    //   "post_id": postID,
    //   "story_id": storyID,
    // });
    print("story delete respsonse=${response!.data}");
    if (response!.data == 1) {
      print(response!.data);
    }
  }

  late Uint8List _imageFile;
  List<ScreenshotController> screenshotController = [];

  void _pause() {
    print("pausssed");

    setState(() {
      _animationController.stop();
      timer.pause();
      if (controller != null && allFiles[_currentIndex].video == 1) {
        controller.pause();
      }
    });
  }

  Widget _postCard(int index) {
    return Center(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            allFiles[index].postParameters![0].shortcode != ""
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      "${allFiles[index].postParameters![0].blogTitle}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Georgie"),
                    ),
                  )
                : Container(),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: GestureDetector(
                onTap: () {
                  OtherUser().otherUser.memberID =
                      allFiles[index].postParameters![0].memberId;
                  OtherUser().otherUser.shortcode =
                      allFiles[index].postParameters![0].shortcode;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SingleFeedPost(
                                memberID:
                                    allFiles[index].postParameters![0].memberId,
                                postID:
                                    allFiles[index].postParameters![0].postId,
                                setNavBar: (bool val) {},
                                refresh: () {},
                                changeColor: () {},
                                isChannelOpen: () {},
                              )));
                },
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Image(
                    image: CachedNetworkImageProvider(allFiles[index]
                        .postParameters![0]
                        .thumbnailUrl!
                        .replaceAll(".mp4", "")),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "@${allFiles[index].postParameters![0].shortcode}",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),
      ),
    );
  }

  final _controller = TextEditingController();

  bool isTapOnQuestion = false;
  @override
  void initState() {
    // getStories();
    print("entered expanded stories page");
    _pageController = PreloadPageController();
    _animationController = AnimationController(vsync: this);
    getUserHighlights();
    getDirectory();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted) {
        setState(() {
          keyboardVisible = visible;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    print("disposeeeeee");
    endMusic();
    /*_pageController.dispose();
    _animationController.dispose();
    if (controller != null) {
      controller.dispose();
    }*/
    super.dispose();
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
                color: Colors.grey,
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
          // print('here is story ${allFiles[_currentIndex].video}');

          if (visibility.visibleFraction == 0) {
            print(
                "visibility music-${visibility.visibleFraction} ${musicplayer.playing}");
            musicplayer.pause();
            print("pauseeeeeee");

            if (_animationController != null) {
              _animationController.reset();
            }
            if (timer != null) {
              timer.pause();
            }
            if (controller != null && allFiles[_currentIndex].video == 1) {
              controller.pause();
            }
          } else if (visibility.visibleFraction > 0 && !keyboardVisible) {
            print('am here music visibility');
            if (!areStoriesLoaded) {
              getStories();
            }

            if (_animationController != null) {
              _animationController.duration = new Duration(seconds: duration);
              _animationController.forward();
            }
            if (timer != null) {
              timer.reset();
              timer.start();
            }
            if (controller != null && allFiles[_currentIndex].video == 1) {
              controller.play();
            }
            if (controller != null && allFiles[_currentIndex].musicData != '') {
              print('am here music');
              musicplayer.play();
            }
          }
        },
        child: Container(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isTapOnQuestion = false;
              });
            },
            onLongPress: () {
              setState(() {
                animate = false;
              });
              if (controller != null && allFiles[_currentIndex].video == 1) {
                controller.pause();
              }
              _animationController.stop();
              timer.pause();
            },
            onLongPressStart: (details) {
              setState(() {
                animate = false;
              });
              _animationController.stop();
              timer.pause();
              if (controller != null && allFiles[_currentIndex].video == 1) {
                controller.pause();
              }
            },
            onLongPressMoveUpdate: (details) {
              print("move update next page");
              setState(() {
                animate = false;
              });
              if (controller != null && allFiles[_currentIndex].video == 1) {
                controller.pause();
              }
              _animationController.stop();
              timer.pause();
            },
            onLongPressEnd: (details) {
              setState(() {
                animate = true;
              });
              if (controller != null && allFiles[_currentIndex].video == 1) {
                controller.play();
              }

              _animationController.forward();
              timer.start();
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
                                  timePosX = double.tryParse(item.posx!);
                                  timePosY = double.tryParse(item.posy!);
                                  timedateTime = item.name;
                                  if (timedateTime == "") {
                                    isTimeViewOn = false;
                                  }
                                }
                                //   isTimeViewOn = true;
                                //   timeScale = double.tryParse(time[index].split("^^")[4]) ??1.0;

                                //   timeRotation = double.tryParse(time[index].split("^^")[5]) ?? 1.0;

                                //   timePosX = double.tryParse(time[index] .split("^^")[2]) ?? 0.0;

                                //   timePosY = double.tryParse(time[index].split("^^")[3]) ?? 0.0;

                                //   timedateTime= time[index].split("^^")[1];
                                //   if(timedateTime==""){
                                //     isTimeViewOn=false;
                                //   }
                                // }
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

                                // if (allFiles[index].hashtag != null &&
                                //     allFiles[index].hashtag != "") {
                                //   isHashTagViewOn = true;
                                //   hashTagScale = double.tryParse(allFiles[index]
                                //           .hashtag
                                //           .split("^^")[3]) ??
                                //       1.0;
                                //   hashTagRotation = double.tryParse(
                                //           allFiles[index]
                                //               .hashtag
                                //               .split("^^")[4]) ??
                                //       1.0;
                                //   hashTagPosX = double.tryParse(allFiles[index]
                                //           .hashtag
                                //           .split("^^")[1]) ??
                                //       0.0;
                                //   hashTagPosY = double.tryParse(allFiles[index]
                                //           .hashtag
                                //           .split("^^")[2]) ??
                                //       0.0;
                                //   hashTagTextData = "#" +
                                //       allFiles[index].hashtag.split("^^")[0];
                                // }

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
                                      double.tryParse(item!.posy!);
                                  locationTextTextData =
                                      item.name!.replaceAll("@@@", "");
                                  if (locationTextTextData == "") {
                                    islocationTextViewOn = false;
                                  }
                                }

                                // if (allFiles[index].locationtext != null &&
                                //     allFiles[index].locationtext != "") {
                                //   islocationTextViewOn = true;
                                //   locationTextScale = double.tryParse(
                                //           allFiles[index]
                                //               .locationtext
                                //               .split("^^")[3]) ??
                                //       1.0;
                                //   locationTextRotation = double.tryParse(
                                //           allFiles[index]
                                //               .locationtext
                                //               .split("^^")[4]) ??
                                //       1.0;
                                //   locationTextPosX = double.tryParse(
                                //           allFiles[index]
                                //               .locationtext
                                //               .split("^^")[1]) ??
                                //       0.0;
                                //   locationTextPosY = double.tryParse(
                                //           allFiles[index]
                                //               .locationtext
                                //               .split("^^")[2]) ??
                                //       0.0;
                                //   locationTextTextData = allFiles[index]
                                //       .locationtext
                                //       .split("^^")[0]
                                //       .replaceAll("@@@", ", ");
                                // }

                                var questionsTextScale,
                                    questionsTextRotation,
                                    questionsTextPosX,
                                    questionsTextPosY,
                                    questionsTextTextData;
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
                                  print(
                                      "allFiles[index].musicPosData=${allFiles[index].musicPosData}");
                                  var item = allFiles[index].musicPosData;
                                  musicScale =
                                      double.tryParse(item!.scale ?? "1.0");
                                  musicRotation =
                                      double.tryParse(item!.rotation ?? "0.0");
                                  musicPosX =
                                      double.tryParse(item!.posx ?? "0.0");
                                  musicPosY =
                                      double.tryParse(item!.posy ?? "0.0");

                                  print(
                                      "haha music = x=${musicPosX} y=${musicPosY} ");
                                }

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
                                      item.name!.replaceAll("@@@", "#");
                                  if (questionsTextTextData == "") {
                                    isquestionsTextViewOn = false;
                                  }
                                }
                                // if (allFiles[index].questionstext != null &&
                                //     allFiles[index].questionstext != "") {
                                //   isquestionsTextViewOn = true;
                                //   questionsTextScale = double.tryParse(
                                //           allFiles[index]
                                //               .questionstext
                                //               .split("^^")[3]) ??
                                //       1.0;
                                //   questionsTextRotation = double.tryParse(
                                //           allFiles[index]
                                //               .questionstext
                                //               .split("^^")[4]) ??
                                //       1.0;
                                //   questionsTextPosX = double.tryParse(
                                //           allFiles[index]
                                //               .questionstext
                                //               .split("^^")[1]) ??
                                //       0.0;
                                //   questionsTextPosY = double.tryParse(
                                //           allFiles[index]
                                //               .questionstext
                                //               .split("^^")[2]) ??
                                //       0.0;
                                //   questionsTextTextData = allFiles[index]
                                //       .questionstext
                                //       .split("^^")[0]
                                //       .replaceAll("@@@", "");
                                // }
                                var questionsReplyTextScale,
                                    questionsReplyTextRotation,
                                    questionsReplyTextPosX,
                                    questionsReplyTextPosY;
                                String? questionsReplyTextTextData;
                                bool isquestionsReplyTextViewOn = false;
                                // if (allFiles[index].questionsReplyData !=
                                //         null &&
                                //     allFiles[index].questionsReplyData != "") {
                                //   isquestionsReplyTextViewOn = true;
                                //   questionsReplyTextScale = double.tryParse(
                                //           allFiles[index]
                                //               .questionsReplyData
                                //               .split("^^")[3]) ??
                                //       1.0;
                                //   questionsReplyTextRotation = double.tryParse(
                                //           allFiles[index]
                                //               .questionsReplyData
                                //               .split("^^")[4]) ??
                                //       1.0;
                                //   questionsReplyTextPosX = double.tryParse(
                                //           allFiles[index]
                                //               .questionsReplyData
                                //               .split("^^")[1]) ??
                                //       0.0;
                                //   questionsReplyTextPosY = double.tryParse(
                                //           allFiles[index]
                                //               .questionsReplyData
                                //               .split("^^")[2]) ??
                                //       0.0;
                                //   questionsReplyTextTextData = allFiles[index]
                                //       .questionsReplyData
                                //       .split("^^")[0]
                                //       .replaceAll("@@@", "");
                                // }

                                // var hashTagScale, hashTagRotation, hashTagPosX, hashTagPosY, hashTagTextData;
                                bool isMantionViewOn = false;
                                allFiles[index].mantion;
                                List<Sticker> mantionList =
                                    allFiles[index].mantion!;
                                if (allFiles[index].mantion != null &&
                                    allFiles[index].mantion!.isNotEmpty) {
                                  isMantionViewOn = true;
                                }

                                return Screenshot(
                                  controller: screenshotController[index],
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        allFiles[index].fromFeed!
                                            ? Container()
                                            : Container(
                                                height: 90.0.h,
                                                width: 100.0.w,
                                                child: allFiles[index].video ==
                                                        0
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                allFiles[index]
                                                                    .image!!),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                          child: BackdropFilter(
                                                            filter: ImageFilter
                                                                .blur(
                                                                    sigmaX: 50,
                                                                    sigmaY: 50),
                                                            child: Stack(
                                                              fit: StackFit
                                                                  .expand,
                                                              children: [
                                                                if (isimageViewOn)
                                                                  Positioned
                                                                      .fill(
                                                                    top: posY,
                                                                    left: posX,
                                                                    child:
                                                                        Transform(
                                                                      transform: new Matrix4
                                                                          .diagonal3(new v
                                                                              .Vector3(
                                                                          scale,
                                                                          scale,
                                                                          scale))
                                                                        ..rotateZ(
                                                                            rotation),
                                                                      alignment:
                                                                          FractionalOffset
                                                                              .center,
                                                                      child:
                                                                          Transform(
                                                                        transform: new Matrix4
                                                                            .diagonal3(new v
                                                                                .Vector3(
                                                                            scale,
                                                                            scale,
                                                                            scale)),
                                                                        alignment:
                                                                            FractionalOffset.center,
                                                                        child:
                                                                            Image(
                                                                          image:
                                                                              CachedNetworkImageProvider(allFiles[index].image!),
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                else
                                                                  Image(
                                                                    image: CachedNetworkImageProvider(
                                                                        allFiles[index]
                                                                            .image!),
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : StoryVideoPlayerAutoPlay(
                                                        volume: allFiles[index]
                                                                    .musicData !=
                                                                ''
                                                            ? false
                                                            : true,
                                                        setController:
                                                            (storyVideoController) {
                                                          setState(() {
                                                            controller =
                                                                storyVideoController;
                                                          });
                                                        },
                                                        url: allFiles[index]
                                                            .image!,
                                                      ),
                                              ),
                                        allFiles[index].backgroundColors !=
                                                    null &&
                                                allFiles[index]
                                                        .backgroundColors !=
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
                                                        gradient:
                                                            LinearGradient(
                                                          colors:
                                                              "0612FA,E2821E"
                                                                  .split(',')
                                                                  .map((e) =>
                                                                      HexColor(
                                                                          e))
                                                                  .toList(),
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        ),
                                                      )
                                                    : null,
                                              )
                                            : Container(),
                                        allFiles[index].stickers!.length > 0
                                            ? Stack(
                                                children: allFiles[index]
                                                    .stickers!
                                                    .map((e) =>
                                                        DisplayStoryStickers(
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
                                              alignment:
                                                  FractionalOffset.center,
                                              child: Center(
                                                child: StoryTimeWidget(
                                                  dateData: DateTime.parse(
                                                      timedateTime),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (isHashTagViewOn)
                                          Positioned.fill(
                                            top: hashTagPosY,
                                            left: hashTagPosX,
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
                                                          hashTagScale),
                                                      padding:
                                                          EdgeInsets.all(7),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .2),
                                                            offset:
                                                                Offset(0, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Text(
                                                        hashTagTextData
                                                                ?.toUpperCase() ??
                                                            "",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: GoogleFonts
                                                                .rajdhani()
                                                            .copyWith(
                                                          // color: Colors.pink,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,

                                                          foreground: Paint()
                                                            ..shader =
                                                                LinearGradient(
                                                              colors: <Color>[
                                                                Colors.orange,
                                                                Colors.pink
                                                              ],
                                                              begin: Alignment
                                                                  .bottomLeft,
                                                              end: Alignment
                                                                  .topRight,
                                                            ).createShader(Rect
                                                                    .largest),
                                                        ),
                                                        textScaleFactor:
                                                            hashTagScale,
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
                                                      padding:
                                                          EdgeInsets.all(7),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .2),
                                                            offset:
                                                                Offset(0, 2),
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
                                                            begin: Alignment
                                                                .topLeft,
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
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                            Text(
                                                              locationTextTextData
                                                                  .toUpperCase(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                      .rajdhani()
                                                                  .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                        if (isMantionViewOn)
                                          ...mantionList
                                              .map((e) => Positioned.fill(
                                                    top:
                                                        // -68.66666666666657

                                                        double.tryParse(
                                                                e.posy!) ??
                                                            0,
                                                    left:
                                                        //  -449.6666666666671

                                                        double.tryParse(
                                                                e.posx!) ??
                                                            0,
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      // transform: Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)..rotateZ(hashtagViewData.rotation),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    0.0.w,
                                                                vertical:
                                                                    5.0.h),
                                                        child: Container(
                                                          color: Colors
                                                              .transparent,
                                                          child: Center(
                                                            child: Container(
                                                              key: ValueKey(
                                                                  hashTagScale),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(7),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .2),
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2),
                                                                    blurRadius:
                                                                        3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Text(
                                                                e.name ??
                                                                    "".toUpperCase(),
                                                                softWrap: false,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts
                                                                        .rajdhani()
                                                                    .copyWith(
                                                                  // color: Colors.pink,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,

                                                                  foreground:
                                                                      Paint()
                                                                        ..shader =
                                                                            LinearGradient(
                                                                          colors: <
                                                                              Color>[
                                                                            Colors.orange,
                                                                            Colors.amber
                                                                          ],
                                                                          begin:
                                                                              Alignment.bottomLeft,
                                                                          end: Alignment
                                                                              .topRight,
                                                                        ).createShader(Rect.largest),
                                                                ),
                                                                textScaleFactor:
                                                                    double.tryParse(
                                                                            e.scale!) ??
                                                                        0,
                                                              ),
                                                              // height: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        allFiles[index].link != ""
                                            ? SwipeToOpenLink()
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print("previous");
                                                      setState(() {
                                                        musicplayer.stop();
                                                        duration = allFiles[
                                                                        _currentIndex]
                                                                    .musicData!
                                                                    .length! !=
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
                                                      if (_currentIndex - 1 >=
                                                          0) {
                                                        setState(() {
                                                          _currentIndex -= 1;
                                                        });

                                                        timer.cancel();
                                                        startTimer();
                                                        _loadStory();
                                                        viewCount(
                                                            allFiles[
                                                                    _currentIndex]
                                                                .storyId!,
                                                            allFiles[
                                                                    _currentIndex]
                                                                .id!);
                                                        print(allFiles[
                                                                _currentIndex]
                                                            .storyId);
                                                      }
                                                    },
                                                    child: Container(
                                                      color:
                                                          //  allFiles[
                                                          //             _currentIndex]
                                                          //         .fromFeed
                                                          //     ? HexColor(allFiles[
                                                          //             _currentIndex]
                                                          //         .postParameters[0]
                                                          //         .color)
                                                          // :
                                                          Color(0xFF42A5F5)
                                                              .withOpacity(0),
                                                      width: 50.0.w,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        animate
                                            ? Positioned.fill(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print("next");
                                                      musicplayer.stop();
                                                      setState(() {
                                                        duration = (allFiles[
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
                                                                    .videoDuration)!;
                                                      });

                                                      if (_currentIndex + 1 <
                                                          allFiles.length) {
                                                        setState(() {
                                                          _currentIndex += 1;
                                                        });
                                                        timer.cancel();
                                                        startTimer();
                                                        _loadStory();
                                                        viewCount(
                                                            allFiles[
                                                                    _currentIndex]
                                                                .storyId!,
                                                            allFiles[
                                                                    _currentIndex]
                                                                .id!);
                                                        print(allFiles[
                                                                _currentIndex]
                                                            .storyId);
                                                      } else {
                                                        musicplayer.dispose();
                                                        widget.changePage!();

                                                        setState(() {
                                                          _currentIndex = 0;
                                                        });
                                                        timer.cancel();
                                                        startTimer();
                                                        _loadStory();
                                                        viewCount(
                                                            allFiles[
                                                                    _currentIndex]
                                                                .storyId!,
                                                            allFiles[
                                                                    _currentIndex]
                                                                .id!);
                                                        print(allFiles[
                                                                _currentIndex]
                                                            .storyId);
                                                      }
                                                    },
                                                    child: Container(
                                                      color:
                                                          //  allFiles[
                                                          //             _currentIndex]
                                                          //         .fromFeed
                                                          //     ? HexColor(allFiles[
                                                          //             _currentIndex]
                                                          //         .postParameters[0]
                                                          //         .color)
                                                          // :
                                                          Colors.transparent,
                                                      width: 50.0.w,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        allFiles[index].fromFeed!
                                            ? _postCard(index)
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
                                                                vertical:
                                                                    5.0.h),
                                                        child: Container(
                                                            // width: 100.0.w,
                                                            color: Colors
                                                                .transparent,
                                                            child: Center(
                                                                child: allFiles[_currentIndex]
                                                                            .musicStyle !=
                                                                        "liststyle"
                                                                    ? Container(
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                7),
                                                                        height:
                                                                            30.0
                                                                                .h,
                                                                        width: 40.0
                                                                            .w,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.transparent,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black.withOpacity(0),
                                                                              offset: Offset(0, 2),
                                                                              blurRadius: 3,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Colors.transparent,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              CachedNetworkImage(imageUrl: musicData[2].toString().replaceFirst('{w}', '200').replaceFirst('{h}', '200')),
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
                                                                        padding:
                                                                            EdgeInsets.all(
                                                                                10),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black.withOpacity(.2),
                                                                              offset: Offset(0, 2),
                                                                              blurRadius: 3,
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
                                                                          color:
                                                                              Colors.white,
                                                                          child:
                                                                              Expanded(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        if (isquestionsTextViewOn)
                                          Positioned.fill(
                                            top: isTapOnQuestion &&
                                                    keyboardVisible
                                                ? 0
                                                : questionsTextPosY,
                                            left: isTapOnQuestion &&
                                                    keyboardVisible
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
                                                      padding:
                                                          EdgeInsets.all(7),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .2),
                                                            offset:
                                                                Offset(0, 2),
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
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .70,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          15),
                                                                  child: Text(
                                                                    questionsTextTextData,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
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
                                                                            .circular(7),
                                                                  ),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
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
                                                                              TextAlign.center,
                                                                          textCapitalization:
                                                                              TextCapitalization.sentences,
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
                                                                              color: Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      IconButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await DirectApiCalls().questionReplyFromStory(
                                                                              widget.user!.memberId!,
                                                                              _controller.text,
                                                                              allFiles[index].id!,
                                                                              allFiles[index].storyId.toString());
                                                                          FocusScope.of(context)
                                                                              .requestFocus(FocusNode());
                                                                          isTapOnQuestion =
                                                                              false;
                                                                          timer
                                                                              .start();
                                                                          _animationController
                                                                              .forward();
                                                                          if (controller != null &&
                                                                              allFiles[_currentIndex].video == 1) {
                                                                            controller.play();
                                                                          }

                                                                          customToastWhite(
                                                                              AppLocalizations.of(
                                                                                "Reply Sent",
                                                                              ),
                                                                              16.0,
                                                                              ToastGravity.CENTER);
                                                                          _controller
                                                                              .clear();
                                                                        },
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .send,
                                                                          size:
                                                                              25,
                                                                          color:
                                                                              Colors.white,
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
                                                              child:
                                                                  CircleAvatar(
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
                                                            BorderRadius
                                                                .circular(8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .2),
                                                            offset:
                                                                Offset(0, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        // padding: EdgeInsets.all(20),
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
                                                                questionsReplyTextTextData!
                                                                    .split(
                                                                        "~~")[0],
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
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
                                                                      .all(15),
                                                              width: double
                                                                  .infinity,
                                                              child: Center(
                                                                child: Text(
                                                                  questionsReplyTextTextData!
                                                                      .split(
                                                                          "~~")[1],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
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
                                      ],
                                    ),
                                  ),
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
                                      animController: _animationController,
                                      position: key,
                                      currentIndex: _currentIndex,
                                    )))
                                .values
                                .toList(),
                          ),
                        ),
                        widget.user!.image != null
                            ? StackedUserCard(
                                allFiles: allFiles != null
                                    ? allFiles[_currentIndex]
                                    : null,
                                openMenu: () {
                                  timer.pause();
                                  _animationController.stop();
                                  if (controller != null &&
                                      allFiles[_currentIndex].video == 1) {
                                    controller.pause();
                                  }
                                  showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(20.0),
                                              topRight:
                                                  const Radius.circular(20.0))),
                                      //isScrollControlled:true,
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return StoryBottomTileOtherUser(
                                          copyLink: () async {
                                            Navigator.pop(context);
                                            Uri uri = await DeepLinks
                                                .createStoryDeepLink(
                                                    widget.user!.memberId!,
                                                    "story",
                                                    allFiles[_currentIndex]
                                                        .image!
                                                        .replaceAll(
                                                            ".mp4", ".jpg")
                                                        .replaceAll(
                                                            "/compressed", ""),
                                                    "",
                                                    "${widget.user!.shortcode}");
                                            Clipboard.setData(ClipboardData(
                                                text: uri.toString()));
                                            Fluttertoast.showToast(
                                              msg: AppLocalizations.of(
                                                "Link Copied",
                                              ),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.7),
                                              textColor: Colors.white,
                                              fontSize: 18.0,
                                            );
                                          },
                                          shareTo: () async {
                                            Uri uri = await DeepLinks
                                                .createStoryDeepLink(
                                                    widget!.user!.memberId!,
                                                    "story",
                                                    allFiles[_currentIndex]
                                                        .image!
                                                        .replaceAll(
                                                            ".mp4", ".jpg")
                                                        .replaceAll(
                                                            "/compressed", ""),
                                                    "",
                                                    "${widget.user!.shortcode}");
                                            Share.share(
                                              '${uri.toString()}',
                                            );
                                          },
                                        );
                                      }).whenComplete(() {
                                    timer.start();
                                    _animationController.forward();
                                    if (controller != null &&
                                        allFiles[_currentIndex].video == 1) {
                                      controller.play();
                                    }
                                  });
                                },
                                timestamp: allFiles[_currentIndex]
                                    .timeStamp
                                    .toString(),
                                openProfile: widget.goToProfile,
                                user: widget.user,
                              )
                            : Container(),
                        Positioned(
                          right: widget.user!.memberId ==
                                  CurrentUser().currentUser.memberID
                              ? 25.0
                              : 10.0,
                          bottom: 8.0,
                          left: 10.0,
                          child: widget.user!.memberId ==
                                  CurrentUser().currentUser.memberID
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    allFiles[_currentIndex].watchedUserImage !=
                                                "" &&
                                            allFiles[_currentIndex]
                                                    .viewStatus !=
                                                0
                                        ? GestureDetector(
                                            onTap: () async {
                                              timer.pause();
                                              _animationController.stop();
                                              if (controller != null &&
                                                  allFiles[_currentIndex]
                                                          .video ==
                                                      1) {
                                                controller.pause();
                                              }

                                              Uint8List? uniImage =
                                                  await screenshotController[
                                                          _currentIndex]
                                                      .capture();
                                              allFiles[_currentIndex]
                                                  .memoryFile = uniImage!;

                                              // for (var i = 0; i <= screenshotController.length; i++) {
                                              //   Uint8List uniImage = await screenshotController[i].capture();
                                              //   allFiles[i].memoryFile = uniImage;
                                              // }
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoryViewsMainPage(
                                                    goToProfile:
                                                        widget.profilePage,
                                                    startTimer: () {
                                                      timer.start();
                                                      _animationController
                                                          .forward();
                                                      if (controller != null &&
                                                          allFiles[_currentIndex]
                                                                  .video ==
                                                              1) {
                                                        controller.play();
                                                      }
                                                      setState(() {
                                                        _currentIndex = 0;
                                                      });
                                                    },
                                                    index: _currentIndex,
                                                    allFiles: allFiles,
                                                    setNavbar: widget.setNavBar,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: new Border.all(
                                                      color: Colors.grey,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 2.0.h,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    backgroundImage:
                                                        NetworkImage(allFiles[
                                                                _currentIndex]
                                                            .watchedUserImage!),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 0.5.h,
                                                ),
                                                Text(
                                                  AppLocalizations.of(
                                                        "Seen by",
                                                      ) +
                                                      " " +
                                                      allFiles[_currentIndex]
                                                          .count
                                                          .toString(),
                                                  style: whiteBold.copyWith(
                                                      fontSize: 8.0.sp),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    StoryBottomMenu(
                                      share: () async {
                                        Uri uri =
                                            await DeepLinks.createStoryDeepLink(
                                                widget.user!.memberId!,
                                                "story",
                                                allFiles[_currentIndex]
                                                    .image!
                                                    .replaceAll(".mp4", ".jpg")
                                                    .replaceAll(
                                                        "/compressed", ""),
                                                "",
                                                "${widget.user!.shortcode}");
                                        Share.share(
                                          '${uri.toString()}',
                                        );
                                      },
                                      openMore: () {
                                        timer.pause();
                                        _animationController.stop();
                                        if (controller != null &&
                                            allFiles[_currentIndex].video ==
                                                1) {
                                          controller.pause();
                                        }
                                        showModalBottomSheet(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            20.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            20.0))),
                                            //isScrollControlled:true,
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return StoryBottomTileCurrentUser(
                                                copyLink: () async {
                                                  Navigator.pop(context);
                                                  Uri uri = await DeepLinks
                                                      .createStoryDeepLink(
                                                          widget
                                                              .user!.memberId!,
                                                          "story",
                                                          allFiles[
                                                                  _currentIndex]
                                                              .image!
                                                              .replaceAll(
                                                                  ".mp4",
                                                                  ".jpg")
                                                              .replaceAll(
                                                                  "/compressed",
                                                                  ""),
                                                          "",
                                                          "${widget.user!.shortcode}");
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text:
                                                              uri.toString()));
                                                  Fluttertoast.showToast(
                                                    msg: AppLocalizations.of(
                                                      "Link Copied",
                                                    ),
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.7),
                                                    textColor: Colors.white,
                                                    fontSize: 18.0,
                                                  );
                                                },
                                                shareTo: () async {
                                                  Uri uri = await DeepLinks
                                                      .createStoryDeepLink(
                                                          widget
                                                              .user!.memberId!,
                                                          "story",
                                                          allFiles[
                                                                  _currentIndex]
                                                              .image!
                                                              .replaceAll(
                                                                  ".mp4",
                                                                  ".jpg")
                                                              .replaceAll(
                                                                  "/compressed",
                                                                  ""),
                                                          "",
                                                          "${widget.user!.shortcode}");
                                                  Share.share(
                                                    'Bebuzee Story ${uri.toString()}',
                                                  );
                                                },
                                                shareAsPost: () {
                                                  List<File> finalFiles = [];
                                                  List<String> videoImages = [];

                                                  Navigator.pop(context);

                                                  if (allFiles[_currentIndex]
                                                          .video ==
                                                      0) {
                                                    Fluttertoast.showToast(
                                                      msg: AppLocalizations.of(
                                                        "Processing",
                                                      ),
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor: Colors
                                                          .black
                                                          .withOpacity(0.7),
                                                      textColor: Colors.white,
                                                      fontSize: 18.0,
                                                    );

                                                    screenshotController[
                                                            _currentIndex]
                                                        .captureAndSave(
                                                            dir, //set path where screenshot will be saved
                                                            fileName:
                                                                "${generateRandomString(12)}.jpg")
                                                        .then((value) async {
                                                      var newFile =
                                                          await File(value!)
                                                              .create(
                                                                  recursive:
                                                                      true);
                                                      finalFiles.add(newFile);
                                                      final imageBytes = File(
                                                              value!)
                                                          .readAsBytesSync();
                                                      final newImage =
                                                          img.decodeImage(
                                                              imageBytes);
                                                      var cropSize = min(
                                                          newImage!.width,
                                                          newImage!.height);
                                                      //print(cropSize.toString() + " cropsizeeeeee");
                                                      // print(newImage.width.toString() + " widthhhhhhh");
                                                      //print(newImage.height.toString() + " heighttttttt");
                                                      int offsetX = (newImage
                                                                  .width -
                                                              min(
                                                                  newImage
                                                                      .width,
                                                                  newImage
                                                                      .height)) ~/
                                                          2;
                                                      int offsetY = (newImage
                                                                  .height -
                                                              min(
                                                                  newImage
                                                                      .width,
                                                                  newImage
                                                                      .height)) ~/
                                                          2;
                                                      //print(offsetX.toString() + " offsetXxxxxxxxxx");
                                                      // print(offsetY.toString() + " offsetYyyyyyyyyyyyyyyy");

                                                      img.Image destImage =
                                                          img.copyCrop(
                                                              newImage!,
                                                              offsetX,
                                                              offsetY,
                                                              cropSize,
                                                              cropSize);

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      UploadPost(
                                                                        file: allFiles[
                                                                            _currentIndex],
                                                                        isSingleVideoFromStory: allFiles[_currentIndex].video ==
                                                                                0
                                                                            ? false
                                                                            : true,
                                                                        clear:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            finalFiles.clear();
                                                                          });
                                                                        },
                                                                        crop: 1,
                                                                        from:
                                                                            'stories',
                                                                        refresh:
                                                                            widget.refreshFeeds,
                                                                        finalFiles:
                                                                            finalFiles,
                                                                        height:
                                                                            destImage.height,
                                                                        width: destImage
                                                                            .width,
                                                                      )));
                                                    });
                                                  } else {
                                                    videoImages.add(
                                                        allFiles[_currentIndex]
                                                            .image!
                                                            .replaceAll(
                                                                ".mp4", ".jpg")
                                                            .replaceAll(
                                                                "/compressed",
                                                                ""));

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                UploadVideoFromStory(
                                                                    file: allFiles[
                                                                        _currentIndex],
                                                                    isSingleVideoFromStory:
                                                                        true,
                                                                    clear: () {
                                                                      setState(
                                                                          () {
                                                                        videoImages
                                                                            .clear();
                                                                      });
                                                                    },
                                                                    crop: 1,
                                                                    from:
                                                                        'stories',
                                                                    refresh: widget
                                                                        .refreshFeeds,
                                                                    finalFiles:
                                                                        videoImages,
                                                                    height: 0,
                                                                    width: 0)));
                                                  }
                                                },
                                                delete: () {
                                                  if (allFiles.length > 1) {
                                                    deleteStory(
                                                        allFiles[_currentIndex]
                                                            .storyId!,
                                                        allFiles[_currentIndex]
                                                            .id!);
                                                    setState(() {
                                                      allFiles.removeAt(
                                                          _currentIndex);
                                                    });
                                                    setState(() {
                                                      _currentIndex = 0;
                                                    });
                                                    Navigator.pop(context);
                                                    Fluttertoast.showToast(
                                                      msg: AppLocalizations.of(
                                                        "Story Deleted",
                                                      ),
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor: Colors
                                                          .black
                                                          .withOpacity(0.7),
                                                      textColor: Colors.white,
                                                      fontSize: 15.0,
                                                    );
                                                  } else {
                                                    deleteStory(
                                                        allFiles[_currentIndex]
                                                            .storyId!,
                                                        allFiles[_currentIndex]
                                                            .id!);
                                                    Timer(
                                                        Duration(
                                                            milliseconds: 500),
                                                        () {
                                                      print("backkkkk");
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      widget.setNavBar!(false);
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            AppLocalizations.of(
                                                          "Deleted",
                                                        ),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        backgroundColor: Colors
                                                            .black
                                                            .withOpacity(0.7),
                                                        textColor: Colors.white,
                                                        fontSize: 15.0,
                                                      );
                                                    });
                                                  }
                                                },
                                                savePhoto: () {
                                                  Navigator.pop(context);
                                                  if (allFiles[_currentIndex]
                                                          .video ==
                                                      0) {
                                                    _capturePng();
                                                    Fluttertoast.showToast(
                                                      msg: AppLocalizations.of(
                                                        "Saved to gallery",
                                                      ),
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor: Colors
                                                          .black
                                                          .withOpacity(0.7),
                                                      textColor: Colors.white,
                                                      fontSize: 15.0,
                                                    );
                                                  } else {
                                                    GallerySaver.saveVideo(
                                                            allFiles[
                                                                    _currentIndex]
                                                                .image!)
                                                        .then((value) =>
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  AppLocalizations
                                                                      .of(
                                                                "Saved to gallery",
                                                              ),
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              backgroundColor:
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0.7),
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 15.0,
                                                            ));
                                                  }
                                                },
                                              );
                                            }).whenComplete(() {
                                          timer.start();
                                          _animationController.forward();

                                          if (controller != null &&
                                              allFiles[_currentIndex].video ==
                                                  1) {
                                            controller.play();
                                          }
                                        });
                                      },
                                      highlightTap: () {
                                        timer.pause();
                                        _animationController.stop();
                                        if (controller != null &&
                                            allFiles[_currentIndex].video ==
                                                1) {
                                          print("yesssss");
                                          controller.pause();
                                        }
                                        showModalBottomSheet(
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            20.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            20.0))),
                                            //isScrollControlled:true,
                                            context: context,
                                            builder: (BuildContext bc) {
                                              if (areUserHighlightsLoaded) {
                                                return AddToExistingHighlight(
                                                  goToProfile:
                                                      widget.goToProfile,
                                                  highlight: userHighlightsList
                                                      .highlights,
                                                  allFiles:
                                                      allFiles[_currentIndex],
                                                  addNew: () {
                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft:
                                                                    const Radius
                                                                            .circular(
                                                                        20.0),
                                                                topRight:
                                                                    const Radius
                                                                            .circular(
                                                                        20.0))),
                                                        //isScrollControlled:true,
                                                        context: context,
                                                        builder:
                                                            (BuildContext bc) {
                                                          return AddStoryToHighlight(
                                                            allFiles: allFiles[
                                                                _currentIndex],
                                                          );
                                                        });
                                                  },
                                                );
                                              } else {
                                                return AddStoryToHighlight(
                                                  allFiles:
                                                      allFiles[_currentIndex],
                                                );
                                              }
                                            }).whenComplete(() {
                                          timer.start();
                                          _animationController.forward();
                                          if (controller != null) {
                                            controller.play();
                                          }
                                        });
                                      },
                                      storyImage: allFiles[_currentIndex].image,
                                    ),
                                  ],
                                )
                              : OtherUserMessage(
                                  controller: _messageController,
                                  file: allFiles[_currentIndex],
                                  memberID: widget.user!.memberId,
                                  token: widget.user!.token,
                                  onTap: () {
                                    print("tapped on send message");
                                    isTapOnQuestion = false;
                                    _pause();
                                  },
                                ),
                        ),
                        keyboardVisible && !isTapOnQuestion
                            ? StoryEmojis(
                                messageController: _messageController,
                                othermemberId: widget.user!.memberId,
                                storyId: widget.user!.postId,
                              )
                            : Container(),
                        allFiles[_currentIndex].position!.length > 0
                            ? Stack(
                                children: allFiles[_currentIndex]
                                    .position!
                                    .map((e) => DisplayStoryTags(
                                          e: e,
                                        ))
                                    .toList(),
                              )
                            : Container(),
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

class MentionText {
  double? mentionScale, mentionRotation, mentionPosX, mentionPosY;
  String? mentionTextData;
  MentionText(
      {this.mentionTextData,
      this.mentionPosX,
      this.mentionPosY,
      this.mentionScale,
      this.mentionRotation});
  static fromString(String dataStr) {
    print(dataStr);

    return MentionText(
        mentionTextData: dataStr.split("^^")[1],
        mentionPosX: (double.tryParse(dataStr.split("^^")[2]) ?? 0.0),
        mentionPosY: (double.tryParse(dataStr.split("^^")[3]) ?? 0.0),
        mentionScale: (double.tryParse(dataStr.split("^^")[4]) ?? 0.0),
        mentionRotation: 0.0);
  }
}
