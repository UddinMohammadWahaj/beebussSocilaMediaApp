import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Bookmarks/boards_list_model.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/Bookmarks/bookmark_api_calls.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/Boards/board_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'create_board_card.dart';

class SaveToBoardSheet extends GetView<FeedController> {
  final String? image;
  final String? postID;
  const SaveToBoardSheet({
    Key? key,
    this.image,
    this.postID,
  }) : super(key: key);

  BoxDecoration _dividerDecoration() {
    return new BoxDecoration(
        border: Border(
      top: BorderSide(color: Colors.black, width: 0.2),
    ));
  }

  BoxDecoration _boxDecoration(double radius) {
    return new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        shape: BoxShape.rectangle,
        color: Colors.grey.shade200);
  }

  Widget _closeButton(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      constraints: BoxConstraints(),
      icon: Icon(
        Icons.close,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      padding: EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _title(String title) {
    return Text(
      AppLocalizations.of(title),
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: _dividerDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _closeButton(context),
          _title(
            AppLocalizations.of("Save to board"),
          ),
          _title(""),
        ],
      ),
    );
  }

  Widget _imageBox() {
    return Stack(
      children: [
        Container(height: 50, width: 50, decoration: _boxDecoration(10)),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 1.5,
              height: 50,
              color: Colors.white,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 25,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _imageCard(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: 50,
        width: 50,
        child: Image(
          image: CachedNetworkImageProvider(image),
          fit: BoxFit.cover,
          height: 50,
          width: 50,
        ),
      ),
    );
  }

  Widget _boardCard(BoardsListModel board) {
    return ListTile(
      onTap: () {
        customToastWhite(
            AppLocalizations.of(
                  "Post saved to",
                ) +
                " ${board.name}",
            15,
            ToastGravity.BOTTOM);
        Get.back();
        BookMarkApiCalls.saveToBoard(postID!, board.boardId!);
      },
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      leading: _imageCard(board.images!),
      title: Text(
        AppLocalizations.of(board.name!),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _addIcon() {
    return Container(
        height: 40,
        width: 40,
        decoration: _boxDecoration(8),
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 30,
        ));
  }

  Widget _createButton(BuildContext context) {
    return Container(
      decoration: _dividerDecoration(),
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateBoardCard(
                        postID: postID,
                        image: image,
                      )));
        },
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        leading: _addIcon(),
        title: Text(
          AppLocalizations.of(
            "Create board",
          ),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FeedController());
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(context),
          Obx(
            () => Container(
              constraints: BoxConstraints(maxHeight: 50.0.h),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.boardsList.length,
                  itemBuilder: (context, index) {
                    return _boardCard(controller.boardsList[index]);
                  }),
            ),
          ),
          _createButton(context)
        ],
      ),
    );
  }
}
