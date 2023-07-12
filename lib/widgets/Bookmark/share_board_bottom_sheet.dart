import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';

class ShareBoardBottomSheet extends GetView<FeedController> {
  final String? boardID;

  const ShareBoardBottomSheet({
    Key? key,
    this.boardID,
  }) : super(key: key);

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

  Widget _searchBar() {
    return Container(
      height: 45,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: new BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.all(Radius.circular(20)),
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
          border: InputBorder.none,
          prefixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of(
            "Search by name...",
          ),
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 18),
        ),
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

  Widget _unselectedCard(int index) {
    return GestureDetector(
      onTap: () {
        controller.sendBoardDirect(index, boardID!);
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: primaryBlueColor,
            shape: BoxShape.rectangle,
          ),
          child: Text(
            AppLocalizations.of(
              "Send",
            ),
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )),
    );
  }

  Widget _selectedCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(
        AppLocalizations.of(
          "Sent",
        ),
        style: TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
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
    controller.directUsersList.forEach((element) {
      if (element.selected!.value) {
        element.selected!.value = false;
      }
    });
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FeedController());
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _divider(),
          _searchBar(),
          Obx(
            () => Container(
              height: 55.0.h,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.directUsersList.length,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        dense: true,
                        leading: _imageCard(index),
                        title: _nameCard(index),
                        subtitle: _shortcodeCard(index),
                        trailing:
                            !controller.directUsersList[index].selected!.value
                                ? _unselectedCard(index)
                                : _selectedCard(),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
