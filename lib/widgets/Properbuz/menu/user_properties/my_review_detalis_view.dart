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
import 'package:html/parser.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';
import 'package:webviewx/webviewx.dart';

import '../../../../Language/appLocalization.dart';
import '../../../../services/Properbuz/user_properties_controller.dart';
import '../../../../services/current_user.dart';

class DetailedMyReview extends GetView<UserPropertiesController> {
  final int index;

  DetailedMyReview({
    Key? key,
    required this.index,
  }) : super(key: key);
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
                "${controller.currentIndex1.toString()}/${controller.loactionReviewList[index]['images'].length}",
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
              onPageChanged: (page) => controller.changeIndex(page),
              itemCount: controller.loactionReviewList[index]['images'].length,
              itemBuilder: (context, imageIndex) {
                return _imageCard(
                    controller.loactionReviewList[index]['images'][imageIndex]);
              }),
          _pageCard()
        ],
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text!).documentElement!.text;

    return parsedString;
  }

  Widget _reviewDescriptioncard() {
    var data1 =
        _parseHtmlString(controller.loactionReviewList[index]['review']);
    return Container(
        // margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ReadMoreText(
          AppLocalizations.of(data1),
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade700),
          trimLines: 4,
          // trimLength: 270,
          textAlign: TextAlign.justify,
          colorClickableText: settingsColor,
          delimiter: "",
          // trimMode: TrimMode.Line,
          trimCollapsedText: '...' +
              AppLocalizations.of('Show') +
              " " +
              AppLocalizations.of('more'),
          trimExpandedText: '  ' +
              AppLocalizations.of('Show') +
              " " +
              AppLocalizations.of(' less'),
          moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700),
        ));
  }

  Widget _ratingsAndDescriptionCard(int index) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 60.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _starIcons(
                    int.parse(controller.loactionReviewList[index]['rating'])),
                Text(
                  AppLocalizations.of(
                      controller.loactionReviewList[index]['review_title']),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          _approvedCard(),
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
          AppLocalizations.of(CurrentUser().currentUser.fullName!),
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          AppLocalizations.of(CurrentUser().currentUser.country!),
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.transparent,
          backgroundImage:
              CachedNetworkImageProvider(CurrentUser().currentUser.image!),
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

  Widget _approvedCard() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          shape: BoxShape.rectangle,
          color: (controller.loactionReviewList[index]['status'] != "0")
              ? Colors.green
              : Color.fromARGB(255, 242, 187, 21),
        ),
        padding: EdgeInsets.all(5),
        child: Text(
          AppLocalizations.of(
              (controller.loactionReviewList[index]['status'] != "0")
                  ? "APPROVED"
                  : "Pending"),
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    ]);
  }

  Widget _descriptionCard() {
    return Html(
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // defaultTextStyle: TextStyle(
        //   fontSize: 17,
        // ),
        data: controller.loactionReviewList[index]['review']);
  }

  Widget _videoCard(String url, int ind) {
    return GestureDetector(
      onTap: () => controller
          .openYouTube(controller.loactionReviewList[index]['video_url']),
      child: Container(
        padding: EdgeInsets.only(
            left: 10,
            right: ind ==
                    controller.loactionReviewList[index]['videothumbnail']
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
                width: controller.loactionReviewList[index]['videothumbnail']
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
                          .loactionReviewList[index]['videothumbnail'].length ==
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
          child: controller
                      .loactionReviewList[index]['videothumbnail'].length ==
                  0
              ? _videoCard(
                  'https://static.vecteezy.com/system/resources/previews/005/337/799/original/icon-image-not-found-free-vector.jpg',
                  0)
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller
                      .loactionReviewList[index]['videothumbnail'].length,
                  itemBuilder: (context, videoIndex) {
                    print("video card");
                    if (controller.loactionReviewList[index]['videothumbnail']
                            .length ==
                        0)
                      return _videoCard(
                          controller.loactionReviewList[index]['images'][0],
                          videoIndex);
                    return _videoCard(
                        controller.loactionReviewList[index]['videothumbnail']
                            [videoIndex],
                        videoIndex);
                  }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserPropertiesController());
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        controller.currentIndex1.value = 1;
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
                controller.currentIndex1.value = 1;
              },
            ),
            backgroundColor: primaryPinkColor,
            elevation: 0,
            title: Text(
              AppLocalizations.of("Review"),
              style: TextStyle(fontSize: 14.0.sp, color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              reviewCard(index),
              Align(
                  alignment: Alignment.centerLeft,
                  child: _reviewDescriptioncard()),
              _videosListBuilder()
            ],
          ),
        ),
      ),
    );
  }
}
