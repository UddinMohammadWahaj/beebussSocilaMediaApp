import 'dart:async';
import 'dart:math';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/stickers_model.dart';
import 'package:bizbultest/services/Story/post_story_api_calls.dart';
import 'package:bizbultest/utilities/loading_indicator.dart';
import 'package:bizbultest/widgets/Stories/story_music_view.dart';
import 'package:bizbultest/widgets/Stories/timeWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:playify/playify.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../api/storyextras/storypopupcontroller.dart';
import '../../utilities/custom_icons.dart';

class StickersPage extends StatefulWidget {
  final Function? emojiDetails;
  final Function? stickerDetails;
  final Function? gifsDetails;
  final Function? activitySelect;

  const StickersPage(
      {Key? key,
        this.emojiDetails,
        this.stickerDetails,
        this.gifsDetails,
        this.activitySelect})
      : super(key: key);

  @override
  _StickersPageState createState() => _StickersPageState();
}

class _StickersPageState extends State<StickersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  Stickers filteredStickersList = Stickers([]);
  Stickers stickersList = Stickers([]);
  Stickers emojisList = Stickers([]);
  Stickers gifsList = Stickers([]);
  Stickers filteredGifsList = Stickers([]);

  get json => null;

  void _getLocalStickers() {
    PostStoryApi.getLocalStickers().then((value) {
      if (mounted) {
        setState(() {
          stickersList.stickers = value.stickers;
          filteredStickersList.stickers = value.stickers;
        });
      }
      _getStickers();
      return value;
    });
  }

  void _getLocalEmojis() {
    PostStoryApi.getLocalEmojis().then((value) {
      if (mounted) {
        setState(() {
          emojisList.stickers = value.stickers;
        });
      }
      _getEmojis();
      return value;
    });
  }

  void getGiphyGif() {
    PostStoryApi.getGiphyGifs().then((value) {
      if (mounted) {
        setState(() {
          print("i am in gif");
          gifsList.stickers = value.stickers;
          print("i am in gif ${gifsList.stickers.length}");
          filteredGifsList.stickers = value.stickers;
        });
      }
      return value;
    });
  }

  void _getLocalGIFs() {
    PostStoryApi.getLocalGIFs().then((value) {
      if (mounted) {
        setState(() {
          gifsList.stickers = value.stickers;
          filteredGifsList.stickers = value.stickers;
        });
      }
      _getGIFs();
      return value;
    });
  }

  void _getStickers() {
    PostStoryApi.getStickers().then((value) {
      if (mounted) {
        setState(() {
          stickersList.stickers = value.stickers;
          filteredStickersList.stickers = value.stickers;
        });
      }
      return value;
    });
  }

  void _getEmojis() {
    PostStoryApi.getEmojis().then((value) {
      if (mounted) {
        setState(() {
          emojisList.stickers = value.stickers;
        });
      }
      return value;
    });
  }

  void _getGIFs() {
    PostStoryApi.getGIFs().then((value) {
      if (mounted) {
        setState(() {
          gifsList.stickers = value.stickers;
          filteredGifsList.stickers = value.stickers;
        });
      }
      return value;
    });
  }

  void _searchStickers(String name) async {
    setState(() {
      stickersList.stickers = filteredStickersList.stickers
          .where((element) => element.stickerName
          .toString()
          .toLowerCase()
          .contains(name.toLowerCase()))
          .toList();
    });
  }

  void _searchGif(String name) async {
    setState(() {
      gifsList.stickers = filteredGifsList.stickers
          .where((element) => element.stickerName
          .toString()
          .toLowerCase()
          .contains(name.toLowerCase()))
          .toList();
    });
  }

  Widget _topBar() {
    return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            decoration: new BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              shape: BoxShape.rectangle,
            ),
            width: 45,
            height: 4,
          ),
        ));
  }

  Widget _textField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        child: TextFormField(
          onChanged: (val) async {
            // _searchStickers(val);
            // _searchGif(val);

            storypopupcontroller.searchText.value = val;
            // Timer(Duration(milliseconds: 700), () async {
            //   await storypopupcontroller.getFilteredGiphyGif(val);
            //   print("search=$val");
            // });
            // await Future.delayed(Duration(milliseconds: 500), () async {
            //   await storypopupcontroller.getFilteredGiphyGif(val);
            //   print("search=$val");
            // });
          },
          maxLines: 1,
          controller: _searchController,
          cursorColor: Colors.white,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0.5),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0.5),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.transparent,
              size: 25,
            ),
            isDense: true,
            hintText: AppLocalizations.of(
              "Search...",
            ),

            //alignLabelWithHint: true,
            contentPadding: EdgeInsets.only(left: 20, top: 15),
            hintStyle: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _tab(String text) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  var storypopupcontroller = Get.put(StoryPopUpController());
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 4, initialIndex: 0);
    _getLocalStickers();
    _getLocalEmojis();
    // _getLocalGIFs();
    // getGiphyGif();
    super.initState();
  }

  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Column(
        children: [
          _topBar(),
          Container(
            height: 70.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(() => !storypopupcontroller.tappedSearch.value
                        ? InkWell(
                      onTap: () {
                        storypopupcontroller.tappedSearch.value = true;
                      },
                      child: Container(
                        height: 5.0.h,
                        width: 90.0.w,
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          )
                        ]),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(7.0.w)),
                      ),
                    )
                        : Container(
                      width: 100.w,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                storypopupcontroller.tappedSearch.value =
                                false;
                              },
                              icon: Icon(Icons.arrow_back,
                                  color: Colors.white)),
                          Expanded(child: _textField())
                        ],
                      ),
                    )),
                    Obx(
                          () => !storypopupcontroller.tappedSearch.value
                          ? TabBar(
                          onTap: (x) async {
                            // if (x == 2) {
                            //   var gif = await GiphyGet.getGif(
                            //       context: context,
                            //       apiKey: 'zONCyRNgg6IGXkmoHG7Yy1RxRgvTtPx5',
                            //       tabColor: Colors.black);
                            // }
                          },
                          controller: _tabController,
                          indicatorColor: Colors.white,
                          tabs: [
                            _tab("Activity"),
                            _tab(
                              AppLocalizations.of(
                                "Stickers",
                              ),
                            ),
                            _tab(
                              AppLocalizations.of("Emojis"),
                            ),
                            _tab("GIPHY"),
                          ])
                          : Container(),
                    ),
                    Obx(
                          () => storypopupcontroller.tappedSearch.value
                          ? Container(
                        height: 75.0.h,
                        child: storypopupcontroller.gifloading.value
                            ? Center(
                          child: CircularProgressIndicator(
                              color: Colors.white),
                        )
                            : GridView.builder(
                            shrinkWrap: true,
                            controller:
                            ModalScrollController.of(context),
                            itemCount: storypopupcontroller
                                .filteredgifListStickers.length,
                            // physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              return AspectRatio(
                                aspectRatio: 1,
                                child: InkWell(
                                  onTap: () {
                                    _searchController.clear();
                                    widget.gifsDetails!(
                                        storypopupcontroller
                                            .filteredgifListStickers[
                                        index]
                                            .name,
                                        storypopupcontroller
                                            .filteredgifListStickers[
                                        index]
                                            .id);
                                  },
                                  child: Container(
                                      height: 20,
                                      child: Image(
                                        image:
                                        CachedNetworkImageProvider(
                                          storypopupcontroller
                                              .filteredgifListStickers[
                                          index]
                                              .name!,
                                        ),
                                        fit: BoxFit.cover,
                                        height: 20,
                                      )),
                                ),
                              );
                            }),
                      )
                          : Container(
                        height: 75.0.h,
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            GridView.count(
                              shrinkWrap: true,
                              controller:
                              ModalScrollController.of(context),
                              crossAxisCount: 3,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: InkWell(
                                    onTap: () {
                                      _searchController.clear();
                                      widget.activitySelect!("location");
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                offset: Offset(0, 2),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.purple,
                                                size: 16,
                                              ),
                                              Expanded(
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: Text(
                                                    "Location"
                                                        .toUpperCase(),
                                                    textAlign:
                                                    TextAlign.center,
                                                    style: GoogleFonts
                                                        .rajdhani()
                                                        .copyWith(
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      foreground: Paint()
                                                        ..shader =
                                                        LinearGradient(
                                                          colors: <Color>[
                                                            Colors.purple,
                                                            Colors
                                                                .pinkAccent
                                                          ],
                                                          begin: Alignment
                                                              .topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        ).createShader(Rect
                                                            .fromLTWH(
                                                            0.0,
                                                            0.0,
                                                            120.0,
                                                            20.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: InkWell(
                                    onTap: () {
                                      _searchController.clear();
                                      widget.activitySelect!("mention");
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Container(
                                          // height: 45,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                offset: Offset(0, 2),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "@Mention".toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style:
                                              GoogleFonts.rajdhani()
                                                  .copyWith(
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.w600,
                                                foreground: Paint()
                                                  ..shader =
                                                  LinearGradient(
                                                    colors: <Color>[
                                                      Colors.orange,
                                                      Colors.amberAccent
                                                    ],
                                                    begin:
                                                    Alignment.topLeft,
                                                    end: Alignment
                                                        .bottomRight,
                                                  ).createShader(
                                                      Rect.fromLTWH(
                                                          0.0,
                                                          0.0,
                                                          120.0,
                                                          20.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: InkWell(
                                    onTap: () {
                                      _searchController.clear();
                                      widget.activitySelect!("hashtag");
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                offset: Offset(0, 2),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(
                                              "#HashTag".toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style:
                                              GoogleFonts.rajdhani()
                                                  .copyWith(
                                                // color: Colors.pink,
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.w600,
                                                foreground: Paint()
                                                  ..shader =
                                                  LinearGradient(
                                                    colors: <Color>[
                                                      Colors.orange,
                                                      Colors.pink
                                                    ],
                                                    begin: Alignment
                                                        .bottomLeft,
                                                    end: Alignment
                                                        .topRight,
                                                  ).createShader(
                                                      Rect.fromLTWH(
                                                          0.0,
                                                          0.0,
                                                          70.0,
                                                          20.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: InkWell(
                                    onTap: () {
                                      _searchController.clear();
                                      widget.activitySelect!("questions");
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned.fill(
                                              left: 15,
                                              right: 15,
                                              child: Container(
                                                // height: 45,
                                                // width: double.infinity,
                                                padding:
                                                EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(.8),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                          .2),
                                                      offset:
                                                      Offset(0, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned.fill(
                                              left: 7,
                                              right: 7,
                                              bottom: 7,
                                              child: Container(
                                                // height: 39,
                                                // width: double.infinity,
                                                padding:
                                                EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(.9),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                          .2),
                                                      offset:
                                                      Offset(0, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: 15),
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                EdgeInsets.all(7),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                          .2),
                                                      offset:
                                                      Offset(0, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                                child: FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: Text(
                                                    "Questions"
                                                        .toUpperCase(),
                                                    textAlign:
                                                    TextAlign.center,
                                                    style: GoogleFonts
                                                        .rajdhani()
                                                        .copyWith(
                                                      color: Colors
                                                          .deepOrange,
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: InkWell(
                                      onTap: () {
                                        _searchController.clear();
                                        widget.activitySelect!("time");
                                      },
                                      child: StoryTimeWidget(
                                        dateData: DateTime.now(),
                                      ),
                                    ),
                                  ),
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StoryMusicView(
                                                      activitySelect: widget
                                                          .activitySelect!)));

                                      _searchController.clear();
                                      // widget.activitySelect("music");
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Container(
                                          // height: 45,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.2),
                                                offset: Offset(0, 2),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Text(
                                              "MUSIC".toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style:
                                              GoogleFonts.rajdhani()
                                                  .copyWith(
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.w600,
                                                foreground: Paint()
                                                  ..shader =
                                                  LinearGradient(
                                                    colors: <Color>[
                                                      Colors.orange,
                                                      Colors.amberAccent
                                                    ],
                                                    begin:
                                                    Alignment.topLeft,
                                                    end: Alignment
                                                        .bottomRight,
                                                  ).createShader(
                                                      Rect.fromLTWH(
                                                          0.0,
                                                          0.0,
                                                          120.0,
                                                          20.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Obx(
                                  () => storypopupcontroller
                                  .stickerListStickers.length ==
                                  0
                                  ? Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                                  : SmartRefresher(
                                key: Key('stickers'),
                                header: CustomHeader(
                                  builder: (context, mode) {
                                    return Container(
                                      child: Center(
                                          child:
                                          loadingAnimation()),
                                    );
                                  },
                                ),
                                footer: CustomFooter(
                                  builder: (BuildContext context,
                                      LoadStatus? mode) {
                                    Widget body;

                                    if (mode == LoadStatus.idle) {
                                      body = Text("");
                                    } else if (mode ==
                                        LoadStatus.loading) {
                                      print("loading gif");
                                      body = Container(
                                        child: Center(
                                            child:
                                            loadingAnimation()),
                                      );
                                    } else if (mode ==
                                        LoadStatus.failed) {
                                      body = Container(
                                          decoration:
                                          new BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: new Border.all(
                                                color: Colors.black,
                                                width: 0.7),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                12.0),
                                            child: Icon(
                                                CustomIcons.reload),
                                          ));
                                    } else if (mode ==
                                        LoadStatus.canLoading) {
                                      body = Text("");
                                    } else {
                                      body = Text("");
                                    }
                                    return Container(
                                      height: 55.0,
                                      child: Center(child: body),
                                    );
                                  },
                                ),
                                controller: storypopupcontroller
                                    .refreshController3,
                                onLoading: () {
                                  print(
                                      "gif onLoading called ${storypopupcontroller.stickercurrentPage + 1} ");
                                  storypopupcontroller.nextGiphysticker(
                                      page:
                                      '${storypopupcontroller.stickercurrentPage.value++}',
                                      search: 'sticker');
                                  storypopupcontroller
                                      .refreshController3
                                      .loadComplete();
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Obx(() => GridView.builder(
                                          shrinkWrap: true,
                                          controller:
                                          ModalScrollController
                                              .of(context),
                                          itemCount:
                                          storypopupcontroller
                                              .stickerListStickers
                                              .length,
                                          // physics: NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20,
                                          ),
                                          itemBuilder:
                                              (context, index) {
                                            return AspectRatio(
                                              aspectRatio: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  _searchController
                                                      .clear();
                                                  widget.gifsDetails!(
                                                      storypopupcontroller
                                                          .stickerListStickers[
                                                      index]
                                                          .name,
                                                      storypopupcontroller
                                                          .stickerListStickers[
                                                      index]
                                                          .id);
                                                },
                                                child: Container(
                                                    height: 20,
                                                    child: Image(
                                                      image:
                                                      CachedNetworkImageProvider(
                                                        storypopupcontroller
                                                            .stickerListStickers[
                                                        index]
                                                            .name!,
                                                      ),
                                                      fit: BoxFit
                                                          .cover,
                                                      height: 20,
                                                    )),
                                              ),
                                            );
                                          })),
                                    ],
                                  ),
                                ),
                                enablePullUp: true,
                                enablePullDown: false,
                              ),
                            ),
                            // GridView.builder(
                            //     shrinkWrap: true,
                            //     controller:
                            //         ModalScrollController.of(context),
                            //     itemCount: stickersList.stickers.length,
                            //     gridDelegate:
                            //         SliverGridDelegateWithFixedCrossAxisCount(
                            //       crossAxisCount: 3,
                            //       crossAxisSpacing: 20,
                            //       mainAxisSpacing: 20,
                            //     ),
                            //     itemBuilder: (context, index) {
                            //       return AspectRatio(
                            //         aspectRatio: 1,
                            //         child: InkWell(
                            //           onTap: () {
                            //             _searchController.clear();
                            //             widget.stickerDetails(
                            //                 stickersList
                            //                     .stickers[index].name,
                            //                 stickersList
                            //                     .stickers[index].id);
                            //           },
                            //           child: Container(
                            //               height: 20,
                            //               child: Image(
                            //                 image:
                            //                     CachedNetworkImageProvider(
                            //                         stickersList
                            //                             .stickers[index]
                            //                             .name),
                            //                 fit: BoxFit.cover,
                            //                 height: 20,
                            //               )),
                            //         ),
                            //       );
                            //     }),

                            Obx(
                                  () => storypopupcontroller
                                  .emojiListStickers.length ==
                                  0
                                  ? Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                                  : SmartRefresher(
                                key: Key('emoji'),
                                header: CustomHeader(
                                  builder: (context, mode) {
                                    return Container(
                                      child: Center(
                                          child:
                                          loadingAnimation()),
                                    );
                                  },
                                ),
                                footer: CustomFooter(
                                  builder: (BuildContext context,
                                      LoadStatus? mode) {
                                    Widget body;

                                    if (mode == LoadStatus.idle) {
                                      body = Text("");
                                    } else if (mode ==
                                        LoadStatus.loading) {
                                      print("loading gif");
                                      body = Container(
                                        child: Center(
                                            child:
                                            loadingAnimation()),
                                      );
                                    } else if (mode ==
                                        LoadStatus.failed) {
                                      body = Container(
                                          decoration:
                                          new BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: new Border.all(
                                                color: Colors.black,
                                                width: 0.7),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                12.0),
                                            child: Icon(
                                                CustomIcons.reload),
                                          ));
                                    } else if (mode ==
                                        LoadStatus.canLoading) {
                                      body = Text("");
                                    } else {
                                      body = Text("");
                                    }
                                    return Container(
                                      height: 55.0,
                                      child: Center(child: body),
                                    );
                                  },
                                ),
                                controller: storypopupcontroller
                                    .refreshController2,
                                onLoading: () {
                                  print(
                                      "gif onLoading called ${storypopupcontroller.emojicurrentPage + 1} ");
                                  storypopupcontroller.nextGiphyemoji(
                                      page:
                                      '${storypopupcontroller.emojicurrentPage.value++}',
                                      search: 'emoji');
                                  storypopupcontroller
                                      .refreshController2
                                      .loadComplete();
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Obx(() => GridView.builder(
                                          shrinkWrap: true,
                                          controller:
                                          ModalScrollController
                                              .of(context),
                                          itemCount:
                                          storypopupcontroller
                                              .emojiListStickers
                                              .length,
                                          // physics: NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20,
                                          ),
                                          itemBuilder:
                                              (context, index) {
                                            return AspectRatio(
                                              aspectRatio: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  _searchController
                                                      .clear();
                                                  widget.gifsDetails!(
                                                      storypopupcontroller
                                                          .emojiListStickers[
                                                      index]
                                                          .name,
                                                      storypopupcontroller
                                                          .emojiListStickers[
                                                      index]
                                                          .id);
                                                },
                                                child: Container(
                                                    height: 20,
                                                    child: Image(
                                                      image:
                                                      CachedNetworkImageProvider(
                                                        storypopupcontroller
                                                            .emojiListStickers[
                                                        index]
                                                            .name!,
                                                      ),
                                                      fit: BoxFit
                                                          .cover,
                                                      height: 20,
                                                    )),
                                              ),
                                            );
                                          })),
                                    ],
                                  ),
                                ),
                                enablePullUp: true,
                                enablePullDown: false,
                              ),
                            ),

                            // GridView.builder(
                            //     shrinkWrap: true,
                            //     controller:
                            //         ModalScrollController.of(context),
                            //     itemCount: emojisList.stickers.length,
                            //     gridDelegate:
                            //         SliverGridDelegateWithFixedCrossAxisCount(
                            //       crossAxisCount: 3,
                            //       crossAxisSpacing: 20,
                            //       mainAxisSpacing: 20,
                            //     ),
                            //     itemBuilder: (context, index) {
                            //       return AspectRatio(
                            //         aspectRatio: 1,
                            //         child: InkWell(
                            //           onTap: () {
                            //             _searchController.clear();
                            //             widget.emojiDetails(
                            //                 emojisList
                            //                     .stickers[index].name,
                            //                 emojisList
                            //                     .stickers[index].id);
                            //           },
                            //           child: Container(
                            //               height: 20,
                            //               child: Image(
                            //                 image:
                            //                     CachedNetworkImageProvider(
                            //                         emojisList
                            //                             .stickers[index]
                            //                             .name),
                            //                 fit: BoxFit.cover,
                            //                 height: 20,
                            //               )),
                            //         ),
                            //       );
                            //     }),

                            Obx(() => storypopupcontroller
                                .gifListStickers.length ==
                                0
                                ? Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            )
                                : SmartRefresher(
                              key: Key('giphy'),
                              header: CustomHeader(
                                builder: (context, mode) {
                                  return Container(
                                    child: Center(
                                        child: loadingAnimation()),
                                  );
                                },
                              ),
                              footer: CustomFooter(
                                builder: (BuildContext context,
                                    LoadStatus? mode) {
                                  Widget body;

                                  if (mode == LoadStatus.idle) {
                                    body = Text("");
                                  } else if (mode ==
                                      LoadStatus.loading) {
                                    print("loading gif");
                                    body = Container(
                                      child: Center(
                                          child:
                                          loadingAnimation()),
                                    );
                                  } else if (mode ==
                                      LoadStatus.failed) {
                                    body = Container(
                                        decoration:
                                        new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                              color: Colors.black,
                                              width: 0.7),
                                        ),
                                        child: Padding(
                                          padding:
                                          EdgeInsets.all(12.0),
                                          child: Icon(
                                              CustomIcons.reload),
                                        ));
                                  } else if (mode ==
                                      LoadStatus.canLoading) {
                                    body = Text("");
                                  } else {
                                    body = Text("");
                                  }
                                  return Container(
                                    height: 55.0,
                                    child: Center(child: body),
                                  );
                                },
                              ),
                              controller: storypopupcontroller
                                  .refreshController,
                              onLoading: () {
                                print(
                                    "gif onLoading called ${storypopupcontroller.currentPage + 1} ");
                                storypopupcontroller.nextGiphyGif(
                                    page:
                                    '${storypopupcontroller.currentPage.value++}');
                                storypopupcontroller
                                    .refreshController
                                    .loadComplete();
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Obx(() => GridView.builder(
                                        shrinkWrap: true,
                                        controller:
                                        ModalScrollController
                                            .of(context),
                                        itemCount:
                                        storypopupcontroller
                                            .gifListStickers
                                            .length,
                                        // physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                        ),
                                        itemBuilder:
                                            (context, index) {
                                          return AspectRatio(
                                            aspectRatio: 1,
                                            child: InkWell(
                                              onTap: () {
                                                _searchController
                                                    .clear();
                                                widget.gifsDetails!(
                                                    storypopupcontroller
                                                        .gifListStickers[
                                                    index]
                                                        .name,
                                                    storypopupcontroller
                                                        .gifListStickers[
                                                    index]
                                                        .id);
                                              },
                                              child: Container(
                                                  height: 20,
                                                  child: Image(
                                                    image:
                                                    CachedNetworkImageProvider(
                                                      storypopupcontroller
                                                          .gifListStickers[
                                                      index]
                                                          .name!,
                                                    ),
                                                    fit: BoxFit
                                                        .cover,
                                                    height: 20,
                                                  )),
                                            ),
                                          );
                                        })),
                                  ],
                                ),
                              ),
                              enablePullUp: true,
                            )),

                            // GridView.builder(
                            //           shrinkWrap: true,
                            //           controller:
                            //               ModalScrollController.of(context),
                            //           itemCount: gifsList.stickers.length,
                            //           physics: NeverScrollableScrollPhysics(),
                            //           gridDelegate:
                            //               SliverGridDelegateWithFixedCrossAxisCount(
                            //             crossAxisCount: 3,
                            //             crossAxisSpacing: 20,
                            //             mainAxisSpacing: 20,
                            //           ),
                            //           itemBuilder: (context, index) {
                            //             return AspectRatio(
                            //               aspectRatio: 1,
                            //               child: InkWell(
                            //                 onTap: () {
                            //                   _searchController.clear();
                            //                   widget.gifsDetails(
                            //                       gifsList.stickers[index].name,
                            //                       gifsList.stickers[index].id);
                            //                 },
                            //                 child: Container(
                            //                     height: 20,
                            //                     child: Image(
                            //                       image:
                            //                           CachedNetworkImageProvider(
                            //                         gifsList.stickers[index].name,
                            //                       ),
                            //                       fit: BoxFit.cover,
                            //                       height: 20,
                            //                     )),
                            //               ),
                            //             );
                            //           })
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}