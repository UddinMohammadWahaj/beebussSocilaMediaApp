import 'dart:math';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Bookmarks/board_filter_model.dart';
import 'package:bizbultest/models/Bookmarks/boards_model.dart';
import 'package:bizbultest/view/Boards/board_controller.dart';
import 'package:bizbultest/view/Boards/board_posts_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SavedBoards extends StatefulWidget {
  final String? memberID;
  const SavedBoards({Key? key, this.memberID}) : super(key: key);

  @override
  _SavedBoardsState createState() => _SavedBoardsState();
}

class _SavedBoardsState extends State<SavedBoards> {
  BoardController boardController = Get.put(BoardController());
  TextEditingController controller = TextEditingController();
  List<String> _sortElements = [
    "A to Z",
    "Z to A",
    AppLocalizations.of("Last saved to"),
  ];
  List<String> _categories = [
    "Cooking Shows",
    "Music Programs",
    "Nickelodeon",
    "Prime Time TV",
    "Reality TV",
    "Sit Coms",
    "Cartoon Characters",
    "Classic Commercials",
    "Actors",
    "Actresses",
    "Blockbusters",
    "Star Wars",
    "The Hunger Games",
    "Twilight",
    "Classic Movies",
    "Comedies",
    "Disney Movies",
    "Fantasy",
    "Horror Movies",
    "Love Stories",
    "Science Fiction",
    "Bathroom Accessories",
    "Floor Coverings",
    "Furniture by Room ",
    "Furniture You Sit On (or At)",
    "Kitchen Appliances",
    "Wall Coverings",
    "Window Coverings",
    "Authors",
    "Famous Characters",
    "Genres",
    "Drama",
    "Horror",
    "Poetry",
    "Romance",
    "Westerns",
    "Mythology",
    "Reference Books",
    "Bands with One-word Names",
    "Boy Bands",
    "Children’s Songs",
    "Classical Music",
    "Eighties Music",
    "Female Singers",
    "Folk Songs",
    "Love Songs",
    "Male Singers",
    "Movie Theme Songs",
    "Musical Instruments",
    "Nineties Music",
    "Nursery Rhymes",
    "Rappers",
    "Seventies Music",
    "Sixties Music",
    "Songs with a Name in the Title",
    "T.V. Show Theme Songs",
    "Theme Songs"
  ];
  int selectedIndex = 2;
  List<int> _gridList = List<int>.generate(30, (index) => 1);
  double borderRadius = 10;
  Random random = new Random();
  String _dynamicImageUrl = "";
  List<String> _dynamicURL = [];

  Widget _closeButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: new BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          shape: BoxShape.rectangle,
        ),
        child: Text(
          AppLocalizations.of(
            "Close",
          ),
          style: TextStyle(fontSize: 18, color: Colors.grey.shade800),
        ),
      ),
    );
  }

  Widget _sortElementsListBuilder() {
    return Obx(
      () => ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: boardController.filterList.length,
          itemBuilder: (context, index) {
            return _sortTile(boardController.filterList[index]);
          }),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.centerRight,
          color: Colors.transparent,
          height: 45,
          width: 50,
          child: Icon(
            icon,
            color: Colors.black,
            size: 30,
          )),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 45,
      width: 100.0.w - (120),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: new BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        shape: BoxShape.rectangle,
      ),
      child: TextFormField(
        maxLines: 1,
        cursorColor: Colors.grey.shade600,
        controller: boardController.searchController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.search,
              color: Colors.grey.shade700,
            ),
          ),
          border: InputBorder.none,
          prefixIconConstraints: BoxConstraints(),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: AppLocalizations.of('Search'),
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ),
    );
  }

  Widget _sortTile(BoardFilterModel filter) {
    return ListTile(
      onTap: () {
        Get.back();
        boardController.getSavedBoards(filter.name!, "");
        boardController.getFilters();
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 25),
      dense: true,
      title: Text(
        filter.name!,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      trailing: filter.isDefault == true
          ? Icon(
              Icons.check,
              color: Colors.black,
              size: 30,
            )
          : null,
    );
  }

  Widget _organiseTile(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 25),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
      ),
    );
  }

  Widget _createTile(String title) {
    return ListTile(
      onTap: () {
        Get.back();
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 25),
      dense: true,
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _sortCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _headerTile(
            AppLocalizations.of(
              "Sort by",
            ),
          ),
          _sortElementsListBuilder(),
          SizedBox(
            height: 10,
          ),
          _headerTile(
            AppLocalizations.of(
              "Organize profile",
            ),
          ),
          _organiseTile(
            AppLocalizations.of(
              "Auto-sort boards",
            ),
            AppLocalizations.of(
              "Choose how you want Bebuzee to display your boards",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _organiseTile(
            AppLocalizations.of(
              "Reorder boards",
            ),
            AppLocalizations.of(
              "Drag and drop to reorder boards. It will save as your custom sort by setting",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _closeButton(),
        ],
      ),
    );
  }

  Widget _createCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _headerTile(
            AppLocalizations.of("Create"),
          ),
          _createTile(
            AppLocalizations.of("Pin"),
          ),
          _createTile(
            AppLocalizations.of("Board"),
          ),
          SizedBox(
            height: 20,
          ),
          _closeButton(),
        ],
      ),
    );
  }

  Widget _headerTile(String title) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 25),
      dense: true,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
      ),
    );
  }

  Widget _pinTextCard(BoardModel board) {
    return Container(
      width: 42.0.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            board.name!,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Text(
                board.posts!,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              ),
              Text(
                "  " + board.time!,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageCard(
      String image,
      Alignment alignment,
      double topLeft,
      double bottomLeft,
      double topRight,
      double bottomRight,
      double h,
      double w) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Container(
          width: w,
          height: h,
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeft),
                bottomLeft: Radius.circular(bottomLeft),
                topRight: Radius.circular(topRight),
                bottomRight: Radius.circular(bottomRight)),
            child: image == ""
                ? Container()
                : Image(
                    alignment: Alignment.topCenter,
                    image: CachedNetworkImageProvider(image),
                    fit: BoxFit.cover,
                    width: w,
                    height: h,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _imageBox(BoardModel board) {
    return GestureDetector(
      onTap: () {
        boardController.setNameAndDescription(board.name!, board.description!);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BoardPostsView(
                      memberID: widget.memberID,
                      board: board,
                    )));
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    height: 14.0.h,
                    width: 45.0.w,
                    decoration: new BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade200),
                  ),
                  Positioned.fill(
                    right: 15.0.w,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 1.5,
                        height: 14.0.h,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 14.0.w,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _imageCard(
                      board.image1!.replaceAll(".mp4", ".jpg"),
                      Alignment.centerLeft,
                      borderRadius,
                      borderRadius,
                      0,
                      0,
                      14.0.h,
                      30.0.w - 1.5),
                  _imageCard(
                      board.image2!.replaceAll(".mp4", ".jpg"),
                      Alignment.topRight,
                      0,
                      0,
                      borderRadius,
                      0,
                      7.0.h - 0.75,
                      15.0.w),
                  _imageCard(
                      board.image3!.replaceAll(".mp4", ".jpg"),
                      Alignment.bottomRight,
                      0,
                      0,
                      0,
                      borderRadius,
                      7.0.h - 0.75,
                      15.0.w),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            _pinTextCard(board)
          ],
        ),
      ),
    );
  }

  Widget _placeholderCard() {
    return SkeletonAnimation(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: Container(
        height: 14.0.h,
        width: 45.0.w,
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            shape: BoxShape.rectangle,
            color: Colors.grey.shade200),
      ),
    );
  }

  Widget _placeholderList() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 15,
      spacing: 5.0.w,
      alignment: WrapAlignment.spaceBetween,
      direction: Axis.horizontal,
      children: _categories.map((e) => _placeholderCard()).toList(),
    );
  }

  Widget _wrapGrid() {
    print("rebuild wrap");
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Obx(
        () => Container(
          child: boardController.isLoading.value
              ? _placeholderList()
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 15,
                  spacing: 5.0.w,
                  alignment: WrapAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: boardController.savedBoardsList
                      .map((e) => _imageBox(e))
                      .toList(),
                ),
        ),
      ),
    );
  }

/*  Widget _gridBuilder() {
    return Container(
      height: 100.0.h - (60 + 75),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: 20,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 16 / 14,
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return _imageBox();
          }),
    );
  }*/

  Widget _bottom() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _searchBar(),
          _iconButton(Icons.sort, () {
            Get.bottomSheet(_sortCard(),
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))));
          }),
          _iconButton(Icons.add, () {
            Get.bottomSheet(_createCard(),
                isScrollControlled: false,
                isDismissible: false,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0))));
          }),
        ],
      ),
    );
  }

  @override
  void initState() {
    _dynamicURL = List<String>.generate(100,
        (index) => "https://picsum.photos/id/${random.nextInt(80)}/200/300");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(50), child: _bottom()),
          leading: IconButton(
            splashRadius: 20,
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            padding: EdgeInsets.symmetric(horizontal: 0),
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          title: Text(
            AppLocalizations.of(
              "Saved boards",
            ),
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 22, color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: _wrapGrid()),
      ),
    );
  }
}
