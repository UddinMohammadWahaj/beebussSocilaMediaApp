import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/country_code_model.dart';
import 'package:bizbultest/services/country_code.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utilities/values.dart';

class SwitchAccountCountrySelection extends StatefulWidget {
  User? currentUser;
  Function? setCountry;
  SwitchAccountCountrySelection({this.currentUser, this.setCountry});

  @override
  _SwitchAccountCountrySelectionState createState() =>
      _SwitchAccountCountrySelectionState();
}

class _SwitchAccountCountrySelectionState
    extends State<SwitchAccountCountrySelection> {
  List<String> listCountry = [];
  late CountryCodeModel valueItem;
  void getCountryCode() async {
    List<String> x = [];
    await CountryCode().getCountryCode();
    countryCodeList.forEach((element) {
      x.add(element.display);
    });
    setState(() {
      listCountry = x;
    });
  }

  @override
  void initState() {
    getCountryCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      width: MediaQuery.of(context).size.width / 5,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DropdownButton<CountryCodeModel>(
          value: valueItem,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          hint: Text(
            AppLocalizations.of('code'),
          ),
          underline: Container(height: 0),
          onChanged: (value) {
            setState(() {
              valueItem = value!;
            });
            widget.setCountry!(value!.value);
            // widget.currentUser.code = value.value;
            countryCode = value.value;
          },
          items: countryCodeList.map<DropdownMenuItem<CountryCodeModel>>(
              (CountryCodeModel value) {
            return DropdownMenuItem<CountryCodeModel>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
        ),
      ),
    );
  }
}
