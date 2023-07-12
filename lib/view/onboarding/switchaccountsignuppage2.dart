import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/services/user_registration.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/utilities/values.dart';
import 'package:bizbultest/view/login_page.dart';
import 'package:bizbultest/widgets/custom_radio_tile.dart';
import 'package:bizbultest/widgets/drop_down_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/current_user.dart';
import '../landing_page.dart';
import '../switchaccountlandingpage.dart';

class SwitchAccountSignUpPage2 extends StatefulWidget {
  static const String routeName = '/signUpPage2';
  User? currentUser;
  SwitchAccountSignUpPage2({this.currentUser});

  @override
  _SwitchAccountSignUpPage2State createState() =>
      _SwitchAccountSignUpPage2State();
}

class _SwitchAccountSignUpPage2State extends State<SwitchAccountSignUpPage2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late String _gender = '';
  late String _month;
  late String _date;
  late String _year;

  int monthNumber(String monthName) {
    switch (monthName) {
      case "January":
        return 1;
      case "February":
        return 2;
      case "March":
        return 3;
      case "April":
        return 4;
      case "May":
        return 5;
      case "June":
        return 6;
      case "July":
        return 7;
      case "August":
        return 8;
      case "September":
        return 9;
      case "October":
        return 10;
      case "November":
        return 11;
      case "December":
        return 12;

      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryWhiteColor,
      appBar: AppBar(
        backgroundColor: primaryWhiteColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            isIOS ? Icons.keyboard_arrow_left : Icons.keyboard_backspace,
            size: 40,
            color: primaryBlackColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          width: _currentScreenSize.width,
          height: _currentScreenSize.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/birthday.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
                Text(
                  AppLocalizations.of(
                    'Add Your Birthday',
                  ),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(
                    "This won't be part of your public profile",
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomDropDownButton(
                      list: months,
                      hint: AppLocalizations.of(
                        'Month',
                      ),
                      value: _month,
                      onChange: (value) {
                        setState(() {
                          _month = value!;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomDropDownButton(
                      list: List.generate(30, (index) {
                        return (index + 1).toString();
                      }),
                      hint: AppLocalizations.of(
                        'Date',
                      ),
                      value: _date,
                      onChange: (value) {
                        setState(() {
                          _date = value!;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomDropDownButton(
                      list: List.generate(100, (index) {
                        return (2008 - index).toString();
                      }),
                      hint: AppLocalizations.of(
                        'Year',
                      ),
                      value: _year,
                      onChange: (value) {
                        setState(() {
                          _year = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                CustomRadioTile(
                  onPressed: () {
                    setState(() {
                      _gender = 'Female';
                    });
                  },
                  onTap: (val) {
                    setState(() {
                      _gender = 'Female';
                    });
                  },
                  value: 'Female',
                  groupValue: _gender,
                ),
                CustomRadioTile(
                  onPressed: () {
                    setState(() {
                      _gender = 'Male';
                    });
                  },
                  onTap: (val) {
                    setState(() {
                      _gender = 'Male';
                    });
                  },
                  value: 'Male',
                  groupValue: _gender,
                ),
                CustomRadioTile(
                  onPressed: () {
                    setState(() {
                      _gender = 'Prefer Not To Say';
                    });
                  },
                  onTap: (val) {
                    setState(() {
                      _gender = 'Prefer Not To Say';
                    });
                  },
                  value: 'Prefer Not To Say',
                  groupValue: _gender,
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoButton(
                  child: Container(
                    width: _currentScreenSize.width,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(
                          'Next',
                        ),
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                  color: primaryBlueColor,
                  onPressed: () async {
                    print(
                        "current user tradesmantype=${widget.currentUser!.tradesmanType} countrycode=${widget.currentUser!.code}");
                    // return;
                    if (_date == null || _year == null || _month == null) {
                      ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                          .showSnackBar(
                        showSnackBar(
                          AppLocalizations.of(
                            'Please select your date of birth',
                          ),
                        ),
                      );
                    }
                    if (_gender.isEmpty) {
                      // ignore: deprecated_member_use
                      ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                          .showSnackBar(
                        showSnackBar(
                          AppLocalizations.of(
                            'Please select your gender',
                          ),
                        ),
                      );
                    } else {
                      widget.currentUser!.gender = _gender;
                      widget.currentUser!.dobDay = int.parse(_date);
                      widget.currentUser!.dobMonth = monthNumber(_month);
                      widget.currentUser!.dobYear = int.parse(_year);
                      // print(
                      //     "current user add here=${widget.currentUser.memberType}");
                      // return;

                      ///Registering user to server
                      String response = await UserRegister
                          .registerUserToTheServerSwitchAccount(
                              widget.currentUser!);
                      if (response.isNotEmpty) {
                        if (response.contains(',')) {
                          widget.currentUser!.memberID = response.split(',')[0];
                          widget.currentUser!.token = response.split(',')[1];
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SwitchAccountLandingPage(
                                memberID: widget.currentUser!.memberID,
                                country: widget.currentUser!.code,
                                currentUser: widget.currentUser);
                          }));
                        } else
                          ScaffoldMessenger.of(
                                  _scaffoldKey.currentState!.context)
                              .showSnackBar(
                            showSnackBar(response),
                          );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return SwitchAccountLandingPage(
                                memberID: widget.currentUser!.memberID,
                                country: widget.currentUser!.code,
                                currentUser: widget.currentUser);
                          }),
                        );
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                // CupertinoButton(
                //   child: RichText(
                //     text: TextSpan(
                //       children: [
                //         TextSpan(
                //           text: AppLocalizations.of(
                //                 'Have an account?',
                //               ) +
                //               " ",
                //           style: buttonTextStyle.copyWith(
                //             color: primaryBlackColor,
                //           ),
                //         ),
                //         TextSpan(
                //           text: AppLocalizations.of(
                //             'Log In',
                //           ),
                //           style: buttonTextStyle.copyWith(
                //             color: primaryBlueColor,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //   color: Colors.transparent,
                //   onPressed: () {
                //     Navigator.pushNamed(context, LoginPage.routeName);
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
