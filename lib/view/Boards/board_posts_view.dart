import 'dart:async';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Bookmarks/boards_model.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Boards/board_posts_controller.dart';
import 'package:bizbultest/widgets/Bookmark/edit_board_view.dart';
import 'package:bizbultest/widgets/Bookmark/merge_boards_view.dart';
import 'package:bizbultest/widgets/Bookmark/save_to_board_sheet.dart';
import 'package:bizbultest/widgets/Bookmark/share_board_bottom_sheet.dart';
import 'package:bizbultest/widgets/Newsfeeds/single_feed_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../profile_page_main.dart';

class BoardPostsView extends StatefulWidget {
  final BoardModel? board;
  final String? memberID;

  const BoardPostsView({Key? key, this.board, this.memberID}) : super(key: key);

  @override
  _BoardPostsViewState createState() => _BoardPostsViewState();
}

class _BoardPostsViewState extends State<BoardPostsView> {
  BoardPostsController boardPostsController = Get.put(BoardPostsController());

  Widget _boardNameHeader() {
    return Obx(
      () => Container(
        padding: EdgeInsets.only(top: 25),
        child: Text(
          AppLocalizations.of(boardPostsController.boardName.value),
          style: Theme.of(context)
              .textTheme
              .overline!
              .merge(TextStyle(fontSize: 40)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _boardDescription() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          AppLocalizations.of(boardPostsController.boardDescription.value),
          style: Theme.of(context)
              .textTheme
              .overline!
              .merge(TextStyle(fontSize: 16)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _setViewListBuilder() {
    return Obx(
      () => ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: boardPostsController.views.length,
          itemBuilder: (context, index) {
            return _setViewTile(
                index, boardPostsController.selectedViewIndex.value);
          }),
    );
  }

  Widget _optionsCard(String text, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 25),
      dense: true,
      title: Text(
        AppLocalizations.of(text),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _setViewTile(int index, int currentIndex) {
    return ListTile(
      onTap: () {
        boardPostsController.setSelectedView(index);
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 25),
      dense: true,
      title: Text(
        AppLocalizations.of(boardPostsController.views[index]),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      trailing: currentIndex == index
          ? Icon(
              Icons.check,
              color: Colors.black,
              size: 30,
            )
          : null,
    );
  }

  Widget _postsCard() {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 15),
      dense: true,
      leading: Text(
        AppLocalizations.of(widget.board!.posts!),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      trailing: Wrap(
        children: [
          widget.memberID == CurrentUser().currentUser.memberID
              ? IconButton(
                  constraints: BoxConstraints(),
                  icon: Obx(
                    () => Icon(
                      boardPostsController.isEdit.value
                          ? CupertinoIcons.clear_circled
                          : Icons.edit,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    boardPostsController.toggleEdit();
                  },
                  splashRadius: 20,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                )
              : Container(
                  height: 0,
                  width: 0,
                ),
          IconButton(
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Get.bottomSheet(_setViewCard(),
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0))));
            },
            splashRadius: 20,
            padding: EdgeInsets.symmetric(horizontal: 15),
          ),
        ],
      ),
    );
  }

  Widget _setViewHeader(String title) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 25),
      dense: true,
      title: Text(
        AppLocalizations.of(title),
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
      ),
    );
  }

  Widget _closeButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: new BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          shape: BoxShape.rectangle,
        ),
        child: Text(
          AppLocalizations.of("Close"),
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }

  Widget _setViewCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _setViewHeader(
            AppLocalizations.of(
              "Set view as",
            ),
          ),
          _setViewListBuilder(),
          _closeButton(),
        ],
      ),
    );
  }

  Widget _moreCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _setViewHeader(
            AppLocalizations.of("Options"),
          ),
          _optionsCard(
              AppLocalizations.of(
                "Edit board",
              ), () {
            Get.back();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditBoardView(
                          board: widget.board,
                        )));
          }),
          _optionsCard(
              AppLocalizations.of(
                "Merge boards",
              ), () {
            Get.back();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MergeBoardsView(
                          board: widget.board,
                        )));
          }),
          _optionsCard(AppLocalizations.of("Share board"), () {
            Get.back();
            Get.bottomSheet(
              ShareBoardBottomSheet(
                boardID: widget.board!.boardId,
              ),
              backgroundColor: Colors.white,
              isScrollControlled: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ).whenComplete(() {
              FeedController controller = Get.put(FeedController());
              Timer(Duration(milliseconds: 500), () {
                controller.directUsersList.forEach((element) {
                  if (element.selected!.value) {
                    element.selected!.value = false;
                  }
                });
                controller.searchController.clear();
              });
            });
          }),
          // _optionsCard("Archive board", () { }),
          _closeButton(),
        ],
      ),
    );
  }

  @override
  void initState() {
    boardPostsController.getPosts(widget.board!.boardId!);
    super.initState();
  }

  @override
  void dispose() {
    boardPostsController.isEdit.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 15),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 25,
            ),
            splashRadius: 20,
          ),
          actions: [
            widget.memberID == CurrentUser().currentUser.memberID
                ? IconButton(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    onPressed: () {
                      Get.bottomSheet(_moreCard(),
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(30.0),
                                  topRight: const Radius.circular(30.0))));
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                      size: 25,
                    ),
                    splashRadius: 20,
                  )
                : Container()
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _boardNameHeader(),
              _boardDescription(),
              _postsCard(),
              BoardsGridBuilder(
                boardID: widget.board!.boardId,
              ),
            ],
          ),
        ));
  }
}

class BoardsGridBuilder extends GetView<BoardPostsController> {
  final String? boardID;

  const BoardsGridBuilder({Key? key, this.boardID}) : super(key: key);

  Widget _imageCard(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image(
        image: CachedNetworkImageProvider(
            controller.postsList[index].thumbnail!.replaceAll(".mp4", ".jpg")),
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        height: 100.0.h,
        width: 100.0.w,
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(4),
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.black,
          size: 18,
        ),
        splashRadius: 5,
        padding: EdgeInsets.all(0),
        constraints: BoxConstraints(),
      ),
    );
  }

  Widget _deletePostButton(int index, BuildContext context) {
    return Positioned.fill(
      child: Align(
          alignment: Alignment.topLeft,
          child: _iconButton(
              CupertinoIcons.delete,
              () => controller.removePost(index, context,
                  controller.postsList[index].postId!, boardID!))),
    );
  }

  Widget _starPostButton(int index) {
    return Positioned.fill(
      child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.all(4),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: () {
                controller.starPost(
                    index, controller.postsList[index].postId!, boardID!);
              },
              icon: Obx(
                () => Icon(
                  controller.postsList[index].starred!.value
                      ? Icons.star
                      : Icons.star,
                  color: controller.postsList[index].starred!.value
                      ? primaryBlueColor
                      : Colors.black,
                  size: 18,
                ),
              ),
              splashRadius: 5,
              padding: EdgeInsets.all(0),
              constraints: BoxConstraints(),
            ),
          )),
    );
  }

  Widget _movePostButton(int index) {
    return Positioned.fill(
      child: Align(
          alignment: Alignment.center,
          child: _iconButton(CupertinoIcons.arrow_right_arrow_left, () {
            Get.bottomSheet(
                SaveToBoardSheet(
                  postID: controller.postsList[index].postId,
                  image: controller.postsList[index].thumbnail!
                      .replaceAll(".mp4", ".jpg"),
                ),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0))));
          })),
    );
  }

  Widget _postCard(int index, BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (controller.isEdit.value) {
          } else {
            OtherUser().otherUser.memberID =
                controller.postsList[index].memberId;
            OtherUser().otherUser.shortcode =
                controller.postsList[index].shortcode;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleFeedPost(
                          memberID: controller.postsList[index].memberId,
                          postID: controller.postsList[index].postId,
                          setNavBar: (bool val) {},
                          refresh: () {},
                          changeColor: () {},
                          isChannelOpen: () {},
                        )));
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              _imageCard(index),
              controller.isEdit.value
                  ? _deletePostButton(index, context)
                  : Container(),
              controller.isEdit.value ? _starPostButton(index) : Container(),
              controller.isEdit.value ? _movePostButton(index) : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingPlaceHolder() {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        itemCount: 15,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 9 / 16),
        itemBuilder: (context, index) {
          return SkeletonAnimation(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                shape: BoxShape.rectangle,
                color: Colors.grey.shade200,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(BoardPostsController());
    return Obx(() {
      if (controller.postsList.isEmpty) {
        return _loadingPlaceHolder();
      } else {
        return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            itemCount: controller.postsList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: controller
                    .crossAxisCount[controller.selectedViewIndex.value],
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio:
                    controller.aspectRatio[controller.selectedViewIndex.value]),
            itemBuilder: (context, index) {
              return _postCard(index, context);
            });
      }
    });
  }
}
