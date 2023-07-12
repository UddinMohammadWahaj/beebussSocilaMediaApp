import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/discover_hashtags.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/providers/discover/discover_tags_provider.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/utilities/precache.dart';
import 'package:bizbultest/view/shortbuz_%20main_page_suggestion.dart';
import 'package:bizbultest/widgets/DiscoverFeeds/discover_image_card_tags.dart';
import 'package:bizbultest/widgets/DiscoverFeeds/discover_tags.dart';
import 'package:bizbultest/widgets/discover_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_text/skeleton_text.dart';
import 'discover_feeds_page.dart';
import 'package:bizbultest/services/Discover/discover_api_calls.dart';

class DiscoverFromTagsView extends StatefulWidget {
  final String? tag;
  Function? profileOpen;
  Function? setNavBar;
  Function? isChannelOpen;
  Function? changeColor;

  DiscoverFromTagsView(
      {Key? key,
      this.tag,
      this.profileOpen,
      this.setNavBar,
      this.isChannelOpen,
      this.changeColor})
      : super(key: key);

  @override
  _DiscoverFromTagsViewState createState() => _DiscoverFromTagsViewState();
}

class _DiscoverFromTagsViewState extends State<DiscoverFromTagsView> {
  late Future _discoverPostsFuture;
  late Future _hashtagsFuture;

  @override
  void initState() {
    Provider.of<DiscoverTagsProvider>(context, listen: false).selectedTag =
        widget.tag!;
    _discoverPostsFuture =
        Provider.of<DiscoverTagsProvider>(context, listen: false)
            .getPosts(context, widget.tag!);
    _hashtagsFuture = Provider.of<DiscoverTagsProvider>(context, listen: false)
        .getHashtags(widget.tag!.replaceFirst('#', ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("hashtag page entry");
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            title: Consumer<DiscoverTagsProvider>(
              builder: (BuildContext context, provider, Widget? child) {
                return Text(
                  AppLocalizations.of('${provider.selectedTag}'),
                  style: TextStyle(fontSize: 25, color: Colors.black),
                );
              },
            ),
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_backspace,
                size: 28,
              ),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
            child: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                  height: 100.0.h - 100,
                  child: DiscoverTagsItem(
                    postsFuture: _discoverPostsFuture,
                    tag: widget.tag!,
                    tagsFuture: _hashtagsFuture,
                    changeColor: widget.changeColor!,
                    isChannelOpen: widget.isChannelOpen!,
                    profileOpen: widget.profileOpen!,
                    setNavBar: widget.setNavBar!,
                  ));
            }, childCount: 1)),
          ],
        )));
  }
}

class DiscoverTagsItem extends StatelessWidget {
  final Future? postsFuture;
  final Future? tagsFuture;
  final String? tag;
  Function? profileOpen;
  Function? setNavBar;
  Function? isChannelOpen;
  Function? changeColor;

  DiscoverTagsItem(
      {Key? key,
      this.postsFuture,
      this.tag,
      this.tagsFuture,
      this.profileOpen,
      this.setNavBar,
      this.isChannelOpen,
      this.changeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Entered hastag detail");
    return Consumer<DiscoverTagsProvider>(
      builder: (BuildContext context, discoverProvider, Widget? child) {
        return FutureBuilder(
            future: postsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return NotificationListener<UserScrollNotification>(
                  onNotification: (v) {
                    if (v.direction == ScrollDirection.reverse) {
                      discoverProvider.onLoading(
                          discoverProvider.selectedTag, context);
                    }
                    return true;
                  },
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
                          print("loading");
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
                            AppLocalizations.of("No more data"),
                          );
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: discoverProvider.controller,
                    onRefresh: () {
                      print("refresh called");
                      discoverProvider.controller.isLoading
                          ? print("loading controller")
                          : print("refresh controller");

                      return discoverProvider.onRefresh(
                          discoverProvider.selectedTag, context);
                    },
                    scrollDirection: Axis.vertical,
                    onLoading: () {
                      print("loading state aha ");
                      return discoverProvider.onLoading(
                          discoverProvider.selectedTag, context);
                    },
                    child: StaggeredGridView.countBuilder(
                      addAutomaticKeepAlives: false,
                      crossAxisCount: 6,
                      itemCount: discoverProvider.postsList.length + 1,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Container(
                              height: 40,
                              child: FutureBuilder(
                                  future: tagsFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      print("hashnot null");
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              discoverProvider.tagsList.length,
                                          itemBuilder: (context, index) {
                                            return DiscoverTagCard(
                                              tags: discoverProvider
                                                  .tagsList[index],
                                              onTap: () {
                                                print("tapped on hash");
                                                discoverProvider.selectedTag =
                                                    discoverProvider
                                                        .tagsList[index]
                                                        .hashtag!;
                                                discoverProvider.getHashtags(
                                                    discoverProvider
                                                        .selectedTag);
                                                discoverProvider.getPosts(
                                                    context,
                                                    discoverProvider
                                                        .selectedTag);
                                              },
                                            );
                                          });
                                    } else {
                                      print("hashnull");
                                      return hashtagPlaceholder();
                                    }
                                  }),
                            ),
                          );
                        } else {
                          print("hashnull this");

                          if (discoverProvider.postsList[index - 1].postType ==
                              'svideo') {
                            return GestureDetector(
                              onTap: () {
                                print("tapped");
                                this.setNavBar!(true);
                                print("tapped2");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShortbuzMainPageSuggestion(
                                              from: "$tag",
                                              fromHashtag: true,
                                              profileOpen: this.profileOpen,
                                              setNavBar: this.setNavBar,
                                              isChannelOpen: this.isChannelOpen,
                                              changeColor: this.changeColor,
                                              postID: discoverProvider
                                                  .postsList[index - 1].postId,
                                            )));
                              },
                              child: DiscoverVideoPlayer(
                                image: discoverProvider
                                    .postsList[index - 1].postVideoThumb,
                                url:
                                    discoverProvider.postsList[index - 1].video,
                              ),
                            );
                          } else {
                            print(
                                "hash no data =${discoverProvider.postsList[index - 1]}");
                          }

                          return DiscoverTagsImageCard(
                              feed: discoverProvider.postsList[index - 1],
                              onPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DiscoverFeedsPage(
                                              posts: discoverProvider
                                                  .postsList[index - 1],
                                              currentMemberImage: CurrentUser()
                                                  .currentUser
                                                  .image,
                                              listOfPostID:
                                                  discoverProvider.allPosts,
                                              postID: discoverProvider
                                                  .postsList[index - 1].postId,
                                              logo: CurrentUser()
                                                  .currentUser
                                                  .logo,
                                              country: CurrentUser()
                                                  .currentUser
                                                  .country,
                                              memberID: CurrentUser()
                                                  .currentUser
                                                  .memberID,
                                            )));
                              });
                        }
                      },
                      staggeredTileBuilder: (index) {
                        if (index == 0) {
                          return StaggeredTile.count(6, 0.7);
                        } else {
                          if (discoverProvider.postsList[index - 1].postType ==
                              'svideo') return StaggeredTile.count(2, 4);

                          return StaggeredTile.count(2, 2);
                        }
                      },
                    ),
                  ),
                );
              } else {
                return SkeletonAnimation(
                  child: Container(
                    height: Get.height,
                    width: Get.width,
                    child: StaggeredGridView.countBuilder(
                      addAutomaticKeepAlives: false,
                      crossAxisCount: 6,
                      staggeredTileBuilder: (index) {
                        if (index == 0) {
                          return StaggeredTile.count(6, 0.7);
                        }
                        return StaggeredTile.count(2, 2);
                      },
                      itemCount: 20,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      itemBuilder: (context, index) => AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                );
              }
            });
      },
    );
  }
}
