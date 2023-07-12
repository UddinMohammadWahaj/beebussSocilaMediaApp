// ignore_for_file: missing_return

import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/widgets/Newsfeeds/single_feed_post.dart';
import 'package:bizbultest/models/Activity/activity_model.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../api/api.dart';
import '../../models/Buzzerfeed/buzzerfeedmainpagemodel.dart';
import '../../models/Buzzerfeed/buzzrefeed_commentlist_model.dart';
import '../../models/Properbuz/properbuz_feeds_model.dart';
import '../../services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import '../../services/Properbuz/properbuz_feed_controller.dart';
import '../../view/Buzzfeed/buzfeedexpanded.dart';
import '../../view/Buzzfeed/buzzerfeedexpandedbylist.dart';
import '../../view/Properbuz/detailed_feed_view.dart';
import '../../view/Properbuz/properbuz_feeds_view.dart';
import '../../view/activity_page.dart' as p1;
import '../Newsfeeds/single_properbuzz_details.dart';

class LikeNotificationCard extends StatefulWidget {
  final ActivityNotifyData? activity;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;

  const LikeNotificationCard(
      {Key? key,
      this.activity,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  _LikeNotificationCardState createState() => _LikeNotificationCardState();
}

class _LikeNotificationCardState extends State<LikeNotificationCard> {
  @override
  void initState() {
    super.initState();
  }

  var listbuzzerfeeddata = <BuzzerfeedDatum>[].obs;

  Future getProperbuzzFeed() async {
    var url =
        "https://www.bebuzee.com/api/properbuzz_news_feed.php?action=new_feed_data_single_post&country=India&user_id=${widget.activity!.memberId}&post_id=${widget.activity!.postId}";
    print(url);
    var response = await ApiProvider().fireApi(url);
    // var response = await http.get(url);
    print("------- ${response.data}");
    ProperbuzFeeds properbuzFeeds =
        ProperbuzFeeds.fromJson(response.data['data']);
    return properbuzFeeds.feeds;
  }

  static Future<String?> getToken() async {
    return await ApiProvider()
        .refreshToken(CurrentUser().currentUser.memberID!);
  }

  Future<List<BuzzerfeedDatum>> getRecentData() async {
    List<BuzzerfeedDatum> output = [];
    var url = 'https://www.bebuzee.com/api/buzzerfeed_single_post.php';
    var client = Dio();
    print(
        "recent url=https://www.bebuzee.com/api/buzzerfeed_single_post.php?user_id=${widget.activity!.memberId}&buzzerfeed_id=${widget.activity!.postId}");
    var token = await getToken();
    print("get recent data called");
    var response = await client.post(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }),
        queryParameters: {
          "user_id": widget.activity!.memberId,
          "buzzerfeed_id": widget.activity!.postId,
        }).then((value) => value);
    if (response.data['status'] == 201) {
      print("fetch first post=${response.data}");
      output = BuzzerfeedMain.fromJson(response.data).data!;
      print("---------recent data=${output[0]}");
      return output;
    } else
      return <BuzzerfeedDatum>[];
  }

  bool loder = false;
  @override
  Widget build(BuildContext context) {
    print("---------${widget.activity!.type} aa");
    return ListTile(
        // tileColor: Colors.pink,
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        onTap: () async {
          // int index;
          // print(
          // "-------posttype------- ${widget.activity.type} ---postid--- ${widget.activity.postId}");
          OtherUser().otherUser.memberID = widget.activity!.memberId!;
          OtherUser().otherUser.shortcode = widget.activity!.fullName!;
          // BuzzerfeedMainController buzzfeedmaincontroller =
          //     Get.put(BuzzerfeedMainController());
          // buzzfeedmaincontroller.mylistdetaildata.value = [];
          // var data1 = await getRecentData();
          // // listbuzzerfeeddata.value = data1;
          // print("---- -----## ${data1}");

          // buzzfeedmaincontroller.mylistdetaildata.value = data1;
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => BuzzerfeedExpandedByList(
          //               buzzerfeedMainController: buzzfeedmaincontroller,
          //               userindex: 0,
          //               posttype:
          //                   buzzfeedmaincontroller.mylistdetaildata[0].type,
          //             )));

          if (widget.activity!.type!.contains("properbuzz")) {
            ProperbuzFeedController controller =
                Get.put(ProperbuzFeedController(from: "singlePost"));
            loder = true;
            var data = await getProperbuzzFeed();

            controller.feeds.value = data;
            loder = false;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailedFeedView(
                          postId: widget.activity!.postId,
                          feedIndex: 0,
                          val: 1,
                          from: "singlePost",
                        ))).then((value) async => await controller.getFeeds()!);
          } else if (widget.activity!.type!.contains("buzzer")) {
            BuzzerfeedMainController buzzfeedmaincontroller =
                Get.put(BuzzerfeedMainController());
            buzzfeedmaincontroller.mylistdetaildata.value = [];

            var data1 = await getRecentData();
            print("------buzzer---$data1");
            buzzfeedmaincontroller.mylistdetaildata.value = await data1;
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BuzzerfeedExpandedByList(
                          buzzerfeedMainController: buzzfeedmaincontroller,
                          userindex: 0,
                          posttype:
                              buzzfeedmaincontroller.mylistdetaildata[0].type!,
                        )));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleFeedPost(
                          memberID: widget.activity!.memberId,
                          postID: widget.activity!.postId,
                          //profileOpen: widget.isChannelOpen,
                          setNavBar: widget.setNavBar!,
                          changeColor: widget.changeColor!,
                          isChannelOpen: widget.isChannelOpen!,
                          postType: widget.activity!.type,
                        )));
          }
          // });
        },
        leading: GestureDetector(
          onTap: () {
            setState(() {
              OtherUser().otherUser.memberID = widget.activity!.memberId!;
              OtherUser().otherUser.shortcode = widget.activity!.fullName!;
            });

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePageMain(
                          setNavBar: widget.setNavBar!,
                          isChannelOpen: widget.isChannelOpen!,
                          changeColor: widget.changeColor!,
                          otherMemberID: widget.activity!.memberId,
                        )));
          },
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(widget.activity!.profile!),
            ),
          ),
        ),
        title: RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 15),
                children: <TextSpan>[
              TextSpan(
                text: widget.activity!.shortcode! + " ",
                style: blackBold.copyWith(fontSize: 15),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print("profile tapped");
                    // Single tapped.
                    setState(() {
                      OtherUser().otherUser.memberID =
                          widget.activity!.memberId!;
                      OtherUser().otherUser.shortcode =
                          widget.activity!.fullName!;
                    });

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePageMain(
                                  setNavBar: widget.setNavBar!,
                                  isChannelOpen: widget.isChannelOpen!,
                                  changeColor: widget.changeColor!,
                                  otherMemberID: widget.activity!.memberId,
                                )));
                  },
              ),
              TextSpan(text: widget.activity!.title),
              TextSpan(
                  text: widget.activity!.timeStamp!.replaceAll(" ", ""),
                  style: greyNormal.copyWith(fontSize: 14)),
            ])),
        trailing: widget.activity!.type == "chat"
            ? null
            : widget.activity!.image == null || widget.activity!.image == ""
                ? Container()
                : Image(
                    image: CachedNetworkImageProvider(widget.activity!.image ??
                        "https://www.bebuzee.com/new_files/buzzerfeed/bee_black.png"),
                    fit: BoxFit.cover,
                    height: 45,
                    width: 45,
                  ));
  }
}
