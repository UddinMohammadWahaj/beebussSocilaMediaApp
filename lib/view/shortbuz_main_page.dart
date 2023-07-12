import 'dart:io';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/shortbuz/shortbuz_video_list_model.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:logger/logger.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:bizbultest/widgets/shortbuz_video_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bizbultest/services/current_user.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:sizer/sizer.dart';

class ShortbuzMainPage extends StatefulWidget {
  final String? postID;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final Function? profileOpen;
  final String? from;
  final Function? jumpToFeeds;
  String keyword;
  ShortbuzMainPage(
      {Key? key,
      this.keyword = '',
      this.postID,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.profileOpen,
      this.from,
      this.jumpToFeeds})
      : super(key: key);

  @override
  _ShortbuzMainPageState createState() => _ShortbuzMainPageState();
}

class _ShortbuzMainPageState extends State<ShortbuzMainPage>
    with WidgetsBindingObserver {
  late ShortbuzVideoListModel videoList;
  late ShortbuzVideoListModel initVideoList;
  bool hasVideos = false;

  String postID = "";

  String _internalIP = '';

  //? get videos

  Future<void> getVideos() async {
    //! api updated
    print("shortbuz disp get videos called");
    var url =
        "https://www.bebuzee.com/api/shortbuz/shortbuzSuggested?action=short_video_data&user_id=${CurrentUser().currentUser.memberID}&post_id_from_feed=${widget.postID}&ip=$_internalIP&post_ids=${widget.postID}&index=&data_sequence=&country=${CurrentUser().currentUser.country}&page=1&keyword=${widget.keyword}";
    print(url);

    var client = new dio.Dio();
    print("token called");

    String? token = await ApiProvider().getTheToken();
    print("token: $token");
    print("shortbuz main url=${url} $token");
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );

    print("response of getvideos=${response.data}");
    if (response.statusCode == 200) {
      try {
        ShortbuzVideoListModel _videoList =
            ShortbuzVideoListModel.fromJson(response.data);

        await Future.wait(_videoList.data!
            .map((e) => PreloadCached.cacheImage(context, e.postUserPicture!))
            .toList());
        _videoList.data!.forEach((element) {
          element.isLoaded = true;
        });
        _videoList.data!.add(new Data());
        if (this.mounted) {
          setState(() {
            videoList = _videoList;
            print("response of videolist.length=${videoList.data!.length}");
            print("response of videolist.length= ${videoList.data![1].postId}");
            initVideoList = _videoList;
            hasVideos = true;
          });
        }
      } catch (e) {
        print('shortbuz Error $e shortbuz');
      }
    }
  }

  //?  clear cache
  Future<void> _clearCache() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  //? check cache size
  Future<Map<String, int>> checkCacheSize() async {
    int fileNum = 0;
    int totalSize = 0;
    final cacheDir = await getTemporaryDirectory();
    cacheDir.path.toString();
    var dir = Directory(cacheDir.path.toString());
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }

    if (totalSize > 200000000) {
      _clearCache();
      SystemNavigator.pop();
    }
    return {'fileNum': fileNum, 'size': totalSize};
  }

  //?  clear cache
  Future<Map<String, int>> clearCache() async {
    int fileNum = 0;
    int totalSize = 0;
    final cacheDir = await getTemporaryDirectory();
    cacheDir.path.toString();
    var dir = Directory(cacheDir.path.toString());
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }

    if (totalSize > 200000000) {
      setState(() {
        hasVideos = false;
      });
      getVideos();
    }
    return {'fileNum': fileNum, 'size': totalSize};
  }

  DateTime offTime = DateTime.now();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("shortbuz disp changed");
    print("resumed shorbuz ");

    if (state.toString() == "AppLifeCycleState.resumed") {
      print("resumed shorbuz ");
    }

    if (state.toString() == "AppLifecycleState.paused") {
      checkCacheSize();
      setState(() {
        offTime = DateTime.now();
      });

      /*
    
        imageCache.clear();
        print(imageCache.currentSizeBytes);

    */
    }
    var diff = DateTime.now().difference(offTime).inMinutes;
    if (state.toString() == "AppLifecycleState.resumed") {
      clearCache();
      if (diff > 10) {
        setState(() {
          hasVideos = false;
        });

        getVideos();
      }
    }
  }

  setPostID() {
    if (widget.postID == null) {
      setState(() {
        postID = "";
      });
    } else {
      setState(() {
        print("PostId set to ${widget.postID}");
        postID = widget.postID!;
      });
    }
  }

  //? update internal ip
  Future<void> _updateInternalIP() async {
    String ipv4 = await Ipify.ipv4();
    print('internal ip' + ipv4);
    // try {
    //   setState(() {
    //     _internalIP = ipv4;
    //   });
    // } catch (e) {
    //   _internalIP = ipv4;
    // }
    print(_internalIP + " :  is ip address");

    getVideos();
  }

  @override
  void didChangeDependencies() {
    print("shortbuz change dep");
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    //_deleteCacheDir();
    // dirStatSync();

    WidgetsBinding.instance.addObserver(this);
    if (widget.from == 'disco') {
      print("shortbuz from discover  ${widget.postID} ${videoList}");

      // return;
    } else {
      print("shortbuz from other");
    }

    // setPostID();
    //getVideos();
    _updateInternalIP();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print("shortbuz disposed");
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ShortbuzMainPage oldWidget) {
    print("shortbuz disp update");
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            brightness: Brightness.dark,
          ),
        ),
        backgroundColor: Colors.black,
        body: hasVideos
            ? WillPopScope(
                onWillPop: () async {
                  if (widget.from == "discover" ||
                      widget.from == "hashtagpage") {
                    Navigator.pop(context);
                    widget.changeColor!(false);
                    widget.setNavBar!(false);
                  } else {
                    widget.changeColor!(false);
                  }

                  return true;
                },
                child: PreloadPageView.builder(
                  preloadPagesCount: 2,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (val) async {
                    return;
                    print("reached short -1");
                    print('video length=${videoList.data!.length}');
                    print("page changed ${val} ${videoList.data![val].video}");
                    print("shoet buz data =${videoList.data!.length}");
                    print("reached short 0");
                    if ((videoList.data![val + 1].postId == null)) {
                      print("url of short swap");

                      /*      print("swappppppppppppp  " + val.toString());*/
                      int len = videoList.data!.length;
                      String urlStr = "";
                      int? dataseq;
                      for (int i = 0; i < len - 1; i++) {
                        if (videoList.data![i].postId == null) break;
                        urlStr += videoList.data![i].postId!;
                        dataseq = videoList.data![i].dataSequence;
                        if (i != len - 2) {
                          urlStr += ",";
                        }
                      }

                      //! api updated
                      var url =
                          "https://www.bebuzee.com/api/shortbuz/list?action=short_video_data&current_user_id=${CurrentUser().currentUser.memberID}&user_id=${CurrentUser().currentUser.memberID}&post_ids=$urlStr&country=${CurrentUser().currentUser.country}&index=$val&data_sequence=${dataseq!}&ip=$_internalIP&country=${CurrentUser().currentUser.country}&page=1";
                      print(url);

                      var client = new dio.Dio();
                      print("token called");

                      String? token = await ApiProvider().getTheToken();
                      print("token: $token");
                      print("shortbuz main url=2 ${url} $token");
                      var head = {
                        "Accept": "application/json",
                        "Authorization": "Bearer $token",
                      };
                      var response = await client.post(
                        url,
                        options: dio.Options(headers: head),
                      );
                      print("reached short 1");
                      if (response.statusCode == 200) {
                        ShortbuzVideoListModel feedData =
                            ShortbuzVideoListModel.fromJson((response.data));
                        await Future.wait(feedData.data!
                            .map((e) => PreloadCached.cacheImage(
                                context, e.postUserPicture!))
                            .toList());
                        ShortbuzVideoListModel videoData = videoList;
                        feedData.data!.forEach((element) {
                          videoData.data![videoData.data!.length - 1] = element;
                          videoData.data![videoData.data!.length - 1].isLoaded =
                              true;
                          videoData.data!.add(new Data());
                        });
                        setState(() {
                          videoList = videoData;
                          hasVideos = true;
                        });
                        print("reached short 2");
                      }
                      if (response.data == null || response.statusCode != 200) {
                        setState(() {
                          hasVideos = false;
                        });
                      }
                    }
                  },
                  itemCount: videoList.data!.length - 1,
                  itemBuilder: (context, index) {
                    // print(
                    //     "page change index =$index  ${videoList.data![index].video} ");
                    print('reached shortbuz 0 ${videoList.data![index]}');
                    var video = videoList.data![index];
                    if (video.isLoaded!) {
                      //   Logger().e("shortbuz video length: " + videoList.data.length.toString());
                      print('reached shortbuz 1 ${videoList.data![index]}');
                      print(
                          "yo video loaded url of shortbuz=${video.video} ${video.postContent} ");
                      return ShortBuzVideoCard(
                        postid: widget.postID,
                        refresh: () {
                          // Timer(Duration(seconds: 1), () {
                          //   getVideos();
                          // });
                        },
                        from: widget.from ?? '',
                        jumpBack: () {
                          if (widget.from == "discover") {
                            Navigator.pop(context);
                            widget.changeColor!(false);
                            widget.setNavBar!(false);
                          } else {
                            widget.changeColor!(false);
                          }
                        },
                        jumpToFeeds: () {
                          widget.jumpToFeeds!(true);
                        },
                        stickerList: [], //videoList.data[index].stickers
                        positionList: [], //videoList.data[index].position
                        hideNavbar: widget.setNavBar,
                        onTap: () {
                          widget.changeColor!(false);
                          widget.profileOpen!(true);
                          widget.setNavBar!(false);
                          setState(() {
                            OtherUser().otherUser.memberID = video.postUserId;
                            OtherUser().otherUser.shortcode =
                                video.postShortcode;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePageMain(
                                        from: "shortbuz",
                                        setNavBar: widget.setNavBar!,
                                        profileOpen: widget.profileOpen!,
                                        isChannelOpen: widget.isChannelOpen!,
                                        changeColor: widget.changeColor!,
                                        otherMemberID: video.postUserId,
                                      )));
                        },
                        index: index,
                        video: video,
                      );
                    } else {
                      return Container(
                        padding: EdgeInsets.only(left: 3.0.w),
                        width: 100.0.w,
                        height: 100.0.h,
                        color: Colors.grey[600],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SkeletonAnimation(
                              child: Container(
                                width: 15.0.h,
                                height: 1.5.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            SkeletonAnimation(
                              child: Container(
                                width: 20.0.h,
                                height: 1.5.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            SkeletonAnimation(
                              child: Container(
                                width: 25.0.h,
                                height: 1.5.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.5.h,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              )
            : Container(
                padding: EdgeInsets.only(left: 1.5.w),
                width: 100.0.w,
                height: 100.0.h,
                color: Colors.grey[600],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 2.0.h, horizontal: 2.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Shortbuz",
                            style: whiteBold.copyWith(fontSize: 20.0.sp),
                          ),
                          Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 4.0.h,
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SkeletonAnimation(
                          child: Container(
                            width: 15.0.h,
                            height: 1.5.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        SkeletonAnimation(
                          child: Container(
                            width: 20.0.h,
                            height: 1.5.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        SkeletonAnimation(
                          child: Container(
                            width: 25.0.h,
                            height: 1.5.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                      ],
                    ),
                  ],
                ),
              ));
  }
}
