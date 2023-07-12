import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HashtagPage extends StatefulWidget {
  final String? logo;
  final String? memberID;
  final String? country;
  final String? hashtag;

  HashtagPage({Key? key, this.logo, this.memberID, this.country, this.hashtag})
      : super(key: key);

  @override
  _HashtagPageState createState() => _HashtagPageState();
}

class _HashtagPageState extends State<HashtagPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.11),
        child: Container(
          child: AppBar(
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.network(widget.logo!, fit: BoxFit.contain)
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.menu,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 3,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        child: Container(
          child: (Text(
            AppLocalizations.of("Hashtags Feeds:") + " " + widget.hashtag!,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
