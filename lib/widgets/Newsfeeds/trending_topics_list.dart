import 'package:bizbultest/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';

class TrendingTopicList extends StatelessWidget {
  final String? color;
  final String? hashtag;
  final VoidCallback? onPressed;

  TrendingTopicList({Key? key, this.color, this.hashtag, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Center(
        child: GestureDetector(
          onTap: onPressed ?? () {},
          /*  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HashtagPage(
                      hashtag: filteredHashtags.hashtags[index].hashtag,
                      memberID: widget.memberID,
                      country: widget.country,
                      logo: widget.logo,
                    )));*/

          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                color: Color.fromRGBO(
                    int.parse(
                        color!.substring(4, color!.length - 1).split(",")[0]),
                    int.parse(
                        color!.substring(4, color!.length - 1).split(",")[1]),
                    int.parse(
                        color!.substring(4, color!.length - 1).split(",")[2]),
                    1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    AppLocalizations.of(hashtag!),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
