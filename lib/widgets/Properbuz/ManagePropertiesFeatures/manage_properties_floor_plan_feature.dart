import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/services/Properbuz/popular_real_estate_market_controller.dart';
import 'package:bizbultest/services/Properbuz/user_properties_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../services/Properbuz/api/add_prop_api.dart';
import '../../../utilities/colors.dart';

class ManagePropertyFloorPlanItemFeature
    extends GetView<UserPropertiesController> {
  final int index;
  final int val;
  const ManagePropertyFloorPlanItemFeature(
      {Key? key, required this.index, required this.val})
      : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ExtendedImage.network(
//         controller.value(val)[index].floorPlan,
//         width: 100.0.w,
//         height: 50.0.h,
//         fit: BoxFit.contain,
//         // border: Border(
//         //   bottom: BorderSide(color: settingsColor, width: 1),
//         //   top: BorderSide(color: settingsColor, width: 1),
//         // ),
//         cache: true,
//         shape: BoxShape.rectangle,
//         mode: ExtendedImageMode.gesture,
//         initGestureConfigHandler: (state) {
//           return GestureConfig(
//             minScale: 0.9,
//             animationMinScale: 0.7,
//             maxScale: 3.0,
//             animationMaxScale: 3.5,
//             speed: 1.0,
//             inertialSpeed: 100.0,
//             initialScale: 1.0,
//             inPageView: false,
//             initialAlignment: InitialAlignment.center,
//           );
//         },
//         //cancelToken: cancellationToken,
//       ),
//     );
//   }
// }
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
      onTap: () async {
        print("--- 55 -- Z${controller.floorImagesNew}");
        controller.managepropertypageController.jumpToPage(ind);
        controller.value(val)[index].selectedFloorIndex!.value = ind;
      },
      child: Obx(
        () => Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            border:
                ind == controller.value(val)[index].selectedFloorIndex!.value
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
                "${(controller.value(val)[index].selectedFloorIndex!.value + 1).toString()}/${controller.floorImagesNew.length}",
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
                      controller.changePropertyFloorPage(page, index, val);

                      controller.managepropertycarouselController.animateToPage(
                        page,
                      );
                    },
                    itemCount: controller.floorImagesNew.length,
                    itemBuilder: (context, imageIndex) {
                      return _imageCardPageView(
                          controller.floorImagesNew[imageIndex]);
                    }),
              ),
            ),
            _pageCard(),
          ],
        ),
        Obx(
          () => CarouselSlider.builder(
              carouselController: controller.managepropertycarouselController,
              itemCount: controller.floorImagesNew.length,
              itemBuilder: (context, value, ind) {
                return _imageCardCarousel(
                    controller.floorImagesNew[value], value);
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
