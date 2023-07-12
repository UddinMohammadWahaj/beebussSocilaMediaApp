import 'package:bizbultest/models/user_story_list_model.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/view/expanded_stories.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:video_player/video_player.dart';

class MainStoriesPage extends StatefulWidget {
  final UserStoryListModel? user;
  final Function? setNavBar;
  final Function? animate;
  final List<UserStoryListModel>? users;
  final int? index;
  final VoidCallback? goToProfile;
  final Function? profilePage;
  final Function? refreshFeeds;
  final String? id;

  const MainStoriesPage(
      {Key? key,
      this.user,
      this.id,
      this.setNavBar,
      this.animate,
      this.users,
      this.index,
      this.goToProfile,
      this.profilePage,
      this.refreshFeeds})
      : super(key: key);

  @override
  _MainStoriesPageState createState() => _MainStoriesPageState();
}

class _MainStoriesPageState extends State<MainStoriesPage>
    with SingleTickerProviderStateMixin {
  late PreloadPageController _pageController;
  late VideoPlayerController controller;
  DirectRefresh refresh = DirectRefresh();
  AudioPlayer musicplayer = AudioPlayer();
  @override
  void initState() {
    _pageController = PreloadPageController(initialPage: widget.index!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        widget.setNavBar!(false);
        refresh.updateRefresh(true);
        return true;
      },
      child: Container(
        child: PreloadPageView.builder(
            preloadPagesCount: 5,
            controller: _pageController,
            itemCount: widget.users!.length,
            // onPageChanged: (page) {
            //   print("here in change page 2 ${musicplayer.duration}");

            //   musicplayer.pause();
            // },
            itemBuilder: (context, index) {
              return ExpandedStoriesPage(
                musicplayer: musicplayer,
                refreshFeeds: widget.refreshFeeds!,
                profilePage: widget.profilePage!,
                goToProfile: widget.goToProfile!,
                animate: widget.animate!,
                changePage: ({msg: ''}) {
                  print("here in change page $msg");
                  if (index == widget.users!.length - 1) {
                    Navigator.pop(context);
                    widget.setNavBar!(false);
                  } else {
                    _pageController.animateToPage((index + 1),
                        duration: new Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  }
                },
                user: widget.users![index],
                setNavBar: widget.setNavBar!,
              );
            }),
      ),
    );
  }
}
