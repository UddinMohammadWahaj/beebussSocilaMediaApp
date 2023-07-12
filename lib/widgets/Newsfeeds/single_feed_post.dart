import 'dart:async';
import 'dart:convert';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/view/discover_people_from_tags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/Properbuz/properbuz_feeds_model.dart';
import '../../utilities/loading_indicator.dart';
import '../../view/Properbuz/detailed_feed_view.dart';
import '../Properbuz/feeds/feed_post_card.dart';
import 'feed_footer.dart';
import 'feed_header.dart';
import '../../../api/ApiRepo.dart' as ApiRepo;

class SingleFeedPost extends StatefulWidget {
  final String? postID;
  final String? memberID;
  final String? postType;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  final Function? profileOpen;
  final Function? refresh;

  SingleFeedPost(
      {Key? key,
      this.postID,
      this.memberID,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar,
      this.profileOpen,
      this.refresh,
      this.postType})
      : super(key: key);

  @override
  _SingleFeedPostState createState() => _SingleFeedPostState();
}

class _SingleFeedPostState extends State<SingleFeedPost> {
  bool isFeedLoaded = false;
  AllFeeds? feedsList;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> getSingleFeed() async {
    var url =
        "https://www.bebuzee.com/api/news_feed_single_post.php?action=new_feed_data_single_post&user_id=${widget.memberID}&post_id=${widget.postID}";
    print(url);
    var response = await ApiProvider().fireApi(url);
    // var response = await http.get(url);
    print("------- ${response.data}");
    if (response.statusCode == 200) {
      AllFeeds feedData = AllFeeds.fromJson(response.data['data']);
      if (mounted) {
        setState(() {
          feedsList = feedData;
          isFeedLoaded = true;
        });
        print("====== ${feedsList!.feeds![0].postType}");
      }
    }
  }

  // Future<void> getProperbuzzFeed() async {
  //   var url =
  //       "https://www.bebuzee.com/api/properbuzz_news_feed.php?action=new_feed_data_single_post&country=India&user_id=${widget.memberID}&post_id=${widget.postID}";
  //   print(url);
  //   var response = await ApiProvider().fireApi(url);
  //   // var response = await http.get(url);
  //   print("------- ${response.data}");
  //   ProperbuzFeeds properbuzFeeds =
  //       ProperbuzFeeds.fromJson(response.data['data']);
  //   return properbuzFeeds.feeds;
  // }

  @override
  void initState() {
    // widget.postType == "properbuzzPost" ?
    // getProperbuzzFeed()
    // :
    getSingleFeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.black,
          onPressed: () {
            // widget.setNavBar(false);
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of('Feed Post'),
          style: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        brightness: Brightness.light,
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          // widget.setNavBar(false);
          return true;
        },
        child: Container(
          child: isFeedLoaded
              ? SingleChildScrollView(
                  child: Container(
                    // color: Colors.pink,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        FeedHeader(
                          refresh: () {
                            Timer(Duration(seconds: 2), () {
                              getSingleFeed();
                            });
                          },
                          setNavBar: widget.setNavBar!,
                          isChannelOpen: widget.isChannelOpen!,
                          changeColor: widget.changeColor!,
                          feed: feedsList!.feeds[0],
                          sKey: _scaffoldKey,
                        ),
                        FeedFooter(
                          stickerList: feedsList!.feeds[0].stickers,
                          positionList: feedsList!.feeds[0].position,
                          setNavBar: widget.setNavBar,
                          isChannelOpen: widget.isChannelOpen,
                          changeColor: widget.changeColor,
                          sKey: _scaffoldKey,
                          feed: feedsList!.feeds[0],
                          onPressMatchText: (value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DiscoverFromTagsView(
                                    tag: value.toString().substring(1),
                                  ),
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: Container(child: loadingAnimation())),
        ),
      ),
    );
  }
}
