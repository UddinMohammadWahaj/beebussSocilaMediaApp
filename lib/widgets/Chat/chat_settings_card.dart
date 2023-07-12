import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final padding;

  SettingItem({this.icon, this.title, this.subtitle, this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    if (subtitle == null) {
      return ListTile(
        contentPadding:
            padding ?? EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: icon == null
            ? null
            : Container(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: darkColor,
                ),
              ),
        title: Text(
          title!,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap!,
      );
    }
    return ListTile(
      contentPadding: padding ?? null,
      leading: icon == null
          ? null
          : Container(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: darkColor,
              ),
            ),
      title: Text(
        title!,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle!),
      onTap: onTap!,
    );
  }
}
