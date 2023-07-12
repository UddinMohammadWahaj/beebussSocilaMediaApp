import 'dart:convert';
import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Chat/chat_profile_api.dart';
import 'package:bizbultest/services/FeedAllApi/feed_controller.dart';
import 'package:bizbultest/services/User/user_controller.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/chat_galley_thumbnails.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/Chat/set_status_page.dart';
import 'package:bizbultest/view/Chat/settings_screen.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:bizbultest/widgets/Newsfeeds/publish_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as g;
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class UserProfileScreen extends StatefulWidget {
  final String? from;

  const UserProfileScreen({Key? key, this.from}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController _controller =
      TextEditingController(text: CurrentUser().currentUser.fullName);
  bool isChanging = false;

  _buildGalleryAppbar(StateSetter state) {
    return AppBar(
      title: Text(
        AppLocalizations.of(
          "Tap photo to select",
        ),
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
                        setState(() {
                          isChanging = true;
                        });
                        ChatProfileApiCalls.deletePhoto().then((value) {
                          setState(() {
                            CurrentUser().currentUser.image =
                                "https://www.bebuzee.com/users/main/no_image_image_news.jpg";
                            isChanging = false;
                          });
                          customToastWhite("Profile photo removed", 15.0,
                              ToastGravity.CENTER);
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

  HomepageRefreshState refresh = new HomepageRefreshState();

  void _changeImage(String path) async {
    setState(() {
      isChanging = true;
    });
    var client = new Dio();
    FormData formData = new FormData.fromMap({
      "image": await MultipartFile.fromFile(path),
    });
    var res = await client.post(
      "https://www.bebuzee.com/new_files/all_apis/user_update_data.php?action=update_profile_picture&user_id=${CurrentUser().currentUser.memberID}&image=",
      data: formData,
      onSendProgress: (int sent, int total) {
        final progress = (sent / total) * 100;
        print('group picture progress: $progress');
      },
    );

    String image = "";
    image = jsonDecode(res.toString())['image'];
    print("image " + jsonDecode(res.toString())['image']);
    if (mounted) {
      setState(() {
        CurrentUser().currentUser.image = image;
        isChanging = false;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("image", jsonDecode(res.toString())['image']);
    print("changed");
    FeedController feedController = g.Get.put(FeedController());
    feedController.hideNavBar.value = true;
    refresh.updateRefresh(true);
  }

  Widget _changeName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Container(
        child: Wrap(
          children: [
            Text(
              AppLocalizations.of(
                "Add About",
              ),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.black),
            ),
            TextFormField(
              autofocus: true,
              maxLines: 1,
              textInputAction: TextInputAction.newline,
              controller: _controller,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: darkColor, width: 2.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: darkColor, width: 2.0),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: darkColor, width: 2.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    UserController userController = g.Get.put(UserController());
                    setState(() {
                      CurrentUser().currentUser.fullName = _controller.text;
                    });
                    userController.changeName(_controller.text);
                    g.Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                        AppLocalizations.of(
                          "Save",
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: darkColor)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    g.Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                        AppLocalizations.of(
                          "Cancel",
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: darkColor)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        flexibleSpace: gradientContainer(null),
        title: Text(
          AppLocalizations.of(
            "Profile",
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 32.0,
              bottom: 16.0,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: Hero(
                    tag: 'profile-pic',
                    child: CircleAvatar(
                      radius: 70.0,
                      backgroundColor: darkColor,
                      backgroundImage:
                          NetworkImage(CurrentUser().currentUser.image!),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 0.0,
                  right: 0.0,
                  left: 70,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        mini: true,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          print("gallery");
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
                                  image: CurrentUser().currentUser.image!,
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
                                                    from: "camera",
                                                    setPhoto: (String path) {
                                                      _changeImage(path);
                                                    },
                                                    path: value!.path,
                                                  )));
                                    });
                                  },
                                );
                              });
                        }),
                  ),
                ),
                isChanging
                    ? Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white)))
                    : Container(),
              ],
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: Icon(
              Icons.account_circle,
              color: darkColor,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(
                    'Name',
                  ),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                ),
                Text(
                  CurrentUser().currentUser.fullName!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                AppLocalizations.of(
                  "This is not your username or pin. This name will be visible to your Bebuzee contacts.",
                ),
              ),
            ),
            trailing: Icon(Icons.mode_edit),
            onTap: () {
              g.Get.bottomSheet(_changeName(),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0))));
            },
          ),
          Divider(
            height: 0.0,
            indent: 72.0,
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: Icon(
              Icons.info_outline,
              color: darkColor,
            ),
            title: Text(
              AppLocalizations.of(
                'About',
              ),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
              ),
            ),
            subtitle: SelectedAboutStatus(),
            trailing: Icon(Icons.mode_edit),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SetStatusPage()));
            },
          ),
          Divider(
            height: 0.0,
            indent: 72.0,
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: Icon(
              Icons.call,
              color: darkColor,
            ),
            title: Text(
              AppLocalizations.of(
                'Phone',
              ),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
              ),
            ),
            subtitle: Text(
              CurrentUser().currentUser.contactNumber!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}

class UpdateProfileBottomTile extends StatefulWidget {
  final VoidCallback? removePhoto;
  final VoidCallback? openGallery;
  final VoidCallback? camera;
  final String? image;

  const UpdateProfileBottomTile(
      {Key? key, this.removePhoto, this.openGallery, this.camera, this.image})
      : super(key: key);

  @override
  _UpdateProfileBottomTileState createState() =>
      _UpdateProfileBottomTileState();
}

class _UpdateProfileBottomTileState extends State<UpdateProfileBottomTile> {
  Widget _button(Icon icon, VoidCallback onTap, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new FloatingActionButton(
              elevation: 0,
              backgroundColor: color,
              foregroundColor: color,
              onPressed: onTap,
              child: icon,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                width: 55,
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
          child: Text(
            AppLocalizations.of(
              "Profile photo",
            ),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
          ),
        ),
        Container(
          child: Row(
            children: [
              widget.image !=
                          "https://www.bebuzee.com/users/main/no_image_image_news.jpg" &&
                      widget.image !=
                          "https://www.bebuzee.com/new_files/new-11.png"
                  ? _button(
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      widget.removePhoto!,
                      Colors.orange.shade900,
                      AppLocalizations.of(
                        "Remove photo",
                      ))
                  : Container(),
              _button(
                Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
                widget.openGallery!,
                Colors.purple,
                AppLocalizations.of(
                  "Gallery",
                ),
              ),
              _button(
                Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                widget.camera!,
                Colors.green,
                AppLocalizations.of(
                  "Camera",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatProfilePhotoCropScreen extends StatefulWidget {
  final String? path;
  final Function? setPhoto;
  final String? from;

  const ChatProfilePhotoCropScreen(
      {Key? key, this.path, this.setPhoto, this.from})
      : super(key: key);

  @override
  _ChatProfilePhotoCropScreenState createState() =>
      _ChatProfilePhotoCropScreenState();
}

class _ChatProfilePhotoCropScreenState
    extends State<ChatProfilePhotoCropScreen> {
  // final imgCropKey = GlobalKey<ImgCropState>();

  Widget _button(String name, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 5.0.h,
          width: 50.0.w,
          color: Colors.transparent,
          child: Center(
            child: Text(
              name,
              style: whiteBold.copyWith(fontSize: 17),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 95.0.h,
            width: 100.0.w,
            color: Colors.black,
            child: Stack(
              children: [
                Center(
                  child: Image.file(
                    File(widget.path!),
                    fit: BoxFit.cover,
                    height: 50.0.h,
                    width: 100.0.w,
                  ),
                ),
                Center(
                  child: Container(
                    height: 50.0.h,
                    width: 100.0.w,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 24.0.h,
                        backgroundImage: FileImage(File(widget.path!))),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              _button(
                  AppLocalizations.of(
                    "CANCEL",
                  ), () {
                Navigator.pop(context);
              }),
              _button(
                  AppLocalizations.of(
                    "DONE",
                  ), () {
                widget.setPhoto!(widget.path);
                if (widget.from == "group" || widget.from == "camera") {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              }),
            ],
          )
        ],
      ),
    );
  }
}
