import 'package:bizbultest/Language/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CountryBottomSheet extends StatelessWidget {
  const CountryBottomSheet({Key? key}) : super(key: key);

  Widget _header() {
    return Container(
        width: 100.0.w,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade500, width: 0.5),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          AppLocalizations.of(
            "Select a Language",
          ),
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.normal, color: Colors.black),
          textAlign: TextAlign.center,
        ));
  }

  Widget _countryCard(String flag, String name, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45.0.w,
        decoration: new BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: new Border.all(
            color: Colors.grey.shade700,
            width: 2,
          ),
        ),
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              flag,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _close() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(),
        SizedBox(
          height: 12,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 40.0.h,
          child: ListView(
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 15,
                direction: Axis.horizontal,
                spacing: 5.0.w - 20,
                children: [
                  _countryCard("🇧🇷", "Brazil", () {}),
                  _countryCard("🇨🇦", "Canada", () {}),
                  _countryCard("🇨🇳", "China", () {}),
                  _countryCard("🇪🇬", "Egypt", () {}),
                  _countryCard("🏴󠁧󠁢󠁥󠁮󠁧󠁿", "England", () {}),
                  _countryCard("🇫🇷", "France", () {}),
                  _countryCard("🇩🇪", "Germany", () {}),
                  _countryCard("🌎", "Global", () {}),
                  _countryCard("🇬🇷", "Greece", () {}),
                  _countryCard("🇭🇰", "Hong Kong", () {}),
                  _countryCard("🇮🇳", "India", () {}),
                  _countryCard("🇮🇩", "Indonesia", () {}),
                  _countryCard("🇮🇷", "Iran", () {}),
                  _countryCard("🇮🇹", "Italy", () {}),
                  _countryCard("🇯🇵", "Japan", () {}),
                  _countryCard("🇰🇷", "Korea", () {}),
                  _countryCard("🇱🇧", "Lebanon", () {}),
                  _countryCard("🇲🇾", "Malaysia", () {}),
                  _countryCard("🇲🇽", "Mexico", () {}),
                  _countryCard("🇲🇦", "Morocco", () {}),
                  _countryCard("🇵🇭", "Philippines", () {}),
                  _countryCard("🇸🇬", "Singapore", () {}),
                  _countryCard("🇹🇭", "Thailand", () {}),
                  _countryCard("🇹🇷", "Turkey", () {}),
                  _countryCard("🇺🇸", "United States", () {}),
                  _countryCard("🇻🇳", "Vietnam", () {}),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
