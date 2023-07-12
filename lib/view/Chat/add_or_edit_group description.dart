import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class AddOrEditGroupDescription extends StatefulWidget {
  final String? description;
  final Function? changeDescription;

  const AddOrEditGroupDescription(
      {Key? key, this.description, this.changeDescription})
      : super(key: key);

  @override
  _AddOrEditGroupDescriptionState createState() =>
      _AddOrEditGroupDescriptionState();
}

class _AddOrEditGroupDescriptionState extends State<AddOrEditGroupDescription> {
  Widget _button(String text, double left, double right, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
              left:
                  BorderSide(color: Colors.grey.withOpacity(0.5), width: left),
              right:
                  BorderSide(color: Colors.grey.withOpacity(0.5), width: right),
              top: BorderSide(color: Colors.grey.withOpacity(0.7), width: 0.5)),
        ),
        height: 50,
        width: 50.0.w,
        child: Center(
            child: Text(
          text,
          textAlign: TextAlign.center,
        )),
      ),
    );
  }

  late TextEditingController _subjectController;

  @override
  void initState() {
    _subjectController = TextEditingController(text: widget.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          automaticallyImplyLeading: false,
          flexibleSpace: gradientContainer(null),
          title: Text(
            AppLocalizations.of(
              "Group description",
            ),
            style: whiteBold.copyWith(fontSize: 18),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      cursorColor: darkColor.withOpacity(0.4),
                      cursorHeight: 30,
                      controller: _subjectController,
                      autofocus: true,
                      decoration: InputDecoration(
                          alignLabelWithHint: false,
                          contentPadding: EdgeInsets.all(0),
                          hintText: AppLocalizations.of(
                            'Add group description',
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: darkColor, width: 2),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: darkColor, width: 2),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: darkColor, width: 2),
                          ),
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 18)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      AppLocalizations.of(
                        "The group description is visible to participants of this group and people invited to this group.",
                      ),
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _button(
                    AppLocalizations.of(
                      "Cancel",
                    ),
                    0,
                    0.5, () {
                  Navigator.pop(context);
                }),
                _button("OK", 0.5, 0, () {
                  Navigator.pop(context);
                  widget.changeDescription!(_subjectController.text);
                }),
              ],
            )
          ],
        ));
  }
}
