import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/popularrealestatemarketview.dart';
import 'package:bizbultest/widgets/Properbuz/PropertiesSearchedbyCity/PropertiesSearchedPage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class PropertiesSearched extends GetView<ProperbuzController> {
  const PropertiesSearched({Key? key}) : super(key: key);

  Widget _locationsListBuilder() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: controller.lstPropertySearch
            .map((e) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  child: GestureDetector(
                    onTap: () {
                      print("clicked ${e.area}");
                      Navigator.of(Get.context!).push(MaterialPageRoute(
                        builder: (context) =>
                            RecentPropertiesSearchedView(e.country!, e.area!),
                      ));
                    },
                    child: Text(
                      "•  " + e.area!,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _categoryCard(int index) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.0.w - 30,
            decoration: new BoxDecoration(
              color: HexColor("#f5f7f6"),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              shape: BoxShape.rectangle,
            ),
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              visualDensity: VisualDensity(horizontal: -4),
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                controller.recentPropertySearchLoader.value = true;
                controller.lstPropertySearch.isEmpty
                    ? await controller.searchByCityData()
                    : null;
                controller.recentPropertySearchLoader.value = false;
                controller.recentlySearchCityStatus[index].value =
                    !controller.recentlySearchCityStatus[index].value;
              },
              title: Text(
                controller.recentlySearchCity[index]["value"],
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Obx(
                () => controller.recentPropertySearchLoader.isTrue
                    ? CircularProgressIndicator(
                        color: hotPropertiesThemeColor,
                      )
                    : Icon(
                        controller.recentlySearchCityStatus[index].value
                            ? Icons.arrow_drop_up_sharp
                            : Icons.arrow_drop_down_sharp,
                        size: 20,
                        color: properbuzBlueColor,
                      ),
              ),
            ),
          ),
          controller.recentlySearchCityStatus[index].value
              ? _locationsListBuilder()
              : Container()
        ],
      ),
    );
  }

  Widget _categoryList(BuildContext context) {
    return Obx(
      () => ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 0),
          itemCount: controller.recentlyAddedLocation.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _categoryCard(index);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzController());
    return _categoryList(context);
  }
}
