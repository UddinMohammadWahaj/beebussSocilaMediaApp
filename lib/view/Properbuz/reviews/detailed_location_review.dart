import 'package:bizbultest/services/Properbuz/location_reviews_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/menu/user_properties/location_review_card.dart';
import 'package:bizbultest/widgets/Properbuz/reviews/review_card_home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:webviewx/webviewx.dart';

import '../../../Language/appLocalization.dart';

class DetailedLocationReview extends GetView<LocationReviewsController> {
  final int index;
  final int value;
  const DetailedLocationReview(
      {Key? key, required this.index, required this.value})
      : super(key: key);

  Widget _pageCard() {
    return Positioned.fill(
      left: 10,
      bottom: 15,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(2)),
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Obx(() => Text(
                "${controller.getReviewsList(value)[index].currentIndex.toString()}/${controller.getReviewsList(value)[index].images!.length}",
                style: TextStyle(
                    color: hotPropertiesThemeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )),
        ),
      ),
    );
  }

  Widget _starIcons(int rating) {
    List starsList = List<int>.generate(5, (counter) => counter++);
    return Row(
        children: starsList
            .asMap()
            .map((i, value) => MapEntry(
                i,
                Icon(
                  Icons.star,
                  size: 17,
                  color:
                      i < rating ? HexColor("#e28743") : Colors.grey.shade500,
                )))
            .values
            .toList());
  }

  Widget _imageCard(String image) {
    return Container(
      color: Colors.grey.shade200,
      child: Image(
        image: CachedNetworkImageProvider(image),
        height: 250,
        fit: BoxFit.cover,
        width: 100.0.w,
      ),
    );
  }

  Widget _imagesBuilder() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      height: 250,
      width: 100.0.w,
      child: Stack(
        children: [
          PageView.builder(
              onPageChanged: (page) =>
                  controller.changeIndex(page, index, value),
              itemCount: controller.getReviewsList(value)[index].images!.length,
              itemBuilder: (context, imageIndex) {
                return _imageCard(controller
                    .getReviewsList(value)[index]
                    .images![imageIndex]);
              }),
          _pageCard()
        ],
      ),
    );
  }

  Widget _ratingsAndDescriptionCard(int index) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _starIcons(controller.getReviewsList(value)[index].ratings!),
          Text(
            AppLocalizations.of(controller.getReviewsList(value)[index].title!),
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }

  Widget _userCard(int index) {
    return Container(
      height: 60,
      width: 80.0.w,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        title: Text(
          AppLocalizations.of(
              controller.getReviewsList(value)[index].userName!),
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          AppLocalizations.of(
              controller.getReviewsList(value)[index].reviewTime!),
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.transparent,
          backgroundImage: CachedNetworkImageProvider(
              controller.getReviewsList(value)[index].userImage!),
        ),
      ),
    );
  }

  Widget reviewCard(int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imagesBuilder(),
          _ratingsAndDescriptionCard(index),
          _userCard(index)
        ],
      ),
    );
  }

  Widget _descriptionCard() {
    return Html(
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // defaultTextStyle: TextStyle(
        //   fontSize: 17,
        // ),
        data: controller.getReviewsList(value)[index].description);
  }

  Widget _videoCard(String url, int ind) {
    return GestureDetector(
      onTap: () => controller
          .openYouTube(controller.locationReviewsList[index].videos![ind]),
      child: Container(
        padding: EdgeInsets.only(
            left: 10,
            right: ind ==
                    controller.locationReviewsList[index].videoThumbnails!
                            .length -
                        1
                ? 10
                : 0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image(
                image: CachedNetworkImageProvider(url),
                height: 200,
                fit: BoxFit.cover,
                width: controller.locationReviewsList[index].videoThumbnails!
                            .length ==
                        1
                    ? 100.0.w - 20
                    : 80.0.w,
              ),
            ),
            Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                shape: BoxShape.rectangle,
                color: Colors.black.withOpacity(0.4),
              ),
              height: 225,
              width: controller
                          .locationReviewsList[index].videoThumbnails!.length ==
                      1
                  ? 100.0.w - 20
                  : 80.0.w,
            ),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/youtube.png",
                    height: 50,
                    width: 50,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _videosListBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              AppLocalizations.of("Video"),
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500),
            )),
        Container(
          height: 225,
          padding: EdgeInsets.only(bottom: 10, top: 10),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              //Commented here for testing
              // itemCount:
              //     controller.locationReviewsList[index].videoThumbnails.length,

              itemCount: controller.locationReviewsList[index].videos!.length,
              itemBuilder: (context, videoIndex) {
                print("video card");
                // if (controller
                //         .locationReviewsList[index].videoThumbnails.length ==
                //     0)
                // return _videoCard(
                //     controller.locationReviewsList[index].images[0],
                //     videoIndex);
                return _videoCard(
                    controller.locationReviewsList[index]
                        .videoThumbnails![videoIndex],
                    videoIndex);
              }),
        ),
      ],
    );
  }

  Widget _reviewDescription(int index) {
    bool see = false;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ReadMoreText(
          AppLocalizations.of(
              controller.getReviewsList(value)[index].description!),
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade700),
          // trimLines: 2,
          trimLength: 130,
          textAlign: TextAlign.justify,
          colorClickableText: settingsColor,
          delimiter: "",
          // trimMode: TrimMode.Line,
          trimCollapsedText: '...' + AppLocalizations.of('Show more'),
          trimExpandedText: '  ' + AppLocalizations.of('Show less'),
          moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LocationReviewsController());
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        controller.getReviewsList(value)[index].currentIndex!.value = 1;
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            leading: IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.keyboard_backspace,
                size: 28,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                controller.getReviewsList(value)[index].currentIndex!.value = 1;
              },
            ),
            backgroundColor: hotPropertiesThemeColor,
            elevation: 0,
            title: Text(
              AppLocalizations.of("Reviews"),
              style: TextStyle(fontSize: 14.0.sp, color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              reviewCard(index),
              _reviewDescription(index),
              _videosListBuilder()
            ],
          ),
        ),
      ),
    );
  }
}
