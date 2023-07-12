import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/upload_post/image_post_type.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/upload_post/link_post_type.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/upload_post/video_post_type.dart';
import 'package:bizbultest/widgets/Properbuz/utils/properbuz_snackbar.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

class UploadPostCard extends GetView<ProperbuzFeedController> {
  final int index;

  UploadPostCard({Key? key, required this.index}) : super(key: key);

  Widget _customUploadTField() {
    return Container(
      constraints: BoxConstraints(minHeight: 80),
      width: 100.0.w,
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
        onDetectionTyped: (val) {
          // if (val != "") {
          //   print("bal=here ${controller.hasLink.value}");
          //   controller.hasLink.value = false;
          //   controller.url.value = val;
          // } else {
          //   controller.hasLink.value = false;
          //   controller.url.value = '';
          // }
          if (!controller.hasLink.value) {
            controller.url.value = val;
          }
          print("bal=$val");
        },
        onChanged: (val) {
          controller.postText.value = val;
          if (val == "") {
            if (controller.isEdit.value) {
              controller.isEdit.value = false;
            }
          }
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
        // textInputAction: TextInputAction.next,
        cursorColor: Colors.grey.shade500,
        controller: controller.postController,
        // keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        detectionRegExp: detectionRegExp()!,
        decoratedStyle: TextStyle(
            fontSize: 15, color: appBarColor, fontWeight: FontWeight.w500),
        basicStyle: TextStyle(fontSize: 15, color: Colors.grey.shade800),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          prefixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of(
            "Share a photo, video or idea",
          ),
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        ),
      ),
    );
  }

  Widget _customCircularButton(
      String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        margin: EdgeInsets.only(right: 10),
        decoration: new BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          shape: BoxShape.rectangle,
          border: new Border.all(
            color: Colors.grey.shade400,
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  icon,
                  color: Colors.grey.shade600,
                  size: 18,
                )),
            Container(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                value,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonRow() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: new BoxDecoration(
          color: HexColor("#f5f7f6"),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400, width: 0.5),
          ),
        ),
        child: !controller.hasLink.value
            ? Row(
                children: [
                  _customCircularButton(
                      AppLocalizations.of(
                        "Image",
                      ),
                      CustomIcons.photo_camera,
                      () => controller.pickImages()),
                  _customCircularButton(
                      AppLocalizations.of(
                        "Video",
                      ),
                      CustomIcons.video_player,
                      () => controller.pickVideo())
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _postButtonRow(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              if (controller.postController.text.isNotEmpty) {
                controller.uploadPost(controller.editIndex.value, 1, context);
              } else {
                Get.showSnackbar(properbuzSnackBar(
                    AppLocalizations.of("Please enter a description")));
              }
            },
            child: Obx(
              () => Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: new BoxDecoration(
                    color: hotPropertiesThemeColor,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    shape: BoxShape.rectangle,
                  ),
                  child: controller.isPosting.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                              child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 1.5,
                          )))
                      : Text(
                          AppLocalizations.of(
                            controller.isEdit.value
                                ? AppLocalizations.of("Update")
                                : AppLocalizations.of("Post"),
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 15),
                        )),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProperbuzFeedController());
    return Container(
      child: Column(
        children: [
          _customUploadTField(),
          _buttonRow(),
          _postButtonRow(context),
          ImagePostType(),
          VideoPostType(),
          LinkCard()
        ],
      ),
    );
  }
}
