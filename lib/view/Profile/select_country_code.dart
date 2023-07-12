import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/country_codes_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SelectCountryCode extends StatefulWidget {
  final List<CountryCodesModel>? countryList;
  final String? currentValue;
  final String? currentCode;
  final Function? setCode;

  const SelectCountryCode(
      {Key? key,
      this.countryList,
      this.currentValue,
      this.setCode,
      this.currentCode})
      : super(key: key);

  @override
  _SelectCountryCodeState createState() => _SelectCountryCodeState();
}

class _SelectCountryCodeState extends State<SelectCountryCode> {
  TextEditingController _controller = TextEditingController();

  List<CountryCodesModel> countries = [];
  List<CountryCodesModel> filteredCountries = [];
  String selectedValue = "";
  String selectedCode = "";

  void _searchCountries(String name) async {
    setState(() {
      filteredCountries = countries
          .where((element) => element.name
              .toString()
              .toLowerCase()
              .contains(name.toLowerCase()))
          .toList();
    });
    print(filteredCountries.length);
  }

  void _onTap(int index) {
    int val = countries[index].name!.split(" ").length - 1;
    //print(selectedCode = countries[index].name.split(" ")[val]);
    countries.forEach((element) {
      if (element.usersCountry == 1) {
        setState(() {
          element.usersCountry = 0;
        });
      }
    });
    setState(() {
      countries[index].usersCountry = 1;
      selectedValue = countries[index].value!;
      selectedCode = countries[index].name!.split(" ")[val];
    });
  }

  void _onTapFilter(int index) {
    int val = filteredCountries[index].name!.split(" ").length - 1;
    filteredCountries.forEach((element) {
      if (element.usersCountry == 1) {
        setState(() {
          element.usersCountry = 0;
        });
      }
    });
    setState(() {
      filteredCountries[index].usersCountry = 1;
      selectedValue = filteredCountries[index].value!;
      selectedCode = filteredCountries[index].name!.split(" ")[val];
    });
    /* countries.forEach((element) {
      if(element.usersCountry == 1) {
        setState(() {
          element.usersCountry = 0;
        });
      }
    });
    countries.where((element) {
      if (element.value == filteredCountries[index].value) {
        setState(() {
          element.usersCountry = 1;
        });
      }
      return true;
    });*/
  }

  @override
  void initState() {
    countries = widget.countryList!;
    selectedValue = widget.currentValue!;
    selectedCode = widget.currentCode!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(
                "Country Code",
              ),
              style: TextStyle(color: Colors.black),
            ),
            Builder(builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 30,
                ),
                onPressed: () {
                  print(widget.currentCode);
                  print(widget.currentValue);
                  widget.setCode!(selectedValue, selectedCode);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
        brightness: Brightness.light,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextFormField(
                onChanged: (val) {
                  if (val != "") {
                    _searchCountries(val);
                  } else {}
                },
                controller: _controller,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black, fontSize: 16),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,

                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: AppLocalizations.of(
                    "Search...",
                  ),

                  contentPadding: EdgeInsets.only(top: 15),
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  alignLabelWithHint: true,
                  // contentPadding: EdgeInsets.zero
                  // 48 -> icon width
                ),
              ),
            ),
          ),
          Container(
            height: 100.0.h - 90 - 106,
            child: _controller.text.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: filteredCountries[index].usersCountry == 1
                            ? Colors.grey.withOpacity(0.4)
                            : Colors.transparent,
                        onTap: () {
                          _onTapFilter(index);
                        },
                        dense: false,
                        title: Container(
                          width: 80.0.w,
                          child: Text(
                            filteredCountries[index].name!,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: filteredCountries[index].usersCountry == 1
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 30,
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                      );
                    })
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: countries[index].usersCountry == 1
                            ? Colors.grey.withOpacity(0.4)
                            : Colors.transparent,
                        onTap: () {
                          _onTap(index);
                        },
                        dense: false,
                        title: Container(
                          width: 80.0.w,
                          child: Text(
                            countries[index].name!,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: countries[index].usersCountry == 1
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 30,
                              )
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                      );
                    }),
          )
        ],
      ),
    );
  }
}
