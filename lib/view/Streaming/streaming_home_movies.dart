import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Streaming/Controllers/category_controller.dart';
import 'package:bizbultest/services/Streaming/Controllers/cover_page_controller.dart';
import 'package:bizbultest/services/Streaming/streaming_home_api_calls.dart';
import 'package:bizbultest/view/Streaming/detailed_video_info_page_movies.dart';
import 'package:bizbultest/view/Streaming/my_list_videos_screen.dart';
import 'package:bizbultest/view/Streaming/streaming_search_page.dart';
import 'package:bizbultest/widgets/Streaming/category_video_list.dart';
import 'package:bizbultest/widgets/Streaming/featured_video_card.dart';
import 'package:bizbultest/widgets/Streaming/genres_card.dart';
import 'package:bizbultest/widgets/Streaming/info_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:get/get.dart';
import 'detailed_video_info_page_series.dart';
import 'package:bizbultest/view/Streaming/detailed_video_player_screen.dart';

class StreamingHomeMovies extends StatefulWidget {
  const StreamingHomeMovies({
    Key? key,
  }) : super(key: key);

  @override
  _StreamingHomeMoviesState createState() => _StreamingHomeMoviesState();
}

class _StreamingHomeMoviesState extends State<StreamingHomeMovies> {
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
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
        ),
      ),
    );
  }

  Widget _genreCard() {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isGenresOpen = true;
          });
        },
        child: Row(
          children: [
            Obx(
              () => Container(
                constraints: BoxConstraints(maxWidth: 30.0.w),
                child: Text(
                  _coverPageController.selectedMovieGenre.value,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade300,
            )
          ],
        ),
      ),
    );
  }

  String selectedGenre = "All Genres";
  bool isGenresOpen = false;

  @override
  void initState() {
    //_coverPageController.coverPageVideo();
    _categoryController.fetchCategoricalMovies("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (_coverPageController.coverPageMovieList.length == 0) {
          return Container();
        } else {
          return Stack(
            children: [
              NestedScrollView(
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
                              automaticallyImplyLeading: true,
                              // leading: Image.asset('assets/images/netflix_icon.png'),
                              titleSpacing: 10.0,
                              title: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        renderTitle(
                                            AppLocalizations.of(
                                              'Movies',
                                            ),
                                            AppLocalizations.of(
                                              'Movies',
                                            ),
                                            () {}),
                                        _genreCard(),
                                      ],
                                    ),
                                    IconButton(
                                      splashRadius: 20,
                                      onPressed: () {
                                        Get.to(() => StreamingSearchPage(
                                              image: _coverPageController
                                                  .coverPageVideoList[0]
                                                  .categoryData![0]
                                                  .poster,
                                            ));
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
                                          .coverPageMovieList[0]
                                          .categoryData![0]))),
                        ),
                      ),
                    ];
                  },
                  body: CategoryVideoList(
                    categoryList: _categoryController.categoricalMoviesList,
                  )),
              isGenresOpen
                  ? GenresCard(
                      val: 1,
                      onTap: (text) {
                        setState(() {
                          selectedGenre = text;
                        });
                      },
                      close: () {
                        setState(() {
                          isGenresOpen = false;
                        });
                      },
                    )
                  : Container()
            ],
          );
        }
      }),
    );
  }
}
