import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/video_ads_model.dart';
import 'package:bizbultest/models/video_model.dart';
import 'package:bizbultest/models/video_section/top_slider_video_section_model.dart';
import 'package:bizbultest/models/video_section/video_list_model.dart';
import 'package:bizbultest/models/video_slider_model.dart';
import 'package:bizbultest/services/MainVideo/main_video_api_calls.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/expanded_video_player.dart';
import 'package:bizbultest/widgets/MainVideoWidgets/expanded_video_player_test.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:bizbultest/widgets/large_video_card.dart';
import 'package:bizbultest/widgets/main_video_card.dart';
import 'package:bizbultest/widgets/single_category_expanded_video_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:logger/logger.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';
import '../../api/ApiRepo.dart' as ApiRepo;

class MainVideoPage extends StatefulWidget {
  final Function? setNavBar;
  final VideoAds? adsList;
  final ScrollController? scrollController;
  final String? from;
  final VideoListModelData? video;
  final Function? changeColor;

  const MainVideoPage(
      {Key? key,
      this.setNavBar,
      this.scrollController,
      this.from,
      this.video,
      this.changeColor,
      this.adsList})
      : super(key: key);

  @override
  _MainVideoPageState createState() => _MainVideoPageState();
}

class _MainVideoPageState extends State<MainVideoPage> {
  VideoListModel? videoList;
  VideoListModel? searchedVideoList;
  bool areSearchedVideosLoaded = false;
  VideoListModel categoryVideoList = VideoListModel(data: []);
  bool areSingleCategoryVideosLoaded = false;
  VideoSectionTopSliderModel sliderList =
      VideoSectionTopSliderModel(category: []);
  bool areVideosLoaded = false;
  bool areSliderVideosLoaded = false;
  VideoListModelData? video;
  bool showNoPlayer = true;
  bool showMiniPlayer = false;
  bool showExpandedPlayer = false;
  var selectedCategory;
  bool isSearchOn = false;
  var currentSearch;
  VideoAds? adsList;
  bool showSingleCategory = false;
  Map<String, List<VideoListModelData>> _mainVideos =
      new Map<String, List<VideoListModelData>>();
  RefreshController _categoryRefreshController =
      RefreshController(initialRefresh: false);
  List<RefreshController> _videoRefreshController = [];
  TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var testurlstr = "";
  void _onRefreshCategories() async {
    print("refresh category called");
    getVideosCategories();

    _categoryRefreshController.refreshCompleted();
  }

  void _onRefreshCategoriesHorizontal(String category, int index) async {
    print("Loadinggggggggggggaaaaaaaaa");
    Logger().e("_onLoadingVideos");
    int len = _mainVideos[category]!.length;
    String urlStr = "";
    // for (int i = 0; i < len; i++) {
    //   urlStr += _mainVideos[category][i].postId.toString();
    //   if (i != len - 1) {
    //     urlStr += ",";
    //   }
    // }
    // urlStr=""'

    try {
      // var url =
      //     "https://www.bebuzee.com/api/video/videoData?action=video_page_data_slide_more_videos&user_id=${CurrentUser().currentUser.memberID}&categories_data=$category&country=${CurrentUser().currentUser.country}&post_ids=$urlStr";

      var tempCat = category.replaceFirst('&', '@');

      var url =
          "https://www.bebuzee.com/api/video_page_more_data.php?action=video_page_data_slide_more_videos&user_id=${CurrentUser().currentUser.memberID}&categories=$tempCat&country=${CurrentUser().currentUser.country}&post_ids=$urlStr";

      print("onLoadingVideos called $url");
      var client = new dio.Dio();
      String? token =
          await ApiProvider().refreshToken(CurrentUser().currentUser.memberID!);
      var head = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      var response = await client.post(
        url,
        options: dio.Options(headers: head),
      );

      if (response!.statusCode == 200) {
        VideoListModel videoData = VideoListModel.fromJson(response!.data);
        await Future.wait(videoData.data!
            .map((e) => Preload.cacheImage(context, e.smallImageData!))
            .toList());
        //Map<String, List<VideoModel>> dataTmp = new Map<String, List<VideoModel>>();
        /*videoData.videos.forEach((element) {
          if (dataTmp.containsKey(element.category)) {
            dataTmp[element.category].add(element);
          } else {
            dataTmp[element.category] = [element];
          }
        });*/

        if (mounted) {
          setState(() {
            _mainVideos[category] = [];
            _mainVideos[category]!.addAll(videoData.data!);
            areVideosLoaded = true;
          });
        }
        print(videoData.data!.length.toString() +
            "   lenghtt of maon videosssss");
      }
      if (response!.data == null || response!.statusCode != 200) {
        if (mounted) {
          setState(() {
            areVideosLoaded = false;
          });
        }
      }
      _videoRefreshController[index].refreshCompleted();
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(
          "Couldn't refresh",
        ),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      _videoRefreshController[index].refreshCompleted();
    } catch (e) {
      print("error");
      _videoRefreshController[index].refreshCompleted();
    }
  }

  //? updated
  Future<void> getVideosCategoriesLocal() async {
    Logger().e("get video category Local");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? videos = prefs.getString("main_videos");
    if (videos != null) {
      VideoListModel videoData = VideoListModel.fromJson(jsonDecode(videos));
      await Future.wait(videoData.data!
          .map((e) => PreloadCached.cacheImage(context, e.smallImageData!))
          .toList());
      Map<String, List<VideoListModelData>> videosTmp =
          new Map<String, List<VideoListModelData>>();
      videoData.data!.forEach((element) {
        if (videosTmp.containsKey(element.category)) {
          videosTmp[element.category]!.add(element);
        } else {
          videosTmp[element.category!] = [element];
        }
      });

      List<RefreshController> tmp = [];

      videosTmp.keys.forEach((element) {
        tmp.add(new RefreshController(initialRefresh: false));
      });

      if (mounted) {
        setState(() {
          _videoRefreshController = tmp;

          _mainVideos = videosTmp;

          videoList = videoData;
          areVideosLoaded = true;
        });
      }
    }

    getVideosCategories();
  }

  void getVideosCategories() async {
    Logger().e("get video category call");
    MainVideoApiCalls.getVideosCategories(context).then((videoData) {
      Map<String, List<VideoListModelData>> videosTmp =
          new Map<String, List<VideoListModelData>>();
      videoData.data!.forEach((element) {
        if (videosTmp.containsKey(element.category)) {
          videosTmp[element.category]!.add(element);
        } else {
          videosTmp[element.category!] = [element];
        }
      });

      List<RefreshController> tmp = [];
      videosTmp.keys.forEach((element) {
        tmp.add(new RefreshController(initialRefresh: false));
      });
      if (mounted) {
        setState(() {
          _videoRefreshController = tmp;

          _mainVideos = videosTmp;

          videoList = videoData;
          areVideosLoaded = true;
        });
      }
    });
  }

  //? updated
  void getSingleCategoryVideos(String category) {
    // Logger().e("get single video category call");
    MainVideoApiCalls.getSingleCategoryVideos(category, context).then((value) {
      if (mounted) {
        setState(() {
          categoryVideoList.data = value.data;
          areSingleCategoryVideosLoaded = true;
        });
      }
      print(categoryVideoList.data!.length.toString() +
          " categoryyyyyyyyy length");
      return value;
    });
  }

  //! api updated
  Future<void> getTopSliderLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String videos = await  prefs.getString("slider_videos");
    // Logger().e("video :: $video");
    // if (videos != null) {
    //   VideoSectionTopSliderModel sliderVideos =
    //       VideoSectionTopSliderModel.fromJson(json.decode(video));
    //   await Future.wait(sliderVideos.category
    //       .map((e) => PreloadCached.cacheImage(context, e.cateImage))
    //       .toList());
    //   if (mounted) {
    //     setState(() {
    //       sliderList.category = sliderVideos.category;
    //     });
    //   }
    // }
    getTopSlider();
  }

  //! api updated
  void getTopSlider() async {
    MainVideoApiCalls.getTopSlider(context).then((value) {
      if (mounted) {
        setState(() {
          sliderList.category = value.category;
        });
      }
      //print(sliderList.sliderVideos.length.toString() + " sliderrrrrrrr list");
      return value;
    });

    setState(() {});
  }

  Future<void> getAds() async {
    print("magia get Ads called");
    var url = Uri.parse(
        "https://www.bebuzee.com/api/video_advertisment_list.php?user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&all_ids=");
    print("response of get ads url=${url}");
    var response =
        await ApiRepo.postWithToken('api/video_advertisment_list.php', {
      "user_id": CurrentUser().currentUser.memberID,
      "country": CurrentUser().currentUser.country,
      "all_ids": ""
    });
    // print(
    //     "response of get ads =${response!.data} sucess=${response!.data['success']}");
    print(response!.data);
    if (response!.data != null && response!.data['data'] != null) {
      VideoAds videoData = VideoAds.fromJson(response!.data['data']);
      print("get ads success ${videoData}");
      if (mounted) {
        setState(() {
          adsList = videoData;
        });
      }
    }
  }

  //! api updated
  void _onLoadingCategories() async {
    print("cooooooooool");
    int len = _mainVideos.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      String temp = _mainVideos.keys.elementAt(i);
      temp = temp.replaceFirst('&', '@');
      // urlStr += _mainVideos.keys.elementAt(i);
      urlStr += temp;
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    if (urlStr.split(",").toList().length < 40) {
      try {
        var url =
            "https://www.bebuzee.com/api/video/videoList?action=video_page_data&user_id=${CurrentUser().currentUser.memberID}&categories=$urlStr&country=${CurrentUser().currentUser.country}&page=1";

        print("onLoading slider called");
        print("loading slider url= $url");

        var client = new dio.Dio();
        String? token = await ApiProvider().getTheToken();
        print("loading slider url= $url $token");
        var head = {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        };
        var response = await client.post(
          url,
          options: dio.Options(headers: head),
        );

        print("response =${response}");
        if (response!.statusCode == 200) {
          VideoListModel videoData = VideoListModel.fromJson(response!.data);
          await Future.wait(videoData.data!
              .map((e) => Preload.cacheImage(context, e.smallImageData!))
              .toList());
          Map<String, List<VideoListModelData>> dataTmp =
              new Map<String, List<VideoListModelData>>();
          videoData.data!.forEach((element) {
            if (dataTmp.containsKey(element.category)) {
              dataTmp[element.category]!.add(element);
            } else {
              dataTmp[element.category!] = [element];
            }
          });

          List<RefreshController> tmp = [];
          dataTmp.keys.forEach((element) {
            tmp.add(new RefreshController(initialRefresh: false));
          });

          if (mounted) {
            setState(() {
              _videoRefreshController.addAll(tmp);

              _mainVideos.addAll(dataTmp);
            });
            Timer(Duration(milliseconds: 500), () {
              areVideosLoaded = true;
            });
          }
          //print(videoData.videos.length.toString() + "   lenghtt of maon videosssss");
        }
        if (response!.data == null || response!.statusCode != 200) {
          if (mounted) {
            setState(() {
              areVideosLoaded = false;
            });
          }
        }
      } on SocketException catch (e) {
        Fluttertoast.showToast(
          msg: AppLocalizations.of(
            "Couldn't refresh",
          ),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black.withOpacity(0.7),
          textColor: Colors.white,
          fontSize: 15.0,
        );
      }
      _categoryRefreshController.loadComplete();
    } else {
      _categoryRefreshController.loadComplete();
    }
  }

  //! api updated
  void _onLoadingVideos(String category, int index) async {
    print("Loadinggggggggggggaaaaaaaaa");
    Logger().e("_onLoadingVideos");
    int len = _mainVideos[category]!.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += _mainVideos[category]![i].postId.toString();
      if (i != len - 1) {
        urlStr += ",";
      }
    }

    try {
      // var url =
      //     "https://www.bebuzee.com/api/video/videoData?action=video_page_data_slide_more_videos&user_id=${CurrentUser().currentUser.memberID}&categories_data=$category&country=${CurrentUser().currentUser.country}&post_ids=$urlStr";

      var tempCat = category.replaceFirst('&', '@');

      var url =
          "https://www.bebuzee.com/api/video/videoList?action=video_page_data_slide_more_videos&user_id=${CurrentUser().currentUser.memberID}&categories=$tempCat&country=${CurrentUser().currentUser.country}&post_ids=$urlStr";

      print("onLoadingVideos called $url");
      var client = new dio.Dio();
      String? token = await ApiProvider().getTheToken();
      var head = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      var response = await client.post(
        url,
        options: dio.Options(headers: head),
      );

      if (response!.statusCode == 200) {
        VideoListModel videoData = VideoListModel.fromJson(response!.data);
        await Future.wait(videoData.data!
            .map((e) => Preload.cacheImage(context, e.smallImageData!))
            .toList());
        //Map<String, List<VideoModel>> dataTmp = new Map<String, List<VideoModel>>();
        /*videoData.videos.forEach((element) {
          if (dataTmp.containsKey(element.category)) {
            dataTmp[element.category].add(element);
          } else {
            dataTmp[element.category] = [element];
          }
        });*/
        if (mounted) {
          setState(() {
            _mainVideos[category]!.addAll(videoData.data!);
            areVideosLoaded = true;
          });
        }
        print(videoData.data!.length.toString() +
            "   lenghtt of maon videosssss");
      }
      if (response!.data == null || response!.statusCode != 200) {
        if (mounted) {
          setState(() {
            areVideosLoaded = false;
          });
        }
      }
      _videoRefreshController[index].loadComplete();
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(
          "Couldn't refresh",
        ),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      _videoRefreshController[index].loadNoData();
    } catch (e) {
      print("error");
      _videoRefreshController[index].loadComplete();
    }
  }

  //! api updated
  void _onLoadingSingleCategoryVideos() async {
    print("singlrrrrrrrrrr");

    Logger().e("_onLoadingSingleCategoryVideos");
    int len = categoryVideoList.data!.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += categoryVideoList.data![i].postId.toString();
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    try {
      selectedCategory = selectedCategory.replaceFirst('&', '@');
      var url =
          "https://www.bebuzee.com/api/video/videoData?action=video_page_data_slide_more_videos&user_id=${CurrentUser().currentUser.memberID}&categories=$selectedCategory&country=${CurrentUser().currentUser.country}&post_ids=$urlStr";

      var client = new dio.Dio();
      print("token called  ${url}");

      String? token = await ApiProvider().getTheToken();
      print("token: $token");
      var head = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      var response = await client.post(
        url,
        options: dio.Options(headers: head),
      );

      if (response!.statusCode == 200) {
        VideoListModel videoData = VideoListModel.fromJson(response!.data);
        await Future.wait(videoData.data!
            .map((e) => Preload.cacheImage(context, e.smallImageData!))
            .toList());
        if (mounted) {
          setState(() {
            categoryVideoList.data!.addAll(videoData.data!);
            areSingleCategoryVideosLoaded = true;
          });
        }
      }
      if (response!.data == null || response!.statusCode != 200) {
        if (mounted) {
          setState(() {
            areSingleCategoryVideosLoaded = false;
          });
        }
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(
          "Couldn't refresh",
        ),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } catch (e) {
      print("In the catch section");
      _categoryRefreshController.loadComplete();
    }
    _categoryRefreshController.loadComplete();
  }

  //! api updated
  void _onLoadingSearchedVideos() async {
    Logger().e("_onLoadingSearchedVideos");
    int len = searchedVideoList!.data!.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += searchedVideoList!.data![i].postId.toString();
      if (i != len - 1) {
        urlStr += ",";
      }
    }
    try {
      var url =
          "https://www.bebuzee.com/api/video/videoData?action=get_search_video_data&user_id=${CurrentUser().currentUser.memberID}&keyword=$currentSearch&post_ids=$urlStr&country=${CurrentUser().currentUser.country}";
      print("searched vid url=$url");
      var client = new dio.Dio();
      String? token = await ApiProvider().getTheToken();
      var head = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
      var response = await client.post(
        url,
        options: dio.Options(headers: head),
      );

      if (response!.statusCode == 200) {
        VideoListModel videoData = VideoListModel.fromJson(response!.data);
        await Future.wait(videoData.data!
            .map((e) => Preload.cacheImage(context, e.smallImageData!))
            .toList());
        if (mounted) {
          setState(() {
            searchedVideoList!.data!.addAll(videoData.data!);
            areSearchedVideosLoaded = true;
          });
        }
      }
      if (response!.data == null || response!.statusCode != 200) {
        if (mounted) {
          setState(() {
            areSearchedVideosLoaded = false;
          });
        }
      }
    } on SocketException catch (e) {
      // Logger().e("Socket Exception");
      Fluttertoast.showToast(
        msg: AppLocalizations.of(
          "Couldn't refresh",
        ),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _categoryRefreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          return Container();
        },
      );
    }
    _categoryRefreshController.loadComplete();
  }

  //! api updated
  Future<void> getSearchedVideos(text) async {
    Logger().e("getSearchedVideos");
    var url =
        "https://www.bebuzee.com/api/video/videoData?action=get_search_video_data&user_id=${CurrentUser().currentUser.memberID}&keyword=$text&post_ids=&country=${CurrentUser().currentUser.country}&country=${CurrentUser().currentUser.country}";
    print(" on searched url=$url");
    var client = new dio.Dio();
    String? token = await ApiProvider().getTheToken();
    var head = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    var response = await client.post(
      url,
      options: dio.Options(headers: head),
    );

    if (response!.statusCode == 200) {
      VideoListModel videoData = VideoListModel.fromJson(response!.data);

      Logger().e("response data:: $response");
      await Future.wait(videoData.data!
          .map((e) => Preload.cacheImage(context, e.smallImageData!))
          .toList());
      //print(peopleData.people[0].name);
      setState(() {
        searchedVideoList = videoData;
        areSearchedVideosLoaded = true;
      });

      if (response!.data == null || response!.statusCode != 200) {
        setState(() {
          areSearchedVideosLoaded = false;
        });
      }
    }
  }

  void adsFromFeeds() {
    if (widget.adsList != null) {
      setState(() {
        adsList = widget.adsList;
      });
    }
  }

  RefreshMainVideo refreshMainVideo = RefreshMainVideo();

  @override
  void initState() {
    print("Entered Main video page");
    adsFromFeeds();
    if (widget.from == "Feeds") {
      setState(() {
        showNoPlayer = false;
        showExpandedPlayer = true;
        video = widget.video;
        print("video main page=${video}");
      });
    }
    getAds();
    print("after getAds");
    // getVideosCategoriesLocal();
    print("after Local cat");
    getVideosCategories();
    getTopSliderLocal();
    print("after getTopSlider");

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.grey[900],
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark);

    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    void onPop() {
      widget.setNavBar!(false);

      print("am here on pop");
      if (showMiniPlayer) {
        widget.changeColor!(false);
      }

      setState(() {
        showMiniPlayer = true;
        showExpandedPlayer = false;
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[900],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.grey[900],
          elevation: 0,
        ),
      ),
      body: StreamBuilder<Object>(
          initialData: refreshMainVideo.currentSelect,
          stream: refreshMainVideo.observableCart,
          builder: (context, snapshot) {
            // Logger().e("snapshot : $snapshot");
            if (snapshot.data != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Timer(Duration(milliseconds: 900), () {
                //   getVideosCategories();
                //   getTopSlider();
                //   refreshMainVideo.updateRefresh(false);
                // });
              });
            }
            return Stack(
              children: [
                Opacity(
                  opacity: showExpandedPlayer == true ? 0 : 1.0,
                  child: Container(
                    child: NotificationListener<UserScrollNotification>(
                      onNotification: (v) {
                        print("bigvideo ${v.direction}");
                        if (v.direction == ScrollDirection.reverse) {
                          if (showSingleCategory)
                            _onLoadingSingleCategoryVideos();
                          else if (!showSingleCategory && isSearchOn)
                            _onLoadingSearchedVideos();
                          else
                            _onLoadingCategories();
                        }
                        return true;
                      },
                      child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: CustomHeader(
                          builder: (context, mode) {
                            return Container(
                              child: Center(
                                  child: loadingAnimationBlackBackground()),
                            );
                          },
                        ),
                        footer: CustomFooter(
                          builder: (BuildContext context, LoadStatus? mode) {
                            Widget body;

                            if (mode == LoadStatus.idle) {
                              body = Text("");
                            } else if (mode == LoadStatus.loading) {
                              body = loadingAnimationBlackBackground();
                            } else if (mode == LoadStatus.failed) {
                              body = Container(
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                        color: Colors.black, width: 0.7),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Icon(CustomIcons.reload),
                                  ));
                            } else if (mode == LoadStatus.canLoading) {
                              body = Text(
                                AppLocalizations.of("release to load more"),
                              );
                            } else {
                              body = Text(
                                AppLocalizations.of("No more Data"),
                              );
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child: body),
                            );
                          },
                        ),
                        controller: _categoryRefreshController,
                        onRefresh: _onRefreshCategories,
                        onLoading: () {
                          showSingleCategory
                              ? _onLoadingSingleCategoryVideos()
                              : !showSingleCategory && isSearchOn
                                  ? _onLoadingSearchedVideos()
                                  : _onLoadingCategories();
                        },
                        child: ListView.builder(
                            controller: widget.scrollController,
                            scrollDirection: Axis.vertical,
                            itemCount: areSingleCategoryVideosLoaded == true
                                ? ((categoryVideoList.data!.length + 2) -
                                    categoryVideoList.data!.length)
                                : isSearchOn
                                    ? 2
                                    : _mainVideos.length * 2,
                            itemBuilder: (context, index) {
                              if (index % 2 == 0) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 1.0.h,
                                      top: index == 0 ? 4.0.h : 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      index == 0
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 25,
                                                  left: 15,
                                                  right: 15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: TextFormField(
                                                  onChanged: (val) {
                                                    if (val.isEmpty) {
                                                      setState(() {
                                                        isSearchOn = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        isSearchOn = true;
                                                        showSingleCategory =
                                                            false;
                                                        currentSearch = val;
                                                      });
                                                      getSearchedVideos(val);
                                                    }
                                                  },
                                                  controller: _searchController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 14, left: 5),
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,

                                                    prefixIcon: Icon(
                                                      Icons.search,
                                                      color: Colors.grey,
                                                    ),
                                                    hintText:
                                                        AppLocalizations.of(
                                                      "Search",
                                                    ),
                                                    hintStyle: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.grey),
                                                    // contentPadding: EdgeInsets.zero
                                                    // 48 -> icon width
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      index == 0 && isSearchOn == false
                                          ? Container(
                                              height: 21.0.h,
                                              child: ListView.builder(
                                                addAutomaticKeepAlives: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    sliderList.category!.length,
                                                itemBuilder: (context, index) {
                                                  var e = sliderList
                                                      .category![index];
                                                  return CategoryCard(
                                                    video: e,
                                                    onTap: () {
                                                      setState(() {
                                                        areSingleCategoryVideosLoaded =
                                                            false;
                                                        selectedCategory =
                                                            e.cateName;
                                                      });
                                                      getSingleCategoryVideos(
                                                        e.cateName!,
                                                      );

                                                      setState(() {
                                                        if (showSingleCategory ==
                                                            false) {
                                                          setState(() {
                                                            showSingleCategory =
                                                                true;
                                                          });
                                                        }
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(
                                              // child: Text(
                                              //     sliderList.category.length
                                              //         .toString(),
                                              //     style: TextStyle(
                                              //         color: Colors.white)),
                                              ),
                                      showSingleCategory == false &&
                                              isSearchOn == false
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(left: 2.0.w),
                                              child: Text(
                                                AppLocalizations.of(
                                                  (CurrentUser()
                                                              .currentUser!
                                                              .country!
                                                              .toLowerCase() ==
                                                          "italy")
                                                      ? _mainVideos[_mainVideos
                                                              .keys!
                                                              .elementAt(
                                                                  (index! ~/
                                                                      2))]![0]
                                                          .categoryIt!
                                                      : _mainVideos[_mainVideos
                                                              .keys!
                                                              .elementAt(
                                                                  (index ~/
                                                                      2))]![0]
                                                          .category!,
                                                ),
                                                style: whiteBold.copyWith(
                                                    fontSize: 15.0.sp),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                );
                              } else if (showSingleCategory == true &&
                                  isSearchOn == false) {
                                return Container(
                                  color: Colors.grey[900],
                                  child: areSingleCategoryVideosLoaded == true
                                      ? ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              categoryVideoList.data!.length,
                                          itemBuilder: (context, index) {
                                            return SingleCategoryExpandedVideoCard(
                                              hide: () {
                                                setState(() {
                                                  showSingleCategory = false;
                                                  areSingleCategoryVideosLoaded =
                                                      false;
                                                });
                                              },
                                              playVideo: () {
                                                widget.setNavBar!(true);
                                                setState(() {
                                                  showNoPlayer = false;
                                                });
                                                Timer(
                                                    Duration(milliseconds: 300),
                                                    () {
                                                  setState(() {
                                                    showNoPlayer = false;
                                                  });
                                                });
                                                setState(() {
                                                  video = categoryVideoList
                                                      .data![index];
                                                  showExpandedPlayer = true;
                                                  showMiniPlayer = false;
                                                });
                                              },
                                              index: index,
                                              video: categoryVideoList
                                                  .data![index],
                                            );
                                          })
                                      : Container(),
                                );
                              } else if (showSingleCategory == false &&
                                  isSearchOn == false) {
                                return Container(
                                  height: 25.0.h,
                                  child: SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    header: CustomHeader(
                                      builder: (context, mode) {
                                        return Container(
                                          child: Center(
                                              child:
                                                  loadingAnimationBlackBackground()),
                                        );
                                      },
                                    ),
                                    footer: CustomFooter(
                                      builder: (BuildContext context,
                                          LoadStatus? mode) {
                                        Widget body;

                                        if (mode == LoadStatus.idle) {
                                          body = Text("");
                                        } else if (mode == LoadStatus.loading) {
                                          body =
                                              loadingAnimationBlackBackground();
                                        } else if (mode == LoadStatus.failed) {
                                          body = Container(
                                              decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: new Border.all(
                                                    color: Colors.black,
                                                    width: 0.7),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Icon(CustomIcons.reload),
                                              ));
                                        } else if (mode ==
                                            LoadStatus.canLoading) {
                                          body = Text(
                                            AppLocalizations.of(
                                              "release to load more",
                                            ),
                                          );
                                        } else {
                                          body = Text(
                                            AppLocalizations.of("No more Data"),
                                          );
                                        }
                                        return Container(
                                          height: 55.0,
                                          child: Center(child: body),
                                        );
                                      },
                                    ),
                                    controller:
                                        _videoRefreshController[index ~/ 2],
                                    onRefresh: () {
                                      _onRefreshCategoriesHorizontal(
                                          _mainVideos.keys
                                              .elementAt(index ~/ 2),
                                          index ~/ 2);
                                    },
                                    onLoading: () {
                                      _onLoadingVideos(
                                          _mainVideos.keys
                                              .elementAt(index ~/ 2),
                                          index ~/ 2);
                                    },
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _mainVideos[_mainVideos.keys
                                              .elementAt(index ~/ 2)]!
                                          .length,
                                      itemBuilder: (context, indexHorizontal) {
                                        return VideoCard(
                                          onPress: () {
                                            Logger().e("====video card ===");
                                            print(_mainVideos[_mainVideos.keys
                                                    .elementAt(index ~/ 2)]![
                                                indexHorizontal]);
                                            print(
                                                "video card ${_mainVideos[_mainVideos.keys.elementAt(index ~/ 2)]![indexHorizontal].video}");
                                            print(
                                                "video card ${_mainVideos[_mainVideos.keys.elementAt(index ~/ 2)]![indexHorizontal].quality}");
                                            print(
                                                "video card ${_mainVideos[_mainVideos.keys.elementAt(index ~/ 2)]![indexHorizontal].postId}");
                                            widget.setNavBar!(true);
                                            setState(() {
                                              showNoPlayer = true;
                                            });
                                            Timer(Duration(milliseconds: 300),
                                                () {
                                              setState(() {
                                                showNoPlayer = false;
                                              });
                                            });
                                            setState(() {
                                              Navigator.pop(context);
                                              video = _mainVideos[_mainVideos
                                                      .keys
                                                      .elementAt(index ~/ 2)]![
                                                  indexHorizontal];
                                              showExpandedPlayer = true;
                                              showMiniPlayer = false;
                                            });
                                          },
                                          video: _mainVideos[_mainVideos.keys
                                                  .elementAt(index ~/ 2)]![
                                              indexHorizontal],
                                          index: indexHorizontal,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              } else if (isSearchOn == true) {
                                return Container(
                                  child: areSearchedVideosLoaded
                                      ? ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              searchedVideoList!.data!.length,
                                          itemBuilder: (context, index) {
                                            return LargeVideoCard(
                                              index: index,
                                              hide: () {
                                                setState(() {
                                                  isSearchOn = false;
                                                  showSingleCategory = false;
                                                });
                                              },
                                              play: () {
                                                print("pressed on playy");
                                                widget.setNavBar!(true);
                                                setState(() {
                                                  showNoPlayer = false;
                                                });
                                                Timer(
                                                    Duration(milliseconds: 300),
                                                    () {
                                                  setState(() {
                                                    showNoPlayer = false;
                                                  });
                                                });
                                                setState(() {
                                                  video = searchedVideoList!
                                                      .data![index];
                                                  print(
                                                      "pressed on a video ${video!.video}");
                                                  showExpandedPlayer = true;
                                                  showMiniPlayer = false;
                                                });
                                              },
                                              video: searchedVideoList!
                                                  .data![index],
                                            );
                                          })
                                      : Container(),
                                );
                              } else {
                                return Container(
                                  color: Colors.grey[900],
                                );
                              }
                            }),
                      ),
                    ),
                  ),
                ),
                showNoPlayer == false
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        // child:
                        //  WillPopScope(
                        //   // ignore: missing_return
                        //   onWillPop: () async {
                        //     widget.setNavBar(false);

                        //     print("am here on pop");
                        //     if (showMiniPlayer) {
                        //       widget.changeColor(false);

                        //       return true;
                        //     }

                        //     setState(() {
                        //       showMiniPlayer = true;
                        //       showExpandedPlayer = false;
                        //     });

                        //     /* if (widget.from == "Feeds" && widget.from != null ) {
                        //     Navigator.pop(context);
                        //     widget.changeColor(false);
                        //   }*/
                        //   },
                        child: Container(
                          child:
                              //      ExpandedVideoPlayerTest(
                              //   video: video.video,
                              // )

                              ExpandedVideoPlayer(
                            onPop: () {
                              onPop();
                            },
                            rebuzed: () {
                              ScaffoldMessenger.of(
                                      _scaffoldKey.currentState!.context)
                                  .showSnackBar(blackSnackBar(
                                      AppLocalizations.of(
                                          'Rebuzed Successfully')));
                            },
                            adsList: adsList,

                            copied: () {
                              ScaffoldMessenger.of(
                                      _scaffoldKey.currentState!.context)
                                  .showSnackBar(blackSnackBar(
                                      AppLocalizations.of('URL Copied')));
                            },
                            onPress: () {
                              setState(() {
                                widget.setNavBar!(false);
                                setState(() {
                                  showMiniPlayer = true;
                                  showExpandedPlayer = false;
                                });
                              });
                            },

                            // dispose: showNoPlayer,
                            video: video!,
                            expand: () {
                              widget.setNavBar!(true);
                              setState(() {
                                showExpandedPlayer = true;
                                showMiniPlayer = false;
                              });
                            },
                            onPressHide: () {
                              setState(() {
                                showNoPlayer = true;
                              });
                            },
                            showFullPlayer: showExpandedPlayer,
                          ),
                        )

                        // ),
                        )
                    : Container(),
              ],
            );
          }),
    );
  }
}

class CategoryCard extends StatefulWidget {
  final VideoSectionTopSliderModelCategory? video;

  final VoidCallback? onTap;

  CategoryCard({Key? key, this.onTap, this.video}) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    //Logger().e("category card called");
    return InkWell(
      onTap: widget.onTap ?? () {},
      child: Container(
          child: CachedNetworkImage(
        imageUrl: widget.video!.cateImage!,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return SkeletonAnimation(
              child: Container(
            height: 20.0.h,
          ));
        },
        height: 20.0.h,
      )

          //  Image(
          //   image: CachedNetworkImageProvider(widget.video.cateImage),
          //   fit: BoxFit.cover,
          //   height: 20.0.h,
          // ),
          ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
