import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/feeds_model.dart';
import 'package:bizbultest/services/Bookmarks/bookmark_api_calls.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateBoardCard extends StatefulWidget {
  final String? image;
  final String? postID;

  const CreateBoardCard({Key? key, this.image, this.postID}) : super(key: key);

  @override
  _CreateBoardCardState createState() => _CreateBoardCardState();
}

class _CreateBoardCardState extends State<CreateBoardCard> {
  TextEditingController _controller = TextEditingController();
  Color _accentColor = primaryBlueColor;
  String boardName = "";
  bool isSecret = false;

  BoxDecoration _boxDecoration(double radius) {
    return new BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(radius)), shape: BoxShape.rectangle, color: Colors.grey.shade200);
  }

  Color _textColor() {
    if (boardName.isEmpty) {
      return Colors.grey.shade500;
    } else {
      return Colors.white;
    }
  }

  Color _buttonColor() {
    if (boardName.isEmpty) {
      return Colors.grey.shade200;
    } else {
      return _accentColor;
    }
  }

  Widget _closeButton(BuildContext context) {
    return IconButton(
      splashRadius: 20,
      constraints: BoxConstraints(),
      icon: Icon(
        Icons.close,
        color: Colors.black54,
        size: 35,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      padding: EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _appBarTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            child: Text(
          AppLocalizations.of(
            "Create board",
          ),
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),
        )),
        _createButton()
      ],
    );
  }

  Widget _createButton() {
    return GestureDetector(
      onTap: () {
        customToastWhite(
            AppLocalizations.of(
              "New board created",
            ),
            15,
            ToastGravity.BOTTOM);
        Get.back();
        Get.back();
        BookMarkApiCalls.createNewBoard(widget.postID!, _controller.text, isSecret);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: new BoxDecoration(
          color: _buttonColor(),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          shape: BoxShape.rectangle,
        ),
        child: Text(
          AppLocalizations.of('Create'),
          style: TextStyle(fontSize: 16, color: _textColor()),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      titleSpacing: 15,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      leading: _closeButton(context),
      title: _appBarTitle(),
    );
  }

  Widget _imageCard() {
    print(widget.image);
    return Positioned.fill(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 83.5,
          height: 70,
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            child: Image.network(
              widget.image!,
              fit: BoxFit.cover,
              width: 75,
              height: 70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _boxCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 100,
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          Container(height: 70, width: 120, decoration: _boxDecoration(10)),
          Positioned.fill(
            right: 35,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 1.5,
                height: 70,
                color: Colors.white,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 35,
                height: 1.5,
                color: Colors.white,
              ),
            ),
          ),
          _imageCard()
        ],
      ),
    );
  }

  Widget _boardName() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          AppLocalizations.of(
            "Board name",
          ),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey.shade800),
        ));
  }

  Widget _textField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        autofocus: true,
        onChanged: (val) {
          setState(() {
            boardName = val;
          });
        },
        maxLines: 1,
        textCapitalization: TextCapitalization.words,
        cursorColor: _accentColor,
        cursorHeight: 30,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _switcher() {
    return Switch(
        activeColor: Colors.green,
        inactiveTrackColor: Colors.grey.shade500,
        inactiveThumbColor: Colors.grey.shade700,
        value: isSecret,
        onChanged: (val) {
          setState(() {
            isSecret = val;
          });
        });
  }

  Widget _visibilityTile() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      title: Text(
        AppLocalizations.of('Visibility'),
        style: TextStyle(fontSize: 15),
      ),
      subtitle: Text(
        AppLocalizations.of(
          "Keep this board secret",
        ),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      trailing: _switcher(),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade500,
      thickness: 0.3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _boxCard(),
            SizedBox(
              height: 20,
            ),
            _boardName(),
            _textField(),
            SizedBox(
              height: 20,
            ),
            _divider(),
            _visibilityTile()
          ],
        ),
      ),
    );
  }
}
