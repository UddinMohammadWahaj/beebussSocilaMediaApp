import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/location_reviews_controller.dart';
import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/view/Properbuz/reviews/detailed_location_review.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../../utilities/colors.dart';

class LocationReviewItem extends GetView<LocationReviewsController> {
  final int index;
  final int value;
  const LocationReviewItem({Key? key, required this.index, required this.value})
      : super(key: key);

  Widget _starIcons(int rating) {
    List starsList = List<int>.generate(5, (counter) => counter++);
    return Row(
        children: starsList
            .asMap()
            .map((i, value) => MapEntry(
                i,
                Icon(
                  Icons.star,
                  size: 19,
                  color:
                      i < rating ? HexColor("#e28743") : Colors.grey.shade500,
                )))
            .values
            .toList());
  }

  bool hasImage(index) {
    if (controller.getReviewsList(value)[index].images!.length == 0) {
      return false;
    }
    return true;
  }

  get dummyImage =>
      'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';

  Widget _photoCard(
    String file,
  ) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Container(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Image.network(
            file,
            fit: BoxFit.cover,
            height: 250,
            width: 100.0.w,
          ),
        ),
      ),
    );
  }

  Widget _listOfimageCard(int index) {
    // if (!hasImage(index)) {
    //   controller.getReviewsList(value)[index].images.addAll(controller.images);
    // }
    return Container(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.getReviewsList(value)[index].images!.length,
              itemBuilder: (context, indexs) {
                return _photoCard(
                  controller.getReviewsList(value)[index].images![indexs],
                );
              }),
          // _photosLengthCard()
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
            controller.getReviewsList(value)[index].title!,
            style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }

  Widget _userCard(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 60,
      width: 60.0.w,
      // color: settingsColor,
      child: ListTile(
        // contentPadding: EdgeInsets.only(bottom: 10),
        title: Text(

          controller.getReviewsList(value)[index].userName!,

          // AppLocalizations.of(controller.getReviewsList(value)[index].userName),
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

  Widget reviewTitle(int index) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(controller.getReviewsList(value)[index].title!),
            style: TextStyle(
                fontSize: 17,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget _videoHeader() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Text(
          AppLocalizations.of("Videos"),
          style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
        ));
  }

  Widget _reviewTitle() {
    return Container(
      padding: EdgeInsets.only(top: 3),
      child: Text(
        AppLocalizations.of(controller.getReviewsList(value)[index].title!),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _reviewDescription(int index) {
    bool see = false;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.only(
          top: 10,
        ),
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
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedLocationReview(
                    index: index,
                    value: value,
                  ))),
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
          border: new Border.all(
            color: hotPropertiesThemeColor,
            width: 1,
          ),
        ),
        margin: EdgeInsets.all(10),
        // color: Colors.pink,
        padding: EdgeInsets.only(
          bottom: 10,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _userCard(index),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: _starIcons(
                      controller.getReviewsList(value)[index].ratings!),
                ),
                // paddingOnly(right: 10),
              ],
            ),
            _listOfimageCard(index),
            reviewTitle(index),
            _reviewDescription(index),
          ],
        ),
      ),
    );
  }
}
