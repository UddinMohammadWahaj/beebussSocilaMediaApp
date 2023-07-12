import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/cupertino.dart';

class CustomHeader extends StatelessWidget {
  final String? header;
  const CustomHeader({Key? key, this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10, top: 20, bottom: 10, right: 10),
        child: Text(
          header!,
          style: TextStyle(
              fontSize: 14,
              color: hotPropertiesThemeColor,
              fontWeight: FontWeight.w500),
        ));
  }
}
