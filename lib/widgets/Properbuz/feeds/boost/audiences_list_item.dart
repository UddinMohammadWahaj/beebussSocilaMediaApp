import 'package:bizbultest/services/Properbuz/boost_post_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudiencesListItem extends GetView<BootPostController> {
  const AudiencesListItem({Key? key}) : super(key: key);

  Widget _selectionIndicator(RxBool selected) {
    if (!selected.value) {
      return Icon(
        CupertinoIcons.circle,
        color: Colors.grey.shade700,
      );
    } else {
      return Icon(
        CupertinoIcons.largecircle_fill_circle,
        color: appBarColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(BootPostController());
    return Container(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.audienceList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => controller.selectUnSelectAudience(index),
              child: Container(
                  color: Colors.grey.shade200,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.audienceList[index].audienceName!,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          Text(
                            controller.audienceList[index].audienceAgeData!,
                            style: TextStyle(color: Colors.grey.shade700),
                          )
                        ],
                      ),
                      Obx(() => _selectionIndicator(
                          controller.audienceList[index].selected!))
                    ],
                  )),
            );
          }),
    );
  }
}
