import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  final IconData? iconData;
  final VoidCallback? onPressed;
  final double? size;

  const AppBarIcon({Key? key, this.iconData, this.onPressed, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          splashRadius: 20,
          icon: Icon(
            iconData,
            color: directAppBarIconColor,
            size: size ?? 25,
          ),
          onPressed: onPressed,
        );
      },
    );
  }
}
