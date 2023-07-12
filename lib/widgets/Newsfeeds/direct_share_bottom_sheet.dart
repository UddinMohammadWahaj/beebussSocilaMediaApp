import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';

class DirectShareBottomSheet extends GetView<FeedController> {
  final String? postID;
  final String? image;
  final String? shortcode;
  final bool? showToStory;

  const DirectShareBottomSheet(
      {Key? key, this.postID, this.image, this.shortcode, this.showToStory})
      : super(key: key);

  Widget _divider() {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      width: 50,
      height: 5,
    );
  }

  Widget _postCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image(
            image: CachedNetworkImageProvider(image!),
            fit: BoxFit.cover,
            height: 50,
            width: 50,
          ),
        ),
        title: _messageField(),
      ),
    );
  }

  Widget _messageField() {
    return TextFormField(
      maxLines: 1,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: Colors.grey.shade400,
      cursorHeight: 20,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      controller: controller.messageController,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(
          "Write a message...",
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: new BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        shape: BoxShape.rectangle,
      ),
      child: TextFormField(
        maxLines: 1,
        cursorColor: Colors.grey.shade500,
        controller: controller.searchController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          prefixIcon: Container(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.search,
              color: Colors.grey.shade500,
            ),
          ),
          suffixIcon: Icon(
            Icons.supervisor_account_sharp,
            color: Colors.grey.shade500,
          ),
          border: InputBorder.none,
          suffixIconConstraints: BoxConstraints(),
          prefixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of('Search'),
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 18),
        ),
      ),
    );
  }

  Widget _shareToStoryCard() {
    return ListTile(
      onTap: () {
        controller.postToStory(postID!);
      },
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.transparent,
        backgroundImage:
            CachedNetworkImageProvider(CurrentUser().currentUser.image!),
      ),
      title: Text(
        AppLocalizations.of(
          "Add post to your story",
        ),
        style: TextStyle(fontSize: 14, color: primaryBlueColor),
      ),
    );
  }

  Widget _imageCard(int index) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.transparent,
      backgroundImage:
          CachedNetworkImageProvider(controller.directUsersList[index].image!),
    );
  }

  Widget _nameCard(int index) {
    return Text(
      controller.directUsersList[index].name!,
      style: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _shortcodeCard(int index) {
    return Text(
      controller.directUsersList[index].shortcode!,
      style: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 14, color: Colors.grey),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _unselectedCard() {
    return Container(
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        border: new Border.all(
          color: Colors.grey.shade500,
          width: 1.5,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 12,
      ),
    );
  }

  Widget _selectedCard() {
    return Icon(
      Icons.check_circle,
      color: Colors.green,
      size: 30,
    );
  }

  Widget _sendButton() {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          _sendPost();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          width: 100.0.w,
          decoration: new BoxDecoration(
            color: primaryBlueColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
          ),
          child: Center(
              child: Text(
            AppLocalizations.of(
              "Send",
            ),
            style: whiteBold.copyWith(fontSize: 14),
          )),
        ),
      ),
    );
  }

  void _sendPost() {
    List<String> members = [];
    controller.directUsersList.forEach((element) {
      if (element.selected!.value) {
        members.add(element.fromuserid!);
      }
    });
    DirectApiCalls.sendFeedPost(
        postID!, members.join(","), controller.messageController.text);
    controller.directUsersList.forEach((element) {
      if (element.selected!.value) {
        element.selected!.value = false;
      }
    });

    Get.back();
    Get.snackbar('Success', 'Shared Successfully');
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FeedController());
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _divider(),
          _postCard(),
          _searchBar(),
          _shareToStoryCard(),
          Obx(
            () => Container(
              height: 40.0.h,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.directUsersList.length,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        dense: true,
                        onTap: () {
                          controller.directUsersList[index].selected!.value =
                              !controller
                                  .directUsersList[index].selected!.value;
                        },
                        leading: _imageCard(index),
                        title: _nameCard(index),
                        subtitle: _shortcodeCard(index),
                        trailing:
                            !controller.directUsersList[index].selected!.value
                                ? _unselectedCard()
                                : _selectedCard(),
                      ),
                    );
                  }),
            ),
          ),
          _sendButton()
        ],
      ),
    );
  }
}
