import 'package:bizbultest/models/user_highlights_model.dart';
import 'package:bizbultest/models/user_story_list_model.dart';
import 'package:bizbultest/view/expanded_stories.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'expanded_highlights_page.dart';

class MainHighlightsPage extends StatefulWidget {
  final UserStoryListModel? user;
  final Function? setNavBar;
  final List<UserHighlightsModel>? highlights;
  final int? index;

  const MainHighlightsPage(
      {Key? key, this.user, this.setNavBar, this.index, this.highlights})
      : super(key: key);

  @override
  _MainHighlightsPageState createState() => _MainHighlightsPageState();
}

class _MainHighlightsPageState extends State<MainHighlightsPage>
    with SingleTickerProviderStateMixin {
  PreloadPageController? _pageController;

  @override
  void initState() {
    print(widget.index.toString() + "  indexxxxx");
    _pageController = PreloadPageController(initialPage: widget.index!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        widget.setNavBar!(false);
        return true;
      },
      child: Container(
        child: PreloadPageView.builder(
            controller: _pageController,
            itemCount: widget.highlights!.length,
            itemBuilder: (context, index) {
              return ExpandedHighlightsPage(
                index: widget.index!,
                changePage: () {
                  if (index == widget.highlights!.length - 1) {
                    Navigator.pop(context);
                    widget.setNavBar!(false);
                  } else {
                    _pageController!.animateToPage((index + 1),
                        duration: new Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  }
                },
                highlights: widget.highlights![index],
                setNavBar: widget.setNavBar!,
              );
            }),
      ),
    );
  }
}
