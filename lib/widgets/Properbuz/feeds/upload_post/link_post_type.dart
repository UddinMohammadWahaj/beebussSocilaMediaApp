import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LinkCard extends GetView<ProperbuzFeedController> {
  const LinkCard({Key? key}) : super(key: key);

  Widget _customImageCard() {
    return Container(
        height: 250,
        width: 100.0.w,
        // child: Text(
        //     "-----${controller.urlMetadata.value.image.toString()}" ?? "222222"),
        child: CachedNetworkImage(
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(color: Colors.red),
          ),
          imageUrl: controller.urlMetadata.value.image!,
          fit: BoxFit.cover,
        )
        //  Image(
        //   image: CachedNetworkImageProvider(

        //     controller.urlMetadata.value.image,),
        //   fit: BoxFit.contain,
        // ),
        );
  }

  Widget _urlInfoCard() {
    return Container(
      color: Colors.grey.shade100,
      child: ListTile(
        contentPadding: EdgeInsets.only(top: 5, left: 10, right: 10),
        title: Text(
          AppLocalizations.of(
            controller.urlMetadata.value.title!,
          ),
          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          controller.urlMetadata.value.domain!,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _urlCard() {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [_customImageCard(), _urlInfoCard()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(ProperbuzFeedController());
    return Obx(
      () => Container(
          child: controller.hasLink.value
              ? Container(
                  child: _urlCard(),
                )
              : Container()),
    );
  }
}
