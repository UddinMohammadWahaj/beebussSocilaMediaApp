import 'dart:io';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/utilities/Chat/delete_message_popup.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'forward_message_chat.dart';

class ViewSingleChatFile extends StatefulWidget {
  final List<ChatMessagesModel>? messages;
  final int? selectedIndex;
  final String? token;
  final String? memberID;

  const ViewSingleChatFile(
      {Key? key, this.messages, this.selectedIndex, this.token, this.memberID})
      : super(key: key);

  @override
  _ViewSingleChatFileState createState() => _ViewSingleChatFileState();
}

class _ViewSingleChatFileState extends State<ViewSingleChatFile> {
  List<ChatMessagesModel> _chatMessages = [];
  PageController? _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    print(widget.selectedIndex);

    _chatMessages = widget.messages!;
    selectedIndex = widget.selectedIndex!;
    _controller = PageController(initialPage: widget.selectedIndex!);

    super.initState();
  }

  void _deleteMessage() {
    showDialog(
      context: context,
      builder: (BuildContext deleteContext) {
        // return object of type Dialog

        return DeleteMessagePopup(
          title: AppLocalizations.of(
            "Delete message?",
          ),
          deleteForMe: () {
            String messageID = "";
            messageID = _chatMessages[selectedIndex].messageId!;
            setState(() {
              _chatMessages.removeAt(selectedIndex);
            });
            Navigator.pop(deleteContext);
            customToastWhite(
                AppLocalizations.of(
                  "Message deleted",
                ),
                15.0,
                ToastGravity.CENTER);
            ChatApiCalls().deleteMessages(messageID, "");
          },
          deleteForAll: () {
            String messageID = "";
            messageID = _chatMessages[selectedIndex].messageId!;
            setState(() {
              _chatMessages.removeAt(selectedIndex);
            });
            Navigator.pop(deleteContext);

            ChatApiCalls().deleteMessagesEveryone(messageID, "", widget.token!);
          },
          isyou: [],
        );
      },
    );
  }

  Future<void> _showPopupMenuPhoto(double height) async {
    int? selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0.w, height, 0, 400),
      items: [
        PopupMenuItem(
          value: 0,
          child: Text(
            AppLocalizations.of("All media"),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            AppLocalizations.of("Show in chat"),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            AppLocalizations.of("Share"),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text("Set as..."),
        ),
        PopupMenuItem(
          value: 4,
          child: Text(
            AppLocalizations.of("View in gallery"),
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: Text(
            AppLocalizations.of("Rotate"),
          ),
        ),
        PopupMenuItem(
          value: 6,
          child: Text(
            AppLocalizations.of("Delete"),
          ),
        )
      ],
      elevation: 8.0,
    );
    if (selected == 0) {
    } else if (selected == 1) {
    } else if (selected == 2) {
      List<String> files = [];
      if (_chatMessages[selectedIndex].you == 1) {
        files.add(_chatMessages[selectedIndex].path!);
      } else {
        files.add(_chatMessages[selectedIndex].receiverDevicePath!);
      }

      Share.shareFiles(files, text: _chatMessages[selectedIndex].message);
    } else if (selected == 3) {
    } else if (selected == 4) {
      if (_chatMessages[selectedIndex].you == 1) {
        OpenFile.open(_chatMessages[selectedIndex].path);
      } else {
        OpenFile.open(_chatMessages[selectedIndex].receiverDevicePath);
      }
    } else if (selected == 5) {
      setState(() {
        _chatMessages[selectedIndex].rotate =
            _chatMessages[selectedIndex].rotate! + 1;
        ;
      });
      print(_chatMessages[selectedIndex].rotate);
    } else {
      _deleteMessage();
    }
  }

  Future<void> _showPopupMenuVideo(double height) async {
    int? selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0.w, height, 0, 400),
      items: [
        PopupMenuItem(
          value: 0,
          child: Text(
            AppLocalizations.of("All media"),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            AppLocalizations.of("Show in chat"),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            AppLocalizations.of("Share"),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            AppLocalizations.of("Delete"),
          ),
        )
      ],
      elevation: 8.0,
    );
    if (selected == 0) {
    } else if (selected == 1) {
    } else if (selected == 2) {
      List<String> files = [];
      if (_chatMessages[selectedIndex].you == 1) {
        files.add(_chatMessages[selectedIndex].path!);
      } else {
        files.add(_chatMessages[selectedIndex].receiverDevicePath!);
      }

      Share.shareFiles(files, text: _chatMessages[selectedIndex].message);
    } else {
      _deleteMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            PageView.builder(
              onPageChanged: (val) {
                print(_chatMessages[selectedIndex].path);
                setState(() {
                  selectedIndex = val;
                });
              },
              controller: _controller,
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                var message = _chatMessages[index];
                return Container(
                    child: message.messageType == "video"
                        ? MultiVideoPlayer(
                            path: message.you! == 1
                                ? message.path!
                                : message.receiverDevicePath!,
                          )
                        : RotatedBox(
                            quarterTurns: message.rotate!,
                            child: Container(
                              child: Image.file(
                                File(message.you == 0
                                    ? message.receiverDevicePath!
                                    : message!.path!),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ));
              },
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              splashRadius: 30,
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.only(right: 20),
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 100.0.w - 195,
                                  child: Text(
                                    _chatMessages[selectedIndex == 0
                                                    ? 0
                                                    : selectedIndex - 1]
                                                .you ==
                                            0
                                        ? _chatMessages[selectedIndex]
                                            .memberFromName
                                        : "You",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 17),
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  _chatMessages[selectedIndex].time!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.only(right: 20),
                              icon: Icon(
                                _chatMessages[selectedIndex].isStar == 1
                                    ? CustomIcons.unstarred
                                    : Icons.star_border,
                                color: Colors.white,
                                size: _chatMessages[selectedIndex].isStar == 1
                                    ? 20
                                    : 24,
                              ),
                              onPressed: () {
                                if (_chatMessages[selectedIndex].isStar == 0) {
                                  setState(() {
                                    _chatMessages[selectedIndex].isStar = 1;
                                  });
                                  ChatApiCalls().starMessage(
                                      _chatMessages[selectedIndex].messageId!);
                                } else {
                                  setState(() {
                                    _chatMessages[selectedIndex].isStar = 0;
                                  });
                                  ChatApiCalls().unstarMessage(
                                      _chatMessages[selectedIndex].messageId!);
                                }
                              },
                            ),
                            IconButton(
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.only(right: 20),
                              icon: Icon(
                                CustomIcons.forward_new,
                                size: 18,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                List<String> id = [];
                                id.add(_chatMessages[selectedIndex].messageId!);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForwardMessageChatPage(
                                              messageIDs: id,
                                              from: "expanded",
                                            )));
                              },
                            ),
                            IconButton(
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (_chatMessages[selectedIndex].messageType ==
                                    "image") {
                                  _showPopupMenuPhoto(statusBarHeight);
                                } else {
                                  _showPopupMenuVideo(statusBarHeight);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiVideoPlayer extends StatefulWidget {
  final String path;

  MultiVideoPlayer({Key? key, this.path = ''}) : super(key: key);

  @override
  _MultiVideoPlayerState createState() => _MultiVideoPlayerState();
}

class _MultiVideoPlayerState extends State<MultiVideoPlayer> {
  FlickManager? flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.file(
        new File(widget.path),
      ),
    );
    flickManager!.flickVideoManager!.videoPlayerController!.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    flickManager!.dispose();
    print("media disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(flickManager!.flickVideoManager!.isPlaying);
        if (flickManager!.flickVideoManager!.isPlaying) {
          setState(() {
            flickManager!.flickControlManager!.pause();
          });
        } else {
          setState(() {
            flickManager!.flickControlManager!.play();
          });
        }
      },
      child: Container(
        child: VisibilityDetector(
          key: ObjectKey(flickManager),
          onVisibilityChanged: (visibility) async {
            if (visibility.visibleFraction == 0 && this.mounted) {
              flickManager!.flickControlManager!.pause();
            } else if (visibility.visibleFraction == 1) {
              flickManager!.flickControlManager!.play();
            }
          },
          child: FlickVideoPlayer(
            wakelockEnabledFullscreen: false,
            wakelockEnabled: false,
            flickManager: flickManager!,
            flickVideoWithControls: FlickVideoWithControls(
              videoFit: BoxFit.contain,
              controls: Stack(
                children: [
                  Positioned(
                    bottom: 20,
                    child: Container(
                      height: 100,
                      color: Colors.transparent,
                      child: FlickAutoHideChild(
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0.w, right: 2.0.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FlickCurrentPosition(
                                fontSize: 12.0.sp,
                              ),
                              SizedBox(
                                width: 7.5.w,
                              ),
                              Container(
                                width: 65.0.w,
                                child: FlickVideoProgressBar(
                                  flickProgressBarSettings:
                                      FlickProgressBarSettings(
                                    height: 4,
                                    handleRadius: 6,
                                    curveRadius: 0,
                                    backgroundColor: Colors.white24,
                                    bufferedColor: Colors.white38,
                                    playedColor: Colors.red,
                                    handleColor: Colors.red,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.0.w,
                              ),
                              FlickTotalDuration(
                                fontSize: 12.0.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
