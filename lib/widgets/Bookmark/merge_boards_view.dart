import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Bookmarks/boards_list_model.dart';
import 'package:bizbultest/models/Bookmarks/boards_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MergeBoardsView extends GetView<FeedController> {
  final BoardModel? board;

  const MergeBoardsView({
    Key? key,
    this.board,
  }) : super(key: key);

  Widget _appBarTitle() {
    return ListTile(
      dense: true,
      title: Text(
        AppLocalizations.of(
          "Merge board",
        ),
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        AppLocalizations.of(
          "Pick a board to move these Posts to",
        ),
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      constraints: BoxConstraints(),
      icon: Icon(
        Icons.close,
        color: Colors.black54,
        size: 35,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      padding: EdgeInsets.symmetric(horizontal: 10),
    );
  }

  Widget _imageCard(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image(
        image: CachedNetworkImageProvider(image),
        fit: BoxFit.cover,
        height: 60,
        width: 60,
      ),
    );
  }

  Widget _boardCard(
    BoardsListModel board,
    BuildContext context,
  ) {
    return ListTile(
      onTap: () {
        Get.bottomSheet(_mergeBottomSheet(context, board),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    topRight: const Radius.circular(30.0))));
      },
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      leading: _imageCard(board.images!),
      title: Text(
        board.name!,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        board.posts!,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _actionButton(
      String name, Color textColor, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        decoration: new BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          shape: BoxShape.rectangle,
        ),
        child: Text(
          name,
          style: TextStyle(
              fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _mergeBottomSheet(
      BuildContext context, BoardsListModel selectedBoard) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(
              "Merge to...",
            ),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppLocalizations.of(
                      "When you merge, all posts on",
                    ) +
                    " ${board!.name} " +
                    AppLocalizations.of("will be deleted and moved to ") +
                    "${selectedBoard.name}.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton(
                  AppLocalizations.of(
                    "Cancel",
                  ),
                  Colors.black,
                  Colors.grey.shade200, () {
                Get.back();
              }),
              _actionButton(
                  AppLocalizations.of(
                    "Merge",
                  ),
                  Colors.white,
                  primaryBlueColor, () {
                Get.back();
                controller.mergeBoards(
                    selectedBoard.boardId!, board!.boardId!, context);
              }),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FeedController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 45,
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        leading: _closeButton(context),
        title: _appBarTitle(),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.boardsMergedList(board!.boardId!).length,
          itemBuilder: (context, index) {
            return _boardCard(
                controller.boardsMergedList(board!.boardId!)[index], context);
          }),
    );
  }
}
