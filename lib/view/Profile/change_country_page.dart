import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../services/current_user.dart';
import '../../services/profile_api_calls.dart';
import '../../settings_model.dart';
import '../../utilities/snack_bar.dart';

class ChangeCountryData extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  SettingsModel? countryList = new SettingsModel(country: []);
  ChangeCountryData({Key? key, this.scaffoldKey, this.countryList})
      : super(key: key);

  @override
  State<ChangeCountryData> createState() => _ChangeCountryDataState();
}

class _ChangeCountryDataState extends State<ChangeCountryData> {
  Color _shadowColor = HexColor("#3150cc");

  @override
  Widget build(BuildContext context) {
    Widget _divider() {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            thickness: 0.1,
            color: Colors.black,
          ));
    }

    TextStyle _commonStyle(double size, FontWeight weight) {
      return GoogleFonts.heebo(
          fontSize: size, fontWeight: weight, color: Colors.black);
    }

    Widget _countryTile(String title, String flag, int index, int lastIndex,
        VoidCallback onTap) {
      return Column(
        children: [
          ListTile(
            onTap: onTap,
            dense: true,
            title: Text(
              title,
              style: _commonStyle(16, FontWeight.w500),
            ),
            trailing: Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: _shadowColor,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                    radius: 20,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    child: Text(
                      flag,
                      style: TextStyle(fontSize: 16),
                    ))),
          ),
          index == lastIndex ? Container() : _divider()
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            size: 25,
            color: Colors.black,
          ),
          splashRadius: 20,
          constraints: BoxConstraints(),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(
            "Country",
          ),
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 22),
        ),
      ),
      body: Container(
        // height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 10,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(
          //         Radius.circular(_cardBorderRadius))),
          // color: _cardColor,

          child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemCount: widget.countryList!.country?.length ?? 0,
              itemBuilder: (context, index) {
                return _countryTile(
                    widget.countryList!.country![index].name,
                    widget.countryList!.country![index].flagIcon,
                    index,
                    widget.countryList!.country!.length - 1, () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(
                          widget.scaffoldKey!.currentState!.context)
                      .showSnackBar(blackSnackBar(AppLocalizations.of(
                          'Switched to ${widget.countryList!.country![index].name}')));
                  setState(() {
                    CurrentUser().currentUser.country =
                        widget.countryList!.country![index].value;
                  });
                  ProfileApiCalls.changeCountry(
                      widget.countryList!.country![index].name);
                });
              }),
        ),
      ),
    );
  }
}
