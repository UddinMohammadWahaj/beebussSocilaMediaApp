import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/status_model.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetStatusPage extends StatefulWidget {
  @override
  _SetStatusPageState createState() => _SetStatusPageState();
}

class _SetStatusPageState extends State<SetStatusPage> {
  late Future _aboutFuture;
  late Future _selectedStatusFuture;
  ChatStatus _statusList = new ChatStatus([]);
  String selectedStatus = "";
  TextEditingController _controller = TextEditingController();

  _getSelectedStatus() {
    _selectedStatusFuture =
        DirectApiCalls.getUserSelectedStatus().then((value) {
      setState(() {
        selectedStatus = value;
        _controller.text = value;
        CurrentUser().currentUser.aboutStatus = value;
      });
      return value;
    });
  }

  _getSelectedStatusLocal() {
    _selectedStatusFuture =
        DirectApiCalls.getUserSelectedStatusLocal().then((value) {
      setState(() {
        selectedStatus = value;
        _controller.text = value;
        CurrentUser().currentUser.aboutStatus = value;
      });
      _getSelectedStatus();
      return value;
    });
  }

  _getStatusList() {
    _aboutFuture = DirectApiCalls.getAllStatus().then((value) {
      setState(() {
        _statusList = value;
      });
      return value;
    });
  }

  _getStatusListLocal() {
    _aboutFuture = DirectApiCalls.getAllStatusLocal().then((value) {
      setState(() {
        _statusList = value!;
      });
      _getStatusList();
      return value;
    });
  }

  @override
  void initState() {
    _getSelectedStatusLocal();
    _getStatusListLocal();
    //  _getStatusList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(
            "About",
          ),
          style: TextStyle(fontSize: 20),
        ),
        flexibleSpace: gradientContainer(null),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 12.0, top: 18.0, right: 12.0, bottom: 8.0),
            child: Text(
              AppLocalizations.of(
                "Currently set to",
              ),
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 16, color: darkColor),
            ),
          ),
          FutureBuilder(
              future: _selectedStatusFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("hasss data");
                  return ListTile(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(15.0),
                                  topRight: const Radius.circular(15.0))),
                          //isScrollControlled:true,
                          context: context,
                          builder: (BuildContext bc) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 30),
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
                                      onChanged: (val) {},
                                      maxLines: null,
                                      textInputAction: TextInputAction.newline,
                                      controller: _controller,
                                      keyboardType: TextInputType.multiline,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(0),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: darkColor, width: 2.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: darkColor, width: 2.0),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: darkColor, width: 2.0),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            DirectApiCalls().updateAboutStatus(
                                                _controller.text);
                                            _statusList.status
                                                .forEach((element) {
                                              if (element.selectedStatus == 1) {
                                                setState(() {
                                                  element.selectedStatus = 0;
                                                });
                                              }
                                            });
                                            setState(() {
                                              selectedStatus = _controller.text;
                                              CurrentUser()
                                                      .currentUser
                                                      .aboutStatus =
                                                  _controller.text;
                                            });
                                            Navigator.pop(context);
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
                                            Navigator.pop(context);
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
                          });
                    },
                    title: Text(
                      selectedStatus,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    trailing: Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 20,
                    ),
                  );
                } else {
                  return Container();
                }
              }),
          Divider(
            thickness: 0.3,
            color: Colors.grey,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              AppLocalizations.of(
                "Select About",
              ),
              style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 16, color: darkColor),
            ),
          ),
          FutureBuilder(
              future: _aboutFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("hasss data");
                  return Container(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _statusList.status.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              DirectApiCalls().updateAboutStatus(
                                  _statusList.status[index].status!);
                              _statusList.status.forEach((element) {
                                if (element.selectedStatus == 1) {
                                  setState(() {
                                    element.selectedStatus = 0;
                                  });
                                }
                              });
                              setState(() {
                                _statusList.status[index].selectedStatus = 1;
                                selectedStatus =
                                    _statusList.status[index].status!;
                                _controller.text =
                                    _statusList.status[index].status!;
                                CurrentUser().currentUser.aboutStatus =
                                    _statusList.status[index].status;
                              });
                            },
                            title: Text(
                              _statusList.status[index].status!,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            trailing:
                                _statusList.status[index].selectedStatus == 1
                                    ? Icon(
                                        Icons.check,
                                        color: darkColor,
                                        size: 25,
                                      )
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                          );
                        }),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }
}
