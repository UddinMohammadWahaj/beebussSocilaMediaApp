import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../services/Properbuz/user_properties_controller.dart';
import '../../utilities/colors.dart';

class PopularFloorPlanItemFeature
    extends GetView<PopularRealEstateMarketController> {
  final int index;
  PopularFloorPlanItemFeature({
    Key? key,
    required this.index,
  }) : super(key: key);

  UserPropertiesController ctr = Get.put(UserPropertiesController());

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
        controller
            .lstofpopularrealestatemodel[index].selectedFloorIndex!.value = ind;
      },
      child: Obx(
        () => Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            border: ind ==
                    controller.lstofpopularrealestatemodel[index]
                        .selectedFloorIndex!.value
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
                "${(controller.lstofpopularrealestatemodel[index].selectedFloorIndex!.value + 1).toString()}/${ctr.floorImagesNew.length}",
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
    return ctr.floorImagesNew.isEmpty
        ? Center(child: Text("Floor Plan not Available..!!"))
        : Column(
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
                            controller.changePropertyFloorPage(
                              page,
                              index,
                            );

                            controller.carouselController.animateToPage(
                              page,
                            );
                          },
                          itemCount: ctr.floorImagesNew.length,
                          itemBuilder: (context, imageIndex) {
                            return _imageCardPageView(
                                ctr.floorImagesNew[imageIndex]);
                          }),
                    ),
                  ),
                  _pageCard(),
                ],
              ),
              Obx(
                () => CarouselSlider.builder(
                    carouselController: controller.carouselController,
                    itemCount: ctr.floorImagesNew.length,
                    itemBuilder: (context, value, ind) {
                      return _imageCardCarousel(
                          ctr.floorImagesNew[value], value);
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
