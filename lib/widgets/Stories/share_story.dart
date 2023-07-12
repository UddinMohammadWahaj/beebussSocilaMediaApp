import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/view/Chat/controllers/chat_home_controller.dart';
import 'package:path/path.dart' as p;
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/create_story_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:sizer/sizer.dart';
import 'package:image/image.dart' as img;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ShareStory extends GetView<FeedController> {
  final String? postID;
  final String? image;
  final String? shortcode;
  final VoidCallback? onTap;
  final VoidCallback? sendToDirect;
  final AssetEntity? asset;
  final File? cameraFile;
  Function? stopMusicPlayer;

  ShareStory(
      {Key? key,
      this.postID,
      this.image,
      this.shortcode,
      this.onTap,
      this.sendToDirect,
      this.asset,
      this.cameraFile,
      this.stopMusicPlayer})
      : super(key: key);

  Widget _divider() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          shape: BoxShape.rectangle,
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        width: 50,
        height: 5,
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
      onTap: () async {
        try {
          this.stopMusicPlayer!();
        } catch (e) {}
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
          "Your Story",
        ),
        style: TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
      ),
      trailing: GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: primaryBlueColor,
              shape: BoxShape.rectangle,
            ),
            child: Text(
              AppLocalizations.of(
                "Share",
              ),
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
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

  Widget _unselectedCard(
    int index,
  ) {
    return GestureDetector(
      onTap: () async {
        ChatHomeController chatHomeController = Get.put(ChatHomeController());
        if (asset != null) {
          File? file = await asset!.file;
          String finalPath = "";
          String type = "";
          if (asset!.type.toString() == "AssetType.video") {
            var thumb = await asset!.thumbnailData;
            img.Image? data = img.decodeImage(thumb!);
            File(
                "${chatHomeController.thumbsPath.value}/${p.basename(file!.path)?.replaceAll(".mp4", ".jpg")}")
              ..writeAsBytesSync(img.encodeJpg(data!, quality: 100));
            type = "video";
            finalPath =
                "${chatHomeController.videoPath.value}/${p.basename(file.path)}";
            String thumbPath =
                "${chatHomeController.thumbsPath.value}/${p.basename(file.path)?.replaceAll(".mp4", ".jpg")}";
            await file.copy(
                "${chatHomeController.videoPath.value}/${p.basename(file.path)}");
            controller.sendStoryDirect(
                index,
                file.path,
                controller.directUsersList[index].fromuserid!,
                finalPath,
                thumbPath,
                type);
          } else {
            type = "image";
            finalPath =
                "${chatHomeController.imagePath.value}/${p.basename(file!.path)}";
            print(file!.path);
            await file.copy(
                "${chatHomeController.imagePath.value}/${p.basename(file.path)}");
            controller.sendStoryDirect(
                index,
                file!.path,
                controller.directUsersList[index].fromuserid!,
                finalPath,
                "aa",
                type);
          }
        } else {
          File file = cameraFile!;
          String finalPath = "";
          String type = "";
          type = "image";
          finalPath =
              "${chatHomeController.imagePath.value}/${p.basename(file.path)}";
          print(file.path);
          await file.copy(
              "${chatHomeController.imagePath.value}/${p.basename(file.path)}");
          controller.sendStoryDirect(
              index,
              file.path,
              controller.directUsersList[index].fromuserid!,
              finalPath,
              "aa",
              type);
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: new Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        child: Text(
          AppLocalizations.of(
            "Sent",
          ),
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ));
  }

  Widget _titleCard(String title) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FeedController(), fenix: true);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _divider(),
          _searchBar(),
          _titleCard(
            AppLocalizations.of(
              "Stories",
            ),
          ),
          _shareToStoryCard(),
          _titleCard(
            AppLocalizations.of(
              "Messages",
            ),
          ),
          Obx(
            () => Container(
              height: 45.0.h,
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
