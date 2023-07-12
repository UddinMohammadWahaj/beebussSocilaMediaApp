import 'dart:async';
import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/chat_messages_model.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/chat_profile_api.dart';
import 'package:bizbultest/services/Chat/group_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/chat_galley_thumbnails.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/Chat/user_profile_screen.dart';
import 'package:bizbultest/view/Chat/view_contact_single_expanded.dart';
import 'package:bizbultest/view/Chat/view_singe_group_file.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sizer/sizer.dart';

import '../../api/ApiRepo.dart' as ApiRepo;
import 'add_or_edit_group description.dart';
import 'all_media_page_chat.dart';
import 'detailed_chat_screen.dart';
import 'direct_chat_screen.dart';
import 'edit_group_name.dart';
import 'group_settings_screen.dart';
import 'new_group_select_users_page.dart';

class ViewGroupInfoExpanded extends StatefulWidget {
  final String? name;
  final String? image;
  final String? groupID;
  final String? groupMembers;
  final String? topic;
  final int? groupStatus;
  final List<ChatMessagesModel>? messages;
  final String? groupDescription;

  const ViewGroupInfoExpanded(
      {Key? key,
      this.name,
      this.image,
      this.groupID,
      this.groupMembers,
      this.topic,
      this.groupStatus,
      this.messages,
      this.groupDescription})
      : super(key: key);

  @override
  _ViewGroupInfoExpandedState createState() => _ViewGroupInfoExpandedState();
}

class _ViewGroupInfoExpandedState extends State<ViewGroupInfoExpanded> {
  ScrollController _controller = ScrollController();
  bool isSearchOpen = false;
  late Future _future;
  UpdateOnlineStatus _status = UpdateOnlineStatus();
  DirectUsers _groupUsers = new DirectUsers([]);
  DirectUsers _mainGroupUsers = new DirectUsers([]);
  bool isCurrentMemberAdmin = false;
  TextEditingController _searchBarController = TextEditingController();
  GroupMembersRefresh _refresh = GroupMembersRefresh();

  void _getUsersLocal() {
    _future = ChatApiCalls.getSelectedGroupUserListLocal(widget.groupID!)
        .then((value) {
      if (mounted) {
        setState(() {
          _groupUsers.users = value.users;
          _mainGroupUsers.users = value.users;
        });
        _groupUsers.users.forEach((element) {
          if (element.fromuserid == CurrentUser().currentUser.memberID &&
              element.admin == 1) {
            setState(() {
              isCurrentMemberAdmin = true;
            });
            print("yes admin");
          }
        });
      }
      _getUsers();
      return value;
    });
  }

  void _getUsers() {
    _future =
        ChatApiCalls.getSelectedGroupUserList(widget.groupID!).then((value) {
      if (mounted) {
        setState(() {
          _groupUsers.users = value!.users;
          _mainGroupUsers.users = value.users;
        });
        _groupUsers.users.forEach((element) {
          if (element.fromuserid == CurrentUser().currentUser.memberID &&
              element.admin == 1) {
            setState(() {
              isCurrentMemberAdmin = true;
            });
            print("yes admin");
          }
        });
      }
      return value;
    });
  }

  void _searchUsers(String name) async {
    setState(() {
      _groupUsers.users = _mainGroupUsers.users
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(name.toLowerCase()))
          .toList();
    });
  }

  Future<void> _showPopupMenu(
      DirectMessageUserListModel user, int index) async {
    int selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(350, 40.0.h, 25, 400),
      items: <PopupMenuEntry<dynamic?>>[
        PopupMenuItem(
          value: 0,
          child: Text(AppLocalizations.of(
                "Message",
              ) +
              " ${user.name}"),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(AppLocalizations.of(
                "View",
              ) +
              " ${user.name}"),
        ),
        isCurrentMemberAdmin && groupStatus! == 0
            ? PopupMenuItem(
                value: 2,
                child: Text(user.admin == 0
                    ? AppLocalizations.of(
                        "Make group admin",
                      )
                    : AppLocalizations.of(
                        "Dismiss as admin",
                      )),
              )
            : PopupMenuItem(child: Container()),
        isCurrentMemberAdmin && groupStatus == 0
            ? PopupMenuItem(
                value: 3,
                child: Text(AppLocalizations.of(
                      "Remove",
                    ) +
                    " ${user.name}"),
              )
            : PopupMenuItem(child: Container()),
      ],
      elevation: 8.0,
    );
    if (selected == 0) {
      print(user.name);
      setState(() {
        CurrentUser().currentUser.currentOpenMemberID = user.fromuserid;
      });
      _status.updateRefresh(user.onlineStatus);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedChatScreen(
                    token: user.token!,
                    name: user.name!,
                    image: user.image!,
                    memberID: user.fromuserid!,
                  )));
    } else if (selected == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewContactSingle(
                    memberID: user.fromuserid!,
                    name: user.name!,
                    image: user.image!,
                  )));
    } else if (selected == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print(user.fromuserid);
        print(widget.groupID);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            if (user.admin == 0) {
              GroupApiCalls()
                  .makeGroupAdmin(
                      user.fromuserid!, widget.groupID!, widget.topic!)
                  .then((value) {
                _getUsers();
                Timer(Duration(milliseconds: 100),
                    () => Navigator.of(context, rootNavigator: true).pop());
              });
              return ProcessingDialog(
                  title: AppLocalizations.of(
                    "Please wait a moment",
                  ),
                  heading: AppLocalizations.of(
                    "Adding...",
                  ));
            } else {
              GroupApiCalls()
                  .removeGroupAdmin(
                      user.fromuserid!, widget.groupID!, widget.topic!)
                  .then((value) {
                _getUsers();
                Timer(Duration(milliseconds: 100),
                    () => Navigator.of(context, rootNavigator: true).pop());
              });
              return ProcessingDialog(
                title: AppLocalizations.of(
                  "Please wait a moment",
                ),
                heading: AppLocalizations.of(
                  "Removing...",
                ),
              );
            }
          },
        );
      });
    } else if (selected == 3) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BasicCancelOkPopup(
              title: 'Remove ${user.name} frsom "$sub" group?',
              onTapOk: () {
                Navigator.of(context, rootNavigator: true).pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      GroupApiCalls()
                          .removeMembersFromGroup(
                              user.fromuserid!, widget.groupID!, widget.topic!)
                          .then((value) {
                        _getUsers();
                        Timer(
                            Duration(milliseconds: 100),
                            () => Navigator.of(context, rootNavigator: true)
                                .pop());
                      });
                      return ProcessingDialog(
                        title: AppLocalizations.of(
                          "Please wait a moment",
                        ),
                        heading: AppLocalizations.of(
                          "Removing...",
                        ),
                      );
                    });
              },
            );
          });
    }
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

  List<GalleryThumbnails> assets = [];

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
      data.add(GalleryThumbnails(element, false));
    });

    // Update the state and notify UI
    if (mounted) {
      setState(() => assets = data);
    }
  }

  void _changeImage(String path) async {
    FormData formData = new FormData.fromMap({
      "image": await MultipartFile.fromFile(path),
      "action": "update_profile_picture",
      "user_id": widget.groupID,
    });

    var res = await ApiRepo.postWithTokenAndFormData(
      "api/member_profile_update.php",
      formData,
      (int sent, int total) {
        final progress = (sent / total) * 100;
        print('group picture progress: $progress');
      },
    );
    String img = "";
    img = res.data['data']['image'];
    setState(() {
      image = img;
    });
    chatRefresh.updateRefresh(true);
  }

  Widget _removeProfilePopup(BuildContext c) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(
                  "Remove profile photo?",
                ),
                style: TextStyle(color: Colors.black87, fontSize: 17),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(c, rootNavigator: true).pop();
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Text(
                            AppLocalizations.of(
                              "CANCEL",
                            ),
                            style: TextStyle(
                                fontSize: 15,
                                color: darkColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(c, rootNavigator: true).pop();

                        ChatProfileApiCalls.deletePhoto().then((value) {
                          setState(() {
                            image =
                                "https://www.bebuzee.com/users/main/no_image_image_news.jpg";
                          });
                          chatRefresh.updateRefresh(true);
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Text(
                            AppLocalizations.of(
                              "REMOVE",
                            ),
                            style: TextStyle(
                                fontSize: 15,
                                color: darkColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGallery(Function setPhoto) {
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

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatProfilePhotoCropScreen(
                                setPhoto: setPhoto,
                                path: file!.path,
                              )));
                },
                grid: true,
                asset: assets[index],
              );
            }),
      );
    });
  }

  ChatsRefresh chatRefresh = ChatsRefresh();

  Widget searchBar() {
    return TextField(
      style: TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: Colors.white,
      onChanged: (val) {
        if (val != "") {
          _searchUsers(val);
        } else {
          setState(() {
            _groupUsers.users = _mainGroupUsers.users;
          });
        }
      },
      controller: _searchBarController,
      autofocus: true,
      decoration: InputDecoration(
          hintText: AppLocalizations.of(
            "Search",
          ),
          border: InputBorder.none,
          hintStyle: whiteNormal.copyWith(fontSize: 16)),
    );
  }

  int groupStatus = 0;

  Widget _iconButton(
      IconData icon, EdgeInsetsGeometry padding, VoidCallback onTap) {
    return IconButton(
        constraints: BoxConstraints(),
        padding: padding,
        onPressed: onTap,
        icon: Icon(
          icon,
          color: Colors.white,
        ));
  }

  String? sub;
  String? description;
  String? image;

  void _addUsers() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewGroupSelectUsers(
                  add: 1,
                  groupID: widget.groupID!,
                  addMember: (String memberIDs) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          GroupApiCalls()
                              .addMembersToGroup(
                                  memberIDs, widget.groupID!, widget.topic!)
                              .then((value) {
                            Timer(
                                Duration(milliseconds: 100),
                                () => Navigator.of(context, rootNavigator: true)
                                    .pop());
                            _getUsers();
                          });
                          return ProcessingDialog(
                            title: AppLocalizations.of(
                              "Please wait a moment",
                            ),
                            heading: AppLocalizations.of(
                              "Adding...",
                            ),
                          );
                        },
                      );
                    });
                  },
                )));
  }

  @override
  void initState() {
    _fetchAssets();

    sub = widget.name;
    image = widget.image;
    description = widget.groupDescription;
    groupStatus = widget.groupStatus!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(MediaQuery.of(context).size.height * 0.20);
      }
    });
    _getUsersLocal();

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _appBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sub!,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        _iconButton(Icons.edit, EdgeInsets.all(0), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditGroupName(
                        subject: sub!,
                        changeSubject: (subject) {
                          setState(() {
                            sub = subject;
                          });
                          GroupApiCalls()
                              .changeGroupSubject(sub!, widget.groupID!);
                        },
                      )));
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isSearchOpen) {
      double top = 0.0;
      return Scaffold(
        backgroundColor: darkColor,
        body: SafeArea(
          child: Container(
            color: Colors.grey.shade300,
            child: CustomScrollView(
              controller: _controller,
              slivers: [
                SliverAppBar(
                  title: top == 56
                      ? null
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              _iconButton(Icons.arrow_back,
                                  EdgeInsets.only(right: 20), () {}),
                              _iconButton(
                                  Icons.person_add, EdgeInsets.only(left: 20),
                                  () {
                                _addUsers();
                              }),
                            ]),
                  brightness: Brightness.dark,
                  automaticallyImplyLeading: false,
                  forceElevated: false,
                  elevation: 3,
                  backgroundColor: darkColor,
                  floating: false,
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.40,
                  flexibleSpace: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;

                    print(top.toString());
                    return FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: EdgeInsets.symmetric(
                          horizontal: top == 56 ? 60 : 15,
                          vertical: top == 56 ? 0 : 10),
                      title: top == 56
                          ? Center(
                              child: _appBar(),
                            )
                          : _appBar(),
                      background: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(20.0),
                                      topRight: const Radius.circular(20.0))),
                              //isScrollControlled:true,
                              context: context,
                              builder: (BuildContext bc) {
                                return UpdateProfileBottomTile(
                                  image: image!,
                                  removePhoto: () {
                                    Navigator.pop(bc);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext removeContext) {
                                          return _removeProfilePopup(
                                              removeContext);
                                        });
                                  },
                                  openGallery: () {
                                    Navigator.pop(bc);
                                    showMaterialModalBottomSheet(
                                        isDismissible: false,
                                        enableDrag: false,
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20.0),
                                                topRight: const Radius.circular(
                                                    20.0))),
                                        //isScrollControlled:true,
                                        context: context,
                                        builder: (context) {
                                          return _buildGallery((String path) {
                                            _changeImage(path);
                                          });
                                        });
                                  },
                                  camera: () async {
                                    Navigator.pop(bc);

                                    var picture = await ImagePicker()
                                        .pickImage(
                                      source: ImageSource.camera,
                                    )
                                        .then((value) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatProfilePhotoCropScreen(
                                                    from: "group",
                                                    setPhoto: (String path,
                                                        imgCropKey) {
                                                      _changeImage(path);
                                                    },
                                                    path: value!.path,
                                                  )));
                                    });
                                  },
                                );
                              });
                        },
                        child: Container(
                          color: darkColor,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.20,
                          child: Image.network(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  groupStatus == 0
                      ? Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              description != ""
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Text(
                                        AppLocalizations.of(
                                          "Description",
                                        ),
                                        style: TextStyle(
                                            color: darkColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  : Container(),
                              CustomListTile(
                                  title: description == ""
                                      ? AppLocalizations.of(
                                          "Add group description")
                                      : description!,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddOrEditGroupDescription(
                                                  description: description!,
                                                  changeDescription: (desc) {
                                                    setState(() {
                                                      description = desc;
                                                    });
                                                    GroupApiCalls()
                                                        .addOrEditGroupDescription(
                                                            desc,
                                                            widget.groupID!);
                                                  },
                                                )));
                                  }),
                            ],
                          ))
                      : Container(),
                  groupStatus == 0
                      ? Container(
                          color: Colors.grey.shade300,
                          height: 15,
                        )
                      : Container(),
                  groupStatus == 1
                      ? Container(
                          color: Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              AppLocalizations.of(
                                "You're no longer a participant in this group",
                              ),
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Container(),
                  groupStatus == 0 && widget.messages!.length != 0
                      ? MediaAndLinks(
                          topic: widget.topic,
                          groupID: widget.groupID,
                          messages: widget.messages,
                          name: sub!,
                        )
                      : Container(),
                  groupStatus == 0 && widget.messages!.length != 0
                      ? Container(
                          color: Colors.grey.shade300,
                          height: 15,
                        )
                      : Container(),
                  groupStatus == 0
                      ? NotificationsAndMedia(
                          users: _mainGroupUsers.users,
                          groupID: widget.groupID,
                          isAdmin: isCurrentMemberAdmin,
                          topic: widget.topic,
                        )
                      : Container(),
                  groupStatus == 0
                      ? Container(
                          color: Colors.grey.shade300,
                          height: 15,
                        )
                      : Container(),
                  GroupMembers(
                    groupStatus: groupStatus,
                    openSearch: () {
                      setState(() {
                        isSearchOpen = true;
                      });
                    },
                    name: sub!,
                    sKey: _scaffoldKey,
                    groupID: widget.groupID,
                    topic: widget.topic,
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 15,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext mainContext) {
                              if (groupStatus == 0) {
                                return ExitGroupPopup(
                                  exit: 1,
                                  action: "EXIT",
                                  title: 'Exit "$sub" group?',
                                  onTapOk: () {
                                    Navigator.of(mainContext,
                                            rootNavigator: true)
                                        .pop();
                                    showDialog(
                                      context: mainContext,
                                      builder: (BuildContext context) {
                                        GroupApiCalls()
                                            .exitGroup(
                                                widget.groupID!, widget.topic!)
                                            .then((value) {
                                          _refresh.updateRefresh(true);
                                          setState(() {
                                            groupStatus = 1;
                                          });
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        });
                                        return ProcessingDialog(
                                          title: AppLocalizations.of(
                                            "Please wait a moment",
                                          ),
                                          heading: AppLocalizations.of(
                                            "Removing...",
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              } else {
                                return ExitGroupPopup(
                                  exit: 0,
                                  action: "DELETE",
                                  title: 'Delete "$sub" group?',
                                  onTapOk: () {
                                    Navigator.of(mainContext,
                                            rootNavigator: true)
                                        .pop();

                                    showDialog(
                                      context: mainContext,
                                      builder: (BuildContext dialogContext) {
                                        ChatApiCalls()
                                            .removeUser(widget.groupID!)
                                            .then((value) {
                                          Timer(Duration(milliseconds: 100),
                                              () {
                                            Navigator.of(dialogContext).pop();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                          /*  Timer(Duration(milliseconds: 500), () {
                                              Navigator.of(context, rootNavigator: true).pop();
                                            });*/
                                        });
                                        return ProcessingDialog(
                                          title: AppLocalizations.of(
                                            "Please wait a moment",
                                          ),
                                          heading: "",
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            });
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      dense: false,
                      leading: Icon(
                        CustomIcons.prohibition,
                        color: Colors.red.shade800,
                      ),
                      title: Text(
                        groupStatus == 0
                            ? AppLocalizations.of("Exit group")
                            : AppLocalizations.of(
                                "Delete group",
                              ),
                        style:
                            TextStyle(fontSize: 16, color: Colors.red.shade800),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 15,
                  ),
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () {
                        bool isExit = true;

                        showDialog(
                            context: context,
                            builder: (BuildContext reportContext) {
                              return ReportPopup(
                                action: AppLocalizations.of(
                                  "Exit group and delete this group's messages",
                                ),
                                exit: (bool exit) {
                                  isExit = exit;
                                },
                                onTapOk: () {
                                  if (isExit) {
                                    Navigator.of(reportContext,
                                            rootNavigator: true)
                                        .pop();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext exitContext) {
                                        GroupApiCalls()
                                            .exitGroup(
                                                widget.groupID!, widget.topic!)
                                            .then((value) {
                                          ChatApiCalls()
                                              .removeUser(widget.groupID!)
                                              .then((value) {
                                            Navigator.of(exitContext,
                                                    rootNavigator: true)
                                                .pop();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            customToastWhite(
                                                "Report sent and you are no longer part of that group",
                                                14.0,
                                                ToastGravity.CENTER);
                                            GroupApiCalls.reportGroup(
                                                widget.groupID!);
                                          });
                                        });
                                        return ProcessingDialog(
                                          title: AppLocalizations.of(
                                            "Please wait a moment",
                                          ),
                                          heading: AppLocalizations.of(
                                            "Reporting..",
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    Navigator.of(reportContext,
                                            rootNavigator: true)
                                        .pop();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    customToastWhite(
                                        AppLocalizations.of(
                                          "Report sent",
                                        ),
                                        14.0,
                                        ToastGravity.CENTER);
                                    GroupApiCalls.reportGroup(widget.groupID!);
                                  }
                                },
                                title: AppLocalizations.of(
                                  "Report this group to Bebuzee?",
                                ),
                                subtitle: AppLocalizations.of(
                                  "Most recent messages in this group will be forwarded to Bebuzee",
                                ),
                              );
                            });
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      dense: false,
                      leading: RotatedBox(
                          quarterTurns: 2,
                          child: Icon(
                            CustomIcons.videolike2,
                            color: Colors.red.shade800,
                          )),
                      title: Text(
                        AppLocalizations.of(
                          "Report group",
                        ),
                        style:
                            TextStyle(fontSize: 16, color: Colors.red.shade800),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade300,
                    height: 20,
                  ),
                ]))
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                setState(() {
                  isSearchOpen = false;
                });
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: darkColor,
          brightness: Brightness.dark,
          title: searchBar(),
        ),
        body: WillPopScope(
          onWillPop: () async {
            setState(() {
              isSearchOpen = false;
            });
            return false;
          },
          child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    color: Colors.white,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _groupUsers.users.length,
                        itemBuilder: (context, index) {
                          var user;
                          user = _groupUsers.users[index];

                          return MinimalUserCard(
                            onLongTap: () {
                              if (user.fromuserid !=
                                  CurrentUser().currentUser.memberID) {
                                _showPopupMenu(user, index);
                              } else {
                                print("you are selected");
                              }
                            },
                            admin: 1,
                            from: "forward",
                            onTap: () {
                              print(user.name);
                              setState(() {
                                CurrentUser().currentUser.currentOpenMemberID =
                                    user.fromuserid;
                              });
                              _status.updateRefresh(user.onlineStatus);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailedChatScreen(
                                            token: user.token,
                                            name: user.name,
                                            image: user.image,
                                            memberID: user.fromuserid,
                                          )));
                            },
                            user: user,
                          );
                        }),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      );
    }
  }
}

class MediaAndLinks extends StatelessWidget {
  final List<ChatMessagesModel>? messages;
  final String? groupID;
  final String? topic;
  final String? name;

  const MediaAndLinks(
      {Key? key, this.messages, this.groupID, this.topic, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllMediaPageChat(
                      title: name!,
                      uniqueID: groupID!,
                      topic: topic!,
                      from: "group",
                    )));
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(
                          "Media, links and docs",
                        ),
                        style: TextStyle(
                            color: darkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        messages!.length.toString(),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: 70,
                  child: ListView.builder(
                      itemCount: messages!.length + 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (index == messages!.length) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllMediaPageChat(
                                            title: name!,
                                            uniqueID: groupID!,
                                            topic: topic!,
                                            from: "group",
                                          )));
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: 70,
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 26,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ViewSingleGroupFile(
                                                topic: topic,
                                                memberID: groupID,
                                                messages: messages,
                                                selectedIndex: index,
                                              )));
                                },
                                child: Container(
                                    width: 70,
                                    child: ChatMediaCard(
                                      path: messages![index].you == 0
                                          ? messages![index].receiverThumbnail!
                                          : messages![index].thumbPath!,
                                      image: messages![index].messageType ==
                                              "video"
                                          ? messages![index]
                                              .videoImage!
                                              .replaceAll(".mp4", ".jpg")
                                          : messages![index]
                                              .imageData!
                                              .toString()
                                              .replaceAll("/resized", ""),
                                    ))),
                          );
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsAndMedia extends StatefulWidget {
  final bool? isAdmin;
  final String? groupID;
  final String? topic;
  final List<DirectMessageUserListModel>? users;

  const NotificationsAndMedia(
      {Key? key, this.isAdmin, this.groupID, this.topic, this.users})
      : super(key: key);

  @override
  _NotificationsAndMediaState createState() => _NotificationsAndMediaState();
}

class _NotificationsAndMediaState extends State<NotificationsAndMedia> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            onTap: () {},
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            dense: false,
            title: Text(
              AppLocalizations.of("Mute notifications"),
              style: TextStyle(fontSize: 16),
            ),
            trailing: Switch(
              onChanged: (val) {
                setState(() {
                  isSwitched = !isSwitched;
                });
              },
              value: isSwitched,
              activeColor: darkColor,
            ),
          ),
          CustomListTile(
              title: AppLocalizations.of(
                "Custom notifications",
              ),
              onTap: () {}),
          CustomListTile(
              title: AppLocalizations.of(
                "Media visibility",
              ),
              onTap: () {}),
          widget.isAdmin!
              ? CustomListTile(
                  title: AppLocalizations.of(
                    "Group settings",
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupSettingsPage(
                                  users: widget.users!,
                                  groupID: widget.groupID!,
                                  topic: widget.topic!,
                                )));
                  })
              : Container(),
        ],
      ),
    );
  }
}

class GroupMembers extends StatefulWidget {
  final String? groupID;
  final GlobalKey<ScaffoldState>? sKey;
  final String? name;
  final Function? openSearch;
  final String? topic;
  final int? groupStatus;

  const GroupMembers(
      {Key? key,
      this.groupID,
      this.sKey,
      this.name,
      this.openSearch,
      this.topic,
      this.groupStatus})
      : super(key: key);

  @override
  _GroupMembersState createState() => _GroupMembersState();
}

class _GroupMembersState extends State<GroupMembers> {
  late Future _future;
  UpdateOnlineStatus _status = UpdateOnlineStatus();
  DirectUsers _groupUsers = new DirectUsers([]);
  bool isCurrentMemberAdmin = false;
  int groupStatus = 0;

  void _makeAdmin() {
    int count = 0;
    _groupUsers.users.forEach((element) {
      if (element.admin == 1) {
        count++;
      }
    });
    if (count == 0) {
      GroupApiCalls()
          .makeGroupAdmin(
              _groupUsers.users[0].fromuserid!, widget.groupID!, widget.topic!)
          .then((value) {
        setState(() {
          isCurrentMemberAdmin = false;
        });
        _getUsers();
      });
    }
  }

  void _getUsersLocal() {
    _future = ChatApiCalls.getSelectedGroupUserListLocal(widget.groupID!)
        .then((value) {
      if (mounted) {
        setState(() {
          _groupUsers.users = value.users;
        });
        _groupUsers.users.forEach((element) {
          if (element.fromuserid == CurrentUser().currentUser.memberID &&
              element.admin == 1) {
            setState(() {
              isCurrentMemberAdmin = true;
            });
            print("yes admin");
          }
        });
      }
      _getUsers();
      return value;
    });
  }

  void _getUsers() {
    _future =
        ChatApiCalls.getSelectedGroupUserList(widget.groupID!).then((value) {
      if (mounted) {
        setState(() {
          _groupUsers.users = value!.users;
        });
        _groupUsers.users.forEach((element) {
          if (element.fromuserid == CurrentUser().currentUser.memberID &&
              element.admin == 1) {
            setState(() {
              isCurrentMemberAdmin = true;
            });
            print("yes admin");
          }
        });
      }
      _makeAdmin();
      return value;
    });
  }

  Future<void> _showPopupMenu(
      DirectMessageUserListModel user, int index) async {
    int selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(350, 400, 25, 400),
      items: <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          value: 0,
          child: Text("Message ${user.name}"),
        ),
        PopupMenuItem(
          value: 1,
          child: Text("View ${user.name}"),
        ),
        isCurrentMemberAdmin && groupStatus == 0
            ? PopupMenuItem(
                value: 2,
                child: Text(user.admin == 0
                    ? AppLocalizations.of("Make group admin")
                    : AppLocalizations.of("Dismiss as admin")),
              )
            : PopupMenuItem(child: Container()),
        isCurrentMemberAdmin && groupStatus == 0
            ? PopupMenuItem(
                value: 3,
                child: Text("Remove ${user.name}"),
              )
            : PopupMenuItem(child: Container()),
      ],
      elevation: 8.0,
    );
    if (selected == 0) {
      print(user.name);
      setState(() {
        CurrentUser().currentUser.currentOpenMemberID = user.fromuserid;
      });
      _status.updateRefresh(user.onlineStatus);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedChatScreen(
                    token: user.token!,
                    name: user.name!,
                    image: user.image!,
                    memberID: user.fromuserid!,
                  )));
    } else if (selected == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewContactSingle(
                    memberID: user.fromuserid!,
                    name: user.name!,
                    image: user.image!,
                  )));
    } else if (selected == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print(user.fromuserid);
        print(widget.groupID);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            if (user.admin == 0) {
              GroupApiCalls()
                  .makeGroupAdmin(
                      user.fromuserid!, widget.groupID!, widget.topic!)
                  .then((value) {
                _getUsers();
                Timer(Duration(milliseconds: 100),
                    () => Navigator.of(context, rootNavigator: true).pop());
              });
              return ProcessingDialog(
                title: AppLocalizations.of(
                  "Please wait a moment",
                ),
                heading: AppLocalizations.of(
                  "Adding...",
                ),
              );
            } else {
              GroupApiCalls()
                  .removeGroupAdmin(
                      user.fromuserid!, widget.groupID!, widget.topic!)
                  .then((value) {
                _getUsers();
                Timer(Duration(milliseconds: 100),
                    () => Navigator.of(context, rootNavigator: true).pop());
              });
              return ProcessingDialog(
                title: AppLocalizations.of(
                  "Please wait a moment",
                ),
                heading: AppLocalizations.of(
                  "Removing...",
                ),
              );
            }
          },
        );
      });
    } else if (selected == 3) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return BasicCancelOkPopup(
              title: 'Remove ${user.name} from "${widget.name}" group?',
              onTapOk: () {
                Navigator.of(context, rootNavigator: true).pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      GroupApiCalls()
                          .removeMembersFromGroup(
                              user.fromuserid!, widget.groupID!, widget.topic!)
                          .then((value) {
                        _getUsers();
                        Timer(
                            Duration(milliseconds: 100),
                            () => Navigator.of(context, rootNavigator: true)
                                .pop());
                      });
                      return ProcessingDialog(
                        title: AppLocalizations.of(
                          "Please wait a moment",
                        ),
                        heading: AppLocalizations.of(
                          "Removing...",
                        ),
                      );
                    });
              },
            );
          });
    }
  }

  void _exitGroup() {
    setState(() {
      groupStatus = 1;
    });
  }

  GroupMembersRefresh _refresh = GroupMembersRefresh();

  void _addUsers() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewGroupSelectUsers(
                  add: 1,
                  groupID: widget.groupID!,
                  addMember: (String memberIDs) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          GroupApiCalls()
                              .addMembersToGroup(
                                  memberIDs, widget.groupID!, widget.topic!)
                              .then((value) {
                            Timer(
                                Duration(milliseconds: 100),
                                () => Navigator.of(context, rootNavigator: true)
                                    .pop());
                            _getUsers();
                          });
                          return ProcessingDialog(
                            title: AppLocalizations.of(
                              "Please wait a moment",
                            ),
                            heading: AppLocalizations.of(
                              "Adding...",
                            ),
                          );
                        },
                      );
                    });
                  },
                )));
  }

  @override
  void initState() {
    print(widget.groupStatus);
    groupStatus = widget.groupStatus!;
    _getUsersLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        initialData: _refresh.currentSelect,
        stream: _refresh.observableCart,
        builder: (context, dynamic snapshot) {
          if (snapshot.data) {
            _getUsers();

            //_exitGroup();
            print("refresh group users");
            _refresh.updateRefresh(false);
          }
          return FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${_groupUsers.users.length.toString()} participants",
                                    style: TextStyle(
                                        color: darkColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Builder(
                                    builder: (BuildContext context) {
                                      return IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        icon: Icon(
                                          Icons.search,
                                          color: darkColor,
                                        ),
                                        onPressed: () {
                                          widget.openSearch!();
                                        },
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: isCurrentMemberAdmin
                                ? _groupUsers.users.length + 2
                                : _groupUsers.users.length,
                            itemBuilder: (context, index) {
                              if (index == 0 && isCurrentMemberAdmin) {
                                return ListTile(
                                  onTap: () {
                                    _addUsers();
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  title: Text(
                                    AppLocalizations.of(
                                      "Add participants",
                                    ),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  leading: Container(
                                    decoration: new BoxDecoration(
                                      color: darkColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.person_add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (index == 1 && isCurrentMemberAdmin) {
                                return ListTile(
                                  onTap: () async {
                                    /* try {
                                    await ContactsService.openExistingContact(new Contact(
                                      givenName: "Gill",
                                      phones: [Item(label: "Mobile", value: "+91 90449 10458")],
                                    ));
                                  } on FormOperationException catch (e) {
                                    switch (e.errorCode) {
                                      case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                                      case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                                      case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                                        print(e.toString());
                                        break;
                                    }
                                  }*/
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  title: Text(
                                    AppLocalizations.of(
                                      "Invite via link",
                                    ),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  leading: Container(
                                    decoration: new BoxDecoration(
                                      color: darkColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.link,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                var user;
                                if (isCurrentMemberAdmin) {
                                  user = _groupUsers.users[index - 2];
                                } else {
                                  user = _groupUsers.users[index];
                                }
                                return MinimalUserCard(
                                  onLongTap: () {
                                    if (user.fromuserid !=
                                        CurrentUser().currentUser.memberID) {
                                      int selectedIndex;
                                      if (isCurrentMemberAdmin) {
                                        selectedIndex = index - 2;
                                      } else {
                                        selectedIndex = index;
                                      }
                                      _showPopupMenu(user, selectedIndex);
                                    } else {
                                      print("you are selected");
                                    }
                                  },
                                  admin: 1,
                                  from: "forward",
                                  onTap: () {
                                    print(user.name);
                                    setState(() {
                                      CurrentUser()
                                              .currentUser
                                              .currentOpenMemberID =
                                          user.fromuserid;
                                    });
                                    _status.updateRefresh(user.onlineStatus);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailedChatScreen(
                                                  token: user.token,
                                                  name: user.name,
                                                  image: user.image,
                                                  memberID: user.fromuserid,
                                                )));
                                  },
                                  user: user,
                                );
                              }
                            }),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              });
        });
  }
}

class CustomListTile extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  const CustomListTile({Key? key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      dense: false,
      title: Text(
        title!,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
