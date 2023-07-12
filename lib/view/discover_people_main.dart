import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/Discover/discover_api_calls.dart';
import 'package:bizbultest/services/FeedAllApi/main_feeds_page_api_calls.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/view/shortbuz_main_page.dart';
import 'package:bizbultest/widgets/DiscoverFeeds/discover_images_card.dart';
import 'package:bizbultest/models/discover_hashtags.dart';
import 'package:bizbultest/services/country_name.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/widgets/DiscoverFeeds/discover_tags.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'discover_people_from_tags.dart';
import 'discover_search_page.dart';

class DiscoverPage extends StatefulWidget {
  final bool? isMemberLoaded;
  final ScrollController? scrollController;
  final Function? setNavBar;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? profileOpen;

  DiscoverPage(
      {Key? key,
      this.isMemberLoaded,
      this.scrollController,
      this.setNavBar,
      this.changeColor,
      this.isChannelOpen,
      this.profileOpen})
      : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with WidgetsBindingObserver {
  late Future _hashtagFuture;
  late Future _postsFuture;
  late DiscoverHashtags _hashtags = DiscoverHashtags([]);
  AllFeeds posts = AllFeeds([]);
  var selectedHashtag = "";
  var countryName;
  late double latitude;
  double scrollPosition = 0;
  late double longitude;
  late String stringOfPostID;
  int boostedCount = 0;
  DateTime offTime = DateTime.now();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var currentPage = 1;
  Future<String> getLocation() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    var locationX = jsonDecode(locationSTR);
    if (this.mounted) {
      setState(() {
        countryName = locationX["country"];
        latitude = locationX["lat"];
        longitude = locationX["lon"];
      });
    }
    //print(latitude.toString() + " latitude");
    return "success";
  }

  void _getHashtags() async {
    print('hash set _getHashtagCalled');
    _hashtagFuture = DiscoverApiCalls.getHashtags("").then((value) {
      if (mounted) {
        setState(() {
          _hashtags.discoverHashtags = value;
          print(
              'hash set _getHashtagCalled Success ${_hashtags.discoverHashtags}');
        });
      }
      return value;
    });
  }

  void _getHashtagsLocal() async {
    _hashtagFuture = DiscoverApiCalls.getLocalHashtags().then((value) {
      if (mounted) {
        setState(() {
          _hashtags.discoverHashtags = value.discoverHashtags;
          print("hash set state success ${_hashtags.discoverHashtags}");
        });
      }
      _getHashtags();
      return value;
    });
  }

  void _getPosts() {
    _postsFuture = DiscoverApiCalls.getPosts("", context).then((value) {
      if (mounted) {
        print("get post is mounted");
        setState(() {
          posts.feeds = value.feeds;
        });
      }
      print(posts.feeds[0].postShortcode);

      // int startindex = 2, startcount = 0;
      // for (int i = startindex; i < posts.feeds.length; i++) {
      //   if (mounted) {
      //     setState(() {
      //       if (i == startindex) {
      //         posts.feeds[i].long = 69;
      //         startcount++;
      //         if (startcount % 2 == 0) {
      //           startindex += 9;
      //         } else
      //           startindex += 13;
      //       }
      //     });
      //   }
      // }

      for (int i = 0; i < posts.feeds.length; i++) {
        if (mounted) {
          setState(() {
            if (posts.feeds[i].shortVideo == 1) {
              boostedCount++;

              if (boostedCount % 2 != 0) {
                posts.feeds[i].long = 1;
              } else {
                posts.feeds[i].long = 2;
              }
            }
/*
            if (posts.feeds[i].boostData == 1 ||
                posts.feeds[i].shortVideo == 1) {
              boostedCount++;

              if (boostedCount % 2 == 0) {
                posts.feeds[i].long = 1;
              } else {
                posts.feeds[i].long = 2;
              }
            }
*/
          });
        }
      }

      List<String?> stringPost =
          posts.feeds.map((value) => value.postId).toList();
      stringOfPostID = stringPost!.join(",");
      return value;
    });
  }

  void _onRefresh() async {
    print("on refresh called");
    currentPage = 1;
    _getPosts();
    setState(() {});

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    int len = posts.feeds.length;
    String urlStr = "";
    // for (int i = 0; i < len; i++) {
    //   urlStr += posts.feeds[i].postId;
    //   if (i != len - 1) {
    //     urlStr += ",";
    //   }
    // }

    var page = posts.feeds[len - 1].page;
    if (page != currentPage)
      return;
    else
      currentPage = page! + 1;

    try {
      var newurl = Uri.parse(
          'https://www.bebuzee.com/api/image/list?user_id=${CurrentUser().currentUser.memberID}&post_id=&country=${CurrentUser().currentUser.country}&page=$currentPage');
      // var newurl = Uri.parse(
      //     'https://www.bebuzee.com/api/new_feed_data.php?user_id=${CurrentUser().currentUser.memberID}&post_ids=$urlStr&action=fetch_post_data_people_images&country=${CurrentUser().currentUser.country}&hash_tag=$selectedHashtag');

      print('urlstr=${newurl}');
      var client = Dio();
      String? token = await ApiProvider().getTheToken();
      await client
          .postUri(
        newurl,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      )
          .then((value) async {
        print("loading status ${value.data}");
        if (value.statusCode == 200 && value.data['status'] == 1) {
          AllFeeds postsData = AllFeeds.fromJson(value.data['data']);
          await Future.wait(postsData.feeds
              .map((e) => PreloadCached.cacheImage(
                  context, e.postsmlImgData!.split("~~")[0]))
              .toList());
          AllFeeds postsTemp = posts;
          postsTemp.feeds.addAll(postsData.feeds);
          for (int i = 0; i < posts.feeds.length; i++) {
            if (posts.feeds[i].shortVideo == 1) {
              boostedCount++;

              if (boostedCount % 2 != 0) {
                posts.feeds[i].long = 1;
              } else {
                posts.feeds[i].long = 2;
              }
            }
          }
          /* have commented
          for (int i = 0; i < postsData.feeds.length; i++) {
            if (postsData.feeds[i].boostData == 1 ||
                postsData.feeds[i].shortVideo == 1) {
              print(
                  "entered here in shortVideo ${postsData.feeds[i].shortVideo}");
              boostedCount++;
              if (boostedCount % 2 == 0) {
                postsData.feeds[i].long = 1;
              } else {
                postsData.feeds[i].long = 2;
              }
            }
          }
          */
          print("loaded baal");
          if (mounted) {
            setState(() {
              // stringOfPostID = stringOfPostID + "," + urlStr;
              posts = postsTemp;
            });
          }
        } else {
          _refreshController.loadComplete();
          currentPage = page;
        }
      });

      // var url = Uri.parse(
      //     "https://www.bebuzee.com/new_files/all_apis/people_images_api_call.php");

      // final response = await http.post(url, body: {
      //   "user_id": CurrentUser().currentUser.memberID,
      //   "post_ids": urlStr,
      //   "action": "fetch_post_data_people_images",
      //   "country": CurrentUser().currentUser.country,
      //   "hash_tag": selectedHashtag
      // });
      // if (response.statusCode == 200) {
      //   AllFeeds postsData = AllFeeds.fromJson(jsonDecode(response.body));
      //   await Future.wait(postsData.feeds
      //       .map((e) =>
      //           PreloadCached.cacheImage(context, e.postImgData.split("~~")[0]))
      //       .toList());
      //   AllFeeds postsTemp = posts;
      //   postsTemp.feeds.addAll(postsData.feeds);

      //   for (int i = 0; i < postsData.feeds.length; i++) {
      //     if (postsData.feeds[i].boostData == 1 ||
      //         postsData.feeds[i].shortVideo == 1) {
      //       boostedCount++;
      //       if (boostedCount % 2 == 0) {
      //         postsData.feeds[i].long = 1;
      //       } else {
      //         postsData.feeds[i].long = 2;
      //       }
      //     }
      //   }

      //   if (mounted) {
      //     setState(() {
      //       stringOfPostID = stringOfPostID + "," + urlStr;
      //       posts = postsTemp;
      //     });
      //   }
      // }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } catch (e) {
      print('loaded baal 2');
      _refreshController.loadComplete();
    }
    print('loaded baal 3');
    _refreshController.loadComplete();
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DiscoverSearchPage(
                        setNavBar: widget.setNavBar,
                        isChannelOpen: widget.isChannelOpen,
                        changeColor: widget.changeColor,
                        memberImage: CurrentUser().currentUser.image,
                        memberID: CurrentUser().currentUser.memberID,
                        country: CurrentUser().currentUser.country,
                        logo: CurrentUser().currentUser.logo,
                        lat: latitude,
                        long: longitude,
                      )));
        },
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.search),
                SizedBox(
                  width: 20,
                ),
                Text(
                  AppLocalizations.of('Search'),
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.4), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _hashtagsList() {
    return FutureBuilder(
        future: _hashtagFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 40,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _hashtags.discoverHashtags.length,
                  itemBuilder: (context, index) {
                    return DiscoverTagCard(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiscoverFromTagsView(
                                      tag: _hashtags
                                          .discoverHashtags[index].hashtag,
                                      changeColor: widget.changeColor!,
                                      isChannelOpen: widget.isChannelOpen!,
                                      profileOpen: widget.profileOpen!,
                                      setNavBar: widget.setNavBar!,
                                    )));
                      },
                      tags: _hashtags.discoverHashtags[index],
                    );
                  }),
            );
          } else {
            return hashtagPlaceholder();
          }
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.toString() == "AppLifecycleState.paused") {
      setState(() {
        offTime = DateTime.now();
      });
    }
    var diff = DateTime.now().difference(offTime).inMinutes;
    if (state.toString() == "AppLifecycleState.resumed" && diff > 15) {
      print("");
    }
  }

  void _getLocalPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? data = prefs.getString("discover_main");
    try {
      if (data != null) {
        print("entered on local data discovber people");
        _postsFuture = DiscoverApiCalls.getLocalPosts().then((value) {
          if (mounted) {
            setState(() {
              posts.feeds = value.feeds;
            });
          }

          for (int i = 0; i < posts.feeds.length; i++) {
            if (mounted) {
              setState(() {
                if (posts.feeds[i].boostData == 1 ||
                    posts.feeds[i].shortVideo == 1) {
                  print(
                      "discover feed shortvideo=${posts.feeds[i].shortVideo} boostedcount=${posts.feeds[i].boostData}");
                  boostedCount++;
                  if (boostedCount % 2 == 0) {
                    posts.feeds[i].long = 1;
                  } else {
                    posts.feeds[i].long = 2;
                  }
                }
              });
            }
          }
          List<String?> stringPost =
              posts.feeds.map((value) => value.postId).toList();
          stringOfPostID = stringPost.join(",");
          return value;
        });
      } else {
        _getPosts();
      }
    } catch (e) {
      _getPosts();
    }
  }

  @override
  void initState() {
    print("entered disco bia");
    _getPosts();
    // _getLocalPosts();
    _getHashtagsLocal();
    getLocation();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("enteted discooooooo");
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                      height: 100.0.h - 105,
                      child: FutureBuilder(
                          future: _postsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print("dicover ppl have data");
                              return NotificationListener<
                                  UserScrollNotification>(
                                onNotification: (v) {
                                  print("discoverpage scroll=${v.direction}");
                                  if (v.direction == ScrollDirection.reverse) {
                                    _onLoading();
                                  }
                                  return true;
                                },
                                child: SmartRefresher(
                                  enablePullDown: true,
                                  enablePullUp: true,
                                  header: CustomHeader(
                                    builder: (context, mode) {
                                      return Container(
                                        child:
                                            Center(child: loadingAnimation()),
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
                                        body = loadingAnimation();
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
                                        body = Text("");
                                      } else {
                                        body = Text("");
                                      }
                                      return Container(
                                        height: 55.0,
                                        child: Center(child: body),
                                      );
                                    },
                                  ),
                                  controller: _refreshController,
                                  onRefresh: _onRefresh,
                                  onLoading: () {
                                    _onLoading();
                                  },
                                  child: StaggeredGridView.countBuilder(
                                    addAutomaticKeepAlives: false,
                                    controller: widget.scrollController,
                                    crossAxisCount: 6,
                                    itemCount: posts.feeds.length + 1,
                                    mainAxisSpacing: 2,
                                    crossAxisSpacing: 2,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Container(
                                          child: Column(
                                            children: [
                                              _searchBar(),
                                              _hashtagsList(),
                                            ],
                                          ),
                                        );
                                      } else {
                                        print(
                                            "current discover feed index =${index}");

                                        print("the post id aftyyer setstate");
                                        return DiscoverImageCard(
                                          index: index,
                                          setNavBar: widget.setNavBar,
                                          isChannelOpen: widget.isChannelOpen,
                                          changeColor: widget.changeColor,
                                          hideNavbar: () {
                                            print(
                                                " the post id aftyyer refresh =${posts.feeds[index - 1].postId} posttyope=${posts.feeds[index - 1].postType} url=${posts.feeds[index - 1].video}");

                                            widget.setNavBar!(true);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShortbuzMainPage(
                                                    profileOpen:
                                                        widget.profileOpen,
                                                    setNavBar: widget.setNavBar,
                                                    isChannelOpen:
                                                        widget.isChannelOpen,
                                                    changeColor:
                                                        widget.changeColor,
                                                    from: "discover",
                                                    postID: posts
                                                        .feeds[index - 1]
                                                        .postId,
                                                  ),
                                                ));
                                          },
                                          post: posts.feeds[index - 1],
                                          memberID: CurrentUser()
                                              .currentUser
                                              .memberID,
                                          country:
                                              CurrentUser().currentUser.country,
                                          currentMemberImage:
                                              CurrentUser().currentUser.image,
                                          logo: CurrentUser().currentUser.logo,
                                          stringOfPostID: stringOfPostID,
                                        );
                                      }
                                    },
                                    staggeredTileBuilder: (index) {
                                      if (index == 0) {
                                        // return StaggeredTile.count(6, 1.75);
                                        return StaggeredTile.count(6, 1.75);
                                      }

                                      if (posts.feeds[index - 1].shortVideo ==
                                          1) {
                                        print(
                                            "the long val=${posts.feeds[index - 1].long}");
                                        if (posts.feeds[index - 1].long == 1)
                                          return StaggeredTile.count(2, 4);
                                        else {
                                          return StaggeredTile.count(4, 4);
                                        }
                                      }
                                      return StaggeredTile.count(2, 2);
/*  
                                      if (index == 0) {
                                        // return StaggeredTile.count(6, 1.75);
                                        return StaggeredTile.count(6, 1.75);
                                      }
                                      if (posts.feeds[index - 1].long == 1) {
                                        return StaggeredTile.count(2, 4);
                                        // return StaggeredTile.fit(3);
                                      } else if (posts.feeds[index - 1].long ==
                                          2) {
                                        return StaggeredTile.count(4, 4);
                                        // return StaggeredTile.fit(4);
                                      } else {
                                        return StaggeredTile.count(2, 2);
                                        // return StaggeredTile.fit(2);
                                      }

                                      */
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }));
                }, childCount: 1),
              )
            ],
          ),
        ));
  }
}
