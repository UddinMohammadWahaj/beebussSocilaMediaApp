import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final String? value;
  const CustomCheckBox({Key? key, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.transparent,
      child: Row(
        children: [
          Icon(
            CupertinoIcons.square,
            color: settingsColor,
          ),
          SizedBox(width: 5),
          Text(
            value!,
            style: TextStyle(fontSize: 14.5, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
