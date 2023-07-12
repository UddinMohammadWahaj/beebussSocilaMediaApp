import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TrendingTopicsHeader extends StatefulWidget {
  final Function? onChanged;
  final TextEditingController? searchTags;

  TrendingTopicsHeader({Key? key, this.onChanged, this.searchTags})
      : super(key: key);
  @override
  _TrendingTopicsHeaderState createState() => _TrendingTopicsHeaderState();
}

class _TrendingTopicsHeaderState extends State<TrendingTopicsHeader> {
  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  size: 25,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  AppLocalizations.of("Trending Topics"),
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      fontFamily: "Helvetica Neue"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
