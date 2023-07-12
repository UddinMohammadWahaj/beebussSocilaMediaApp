import 'dart:async';
import 'package:bizbultest/models/discover_hashtags.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/discover_people_from_tags.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Language/appLocalization.dart';

class DiscoverTagCard extends StatelessWidget {
  final VoidCallback? onTap;
  final DiscoverHashtagsModel? tags;

  const DiscoverTagCard({Key? key, this.tags, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: new BoxDecoration(
            color: Color.fromRGBO(
                int.parse(tags!.color!
                    .substring(4, tags!.color!.length - 1)
                    .split(",")[0]),
                int.parse(tags!.color!
                    .substring(4, tags!.color!.length - 1)
                    .split(",")[1]),
                int.parse(tags!.color!
                    .substring(4, tags!.color!.length - 1)
                    .split(",")[2]),
                1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Center(
              child: Text(
                AppLocalizations.of(tags!.hashtag!),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
