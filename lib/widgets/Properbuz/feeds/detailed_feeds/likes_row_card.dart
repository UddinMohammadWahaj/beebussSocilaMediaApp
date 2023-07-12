import 'package:bizbultest/services/Properbuz/comments_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'detailed_likes_view.dart';

class LikesRowCard extends GetView<CommentsController> {
  const LikesRowCard({Key? key}) : super(key: key);

  Widget _header() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
        child: Text(
          "Likes",
          style: TextStyle(
              fontSize: 17,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.normal),
        ));
  }

  Widget _userCard(String image) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: CircleAvatar(
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(image),
        backgroundColor: appBarColor,
        foregroundColor: appBarColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CommentsController());
    return Obx(
      () => Container(
        child: controller.usersList.isEmpty
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailedLikesView())),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      color: Colors.transparent,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.usersList.length,
                          itemBuilder: (context, index) {
                            return _userCard(
                                controller.usersList[index].image!);
                          }),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
