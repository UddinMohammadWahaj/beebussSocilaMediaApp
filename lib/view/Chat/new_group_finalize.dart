import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/group_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/utilities/Chat/chat_galley_thumbnails.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multipart_request/multipart_request.dart' as mp;
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';

class NewGroupFinalize extends StatefulWidget {
  final List<DirectMessageUserListModel>? users;
  final List<String>? memberIDs;
  final bool? fromContacts;

  const NewGroupFinalize(
      {Key? key, this.users, this.memberIDs, this.fromContacts})
      : super(key: key);

  @override
  _NewGroupFinalizeState createState() => _NewGroupFinalizeState();
}

class _NewGroupFinalizeState extends State<NewGroupFinalize> {
  TextEditingController _subjectController = TextEditingController();
  late File icon;

  List<GalleryThumbnails> assets = [];
  ChatsRefresh refresh = ChatsRefresh();

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(
        onlyAll: true, type: RequestType.image);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );
    List<GalleryThumbnails> data = [];
    recentAssets.forEach((element) {
      if (element.type.toString() == "AssetType.video" ||
          element.type.toString() == "AssetType.image") {
        data.add(GalleryThumbnails(element, false));
      }
    });

    // Update the state and notify UI
    if (mounted) {
      setState(() => assets = data);
    }
  }

  Widget _textField() {
    return TextField(
      style: TextStyle(color: Colors.black54, fontSize: 16),
      cursorColor: Colors.black54,
      controller: _subjectController,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Type group subject here...',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: darkColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: darkColor),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: darkColor),
          ),
          hintStyle: TextStyle(color: Colors.black54, fontSize: 16)),
    );
  }

  _buildGalleryAppbar(StateSetter state) {
    return AppBar(
      title: Text(
        AppLocalizations.of(
              "Tap photo to select",
            ) +
            " ",
        style: whiteBold.copyWith(fontSize: 20),
      ),
      flexibleSpace: gradientContainer(null),
      elevation: 0,
      automaticallyImplyLeading: true,
    );
  }

  Widget _buildGallery() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
      return Scaffold(
        appBar: _buildGalleryAppbar(state),
        body: GridView.builder(
            controller: ModalScrollController.of(context),
            addAutomaticKeepAlives: false,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2),
            itemCount: assets.length,
            itemBuilder: (context, index) {
              return ChatGalleryThumbnailsHorizontal(
                onTap: () async {
                  File? file = await assets[index].asset!.file;
                  setState(() {
                    icon = file!;
                  });
                  Navigator.pop(context);
                },
                grid: true,
                asset: assets[index],
              );
            }),
      );
    });
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                AppLocalizations.of("New group"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
                child: Text(
              AppLocalizations.of(
                'Add subject',
              ),
              style: TextStyle(
                fontSize: 12.0,
              ),
            ))
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            child: Wrap(
              alignment: WrapAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          child: Row(
                            children: [
                              icon == null
                                  ? FloatingActionButton(
                                      elevation: 0,
                                      focusElevation: 0,
                                      focusColor: Colors.grey.withOpacity(0.4),
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.4),
                                      foregroundColor:
                                          Colors.grey.withOpacity(0.4),
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        showMaterialModalBottomSheet(
                                            isDismissible: false,
                                            enableDrag: false,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            20.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            20.0))),
                                            //isScrollControlled:true,
                                            context: context,
                                            builder: (context) {
                                              return _buildGallery();
                                            });
                                      })
                                  : Container(
                                      height: 56,
                                      width: 56,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(icon))),
                                    ),
                              SizedBox(
                                width: 12,
                              ),
                              Container(
                                  width: 100.0.w - 110, child: _textField()),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          AppLocalizations.of(
                            "Provide a group subject and optional group icon",
                          ),
                          style: greyNormal.copyWith(fontSize: 13),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                              child: Text(
                            AppLocalizations.of(
                                  "Participants:",
                                ) +
                                " ${widget.users!.length.toString()}",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 15),
                            textAlign: TextAlign.start,
                          )),
                        ),
                        GridView.builder(
                            shrinkWrap: true,
                            addAutomaticKeepAlives: false,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 3),
                            itemCount: widget.users!.length,
                            itemBuilder: (context, index) {
                              var user = widget.users![index];
                              return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30.0,
                                      backgroundColor: darkColor,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              user.image!),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        width: 20.0.w,
                                        child: Text(
                                          user.name!,
                                          style: TextStyle(fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ))
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: 90,
            right: 15,
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                foregroundColor: darkColor,
                backgroundColor: darkColor,
                focusColor: darkColor,
                onPressed: () {
                  if (_subjectController.text.isEmpty) {
                    customToastWhite(
                        AppLocalizations.of(
                            "Provide a subject and an optional group icon"),
                        14.0,
                        ToastGravity.BOTTOM);
                  } else if (icon == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          darkColor)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    AppLocalizations.of(
                                      "Creating group",
                                    ),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    GroupApiCalls()
                        .createGroupWithoutIcon(widget.memberIDs!.join(","),
                            _subjectController.text.replaceAll("&", "~~~"))
                        .then((value) {
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      if (widget.fromContacts!) {
                        Navigator.pop(context);
                      }
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ProcessingDialog(
                          title: AppLocalizations.of(
                            "Creating group",
                          ),
                          heading: "",
                        );
                      },
                    );

                    GroupApiCalls.createGroupWithIcon(
                            widget.memberIDs!.join(","),
                            _subjectController.text.replaceAll("&", "~~~"),
                            icon.path)
                        .then((request) {
                      mp.Response response = request.send();
                      response.onError = () {
                        print("Error");
                      };
                      response.onComplete = (response) {
                        String groupID = "";
                        groupID = jsonDecode(response)['data']['group_id'];
                        print("group without icon");
                        print(groupID);
                        GroupApiCalls().subscribeToTopicGroup(groupID);

                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        if (widget.fromContacts!) {
                          Navigator.pop(context);
                        }
                      };
                      response.progress.listen((int progress) {
                        print("progress from response object " +
                            progress.toString());
                      });
                    });
                  }
                },
                child: Icon(
                  Icons.check,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
