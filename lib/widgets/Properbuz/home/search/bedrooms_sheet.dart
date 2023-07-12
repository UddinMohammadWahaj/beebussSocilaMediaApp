import 'package:bizbultest/services/Properbuz/properbuz_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BedroomsSheet extends GetView<ProperbuzController> {
  const BedroomsSheet({Key? key}) : super(key: key);

  Widget _bedroomCard(
    String value,
  ) {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        onTap: () {
          controller.selectedBedroom.value = value;
          Get.back();
        },
        title: Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzController());
    return Obx(
      () => Container(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.bedrooms
              .map((element) => _bedroomCard(element['bedroom'].toString()))
              .toList(),
        ),
      )),
    );
  }
}
