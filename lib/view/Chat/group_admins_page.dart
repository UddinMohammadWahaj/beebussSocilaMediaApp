import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupAdminsPage extends StatefulWidget {
  final List<DirectMessageUserListModel>? users;
  final Function? addOrRemoveAdmin;

  const GroupAdminsPage({Key? key, this.users, this.addOrRemoveAdmin})
      : super(key: key);

  @override
  _GroupAdminsPageState createState() => _GroupAdminsPageState();
}

class _GroupAdminsPageState extends State<GroupAdminsPage> {
  List<DirectMessageUserListModel> _allUsers = [];
  List<DirectMessageUserListModel> _admins = [];

  void _setUsers() {
    setState(() {
      _allUsers = widget.users!
          .where((element) =>
              element.fromuserid != CurrentUser().currentUser.memberID)
          .toList();
    });
    _allUsers.forEach((element) {
      if (element.admin == 1) {
        setState(() {
          _admins.add(element);
        });
      }
    });
  }

  Widget _icon(double rightPadding, IconData icon, Color color, double size) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }

  Widget _checkIcon() {
    return Positioned(
      top: 26,
      left: 26,
      child: Container(
          decoration: new BoxDecoration(
            color: darkColor,
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: _icon(0, Icons.check, Colors.white, 15)),
    );
  }

  Widget _crossIcon(String name) {
    return Positioned(
      top: 40,
      left: 40,
      child: Container(
          decoration: new BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
            border: new Border.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: _icon(0, Icons.close, Colors.white, 18)),
    );
  }

  Widget _nameCard(String name) {
    return Text(
      name,
      style: TextStyle(
          fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _statusCard(String status) {
    return Text(
      status,
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black54),
    );
  }

  Widget _imageIcon(
      double radius, String imageURL, Widget stackIcon, bool showIcon) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: darkColor,
          backgroundImage: CachedNetworkImageProvider(imageURL),
        ),
        showIcon
            ? stackIcon
            : Container(
                height: 0,
                width: 0,
              ),
      ],
    );
  }

  Widget _userTile(double radius, String imageURL, String name, String status,
      bool showIcon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: _imageIcon(radius, imageURL, _checkIcon(), showIcon),
      title: _nameCard(name),
      subtitle: _statusCard(status),
    );
  }

  void _addOrRemoveFromAllUsers(int index) {
    if (_allUsers[index].admin == 1) {
      setState(() {
        _allUsers[index].admin = 0;
        _admins.removeWhere(
            (element) => element.fromuserid == _allUsers[index].fromuserid);
      });
    } else {
      setState(() {
        _allUsers[index].admin = 1;
        _admins.add(_allUsers[index]);
      });
    }
  }

  void _addOrRemoveFromAdmins(int index) {
    _allUsers.forEach((element) {
      if (element.fromuserid == _admins[index].fromuserid) {
        setState(() {
          element.admin = 0;
        });
      }
    });
    setState(() {
      _admins.removeAt(index);
    });
  }

  @override
  void initState() {
    _setUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        backgroundColor: darkColor,
        child: Icon(
          Icons.check,
          size: 22,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
          widget.addOrRemoveAdmin!(_allUsers);
        },
      ),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(
                "Edit group admins",
              ),
              style: whiteBold.copyWith(fontSize: 20),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "${_admins.length.toString()} of ${_allUsers.length.toString()} selected",
              style: whiteNormal.copyWith(fontSize: 14),
            ),
          ],
        ),
        flexibleSpace: gradientContainer(null),
        backgroundColor: Colors.white,
        brightness: Brightness.dark,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _admins.length != 0
                  ? Container(
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: _admins.length,
                          itemBuilder: (context, index) {
                            DirectMessageUserListModel user = _admins[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        print("Addddddddd");
                                        _addOrRemoveFromAdmins(index);
                                      },
                                      child: _imageIcon(30, user.image!,
                                          _crossIcon(user.name!), true)),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    user.name!,
                                    style: TextStyle(color: Colors.black54),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            );
                          }),
                    )
                  : Container(),
              _admins.length != 0
                  ? Divider(
                      thickness: 0.5,
                      color: Colors.grey.withOpacity(0.4),
                    )
                  : Container(),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allUsers.length,
                  itemBuilder: (context, index) {
                    DirectMessageUserListModel user = _allUsers[index];
                    return _userTile(22, user.image!, user.name!,
                        user.userStatus!, user.admin == 1 ? true : false, () {
                      _addOrRemoveFromAllUsers(index);
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
