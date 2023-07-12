import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Streaming/Controllers/category_controller.dart';
import 'package:bizbultest/services/Streaming/Controllers/cover_page_controller.dart';
import 'package:bizbultest/view/Streaming/my_list_videos_screen.dart';
import 'package:bizbultest/view/Streaming/streaming_home_movies.dart';
import 'package:bizbultest/view/Streaming/streaming_home_series.dart';
import 'package:bizbultest/view/Streaming/streaming_search_page.dart';
import 'package:bizbultest/widgets/Streaming/category_video_list.dart';
import 'package:bizbultest/widgets/Streaming/featured_video_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class StreamingHome extends StatefulWidget {
  final Function? setNavbar;

  const StreamingHome({Key? key, this.setNavbar}) : super(key: key);

  @override
  _StreamingHomeState createState() => _StreamingHomeState();
}

class _StreamingHomeState extends State<StreamingHome> {
  CategoryController _categoryController = Get.put(CategoryController());
  CoverPageController _coverPageController = Get.put(CoverPageController());

  Widget renderTitle(String tag, String text, VoidCallback onTap) {
    return Hero(
      tag: tag,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _coverPageController.coverPageVideo();
    _categoryController.fetchCategoricalVideos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Get.delete<CategoryController>();
        Get.delete<CoverPageController>();
        widget.setNavbar!(false);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          if (_coverPageController.coverPageVideoList.length == 0) {
            return Container();
          } else {
            return NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverSafeArea(
                        top: false,
                        bottom: false,
                        sliver: SliverAppBar(
                            pinned: true,
                            floating: false,
                            expandedHeight: 65.0.h,
                            backgroundColor: Colors.black,
                            automaticallyImplyLeading: false,
                            // leading:
                            //     Image.asset('assets/images/netflix_icon.png'),
                            titleSpacing: 10.0,
                            title: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  renderTitle(
                                      AppLocalizations.of(
                                        'TV Shows',
                                      ),
                                      AppLocalizations.of(
                                        'TV Shows',
                                      ), () {
                                    _coverPageController.resetGenres(2);
                                    _coverPageController.selectedSeriesGenre
                                        .value = "All Genres";
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StreamingHomeSeries()));
                                  }),
                                  renderTitle(
                                      AppLocalizations.of(
                                        'Movies',
                                      ),
                                      AppLocalizations.of(
                                        'Movies',
                                      ), () {
                                    _coverPageController.resetGenres(1);
                                    _coverPageController.selectedMovieGenre
                                        .value = "All Genres";
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StreamingHomeMovies()));
                                  }),
                                  renderTitle(
                                      AppLocalizations.of(
                                        'My List',
                                      ),
                                      AppLocalizations.of(
                                        'My List',
                                      ), () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyListVideos()));
                                  }),
                                  IconButton(
                                    splashRadius: 20,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StreamingSearchPage(
                                                    image: _coverPageController
                                                        .coverPageVideoList[0]
                                                        .categoryData![0]
                                                        .poster,
                                                  )));
                                    },
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                                collapseMode: CollapseMode.pin,
                                background: FeaturedVideoCard(
                                    video: _coverPageController
                                        .coverPageVideoList[0]
                                        .categoryData![0]))),
                      ),
                    ),
                  ];
                },
                body: CategoryVideoList(
                  categoryList: _categoryController.categoricalVideoList,
                ));
          }
        }),
      ),
    );
  }
}
