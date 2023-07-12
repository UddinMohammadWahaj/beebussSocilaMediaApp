import 'package:bizbultest/services/Properbuz/comments_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/profile_page_main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DetailedLikesView extends GetView<CommentsController> {
  const DetailedLikesView({Key? key}) : super(key: key);

  Widget _userCard(int index, BuildContext context) {
    String value = controller.usersList[index].shortcode!;
    return ListTile(
      onTap: () {
        OtherUser().otherUser.memberID = value.toString().replaceAll("@", "");
        OtherUser().otherUser.shortcode = value.toString().replaceAll("@", "");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePageMain(
                      from: "tags",
                      setNavBar: () {},
                      isChannelOpen: () {},
                      changeColor: () {},
                      otherMemberID: value.toString().replaceAll("@", ""),
                    )));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: CircleAvatar(
        radius: 22,
        backgroundImage:
            CachedNetworkImageProvider(controller.usersList[index].image!),
      ),
      title: Text(
        controller.usersList[index].name!,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        controller.usersList[index].designation!,
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CommentsController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "All Likes",
          style: TextStyle(
              fontSize: 15.0.sp,
              color: Colors.black,
              fontWeight: FontWeight.normal),
        ),
      ),
      body: ListView.builder(
          itemCount: controller.usersList.length,
          itemBuilder: (context, index) {
            return _userCard(index, context);
          }),
    );
  }
}
