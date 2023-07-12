import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Streaming/Controllers/category_controller.dart';
import 'package:bizbultest/services/Streaming/Controllers/search_controller.dart';
import 'package:bizbultest/widgets/Streaming/info_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import 'detailed_video_info_page_movies.dart';

class StreamingSearchPage extends StatefulWidget {
  final String? image;

  const StreamingSearchPage({Key? key, this.image}) : super(key: key);

  @override
  _StreamingSearchPageState createState() => _StreamingSearchPageState();
}

class _StreamingSearchPageState extends State<StreamingSearchPage> {
  CategoryController _categoryController = Get.put(CategoryController());
  StreamingSearchController controller = Get.put(StreamingSearchController());
  double horizontalHeight = 85;

  PreferredSize _searchBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            shape: BoxShape.rectangle,
          ),
          child: TextFormField(
            onChanged: (val) {
              controller.searchValue.value = val;
            },
            textCapitalization: TextCapitalization.words,
            maxLines: 1,
            cursorColor: Colors.black54,
            cursorHeight: 16,
            style: _style(14, FontWeight.normal, Colors.black54),
            controller: controller.searchController,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black54,
              ),
              hintText: AppLocalizations.of(
                "Search for a show, movie, genre, etc.",
              ),
              hintStyle: _style(14, FontWeight.normal, Colors.black54),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _style(double size, FontWeight weight, Color color) {
    return GoogleFonts.publicSans(
        fontSize: size, fontWeight: weight, color: color);
  }

  Widget _headerCard(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        text,
        style: _style(22, FontWeight.bold, Colors.white),
      ),
    );
  }

  Widget _categoryCard(String category) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
          begin: FractionalOffset.centerLeft,
          end: FractionalOffset.centerRight,
          stops: [0.1, 0.3, 0.5, 0.7, 1.0],
          colors: [
            Colors.red.shade400,
            Colors.red.shade500,
            Colors.red,
            Colors.red.shade600,
            Colors.red.shade700
          ],
        ),
      ),
      child: Center(
        child: Container(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            category,
            style: _style(14, FontWeight.w500, Colors.white),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )),
      ),
    );
  }

  Widget _categoryGrid() {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        shrinkWrap: true,
        itemCount: _categoryController.allCategoryList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            childAspectRatio: 16 / 5),
        itemBuilder: (context, index) {
          return _categoryCard(
              _categoryController.allCategoryList[index].name!);
        });
  }

  Widget _imageCard(String image) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.all(Radius.circular(3)),
        shape: BoxShape.rectangle,
      ),
      child: Container(
        height: horizontalHeight,
        width: 135,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image(
              image: CachedNetworkImageProvider(
                image,
              ),
              fit: BoxFit.cover,
              height: horizontalHeight,
              width: 135,
            )),
      ),
    );
  }

  Widget _topSearchCard(int index) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            barrierColor: Colors.white.withOpacity(0),
            elevation: 0,
            backgroundColor: Colors.grey.shade900,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            //isScrollControlled:true,
            context: context,
            builder: (BuildContext bc) {
              return InfoCard(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailedVideoInfoPageMovie(
                                image:
                                    controller.topSearchedVideos[index].poster,
                                video: controller.topSearchedVideos[index],
                              )));
                },
                video: controller.topSearchedVideos[index],
              );
            });
      },
      child: Container(
        color: HexColor("#21201e"),
        height: horizontalHeight,
        margin: EdgeInsets.only(bottom: 2),
        padding: EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _imageCard(controller.topSearchedVideos[index].poster!),
            Container(
              height: horizontalHeight,
              color: Colors.transparent,
              width: 100.0.w - 185,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(
                        controller.topSearchedVideos[index].title!,
                      ),
                      style: _style(14, FontWeight.normal, Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              height: horizontalHeight,
              width: 30,
              color: Colors.transparent,
              child: _playButton(),
            )
          ],
        ),
      ),
    );
  }

  Widget _topSearchedList() {
    return Obx(
      () => ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(top: 5),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.topSearchedVideos.length,
          itemBuilder: (context, index) {
            return _topSearchCard(index);
          }),
    );
  }

  Widget _searchedList() {
    return Obx(() => Container(
          child: controller.isSearching.value
              ? Container(
                  padding: EdgeInsets.only(top: 35.0.h),
                  child: Center(
                    child: SizedBox(
                        height: 26,
                        width: 26,
                        child: Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.5,
                        ))),
                  ),
                )
              : Container(
                  child: controller.searchedVideos.isEmpty &&
                          !controller.isSearching.value
                      ? Container(
                          padding: EdgeInsets.only(top: 35.0.h),
                          child: Center(
                            child: Text(
                              "No results found for '${controller.searchValue.value}'",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      : GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          shrinkWrap: true,
                          itemCount: controller.searchedVideos.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 3 / 4),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    barrierColor: Colors.white.withOpacity(0),
                                    elevation: 0,
                                    backgroundColor: Colors.grey.shade900,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(10.0),
                                            topRight:
                                                const Radius.circular(10.0))),
                                    //isScrollControlled:true,
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return InfoCard(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailedVideoInfoPageMovie(
                                                        image: controller
                                                            .searchedVideos[
                                                                index]
                                                            .poster,
                                                        video: controller
                                                                .searchedVideos[
                                                            index],
                                                      )));
                                        },
                                        video: controller.searchedVideos[index],
                                      );
                                    });
                              },
                              child: Container(
                                  color: Colors.grey.shade800,
                                  child: Image(
                                    image: CachedNetworkImageProvider(controller
                                        .searchedVideos[index].poster!),
                                    fit: BoxFit.cover,
                                  )),
                            );
                          }),
                ),
        ));
  }

  Widget _playButton() {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Get.delete<StreamingSearchController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                Get.delete<StreamingSearchController>();
              },
            ),
            bottom: _searchBar(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _headerCard(
                  //   AppLocalizations.of(
                  //     "Top Categories",
                  //   ),
                  // ),
                  // _categoryGrid(),
                  Obx(
                    () => _headerCard(
                      AppLocalizations.of(
                        controller.searchValue.value.isEmpty
                            ? "Top Searches"
                            : "Movies and TV Shows",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() => Container(
                      child: controller.searchValue.value.isEmpty
                          ? _topSearchedList()
                          : _searchedList())),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
