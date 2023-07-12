import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Streaming/category_model.dart';
import 'package:bizbultest/services/Streaming/Controllers/category_controller.dart';
import 'package:bizbultest/services/Streaming/Controllers/cover_page_controller.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/widgets/Streaming/preview_video_player.dart';
import 'package:bizbultest/widgets/Streaming/season_card.dart';
import 'package:bizbultest/widgets/Streaming/video_header.dart';
import 'package:bizbultest/widgets/Streaming/video_preview_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:skeleton_text/skeleton_text.dart';
import 'package:video_player/video_player.dart';

class DetailedVideoInfoPageSeries extends StatefulWidget {
  final int? index;
  final int? catIndex;
  final String? image;
  final CategoryDataModel? video;

  const DetailedVideoInfoPageSeries(
      {Key? key, this.image, this.video, this.index, this.catIndex})
      : super(key: key);

  @override
  _DetailedVideoInfoPageSeriesState createState() =>
      _DetailedVideoInfoPageSeriesState();
}

class _DetailedVideoInfoPageSeriesState
    extends State<DetailedVideoInfoPageSeries> {
  late FlickManager _flickManager;
  bool isVideoPlaying = false;
  int _selectedTab = 1;
  String _selectedSeason = "Season 1";
  bool _isSeasonCardOpened = false;
  CategoryController controller = Get.put(CategoryController());

  List<String> _seasons = [
    "Season 1",
    "Season 2",
    "Season 3",
    "Season 4",
    "Season 5",
  ];

  TextStyle _style(double size, FontWeight weight, Color color) {
    return GoogleFonts.publicSans(
        fontSize: size, fontWeight: weight, color: color);
  }

  Widget _placeHolderList() {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 30,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 9 / 16),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              AspectRatio(
                aspectRatio: 9 / 16,
                child: SkeletonAnimation(
                  shimmerColor: Colors.black38,
                  child: Container(
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      shape: BoxShape.rectangle,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget _tabButton(String text, int val, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: new BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
              border: _selectedTab == val
                  ? Border(top: BorderSide(color: Colors.red, width: 3))
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                text,
                style: whiteBold.copyWith(fontSize: 11.0.sp),
              ),
            )),
      ),
    );
  }

  void _selectTabButton(int val) {
    setState(() {
      _selectedTab = val;
    });
  }

  Widget _seasonButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSeasonCardOpened = true;
        });
      },
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedSeason,
                style: _style(12.0.sp, FontWeight.bold, Colors.white),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.arrow_drop_down_outlined,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seasonsCard() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      height: 100.0.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Obx(
              () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.categoricalSeriesList[widget.index!]
                      .categoryData![widget.catIndex!].seasons!.length,
                  itemBuilder: (context, index) {
                    return _seasonListButton(
                        controller.categoricalSeriesList[widget.index!]
                            .categoryData![widget.catIndex!].seasons![index],
                        index);
                  }),
            ),
          ),
          FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              child: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isSeasonCardOpened = false;
                });
              })
        ],
      ),
    );
  }

  Widget _seasonListButton(String text, int season) {
    return Container(
      child: ListTile(
          onTap: () {
            setState(() {
              _selectedSeason = text;
              _isSeasonCardOpened = false;
            });
            controller.getSeasons(
                widget.index!, season.toString(), widget.catIndex!);
          },
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          dense: true,
          title: Center(
            child: Text(
              text,
              style: _style(
                _selectedSeason == text ? 19.0.sp : 14.0.sp,
                _selectedSeason == text ? FontWeight.bold : FontWeight.normal,
                Colors.white,
              ),
            ),
          )),
    );
  }

  @override
  void initState() {
    controller.getSeasons(widget.index!, "1", widget.catIndex!);
    super.initState();
  }

  @override
  void dispose() {
    //_flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    double height = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(5.0.h),
        child: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          brightness: Brightness.dark,
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
                splashRadius: 20,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {})
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !isVideoPlaying
                    ? VideoPreviewCard(
                        onTap: () {
                          setState(() {
                            isVideoPlaying = true;
                          });
                        },
                        video: widget.video,
                      )
                    : PreviewVideoPlayer(
                        flickManager: _flickManager,
                      ),
                Container(
                  height: 65.0.h - height,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VideoHeader(
                          video: widget.video!,
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey.shade700,
                          width: 100.0.w,
                        ),
                        Row(
                          children: [
                            _tabButton(
                                AppLocalizations.of(
                                  "EPISODES",
                                ),
                                1, () {
                              _selectTabButton(1);
                            }),
                            _tabButton(
                                AppLocalizations.of(
                                  "MORE LIKE THIS",
                                ),
                                2, () {
                              _selectTabButton(2);
                            }),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _selectedTab == 2
                            ? _placeHolderList()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: _seasonButton(),
                                      ),
                                      Obx(
                                        () => ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.only(top: 5),
                                            itemCount: controller
                                                .categoricalSeriesList[
                                                    widget.index!]
                                                .categoryData![widget.catIndex!]
                                                .episodes!
                                                .length,
                                            itemBuilder: (context, index) {
                                              return SeasonCard(
                                                episodeIndex: index,
                                                image: widget.video!.poster,
                                                index: widget.index,
                                                catIndex: widget.catIndex,
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          _isSeasonCardOpened ? _seasonsCard() : Container()
        ],
      ),
    );
  }
}
