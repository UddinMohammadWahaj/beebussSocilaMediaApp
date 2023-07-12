import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/people_search_model.dart';
import 'package:bizbultest/services/BuzzfeedControllers/buzzfeedmaincontroller.dart';
import 'package:bizbultest/widgets/accounts_search.dart';
import 'package:bizbultest/widgets/place_search.dart';
import 'package:bizbultest/widgets/tags_search.dart';
import 'package:bizbultest/widgets/videos_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'buzzerfeedsearch/buzzerfeedaccountsearch.dart';
import 'buzzerfeedsearch/buzzerfeedtagsearch.dart';
import 'buzzfeedtrendingtoday.dart';

class BuzzerfeedSearchPage extends StatefulWidget {
  final String? logo;
  final String? memberID;
  final String? country;
  final String? memberImage;
  final double? lat;
  final double? long;
  final Function? changeColor;
  final Function? isChannelOpen;
  final Function? setNavBar;
  BuzzerfeedMainController? controller;

  BuzzerfeedSearchPage(
      {Key? key,
      this.logo,
      this.memberID,
      this.country,
      this.lat,
      this.controller,
      this.long,
      this.memberImage,
      this.changeColor,
      this.isChannelOpen,
      this.setNavBar})
      : super(key: key);

  @override
  BuzzerfeedSearchPageState createState() => BuzzerfeedSearchPageState();
}

class BuzzerfeedSearchPageState extends State<BuzzerfeedSearchPage> {
  TextEditingController _searchController = TextEditingController();
  String searchText = "";
  bool isVideo = false;
  TagsSearch? accounts;
  bool hasData = false;

  Widget _tab(String tabTitle) {
    return Tab(
      child: Text(
        tabTitle,
        style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  void initState() {
    print("entered discooo");
    _searchController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("entered discooo");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: isVideo == true ? Colors.black : Colors.white));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
          children: <Widget>[
            BuzzerfeedTagsSearchPage(
              logo: widget.logo!,
              country: widget.country!,
              memberID: widget.memberID!,
              search: _searchController.text,
              controller: widget.controller!,
              parent: this,
            ),
            BuzzerfeedAccountsSearch(
              setNavBar: widget.setNavBar!,
              isChannelOpen: widget.isChannelOpen!,
              changeColor: widget.changeColor!,
              memberID: widget.memberID!,
              search: _searchController.text,
              people: accounts!,
              parent: this,
            ),
            BuzzfeedTrendingToday()
            // VideosSearchPage(
            //   country: widget.country,
            //   memberID: widget.memberID,
            //   search: _searchController.text,
            //   parent: this,
            // ),
            // PlacesSearchPage(
            //   memberImage: widget.memberImage,
            //   country: widget.country,
            //   long: widget.long,
            //   lat: widget.lat,
            //   memberID: widget.memberID,
            //   search: _searchController.text,
            //   parent: this,
            // ),
          ],
        ),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          brightness: isVideo == true ? Brightness.dark : Brightness.light,
          backgroundColor: isVideo == true ? Colors.black : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              size: 28,
            ),
            color: isVideo == true ? Colors.white : Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            height: 35,
            decoration: new BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              shape: BoxShape.rectangle,
            ),
            child: TextFormField(
              cursorColor: Colors.grey,
              autofocus: true,
              onChanged: (val) {
                setState(() {
                  searchText = val;
                });
              },
              controller: _searchController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              style: TextStyle(
                  color: isVideo == true ? Colors.white : Colors.black),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: AppLocalizations.of('Search'),
                  contentPadding: EdgeInsets.only(left: 20, bottom: 12),
                  hintStyle: TextStyle(
                      fontSize: 16,
                      color: isVideo == true
                          ? Colors.white
                          : Colors.grey.withOpacity(0.8))
                  // 48 -> icon width
                  ),
            ),
          ),
          bottom: TabBar(
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isVideo ? Colors.white : Colors.black,
                  width: 2.0,
                ),
              ),
            ),
            onTap: (index) {
              if (index == 2) {
                setState(() {
                  isVideo = true;
                });
              } else {
                setState(() {
                  isVideo = false;
                });
              }
            },
            tabs: [
              _tab(
                  // AppLocalizations.of("Tags"),
                  "Hashtags"),
              _tab(
                AppLocalizations.of("Accounts"),
              ),
              _tab(
                "Trending Today",
              ),
            ],
            labelColor: isVideo ? Colors.white : Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: isVideo ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
