import 'package:bizbultest/Language/appLocalization.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

import 'colors.dart';

class DialogHelpers {
  static Dialog getProfileDialog({
    required BuildContext context,
    int? id,
    String? imageUrl,
    String? name,
    GestureTapCallback? onTapMessage,
    GestureTapCallback? onTapCall,
    GestureTapCallback? onTapVideoCall,
    GestureTapCallback? onTapInfo,
  }) {
    Widget image = imageUrl == null
        ? SizedBox(
            child: Container(
            decoration: BoxDecoration(
              color: profileDialogBgColor,
            ),
            height: 250.0,
            child: Center(
              child: Icon(
                Icons.account_circle,
                color: profileDialogIconColor,
                size: 120.0,
              ),
            ),
          ))
        : Image(
            image: CachedNetworkImageProvider(imageUrl),
          );
    return new Dialog(
      shape: RoundedRectangleBorder(),
      child: Container(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                child: Stack(
                  children: <Widget>[
                    image,
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              name!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.message,
                      size: 25,
                    ),
                    onPressed:
                        onTapMessage ?? () => _defOnTapMessage(context, id!),
                    color: secondaryColor,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.call,
                      size: 25,
                    ),
                    onPressed: onTapCall ?? () => _defOnTapCall(context),
                    color: secondaryColor,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.videocam,
                      size: 25,
                    ),
                    onPressed:
                        onTapVideoCall ?? () => _defOnTapVideoCall(context),
                    color: secondaryColor,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      size: 25,
                    ),
                    onPressed: onTapInfo ?? () => _defOnTapInfo(context, id!),
                    color: secondaryColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static showRadioDialog(List allOptions, String title, Function getText,
      BuildContext context, option, bool isActions, onChanged) {
    showDialog(
        barrierDismissible: !isActions,
        context: context,
        builder: (context) {
          List<Widget> widgets = [];
          for (dynamic opt in allOptions) {
            widgets.add(
              ListTileTheme(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RadioListTile(
                  value: opt,
                  title: Text(
                    getText(opt),
                    style: TextStyle(fontSize: 18.0),
                  ),
                  groupValue: option,
                  onChanged: (dynamic value) {
                    onChanged(value.toString());
                    Navigator.of(context).pop();
                  },
                  activeColor: secondaryColor,
                ),
              ),
            );
          }

          return AlertDialog(
            contentPadding: EdgeInsets.only(bottom: 8.0),
            title: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widgets,
                    ),
                  ),
                ),
              ],
            ),
            actions: !isActions
                ? null
                : <Widget>[
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Text(
                          AppLocalizations.of("Cancel"),
                          style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        child: Text(
                          AppLocalizations.of("OK"),
                          style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
          );
        });
  }

  static _defOnTapMessage(BuildContext context, int id) {}

  static _defOnTapCall(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of('Call Button tapped'),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  static _defOnTapVideoCall(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of('Video Call Button tapped'),
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  static _defOnTapInfo(BuildContext context, int id) {}
}

class ProcessingDialog extends StatelessWidget {
  final String? title;
  final String? heading;

  const ProcessingDialog({Key? key, this.title, this.heading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              heading != ""
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Container(
                        child: Text(
                          heading!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(darkColor)),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    title!,
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BasicCancelOkPopup extends StatelessWidget {
  final String? title;
  final VoidCallback? onTapOk;

  const BasicCancelOkPopup({Key? key, this.title, this.onTapOk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: TextStyle(color: Colors.black87, fontSize: 15),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        AppLocalizations.of("Cancel"),
                        style: TextStyle(fontSize: 15, color: darkColor),
                      )),
                  MaterialButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        onTapOk!();
                      },
                      child: Text(
                        AppLocalizations.of("OK"),
                        style: TextStyle(fontSize: 15, color: darkColor),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlockPopup extends StatelessWidget {
  final String? title;
  final VoidCallback? onTapOk;
  final int? action;

  const BlockPopup({Key? key, this.title, this.onTapOk, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  action == 1
                      ? Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Text(
                                  AppLocalizations.of(
                                    "REPORT AND BLOCK",
                                  ),
                                  style:
                                      TextStyle(fontSize: 14, color: darkColor),
                                )),
                          ],
                        )
                      : Container(),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text(
                            AppLocalizations.of("Cancel"),
                            style: TextStyle(fontSize: 14, color: darkColor),
                          )),
                      TextButton(
                          onPressed: () async {
                            onTapOk!();
                          },
                          child: Text(
                            AppLocalizations.of("Block"),
                            style: TextStyle(fontSize: 14, color: darkColor),
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UnblockPopup extends StatelessWidget {
  final String? title;
  final VoidCallback? onTapOk;

  const UnblockPopup({Key? key, this.title, this.onTapOk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        AppLocalizations.of("Cancel"),
                        style: TextStyle(fontSize: 15, color: darkColor),
                      )),
                  MaterialButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        onTapOk!();
                      },
                      child: Text(
                        AppLocalizations.of("Unblock"),
                        style: TextStyle(fontSize: 15, color: darkColor),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExitGroupPopup extends StatelessWidget {
  final String? title;
  final VoidCallback? onTapOk;
  final String? action;
  final int? exit;

  const ExitGroupPopup(
      {Key? key, this.title, this.onTapOk, this.action, this.exit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: TextStyle(color: Colors.black87, fontSize: 15),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  exit == 1
                      ? Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Text(
                                  AppLocalizations.of(
                                    "MUTE INSTEAD",
                                  ),
                                  style:
                                      TextStyle(fontSize: 14, color: darkColor),
                                )),
                          ],
                        )
                      : Container(),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Text(
                            AppLocalizations.of(
                              "CANCEL",
                            ),
                            style: TextStyle(fontSize: 14, color: darkColor),
                          )),
                      TextButton(
                          onPressed: () async {
                            onTapOk!();
                          },
                          child: Text(
                            action!,
                            style: TextStyle(fontSize: 14, color: darkColor),
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportPopup extends StatefulWidget {
  final String? title;
  final VoidCallback? onTapOk;
  final Function? exit;
  final String? subtitle;
  final String? action;

  const ReportPopup(
      {Key? key,
      this.title,
      this.onTapOk,
      this.exit,
      this.subtitle,
      this.action})
      : super(key: key);

  @override
  _ReportPopupState createState() => _ReportPopupState();
}

class _ReportPopupState extends State<ReportPopup> {
  Widget _unselected() {
    return Container(
      height: 20,
      width: 20,
      child: Icon(
        Icons.check_box_outline_blank,
        color: Colors.grey,
      ),
    );
  }

  Widget _selected() {
    return Container(
      height: 20,
      width: 20,
      child: Icon(Icons.check_box, color: darkColor),
    );
  }

  bool selected = true;

  Widget _tile(String title, VoidCallback onTap, bool selected) {
    return ListTile(
      dense: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(color: Colors.black54, fontSize: 14),
      ),
      leading: selected ? _selected() : _unselected(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title!,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.subtitle!,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              _tile(widget.action!, () {
                setState(() {
                  selected = !selected;
                });
                widget.exit!(selected);
              }, selected),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(
                        AppLocalizations.of(
                          "CANCEL",
                        ),
                        style: TextStyle(fontSize: 15, color: darkColor),
                      )),
                  MaterialButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        widget.onTapOk!();
                      },
                      child: Text(
                        AppLocalizations.of(
                          "REPORT",
                        ),
                        style: TextStyle(fontSize: 15, color: darkColor),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void simpleDialog(
    BuildContext simpleContext, String title, String buttonTitle) {
  showDialog(
      context: simpleContext,
      builder: (BuildContext simpleContext) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                    child: Text(
                  title,
                  style: TextStyle(fontSize: 16),
                )),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(simpleContext);
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    child: Text(
                      buttonTitle,
                      style: TextStyle(
                          fontSize: 16,
                          color: darkColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
        // return object of type Dialog
      });
}
