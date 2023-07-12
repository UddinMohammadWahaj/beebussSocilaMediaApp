import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/discover_hashtags.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/country_name.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/widgets/DiscoverFeeds/discover_image_card_tags.dart';
import 'package:bizbultest/widgets/DiscoverFeeds/discover_tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'discover_feeds_page.dart';

class DiscoverPageFromTags extends StatefulWidget {
  final String? logo;
  final String? memberID;
  final String? country;
  final String? tag;
  final String? currentMemberImage;

  DiscoverPageFromTags(
      {Key? key,
      this.logo,
      this.memberID,
      this.country,
      this.tag,
      this.currentMemberImage})
      : super(key: key);

  @override
  _DiscoverPageFromTagsState createState() => _DiscoverPageFromTagsState();
}

class _DiscoverPageFromTagsState extends State<DiscoverPageFromTags> {
  TextEditingController _searchController = TextEditingController();

  DiscoverHashtags? tags;
  AllFeeds? posts;
  var selectedHashtag = "";
  bool? changeTag = false;
  bool? hasPosts = false;
  bool? hasTags = false;
  var countryName;
  double? latitude;
  double? longitude;
  String? stringOfPostID;

  Future<String> getLocation() async {
    Network n = new Network("http://ip-api.com/json");
    var locationSTR = (await n.getData());
    var locationX = jsonDecode(locationSTR);
    setState(() {
      countryName = locationX["country"];
      latitude = locationX["lat"];
      longitude = locationX["lon"];
    });

    return "success";
  }

  Future<void> getHashtags(String tag) async {
    var url = Uri.parse(
        "https://www.bebuzee.com/api/new_feed_data.php?action=fetch_post_data_people_images_hashtag_data&user_id=${widget.memberID}&country=${widget.country}&hash_tag=$tag");

    var response = await http.get(url);

    // print(response.body);
    if (response.statusCode == 200) {
      DiscoverHashtags hashTagData =
          DiscoverHashtags.fromJson(jsonDecode(response.body));
      // print(hashTagData.discoverHashtags[0].hashtag);
      setState(() {
        tags = hashTagData;
        hasTags = true;
      });
    }
    if (response.body == null || response.statusCode != 200) {
      setState(() {
        hasTags = false;
      });
    }
  }

  Future<void> getPosts(String tag) async {
    print("hashtag get posts called");
    var url = Uri.parse(
        "https://www.bebuzee.com/api/new_feed_data.php?user_id=${widget.memberID}&country=${widget.country}&hash_tag=$tag");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      AllFeeds postsData = AllFeeds.fromJson(jsonDecode(response.body));
      //await Future.wait(postsData.feeds.map((e) => Preload.cacheImage(context, e.postImgData.split("~~")[0])).toList());
      // await Future.wait(postsData.feeds.map((e) => PreloadUserImage.cacheImage(context, e.postUserPicture)).toList());
      if (mounted) {
        setState(() {
          posts = postsData;
          hasPosts = true;
          List<String?> stringPost =
              posts!.feeds.map((value) => value.postId).toList();
          //print(stringPost);
          stringOfPostID = stringPost.join(",");
        });
      }

      if (response.body == null || response.statusCode != 200) {
        setState(() {
          hasPosts = false;
        });
      }
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    getPosts(widget.tag!);
    _refreshController.refreshCompleted();
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void _onLoading() async {
    print("loading has tag cont called");
    int len = posts!.feeds.length;
    String urlStr = "";
    for (int i = 0; i < len; i++) {
      urlStr += posts!.feeds[i].postId!;
      if (i != len - 1) {
        urlStr += ",";
      }
    }

    try {
      print("loading has tag cont called");
      var url = Uri.parse(
          "https://www.bebuzee.com/new_files/all_apis/people_images_api_call.php");

      final response = await http.post(url, body: {
        "user_id": widget.memberID,
        "post_ids": urlStr,
        "action": "fetch_post_data_people_images",
        "country": widget.country,
        "hash_tag": selectedHashtag
      });
      if (response.statusCode == 200) {
        AllFeeds postsData = AllFeeds.fromJson(jsonDecode(response.body));
        //await Future.wait(postsData.feeds.map((e) => Preload.cacheImage(context, e.postImgData)).toList());
        // await Future.wait(postsData.feeds.map((e) => PreloadUserImage.cacheImage(context, e.postUserPicture)).toList());
        AllFeeds postsTemp = posts!;
        postsTemp.feeds.addAll(postsData.feeds);
        if (mounted) {
          Timer(Duration(milliseconds: 400), () {
            setState(() {
              posts = postsTemp;
              hasPosts = true;
              stringOfPostID = stringOfPostID! + "," + urlStr;
            });
          });
        }
      }
      if (response.body == null || response.statusCode != 200) {
        setState(() {
          hasPosts = false;
        });
      }
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: "Couldn't refresh feed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
        fontSize: 15.0,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          _refreshController.loadFailed();
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          return Container();
        },
      );
    }
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    print(widget.tag);
    selectedHashtag = widget.tag!;
    getLocation();
    getPosts(widget.tag!);
    getHashtags(widget.tag!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
      ),
      backgroundColor: Colors.white,
      body: hasPosts == true
          ? Container(
              child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    height: 93.0.h,
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: CustomHeader(
                        builder: (context, mode) {
                          return Container(
                            child: Center(child: loadingAnimation()),
                          );
                        },
                      ),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus? mode) {
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
                                      color: Colors.black, width: 0.7),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Icon(CustomIcons.reload),
                                ));
                          } else if (mode == LoadStatus.canLoading) {
                            body = Text("");
                          } else {
                            body = Text(
                              AppLocalizations.of(
                                "No more Data",
                              ),
                            );
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 6,
                        itemCount: posts!.feeds.length + 1,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Container(
                              child: hasTags!
                                  ? Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          splashColor:
                                              Colors.grey.withOpacity(0.3),
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 3.0.w,
                                                  top: 2.0.h,
                                                  right: 3.0.w,
                                                  bottom: 2.0.h),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .keyboard_backspace_outlined,
                                                    size: 27,
                                                  ),
                                                  SizedBox(
                                                    width: 4.0.w,
                                                  ),
                                                  Text(
                                                    changeTag == false
                                                        ? "#" + widget.tag!
                                                        : "#" + selectedHashtag,
                                                    style: blackBold.copyWith(
                                                        fontSize: 25),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 0.0.h),
                                          child: Container(
                                            height: 4.8.h,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: tags!
                                                    .discoverHashtags.length,
                                                itemBuilder: (context, index) {
                                                  return DiscoverTagCard(
                                                    tags:
                                                        tags!.discoverHashtags[
                                                            index],
                                                  );
                                                }),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            );
                          } else {
                            return DiscoverTagsImageCard(
                                feed: posts!.feeds[index - 1],
                                onPress: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DiscoverFeedsPage(
                                                posts: posts!.feeds[index - 1],
                                                currentMemberImage:
                                                    widget.currentMemberImage,
                                                listOfPostID: stringOfPostID,
                                                postID: posts!
                                                    .feeds[index - 1].postId,
                                                logo: widget.logo,
                                                country: widget.country,
                                                memberID: widget.memberID,
                                              )));
                                });
                          }
                        },
                        staggeredTileBuilder: (index) {
                          if (index == 0) {
                            return StaggeredTile.count(6, 1.7);
                          } else {
                            return StaggeredTile.count(2, 2);
                          }
                        },
                      ),
                    ),
                  );
                })),
              ],
            ))
          : Container(),
    );
  }
}
