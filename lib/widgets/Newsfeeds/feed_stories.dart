import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/create_story_page.dart';
import 'package:bizbultest/widgets/Stories/main_stories_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/models/user_story_list_model.dart';
import 'package:bizbultest/view/expanded_stories.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../api/ApiRepo.dart' as ApiRepo;
import '../../api/api.dart';

class FeedStories extends StatefulWidget {
  final Function? setNavBar;
  final Function? animate;
  final UserStoryListModel? user;
  final List<UserStoryListModel>? stories;
  final int? e;
  final List? buzz;
  final String? value;
  final VoidCallback? goToProfile;
  final Function? refreshFromMultipleStories;
  final Function? profilePage;
  final Function? refreshFeeds;

  const FeedStories(
      {Key? key,
      this.e,
      this.buzz,
      this.value,
      this.user,
      this.setNavBar,
      this.animate,
      this.stories,
      this.goToProfile,
      this.refreshFromMultipleStories,
      this.profilePage,
      this.refreshFeeds})
      : super(key: key);

  @override
  _FeedStoriesState createState() => _FeedStoriesState();
}

class _FeedStoriesState extends State<FeedStories> {
  Future<void> viewCount() async {
    // var url = Uri.parse(
    //     "https://www.bebuzee.com/app_devlope_story_data.php?action=story_update_view&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&story_user_id=${widget.user.memberId}&post_id=${widget.user.postId}");

    // var response = await http.get(url);
    var url =
        "https://www.bebuzee.com/api/storyViewUpdate?action=story_update_view&user_id=${CurrentUser().currentUser.memberID}&country=${CurrentUser().currentUser.country}&story_user_id=${widget.user!.memberId}&post_id=${widget.user!.postId}&story_id=${widget.user!.memberId}";
    print("view countr url=${url}");
    var response = await ApiProvider().fireApi(url);
    // var response = await ApiRepo.postWithToken("api/story_update_view.php", {
    //   "user_id": CurrentUser().currentUser.memberID,
    //   "country": CurrentUser().currentUser.country,
    //   "story_user_id": widget.user.memberId,
    //   "post_id": widget.user.postId
    // });

    print('view count= ${response.data['data']}');
    print(response.data);
  }

  @override
  Widget build(BuildContext context) {
    print("entered feed stories");
    return Padding(
      padding: EdgeInsets.only(right: 25, left: widget.e == 0 ? 10 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  print(widget.user!.memberId);
                  viewCount();
                  setState(() {
                    widget.user!.viewStatus = 1;
                  });
                  widget.setNavBar!(true);

                  if (widget.e == 0 && widget.user!.story == 0) {
                    widget.setNavBar!(true);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateStory(
                                  setNavbar: widget.setNavBar!,
                                  refreshFromMultipleStories:
                                      widget.refreshFromMultipleStories!,
                                )));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainStoriesPage(
                                  refreshFeeds: widget.refreshFeeds,
                                  profilePage: widget.profilePage,
                                  goToProfile: widget.goToProfile,
                                  index: widget.e,
                                  users: widget.stories,
                                  animate: widget.animate,
                                  user: widget.user,
                                  setNavBar: widget.setNavBar,
                                )));
                  }
                },
                child: Container(
                  width: 80,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        colors: widget.user!.viewStatus == 0
                            ? [
                                HexColor("#2B25CC"),
                                HexColor("#A6635B"),
                                HexColor("#91596F"),
                                HexColor("#B46A4D"),
                                HexColor("#F18910"),
                                HexColor("#A6635B")
                              ]
                            : [Colors.grey, Colors.grey]),
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: widget.user!.viewStatus == 0
                          ? Colors.transparent
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: CachedNetworkImageProvider(
                                widget.user!.memberId ==
                                        CurrentUser().currentUser.memberID
                                    ? CurrentUser().currentUser.image!
                                    : widget.user!.image!),
                            fit: BoxFit.cover,
                            height: 100,
                            alignment: Alignment.topCenter,
                          )),
                    ),
                  ),
                ),
              ),
              widget.e == 0 && widget.user!.story == 0
                  ? Positioned.fill(
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            child: Material(
                              // pause button (round)
                              borderRadius: BorderRadius.circular(
                                  50), // change radius size
                              color: primaryBlueColor, //button colour
                              child: InkWell(
                                splashColor:
                                    primaryBlueColor, // inkwell onPress colour
                                child: SizedBox(
                                  //customisable size of 'button'
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                onTap: () {}, // or use onPressed: () {}
                              ),
                            ),
                          )),
                    )
                  : Container(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Container(
              width: 80,
              child: Text(
                widget.e == 0
                    ? AppLocalizations.of("Your Story")
                    : widget.user!.shortcode!,
                style: TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
