import 'dart:math';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/view_resuts_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:html/parser.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

import '../../../../view/Properbuz/add_items/manage_review_view.dart';
import 'my_review_detalis_view.dart';

class LocationReviewCard extends GetView<UserPropertiesController> {
  final String? approvalstatus;
  final String? country;
  final String? location;
  final String? title;
  final String? review;
  final int? rating;
  final List<dynamic>? images;

  final int index;
  LocationReviewCard({
    Key? key,
    this.approvalstatus,
    this.country,
    this.location,
    this.rating,
    this.review,
    this.title,
    this.images = const [],
    required this.index,
  }) : super(key: key);

  Widget getStars(rating) {
    List<Widget> noofstars = [];
    for (int i = 0; i < rating; i++)
      noofstars.add(
        Icon(
          Icons.star,
          color: HexColor("#e28743"),
        ),
      );
    for (int j = rating; j < 5; j++) {
      noofstars.add(
        Icon(
          Icons.star_border,
          color: Colors.grey.shade500,
        ),
      );
    }
    return Row(children: noofstars);
  }

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

  Widget _photosLengthCard() {
    return Positioned.fill(
      left: 20,
      bottom: 10,
      child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                "${this.images!.length} ${this.photosString()}",
                style: TextStyle(
                    color: hotPropertiesThemeColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 13),
              ))),
    );
  }

  Widget _listOfimageCard() {
    return Container(
      height: 250,
      child: Stack(
        children: [
          PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: this.images!.length,
              itemBuilder: (context, index) {
                return _photoCard(
                  this.images![index],
                );
              }),
          _photosLengthCard()
        ],
      ),
    );
  }

  String photosString() {
    switch (this.images!.length) {
      case 1:
        return AppLocalizations.of("Photo");
        break;
      default:
        return AppLocalizations.of("Photos");
        break;
    }
  }

  Widget _imageCard() {
    var r = Random();
    return Image(
      image: CachedNetworkImageProvider(
          controller.images[r.nextInt(controller.images.length)]),
      fit: BoxFit.cover,
      height: 250,
      width: 100.0.w,
    );
  }

  Widget _starIcons() {
    List starsList = List<int>.generate(5, (counter) => counter++);
    return Row(
      children: starsList
          .map((e) => Icon(
                Icons.star,
                size: 15,
                color: HexColor("#e28743"),
              ))
          .toList(),
    );
  }

  Widget _reviewTitle() {
    return Container(
      padding: EdgeInsets.only(top: 3),
      child: Text(
        AppLocalizations.of(
            // "What you should know before moving to New York?",
            this.title!),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Widget _reviewDescription() {
    return Container(
        padding: EdgeInsets.only(top: 3),
        child: Html(
          data: this.review,
          // renderNewlines: true,
          // defaultTextStyle: TextStyle(fontSize: 17),
        )

        //  ReadMoreText(
        //   AppLocalizations.of(
        //       // 'THE HARDEST THING(S) TO ADJUST WHEN YOU MOVING TO nEW YORK. The Prices – We knew that NYC was the most expensive US city to live in, and we tried to prep ourselves, but it still shocks me whenever we eat out and get the bill. If you use yelp as a gauge for how much you think you’ll spend, expect the scale to be different here. One dollar sign means two, two means three, and three means four.' +
        //       //     " ",
        //       this.review),
        //   trimLines: 2,
        //   colorClickableText: Colors.grey.shade500,
        //   trimMode: TrimMode.Line,
        //   trimCollapsedText: AppLocalizations.of(
        //     'see more',
        //   ),
        //   trimExpandedText: AppLocalizations.of(
        //     'see less',
        //   ),
        //   style: TextStyle(
        //       fontWeight: FontWeight.normal,
        //       color: Colors.grey.shade700,
        //       fontSize: 13),
        //   moreStyle: TextStyle(
        //       fontWeight: FontWeight.normal, color: Colors.grey.shade600),
        // ),
        );
  }

  Widget _locationCard() {
    return Container(
        padding: EdgeInsets.only(top: 3),
        child: Text(
          AppLocalizations.of(
              // "Sydney, Australia",
              "${this.country},${this.location}"),
          style: TextStyle(),
        ));
  }

  Widget _manageIcon(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.delete_solid,
              color: Colors.red,
            )),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManageLocationReviewView(
                            index: index,
                          )));
            },
            icon: Icon(
              Icons.edit_location_alt_outlined,
              color: Colors.red,
            )),
      ],
    );
  }

  Widget _approvedCard(context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          shape: BoxShape.rectangle,
          color: (this.approvalstatus != "0")
              ? Colors.green
              : Color.fromARGB(255, 242, 187, 21),
        ),
        padding: EdgeInsets.all(5),
        child: Text(
          AppLocalizations.of(
              (this.approvalstatus != "0") ? "APPROVED" : "Pending"),
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      _manageIcon(context),
    ]);
  }

  Widget _reviewDescriptioncard() {
    // bool see = false;
    var data = _parseHtmlString(this.review!);
    return Container(
        // margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: ReadMoreText(
          AppLocalizations.of(data),
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

  Widget _reviewCard(context) {
    return Container(
      color: Colors.grey.shade50,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _approvedCard(context),
          _locationCard(),
          // _starIcons(),
          getStars(this.rating),
          _reviewTitle(),
          _reviewDescriptioncard(),
          // _reviewDescription(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserPropertiesController());
    var r = Random();
    return GestureDetector(
      onTap: () {
        print("======= ${controller.loactionReviewList[index]}");
        // print("---------review ${this.review}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailedMyReview(
                      index: index,
                    )));
      },
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
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            (images!.length == 0)
                ? _photoCard(
                    controller.images[r.nextInt(controller.images.length)])
                : _listOfimageCard(),
            _reviewCard(context),
          ],
        ),
      ),
    );
  }
}
