import 'package:bizbultest/services/Properbuz/api/populare_real_estate_api.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ManagePropertyPhotosItemFeature
    extends GetView<UserPropertiesController> {
  final int val;
  final int index;

  const ManagePropertyPhotosItemFeature({
    Key? key,
    required this.val,
    required this.index,
  }) : super(key: key);

  Widget _imageCardPageView(String image) {
    return Container(
      color: Colors.grey.shade200,
      child: Image(
        image: CachedNetworkImageProvider(image),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _imageCardCarousel(String image, int ind) {
    return GestureDetector(
      onTap: () {
        controller.managepropertypageController.jumpToPage(ind);
        controller.value(val)[index].selectedPhotoIndex!.value = ind;
      },
      child: Obx(
        () => Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            border:
                ind == controller.value(val)[index].selectedPhotoIndex!.value
                    ? new Border.all(
                        color: hotPropertiesThemeColor,
                        width: 1.5,
                      )
                    : null,
          ),
          width: 15.0.h,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(
              left: index == 0 ? 0 : 5, right: 10, top: 10, bottom: 10),
          child: Image(
            image: CachedNetworkImageProvider(image),
            fit: BoxFit.cover,
            width: 15.0.h,
          ),
        ),
      ),
    );
  }

  Widget _pageCard() {
    return Positioned.fill(
      left: 10,
      bottom: 15,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: new BoxDecoration(
            color: hotPropertiesThemeColor,
            borderRadius: BorderRadius.all(Radius.circular(2)),
            shape: BoxShape.rectangle,
          ),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Obx(() => Text(
                "${(controller.value(val)[index].selectedPhotoIndex!.value + 1).toString()}/${controller.value(val)[index].images!.length}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(''),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5),
              height: 35.0.h,
              width: 100.0.w,
              child: Obx(
                () => PageView.builder(
                    controller: controller.managepropertypageController,
                    onPageChanged: (page) {
                      controller.changePropertyImagesPage(page, index, val);

                      controller.managepropertycarouselController.animateToPage(
                        page,
                      );
                    },
                    itemCount: controller.value(val)[index].images!.length,
                    itemBuilder: (context, imageIndex) {
                      return _imageCardPageView(
                          controller.value(val)[index].images![imageIndex]);
                    }),
              ),
            ),
            _pageCard(),
          ],
        ),
        Obx(
          () => CarouselSlider.builder(
              carouselController: controller.managepropertycarouselController,
              itemCount: controller.value(val)[index].images!.length,
              itemBuilder: (context, value, ind) {
                return _imageCardCarousel(
                    controller.value(val)[index].images![value], value);
              },
              options: CarouselOptions(
                  pageSnapping: false,
                  enableInfiniteScroll: false,
                  height: 15.0.h,
                  disableCenter: true,
                  viewportFraction: 0.4,
                  enlargeCenterPage: false)),
        )
      ],
    );
  }
}
