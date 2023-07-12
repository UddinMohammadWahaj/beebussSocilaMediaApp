import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentMenuCurrentMember extends StatefulWidget {
  final VoidCallback? onPressDelete;

  CommentMenuCurrentMember({Key? key, this.onPressDelete}) : super(key: key);

  @override
  _CommentMenuCurrentMemberState createState() =>
      _CommentMenuCurrentMemberState();
}

class _CommentMenuCurrentMemberState extends State<CommentMenuCurrentMember> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: widget.onPressDelete ?? () {},
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 35, right: 35),
                      child: Text(
                        AppLocalizations.of("Delete"),
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 35, right: 35),
                      child: Text(
                        AppLocalizations.of("Cancel"),
                        style: TextStyle(
                            color: primaryBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CommentMenuOtherUser extends StatefulWidget {
  final VoidCallback? onReportSpam;
  final VoidCallback? onReportAbusive;
  bool? isReported = false;

  CommentMenuOtherUser(
      {Key? key, this.onReportSpam, this.onReportAbusive, this.isReported})
      : super(key: key);

  @override
  _CommentMenuOtherUserState createState() => _CommentMenuOtherUserState();
}

class _CommentMenuOtherUserState extends State<CommentMenuOtherUser> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog

                        return Dialog(
                          backgroundColor: Colors.white,
                          elevation: 5,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                        "Report",
                                      ),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      AppLocalizations.of(
                                        "Why are you reporting this comment?",
                                      ),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    GestureDetector(
                                      onTap: widget.onReportSpam ??
                                          () {
                                            Navigator.pop(context);

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  // return object of type Dialog

                                                  return ReportSuccessPopup();
                                                });
                                          },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 35,
                                              right: 35),
                                          child: Text(
                                            AppLocalizations.of(
                                              "Spam or Scam",
                                            ),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    GestureDetector(
                                      onTap: widget.onReportAbusive ??
                                          () {
                                            Navigator.pop(context);

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  // return object of type Dialog

                                                  return ReportSuccessPopup();
                                                });
                                          },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 35,
                                              right: 35),
                                          child: Text(
                                            AppLocalizations.of(
                                              "Abusive Content",
                                            ),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 35,
                                              right: 35),
                                          child: Text(
                                            AppLocalizations.of(
                                              "Cancel",
                                            ),
                                            style: TextStyle(
                                                color: primaryBlueColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 35, right: 35),
                      child: Text(
                        AppLocalizations.of(
                          "Report",
                        ),
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 35, right: 35),
                      child: Text(
                        AppLocalizations.of(
                          "Cancel",
                        ),
                        style: TextStyle(
                            color: primaryBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReportSuccessPopup extends StatefulWidget {
  @override
  _ReportSuccessPopupState createState() => _ReportSuccessPopupState();
}

class _ReportSuccessPopupState extends State<ReportSuccessPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(
                    "Report",
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AppLocalizations.of(
                    "Your report has been submitted successfully",
                  ),
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 35, right: 35),
                      child: Text(
                        AppLocalizations.of(
                          "Ok",
                        ),
                        style: TextStyle(
                            color: primaryBlueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
