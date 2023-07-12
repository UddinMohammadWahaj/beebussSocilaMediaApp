import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/expanded_story_model.dart';
import 'package:bizbultest/models/tags_search_model.dart';
import 'package:bizbultest/models/user_story_list_model.dart';
import 'package:bizbultest/models/user_tag_model.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/create_story_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:sizer/sizer.dart';
// import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FittedVideoPlayerStoryMute extends StatefulWidget {
  FittedVideoPlayerStoryMute(
      {Key? key, this.video, this.index, this.setDuration, this.volume = true})
      : super(key: key);

  final File? video;
  final int? index;
  final Function? setDuration;
  bool? volume;

  @override
  _FittedVideoPlayerStoryMuteState createState() =>
      _FittedVideoPlayerStoryMuteState();
}

class _FittedVideoPlayerStoryMuteState
    extends State<FittedVideoPlayerStoryMute> {
  late VideoPlayerController controller;
  bool video_on = false;
  @override
  void initState() {
    controller = VideoPlayerController.file(widget.video!,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    controller.initialize().then((_) {
      setState(() {});
      controller.pause();

      // controller.setVolume(0);

      controller.setLooping(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    print("dispppppp multiiiiiiiii");
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: controller.value != null && controller.value.isInitialized
                  ? VisibilityDetector(
                      key: ObjectKey(controller),
                      onVisibilityChanged: (visibility) {
                        if (visibility.visibleFraction > 0.9) {
                          controller.play();
                        } else {
                          controller.pause();
                        }
                      },
                      child: SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: controller.value.size?.width ?? 0,
                            height: controller.value.size?.height ?? 0,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 50.0.h,
                      width: 100.0.w,
                      color: Colors.black,
                    )),
          Positioned(
            child: InkWell(
              onTap: () {
                setState(() {
                  video_on = !video_on;
                  if (video_on)
                    controller.setVolume(0);
                  else
                    controller.setVolume(1);
                });
              },
              child: Icon(
                video_on ? Icons.volume_off_rounded : Icons.volume_up,
                color: Colors.white,
                size: 30,
              ),
            ),
            top: 12,
            left: 10,
          ),
        ],
      ),
    );
  }
}

class FittedVideoPlayerStory extends StatefulWidget {
  FittedVideoPlayerStory(
      {Key? key, this.video, this.index, this.setDuration, this.volume = true})
      : super(key: key);

  final File? video;
  final int? index;
  final Function? setDuration;
  bool? volume;

  @override
  _FittedVideoPlayerStoryState createState() => _FittedVideoPlayerStoryState();
}

class _FittedVideoPlayerStoryState extends State<FittedVideoPlayerStory> {
  late VideoPlayerController controller;

  bool video_on = false;
  @override
  void initState() {
    controller = VideoPlayerController.file(widget.video!,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    controller.initialize().then((_) {
      setState(() {});
      controller.pause();
      if (widget.volume!) {
        controller.setVolume(1);
      } else {
        controller.setVolume(0);
      }

      controller.setLooping(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    print("dispppppp multiiiiiiiii");
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: controller.value != null && controller.value.isInitialized
                  ? VisibilityDetector(
                      key: ObjectKey(controller),
                      onVisibilityChanged: (visibility) {
                        if (visibility.visibleFraction > 0.9) {
                          controller.play();
                        } else {
                          controller.pause();
                        }
                      },
                      child: SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: controller.value.size?.width ?? 0,
                            height: controller.value.size?.height ?? 0,
                            child: VideoPlayer(controller),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 50.0.h,
                      width: 100.0.w,
                      color: Colors.black,
                    )),
          Positioned(
            child: InkWell(
              onTap: () {
                setState(() {
                  video_on = !video_on;
                  if (video_on)
                    controller.setVolume(0);
                  else
                    controller.setVolume(1);
                });
              },
              child: Icon(
                video_on ? Icons.volume_off_rounded : Icons.volume_up,
                color: Colors.white,
                size: 30,
              ),
            ),
            top: 12,
            left: 10,
          ),
        ],
      ),
    );
  }
}

class UserRow extends StatelessWidget {
  final VoidCallback? onTap;
  final TagModel? user;

  const UserRow({Key? key, this.onTap, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h, right: 2.5.w, left: 2.5.w),
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.3),
        onTap: onTap ?? () {},
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 3.0.h,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(user!.image!),
                    ),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Container(
                      width: 7.0.h,
                      child: Text(
                        user!.shortcode!,
                        style: whiteNormal.copyWith(fontSize: 8.0.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllFilesRow extends StatelessWidget {
  final int? index;
  final int? currentIndex;
  final VoidCallback? navigate;
  final AssetCustom? assetsList;

  AllFilesRow(
      {Key? key, this.index, this.currentIndex, this.navigate, this.assetsList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.0.w),
      child: InkWell(
        onTap: navigate ?? () {},
        child: Container(
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
            border: new Border.all(
              color: currentIndex == index ? Colors.white : Colors.transparent,
              width: currentIndex == index ? 2 : 0,
            ),
          ),
          height: 8.0.h,
          width: 11.0.w,
          child: MiniThumbnails(
            asset: assetsList!,
          ),
        ),
      ),
    );
  }
}

class DeleteFiles extends StatelessWidget {
  final VoidCallback? delete;

  const DeleteFiles({Key? key, this.delete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      right: 4.0.w,
      bottom: 20.0.h,
      child: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: delete ?? () {},
          child: Container(
            child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.7),
                radius: 25,
                child: Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.white,
                  size: 30,
                )),
          ),
        ),
      ),
    );
  }
}

class StoryFontCard extends StatelessWidget {
  final int? selectedFontIndex;
  final int? index;
  final VoidCallback? onTap;
  final TextStyle? font;

  const StoryFontCard(
      {Key? key, this.selectedFontIndex, this.index, this.onTap, this.font})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap ?? () {},
        child: CircleAvatar(
          backgroundColor:
              selectedFontIndex == index ? Colors.white : Colors.black,
          child: Center(
              child: Text(
            "Aa",
            style: font!.copyWith(
                fontSize: 12.0.sp,
                color: selectedFontIndex == index ? Colors.pink : Colors.white),
          )),
        ),
      ),
    );
  }
}

class StoryColorCard extends StatelessWidget {
  final Color? color;
  final VoidCallback? onTap;

  const StoryColorCard({Key? key, this.color, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap ?? () {},
        child: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            backgroundColor: color,
          ),
        ),
      ),
    );
  }
}

class StackedUserCard extends StatelessWidget {
  final String? timestamp;
  final VoidCallback? openProfile;
  final UserStoryListModel? user;
  final VoidCallback? openMenu;
  FileElement? allFiles;

  StackedUserCard(
      {Key? key,
      this.timestamp,
      this.openProfile,
      this.user,
      this.openMenu,
      this.allFiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("got here ${this.allFiles} ");
    return Positioned(
        top: 20,
        left: 10.0,
        right: 10.0,
        child: ListTile(
          onTap: openProfile,
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            child: CircleAvatar(
              radius: 4.5.w,
              backgroundColor: Colors.transparent,
              backgroundImage: CachedNetworkImageProvider(user!.image!),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user!.shortcode! + "     " + timestamp!,
                style: TextStyle(
                    fontSize: 9.0.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              this.allFiles != null &&
                      this.allFiles!.musicData != '' &&
                      this.allFiles!.musicData != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 1.5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.music_note_rounded,
                              size: 10.0.sp, color: Colors.white),
                          SizedBox(
                            width: 0.3.w,
                          ),
                          Text(
                            "${allFiles!.musicData!.split('^^')[0]}" +
                                ", " +
                                '${allFiles!.musicData!.split('^^')[1]}',
                            style: TextStyle(
                                fontSize: 9.0.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ))
                  : Container(height: 0, width: 0),
            ],
          ),
          trailing: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: openMenu,
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
              size: 4.5.w,
            ),
          ),
        ));
  }
}

class SwipeToOpenLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        bottom: 10,
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.keyboard_arrow_up_outlined,
                  color: Colors.white,
                  size: 4.0.h,
                ),
                Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text(
                      AppLocalizations.of(
                        "Swipe Up",
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 10.0.sp),
                    ),
                  ),
                ),
              ],
            )));
  }
}

class OtherUserMessage extends StatefulWidget {
  final Function? sendMessage;
  final VoidCallback? onTap;
  final String? memberID;
  final String? token;
  final FileElement? file;
  final TextEditingController? controller;

  OtherUserMessage(
      {Key? key,
      this.sendMessage,
      this.onTap,
      this.memberID,
      this.token,
      this.file,
      this.controller})
      : super(key: key);

  @override
  _OtherUserMessageState createState() => _OtherUserMessageState();
}

class _OtherUserMessageState extends State<OtherUserMessage> {
  TextEditingController _messageController = TextEditingController();
  DirectRefresh refresh = DirectRefresh();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: new BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: new Border.all(
              color: Colors.white,
              width: 0.5,
            ),
            shape: BoxShape.rectangle,
          ),
          width: 80.0.w,
          height: 40,
          child: TextFormField(
            onTap: widget.onTap ?? () {},
            onChanged: (val) {},
            maxLines: null,
            controller: widget.controller,
            cursorHeight: 20,
            cursorColor: Colors.white,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.emoji_emotions_outlined,
                color: Colors.white,
                size: 25,
              ),
              isDense: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: AppLocalizations.of(
                "Send message",
              ),
              //alignLabelWithHint: true,
              contentPadding: EdgeInsets.only(left: 15, top: 10),
              hintStyle: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            String type = "";
            if (widget.file!.video == 1) {
              type = "video";
            } else {
              type = "image";
            }
            print(widget.memberID);
            print(widget.token);
            print(widget.controller!.text);
            DirectApiCalls().messageFromStory(widget.memberID!, type,
                widget.file!.image!, widget.controller!.text);

            customToastWhite(
                AppLocalizations.of(
                  "Message Sent",
                ),
                16.0,
                ToastGravity.CENTER);
            widget.controller!.clear();
            /*     if (widget.file.video == 1) {

              GallerySaver.saveVideo(widget.file.image, albumName: "bizbultest/Bebuzee Videos").then((value) {

                print("video saved");
                //Navigator.pop(context);
              });
              final fileName = await VideoThumbnail.thumbnailFile(
                video: widget.file.image,
                thumbnailPath: "/storage/emulated/0/bizbultest/.thumbnails/",
                imageFormat: ImageFormat.PNG, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
                quality: 80,
              );
              print(fileName);
            } else {
              GallerySaver.saveImage(widget.file.image, albumName: "bizbultest/Bebuzee Images").then((value) {
                print("image savedddd");
                //Navigator.pop(context);


              });
            }*/
          },
          icon: Icon(
            Icons.send,
            size: 25,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class StoryHashtagsCard extends StatelessWidget {
  final TagSearchModel? hashtag;
  final VoidCallback? onTap;

  const StoryHashtagsCard({Key? key, this.hashtag, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.0.w),
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.grey.withOpacity(0.8),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Text(
              hashtag!.name!.toUpperCase(),
              style: whiteNormal.copyWith(fontSize: 13.0.sp),
            ),
          ),
        ),
      ),
    );
  }
}
