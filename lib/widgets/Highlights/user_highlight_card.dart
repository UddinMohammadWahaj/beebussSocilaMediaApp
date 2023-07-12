import 'package:bizbultest/models/user_highlights_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';

class UserHighlightCard extends StatelessWidget {
  final int? e;
  final UserHighlightsModel? highlight;
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;

  UserHighlightCard(
      {Key? key, this.e, this.highlight, this.onTap, this.onLongTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("first image or vide=${highlight!.firstImageOrVideo}");
    return Padding(
      padding: EdgeInsets.only(right: 25, left: e == 0 ? 10 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap ?? () {},
            onLongPress: onLongTap ?? () {},
            child: Container(
              width: 80,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                shape: BoxShape.rectangle,
                border: new Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(2),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: Image(
                        image: CachedNetworkImageProvider(
                          highlight!.firstImageOrVideo!
                              .replaceAll(".mp4", ".jpg") ?? "",
                        ),
                        fit: BoxFit.cover,
                        height: 100,
                        alignment: Alignment.topCenter,
                      ),
                    )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Container(
              width: 80,
              child: Text(
                AppLocalizations.of(highlight!.highlightText!),
                style: TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
