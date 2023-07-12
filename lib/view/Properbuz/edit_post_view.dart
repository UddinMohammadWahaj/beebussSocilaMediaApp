import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class EditPostView extends GetView<ProperbuzFeedController> {
  final int? index;
  final int? val;

  const EditPostView({Key? key, this.index, this.val}) : super(key: key);

  Widget _updateButton(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Obx(
          () => GestureDetector(
            onTap: () {
              if (controller.getFeedsList(val!)[index!].description!.value ==
                      controller.editPostText.value ||
                  controller.editPostText.value.isEmpty) {
              } else {
                controller.updatePost(val!, index!, context);
              }
            },
            child: Container(
                color:
                    controller.getFeedsList(val!)[index!].description!.value ==
                                controller.editPostText.value ||
                            controller.editPostText.value.isEmpty
                        ? Colors.grey.shade200
                        : hotPropertiesThemeColor,
                height: 60,
                width: 100.0.w,
                child: Center(
                    child: controller.isUpdating.value
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: Center(
                                child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            )))
                        : Text(
                            AppLocalizations.of("Update"),
                            style: TextStyle(
                                fontSize: 18,
                                color: controller
                                                .getFeedsList(val!)[index!]
                                                .description!
                                                .value ==
                                            controller.editPostText.value ||
                                        controller.editPostText.value.isEmpty
                                    ? Colors.grey.shade500
                                    : Colors.white,
                                fontWeight: FontWeight.w500),
                          ))),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        controller.editPostController.clear();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.close,
              size: 28,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              controller.editPostController.clear();
            },
          ),
          title: Text(
            AppLocalizations.of("Edit") + " " + AppLocalizations.of("Post"),
            style: TextStyle(
                fontSize: 15.0.sp,
                color: Colors.black,
                fontWeight: FontWeight.normal),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: 100.0.w,
                height: 100.0.h - 65,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: new BoxDecoration(
                  border: Border(
                    //bottom: BorderSide(color: Colors.grey.shade400, width: 0.5),
                    top: BorderSide(color: Colors.grey.shade400, width: 0.5),
                  ),
                  shape: BoxShape.rectangle,
                  color: HexColor("#f5f7f6"),
                ),
                child: DetectableTextField(
                  onChanged: (val) {
                    controller.editPostText.value = val;
                  },
                  maxLines: null,
                  cursorColor: Colors.grey.shade500,
                  controller: controller.editPostController,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  detectionRegExp: detectionRegExp()!,
                  decoratedStyle: TextStyle(
                      fontSize: 15,
                      color: hotPropertiesThemeColor,
                      fontWeight: FontWeight.w500),
                  basicStyle:
                      TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIconConstraints: BoxConstraints(),
                    prefixIconConstraints: BoxConstraints(),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: AppLocalizations.of(
                      "Write something...",
                    ),
                    hintStyle:
                        TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  ),
                ),
              ),
            ),
            _updateButton(context),
          ],
        ),
      ),
    );
  }
}
