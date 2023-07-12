import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/Bebuzeesearch/bebuzeesearchview.dart';
import 'package:bizbultest/view/discover_feeds_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../api/api.dart';
import '../../models/video_section/video_list_model.dart';
import '../../services/Discover/discover_api_calls.dart';
import '../../utilities/custom_icons.dart';
import '../../utilities/precache.dart';
import '../../widgets/MainVideoWidgets/expanded_video_player.dart';
import '../../widgets/all_cat_icons.dart';
import '../Buzzfeed/buzzfeed_logo_icons.dart';
import '../Buzzfeed/buzzfeedview.dart';
import '../Buzzfeed/shopbuz_logo_icon.dart';
import '../expanded_blog_page.dart';
import '../shortbuz_main_page.dart';

class BebuzeeSearchInnerView extends StatefulWidget {
  BebuzeeSearchController controller;
  String keysearch;
  BebuzeeSearchInnerView(
      {Key? key, required this.controller, required this.keysearch})
      : super(key: key);

  @override
  State<BebuzeeSearchInnerView> createState() => _BebuzeeSearchInnerViewState();
}

class _BebuzeeSearchInnerViewState extends State<BebuzeeSearchInnerView>
    with SingleTickerProviderStateMixin {
  var textconttroller = TextEditingController();
  late TabController tabcontroller;
  late List<VideoListModelData> videoList;
  bool hasData = false;
  @override
  void initState() {
    tabcontroller = TabController(
      initialIndex: 0,
      length: 10,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget customTextBox() {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20)),
          child: TextField(
            cursorColor: Colors.black,
            enabled: false,
            onTap: () {
              Navigator.of(context).pop();
            },
            controller: textconttroller,
            onChanged: (v) {
              // controller.search.value = v;
              widget.controller.search.value = textconttroller.text;
            },
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              color: Colors.black,
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              focusColor: Colors.white,
              prefixIcon: Icon(Icons.search, color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: Colors.white, width: 2, style: BorderStyle.solid)),
              fillColor: Colors.white,
              // filled: true,
              disabledBorder: InputBorder.none,
              hintText: '${widget.keysearch}',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),

              hintStyle: TextStyle(
                  fontFamily: 'LeagueSpartanMedium',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w200),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
        ),
      );
    }

    Future<List<VideoListModelData>> getVideos(postid) async {
      var newUrl = Uri.parse(
          'https://www.bebuzee.com/api/video/videoData?user_id=${CurrentUser().currentUser.memberID}&keyword=&post_ids=&country=WorldWide&page=1&post_id=${postid}');
      var client = Dio();
      String? token = await ApiProvider().getTheToken();
      print("video url=${newUrl}");
      var response = await client
          .postUri(
            newUrl,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }),
          )
          .then((value) => value);
      var url = Uri.parse(
          "https://www.bebuzee.com/new_files/all_apis/video_page_api_call.php?action=get_search_video_data&user_id=${CurrentUser().currentUser.memberID}&keyword=&post_ids=&country=${CurrentUser().currentUser.country}&page=1");
      // var response = await http.get(url);
      //print(response.body);

      if (response.statusCode == 200) {
        print("video list=${response.data}");
        // Videos videoData = Videos.fromJson(response.data['data']);

        VideoListModel videoData = VideoListModel.fromJson(response.data);

        await Future.wait(videoData.data!
            .map((e) => Preload.cacheImage(context, e.image!))
            .toList());
        return videoData.data!;
        // await Future.wait(videoData.videos
        //     .map((e) => Preload.cacheImage(context, e.image))
        //     .toList());

        //print(peopleData.people[0].name);
        // setState(() {
        //   videoList = videoData.data!;
        //   hasData = true;
        // });

        // if (response.data == null || response.statusCode != 200) {
        //   setState(() {
        //     hasData = false;
        //   });
        // }
      } else {
        return <VideoListModelData>[];
      }
    }

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight * 1.5,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            centerTitle: true,
            toolbarHeight: kToolbarHeight,
            elevation: 0,
            title: TabBar(
                isScrollable: true,
                labelColor: Colors.white,
                labelPadding: EdgeInsets.all(15),
                indicatorColor: Colors.black,
                // padding: EdgeInsets.all(10),
                controller: tabcontroller,
                labelStyle:
                    TextStyle(fontSize: 15, fontFamily: 'LeagueSpartanMedium'),
                tabs: [
                  Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 1.0.w,
                      ),
                      Text('All', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.group,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 1.0.w,
                      ),
                      Text('Users', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        CustomIcons.video1,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 1.2.w,
                      ),
                      Text('Videos', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        BuzzfeedLogo.buzzfeedlogo,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 1.2.w,
                      ),
                      Text('Buzz', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  // Text('Videos', style: TextStyle(color: Colors.black)),
                  // Text('Buzz', style: TextStyle(color: Colors.black)),

                  Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 1.2.w,
                      ),
                      Text('Images', style: TextStyle(color: Colors.black)),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        CustomIcons.blogg,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 1.2.w,
                      ),
                      Text('Blogs', style: TextStyle(color: Colors.black)),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        CustomIcons.properbuz,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 1.2.w,
                      ),
                      Text('Properties', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        ShopbuzLogo.img_20221026_wa0009__2___1_,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 1.2.w,
                      ),
                      Text('Shopbuz', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Row(children: [
                    Icon(
                      Icons.newspaper,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 1.2.w,
                    ),
                    Text('Real Estate News',
                        style: TextStyle(color: Colors.black))
                  ]),
                  Row(children: [
                    Icon(
                      TradeIicon.app_icon_black_3d__1_,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 1.2.w,
                    ),
                    Text('Tradesman', style: TextStyle(color: Colors.black))
                  ]),
                ]),
          ),
          title: customTextBox(),
          leading: IconButton(
              onPressed: () {
                widget.controller.bebuzeesearchdata.value = [];
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        body: TabBarView(
          controller: tabcontroller,
          children: [
            Obx(
              () => widget.controller.bebuzeesearchdata.value.length == 0
                  ? Container(
                      height: 100.0.h,
                      width: 100.0.w,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          widget.controller.bebuzeesearchdata.value.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {},
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.controller.bebuzeesearchdata[index].description}',
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 1.0.h,
                              ),
                              Text(
                                  '${widget.controller.bebuzeesearchdata[index].date ?? ''}')
                            ],
                          ),
                          leading: Container(
                            height: 10.0.h,
                            width: 15.0.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      widget.controller.bebuzeesearchdata[index]
                                          .image,
                                    ))),
                          ),
                          title: Text(
                            '${widget.controller.bebuzeesearchdata.value[index].title}',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
            ),
            Obx(
              () => widget.controller.bebuzeesearchdata.value.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount: widget
                          .controller
                          .bebuzeesearchdata
                          .value
                          // .where((element) => element.type == 'user')
                          // .toList()
                          .length,
                      itemBuilder: (context, index) {
                        print(
                            "lengthh type useer=${widget.controller.bebuzeesearchdata.value.where((element) => element.type == 'user').toList().length}");
                        if (widget.controller.bebuzeesearchdata[index].type !=
                            'user')
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {},
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.controller.bebuzeesearchdata[index].description}',
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Text(
                                    '${widget.controller.bebuzeesearchdata[index].date ?? ''}')
                              ],
                            ),
                            leading: Container(
                              height: 10.0.h,
                              width: 15.0.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        widget.controller
                                            .bebuzeesearchdata[index].image,
                                      ))),
                            ),
                            title: Text(
                              '${widget.controller.bebuzeesearchdata.value[index].title}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      }),
            ),
            Obx(
              () => widget.controller.bebuzeesearchdata.value.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount:
                          widget.controller.bebuzeesearchdata.value.length,
                      itemBuilder: (context, index) {
                        if (widget.controller.bebuzeesearchdata[index].type ==
                                'video' ||
                            widget.controller.bebuzeesearchdata[index].type ==
                                'svideo')
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () async {
                                if (widget.controller.bebuzeesearchdata[index]
                                        .type ==
                                    'video') {
                                  var videoList = await getVideos(widget
                                      .controller.bebuzeesearchdata[index].id
                                      .toString());
                                  print("video-->${videoList.length}");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ExpandedVideoPlayer(
                                          rebuzed: () {},
                                          adsList: null,

                                          copied: () {},
                                          onPress: () {},

                                          // dispose: showNoPlayer,
                                          video: videoList[0],
                                          expand: () {},
                                          onPressHide: () {},
                                          showFullPlayer: true, onPop: () {},
                                        ),
                                      ));
                                }

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShortbuzMainPage(
                                        profileOpen: () {},
                                        setNavBar: () {},
                                        isChannelOpen: () {},
                                        changeColor: () {},
                                        from: "discover",
                                        postID: widget.controller
                                            .bebuzeesearchdata[index].id
                                            .toString(),
                                      ),
                                    ));
                              },
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.controller.bebuzeesearchdata[index].description}',
                                    maxLines: 2,
                                  ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  Text(
                                      '${widget.controller.bebuzeesearchdata.value[index].type}'),
                                  Text(
                                      '${widget.controller.bebuzeesearchdata[index].date ?? ''}')
                                ],
                              ),
                              leading: Container(
                                height: 10.0.h,
                                width: 15.0.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          widget.controller
                                              .bebuzeesearchdata[index].image,
                                        ))),
                              ),
                              title: Text(
                                '${widget.controller.bebuzeesearchdata.value[index].title}',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        return Container(
                          height: 0,
                          width: 0,
                        );
                      }),
            ),
            Obx(
              () => widget.controller.bebuzeesearchdata.value.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount:
                          widget.controller.bebuzeesearchdata.value.length,
                      itemBuilder: (context, index) {
                        if (widget.controller.bebuzeesearchdata[index].type !=
                            'buzzerfeed')
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () async {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                builder: (context) => SingleChildScrollView(
                                  child: Container(
                                    height: 80.0.h,
                                    width: 100.0.w,
                                    child: BuzzfeedView(
                                      key: Key(
                                          CurrentUser().currentUser.memberID!),
                                      from: 'search',
                                      postid: widget.controller
                                          .bebuzeesearchdata[index].id
                                          .toString(),
                                    ),
                                  ),
                                ),
                              );
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => BuzzfeedView(
                              //     key: Key(CurrentUser().currentUser.memberID!),
                              //     from: 'search',
                              //     postid: widget
                              //         .controller.bebuzeesearchdata[index].id
                              //         .toString(),
                              //   ),
                              // ));
                            },
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.controller.bebuzeesearchdata[index].description}',
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Text(
                                    '${widget.controller.bebuzeesearchdata[index].date ?? ''}')
                              ],
                            ),
                            leading: Container(
                              height: 10.0.h,
                              width: 15.0.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        widget.controller
                                            .bebuzeesearchdata[index].image,
                                      ))),
                            ),
                            title: Text(
                              '${widget.controller.bebuzeesearchdata.value[index].title}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      }),
            ),
            Obx(
              () => widget.controller.bebuzeesearchdata.value.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount:
                          widget.controller.bebuzeesearchdata.value.length,
                      itemBuilder: (context, index) {
                        if (widget.controller.bebuzeesearchdata[index].type !=
                            'image')
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () async {
                              NewsFeedModel data =
                                  await DiscoverApiCalls.getPostsSearch(
                                          widget.controller
                                              .bebuzeesearchdata[index].id
                                              .toString(),
                                          context)
                                      .then((value) => value.feeds[0]);
                              //  Navigator.of(context).push(MaterialPageRoute(builder: (){
                              //   return DiscoverF
                              //  }))
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DiscoverFeedsPage(
                                            setNavBar: () {},
                                            isChannelOpen: () {},
                                            changeColor: () {},
                                            currentMemberImage:
                                                data.postUserPicture,
                                            listOfPostID: '',
                                            postID: widget.controller
                                                .bebuzeesearchdata[index].id
                                                .toString(),
                                            logo: '',
                                            country: CurrentUser()
                                                .currentUser
                                                .country,
                                            memberID: data.postUserId,
                                            posts: data,
                                          )));
                              print(
                                  "post id of search image=${widget.controller.bebuzeesearchdata[index].id}");
                            },
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.controller.bebuzeesearchdata[index].description}',
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Text(
                                    '${widget.controller.bebuzeesearchdata[index].date ?? ''}')
                              ],
                            ),
                            leading: Container(
                              height: 10.0.h,
                              width: 15.0.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        widget.controller
                                            .bebuzeesearchdata[index].image,
                                      ))),
                            ),
                            title: Text(
                              '${widget.controller.bebuzeesearchdata.value[index].title}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      }),
            ),
            Obx(
              () => widget.controller.bebuzeesearchdata.value.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount:
                          widget.controller.bebuzeesearchdata.value.length,
                      itemBuilder: (context, index) {
                        if (widget.controller.bebuzeesearchdata[index].type !=
                            'blog')
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExpandedBlogPage(
                                            refreshFromShortbuz: () {},
                                            refresh: () {},
                                            refreshFromMultipleStories: () {},
                                            setNavBar: () {},
                                            isChannelOpen: () {},
                                            changeColor: () {},
                                            blogID: widget.controller
                                                .bebuzeesearchdata[index].id
                                                .toString(),
                                          )));
                            },
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.controller.bebuzeesearchdata[index].description}',
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Text(
                                    '${widget.controller.bebuzeesearchdata[index].date ?? ''}')
                              ],
                            ),
                            leading: Container(
                              height: 10.0.h,
                              width: 15.0.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        widget.controller
                                            .bebuzeesearchdata[index].image,
                                      ))),
                            ),
                            title: Text(
                              '${widget.controller.bebuzeesearchdata.value[index].title}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      }),
            ),
            Obx(
              () => widget.controller.bebuzeesearchdata.value.length == 0
                  ? Container()
                  : ListView.builder(
                      itemCount:
                          widget.controller.bebuzeesearchdata.value.length,
                      itemBuilder: (context, index) {
                        if (widget.controller.bebuzeesearchdata[index].type !=
                            'properbuz')
                          return Container(
                            height: 0,
                            width: 0,
                          );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {},
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.controller.bebuzeesearchdata[index].description}',
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Text(
                                    '${widget.controller.bebuzeesearchdata[index].date ?? ''}')
                              ],
                            ),
                            leading: Container(
                              height: 10.0.h,
                              width: 15.0.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        widget.controller
                                            .bebuzeesearchdata[index].image,
                                      ))),
                            ),
                            title: Text(
                              '${widget.controller.bebuzeesearchdata.value[index].title}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ));
  }
}

// class BebuzeeSearchInnerView extends GetView<BebuzeeSearchController> {
//   var textconttroller = TextEditingController();

  
//   }
// }
