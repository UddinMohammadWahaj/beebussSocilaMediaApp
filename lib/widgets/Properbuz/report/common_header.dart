import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportCommonHeader extends StatelessWidget {
  final String? title;
  const ReportCommonHeader({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: ListTile(
        onTap: () => Get.back(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        title: Text(
          AppLocalizations.of(title!),
          style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.normal),
        ),
        trailing: Icon(
          Icons.close,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
