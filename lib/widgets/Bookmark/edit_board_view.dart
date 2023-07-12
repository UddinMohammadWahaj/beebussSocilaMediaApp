import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Bookmarks/boards_model.dart';
import 'package:bizbultest/services/Bookmarks/bookmark_api_calls.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/Boards/board_posts_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EditBoardView extends StatefulWidget {
  final BoardModel? board;

  const EditBoardView({
    Key? key,
    this.board,
  }) : super(key: key);

  @override
  _EditBoardViewState createState() => _EditBoardViewState();
}

class _EditBoardViewState extends State<EditBoardView> {
  BoardPostsController boardPostsController = Get.put(BoardPostsController());
  Color _accentColor = primaryBlueColor;
  String boardName = "";
  bool isSecret = false;

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

  Widget _appBarTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            child: Text(
          AppLocalizations.of(
            "Edit board",
          ),
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black),
        )),
        _doneButton(context)
      ],
    );
  }

  Widget _doneButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        boardPostsController.editBoard(
            context, widget.board!.boardId!, isSecret);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: new BoxDecoration(
          color: _accentColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          shape: BoxShape.rectangle,
        ),
        child: Text(
          AppLocalizations.of(
            "Done",
          ),
          style: TextStyle(fontSize: 16, color: Colors.white),
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
      title: _appBarTitle(context),
    );
  }

  Widget _headerCard(String name) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          name,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey.shade800),
        ));
  }

  Widget _textField(TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        autofocus: false,
        maxLines: 1,
        textCapitalization: TextCapitalization.words,
        cursorColor: _accentColor,
        cursorHeight: 30,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        controller: controller,
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
        activeColor: _accentColor,
        inactiveTrackColor: Colors.grey.shade500,
        inactiveThumbColor: Colors.grey.shade200,
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
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        AppLocalizations.of(
          "If you don't want others to see this board, keep it secret",
        ),
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
      ),
      trailing: _switcher(),
    );
  }

  Widget _deleteTile(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.bottomSheet(_deleteBottomSheet(context),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    topRight: const Radius.circular(30.0))));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      title: Text(
        AppLocalizations.of(
          "Delete",
        ),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        AppLocalizations.of(
          "Delete this board and all of its Posts forever. You can't undo this.",
        ),
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade500,
      thickness: 0.3,
    );
  }

  Widget _actionButton(
      String name, Color textColor, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        decoration: new BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          shape: BoxShape.rectangle,
        ),
        child: Text(
          name,
          style: TextStyle(
              fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _deleteBottomSheet(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(
              "Delete board?",
            ),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            AppLocalizations.of(
              "You won't be able to get it back.",
            ),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _actionButton(
                  AppLocalizations.of(
                    "Cancel",
                  ),
                  Colors.black,
                  Colors.grey.shade200, () {
                Get.back();
              }),
              _actionButton(
                  AppLocalizations.of(
                    "Delete",
                  ),
                  Colors.white,
                  _accentColor, () {
                boardPostsController.deleteBoard(
                    context, widget.board!.boardId!);
              }),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    isSecret = widget.board!.isSecrete!;
    boardPostsController.boardNameController.text =
        boardPostsController.boardName.value;
    boardPostsController.boardDescriptionController.text =
        boardPostsController.boardDescription.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        // child: Container(
        //   padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(
              AppLocalizations.of("Name"),
            ),
            _textField(boardPostsController.boardNameController),
            SizedBox(
              height: 20,
            ),
            _headerCard(
              AppLocalizations.of("Description"),
            ),
            _textField(boardPostsController.boardDescriptionController),
            _divider(),
            _visibilityTile(),
            SizedBox(
              height: 20,
            ),
            _deleteTile(context)
          ],
        ),
      ),
      // ),
    );
  }
}
