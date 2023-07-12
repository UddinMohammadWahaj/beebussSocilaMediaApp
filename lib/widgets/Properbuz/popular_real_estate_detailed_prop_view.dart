import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/hot_properties_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/property/common_appbar_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class PopularDetailedPropertyView extends GetView<PropertiesController> {
  final String? description;
  const PopularDetailedPropertyView({Key? key, this.description})
      : super(key: key);

  Widget _appBarTitle() {
    return CommonAppBarTitle(
      title: AppLocalizations.of(
        "Description",
      ),
      buttonTitle: "",
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        backgroundColor: appBarColor,
        elevation: 0,
        brightness: Brightness.dark,
        title: _appBarTitle(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Html(
            data: description,
            // defaultTextStyle: TextStyle(
            //     fontSize: 18, color: Colors.grey.shade700, height: 1.5),
          ),
        ),
      ),
    );
  }
}
