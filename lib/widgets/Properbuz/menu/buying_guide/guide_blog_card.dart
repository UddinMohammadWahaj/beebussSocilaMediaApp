import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/property_guides_controller.dart';
import 'package:bizbultest/widgets/Properbuz/menu/buying_guide/read_more.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class GuideBlogCard extends GetView<PropertyGuidesController> {
  final int index;

  const GuideBlogCard({Key? key, required this.index}) : super(key: key);

  Widget _imageCard() {
    return Container(
      height: 30.0.h,
      width: 100.0.w,
      color: Colors.grey.shade200,
      child: Image(
        image: CachedNetworkImageProvider(controller.blogImage(index)),
        fit: BoxFit.cover,
        height: 30.0.h,
        width: 100.0.w,
      ),
    );
  }

  Widget _titleCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        AppLocalizations.of(controller.blogsList[index].title!),
        style: Theme.of(context).textTheme.overline!.merge(TextStyle(
            fontSize: 18,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500)),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _readMoreCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("object... ${controller.blogsList[index].title} ");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BuyingGuideReadMore(
                      index: index,
                    )));
      },
      child: Container(
        color: HexColor("#e9e6df"),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(
                "Read More",
              ),
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500),
            ),
            Icon(
              Icons.share,
              color: Colors.grey.shade800,
              size: 25,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertyGuidesController());
    return Container(
      //padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.blogImage(index) == "" &&
                  controller.blogImage(index) == null
              ? Container()
              : _imageCard(),
          _titleCard(context),
          _readMoreCard(context)
        ],
      ),
    );
  }
}
