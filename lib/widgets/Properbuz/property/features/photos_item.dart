import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PhotosItemFeature extends GetView<PropertiesController> {
  final int val;
  final int index;

  const PhotosItemFeature({
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
        controller.pageController.jumpToPage(ind);
        controller.properties(val)[index].selectedPhotoIndex!.value = ind;
      },
      child: Obx(
        () => Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            border: ind ==
                    controller.properties(val)[index].selectedPhotoIndex!.value
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
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        shape: BoxShape.rectangle,
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Obx(() => Text(
            "${(controller.properties(val)[index].selectedPhotoIndex!.value + 1).toString()}/${controller.properties(val)[index].images!.length}",
            style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 14.5,
                fontWeight: FontWeight.w500),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PropertiesController());
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
                    controller: controller.pageController,
                    onPageChanged: (page) {
                      controller.changePropertyImagesPage(page, index, val);
                      controller.carouselController.animateToPage(page);
                    },
                    itemCount: controller.properties(val)[index].images!.length,
                    itemBuilder: (context, imageIndex) {
                      return _imageCardPageView(controller
                          .properties(val)[index]
                          .images![imageIndex]);
                    }),
              ),
            ),
            _pageCard(),
          ],
        ),
        Obx(
          () => CarouselSlider.builder(
              carouselController: controller.carouselController,
              itemCount: controller.properties(val)[index].images!.length,
              itemBuilder: (context, value, ind) {
                return _imageCardCarousel(
                    controller.properties(val)[index].images![value], value);
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
