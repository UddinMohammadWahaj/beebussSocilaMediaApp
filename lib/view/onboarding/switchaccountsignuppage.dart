import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/user.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/services/user_registration.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/utilities/validator.dart';
import 'package:bizbultest/view/login_page.dart';
import 'package:bizbultest/view/onboarding/signup_page2.dart';
import 'package:bizbultest/view/onboarding/switchaccountsignuppage2.dart';
import 'package:bizbultest/view/web_view.dart';
import 'package:bizbultest/widgets/country_select_switch_account.dart';
import 'package:bizbultest/widgets/country_selection.dart';
import 'package:bizbultest/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../services/current_user.dart';
import '../../utilities/values.dart';

class SwitchSignUpPage1 extends StatefulWidget {
  // s
  String from;
  @override
  SwitchSignUpPage1({this.from = ''});
  _SwitchSignUpPage1State createState() => _SwitchSignUpPage1State();
}

class _SwitchSignUpPage1State extends State<SwitchSignUpPage1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController fullNameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController usernameTextEditingController = TextEditingController();
  FocusNode emailFieldFocusNode = FocusNode();
  FocusNode passwordFieldFocusNode = FocusNode();
  FocusNode fullNameFieldFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode usernameFieldFocusNode = FocusNode();
  bool showUserNameIcon = false;
  String error = '';
  bool errorEmail = false;
  bool errorFullName = false;
  bool errorPhone = false;
  bool errorUsername = false;
  bool errorCode = false;
  bool errorPassword = false;
  bool obscurePassword = true;

  User currentUser = User();
  void validateFields() {
    emailFieldFocusNode.addListener(() async {
      if (!emailFieldFocusNode.hasFocus) {
        if (!validateEmail(emailTextEditingController.text)) {
          ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
            showSnackBar(
              AppLocalizations.of('Invalid Email'),
            ),
          );

          setState(() {
            errorEmail = true;
          });
        } else {
          String text = await UserRegister.checkUserEmail(
              emailTextEditingController.text);
          if (text != '') {
            usernameTextEditingController.text = text;
            setState(() {
              errorEmail = false;
            });
            setState(() {
              showUserNameIcon = true;
            });
          } else {
            ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                .showSnackBar(
              showSnackBar(
                AppLocalizations.of(
                  'Email Already Exits! Try to login',
                ),
              ),
            );
            setState(() {
              errorEmail = true;
            });
          }
        }
      }
    });

    fullNameFieldFocusNode.addListener(() async {
      if (!fullNameFieldFocusNode.hasFocus) {
        if (!validateName(fullNameTextEditingController.text)) {
          error = 'Invalid Name';
          ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
            showSnackBar(
              AppLocalizations.of('Invalid Name'),
            ),
          );
          setState(() {
            errorFullName = true;
          });
        } else {
          setState(() {
            errorFullName = false;
          });
        }
      }
    });

    usernameFieldFocusNode.addListener(() async {
      if (!usernameFieldFocusNode.hasFocus) {
        if (validateName(usernameTextEditingController.text)) {
          if (!await UserRegister.checkUserIDExist(
              usernameTextEditingController.text)) {
            ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                .showSnackBar(
              showSnackBar(
                AppLocalizations.of('Invalid username'),
              ),
            );
            setState(() {
              errorUsername = true;
            });
          } else {
            setState(() {
              errorUsername = false;
            });
          }
        } else {
          ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
            showSnackBar(
              AppLocalizations.of('Invalid username'),
            ),
          );
          setState(() {
            errorUsername = true;
          });
        }
      }
    });

    phoneFocusNode.addListener(() async {
      if (!phoneFocusNode.hasFocus) {
        if (phoneTextEditingController.text.length <= 0) {
          ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
            showSnackBar(
              AppLocalizations.of('Invalid Phone Number'),
            ),
          );
          errorPhone = true;
        } else {
          if (currentUser.code != null) {
            if (!await UserRegister.checkUserPhoneNumberExist(
                currentUser.code!, phoneTextEditingController.text)) {
              ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                  .showSnackBar(
                showSnackBar(
                  AppLocalizations.of(
                    'Phone Number Already in use',
                  ),
                ),
              );
              errorPhone = true;
            } else {
              errorPhone = false;
            }
          } else {
            ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                .showSnackBar(
              showSnackBar(
                AppLocalizations.of(
                  'Please Select Country Code',
                ),
              ),
            );
          }
        }
      }
    });

    passwordFieldFocusNode.addListener(() async {
      if (!passwordFieldFocusNode.hasFocus) {
        if (validatePassword(passwordTextEditingController.text)) {
          errorPassword = true;
          ScaffoldMessenger.of(_scaffoldKey.currentState!.context).showSnackBar(
            showSnackBar(
                AppLocalizations.of('Password must be at least 6 characters.')),
          );
        } else {
          errorPassword = false;
        }
      }
    });
  }

  int tradesmanType = 0;
  String tradesmanString = 'Solo';
  List<Map> tradesmanTypes = [
    {
      "id": 0,
      "name": "Solo",
    },
    {
      "id": 1,
      "name": "Company",
    },
  ];

  int selectedType = 0;
  List<Map> memberTypes = [
    {
      "id": 0,
      "name": "User",
    },
    {
      "id": 1,
      "name": "Estate Agent",
    },
    {
      "id": 3,
      "name": "Tradesman",
    },
    {
      "id": 2,
      "name": "Shopping merchant",
    },
  ];

  @override
  void initState() {
    validateFields();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryWhiteColor,
      appBar: AppBar(
        toolbarHeight: widget.from == 'profile' ? kToolbarHeight : 0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(10),
          width: _currentScreenSize.width,
          height: _currentScreenSize.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/splash_main.png',
                  height: 10.0.h,
                  width: 15.0.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  label: AppLocalizations.of(
                    'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.clear,
                  showIcon: errorEmail,
                  textEditingController: emailTextEditingController,
                  focusNode: emailFieldFocusNode,
                ),
                CustomTextField(
                  label: AppLocalizations.of(
                    'Full Name',
                  ),
                  keyboardType: TextInputType.name,
                  icon: Icons.clear,
                  showIcon: errorFullName,
                  textEditingController: fullNameTextEditingController,
                  focusNode: fullNameFieldFocusNode,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SwitchAccountCountrySelection(
                        currentUser: this.currentUser,
                        setCountry: (country) {
                          this.currentUser.code = country;
                          countryCode = this.currentUser.code;
                          print('country=${this.currentUser.code}');
                        },
                      ),
                      CustomTextField(
                        label: AppLocalizations.of(
                          'Phone',
                        ),
                        inputWidth: _currentScreenSize.width / 1.6,
                        keyboardType: TextInputType.phone,
                        icon: Icons.clear,
                        showIcon: errorPhone,
                        textEditingController: phoneTextEditingController,
                        focusNode: phoneFocusNode,
                      ),
                    ],
                  ),
                ),
                CustomTextField(
                  label: AppLocalizations.of(
                    'Username',
                  ),
                  keyboardType: TextInputType.name,
                  icon: errorUsername ? Icons.clear : Icons.refresh,
                  showIcon: errorUsername || showUserNameIcon,
                  textEditingController: usernameTextEditingController,
                  focusNode: usernameFieldFocusNode,
                  iconColor: errorUsername ? Colors.red : Colors.green,
                  onPressedIcon: () async {
                    if (!errorUsername) {
                      String text = await UserRegister.checkUserEmail(
                          emailTextEditingController.text);
                      if (text != '') {
                        usernameTextEditingController.text = text;
                        setState(() {
                          errorEmail = false;
                        });
                      } else {
                        ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                            .showSnackBar(
                          showSnackBar(AppLocalizations.of(
                              'Email Already Exits! Try to login')),
                        );
                        setState(() {
                          errorEmail = true;
                        });
                      }
                    }
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: double.infinity,
                  child: DropdownButtonFormField<dynamic>(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    value: selectedType,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    hint: Text(
                      AppLocalizations.of('code'),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                        print("selected type=$selectedType");
                      });
                      currentUser.code = value.value;
                      // countryCode = value.value;
                    },
                    items: memberTypes.map<DropdownMenuItem>((value) {
                      return DropdownMenuItem(
                        value: value["id"],
                        child: Text(value["name"]),
                      );
                    }).toList(),
                  ),
                ),
                selectedType == 3
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        width: double.infinity,
                        child: DropdownButtonFormField<dynamic>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          value: tradesmanType,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          hint: Text(
                            AppLocalizations.of('code'),
                          ),
                          onChanged: (value) {
                            setState(() {
                              tradesmanType = value;
                              if (tradesmanType == 0)
                                tradesmanString = 'solo';
                              else
                                tradesmanString = 'company';
                              print("selected type=$tradesmanString");
                            });

                            currentUser.tradesmanType = tradesmanString;
                            countryCode = value.value;
                          },
                          items: tradesmanTypes.map<DropdownMenuItem>((value) {
                            return DropdownMenuItem(
                              value: value["id"],
                              child: Text(value["name"]),
                            );
                          }).toList(),
                        ),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                CustomTextField(
                  label: AppLocalizations.of(
                    'Password',
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: obscurePassword,
                  icon: obscurePassword
                      ? FontAwesomeIcons.solidEyeSlash
                      : FontAwesomeIcons.solidEye,
                  showIcon: true,
                  iconColor: primaryBlackColor,
                  textEditingController: passwordTextEditingController,
                  focusNode: passwordFieldFocusNode,
                  onPressedIcon: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
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
                          'Sign up',
                        ),
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                  color: primaryBlueColor,
                  onPressed: () async {
                    if (emailTextEditingController.text.isEmpty &&
                            phoneTextEditingController.text.isEmpty &&
                            fullNameTextEditingController.text.isEmpty &&
                            usernameTextEditingController.text.isEmpty &&
                            passwordTextEditingController.text.isEmpty ||
                        countryCode == null) {
                      ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                          .showSnackBar(
                        showSnackBar(
                            AppLocalizations.of('Please enter all the fields')),
                      );
                    } else if (errorEmail ||
                        errorUsername ||
                        errorPhone ||
                        errorFullName ||
                        errorPhone) {
                      ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                          .showSnackBar(
                        showSnackBar(
                            AppLocalizations.of('Please enter correct data')),
                      );
                    } else {
                      User user = User(
                        email: emailTextEditingController.text,
                        phone: phoneTextEditingController.text,
                        fullName: fullNameTextEditingController.text,
                        username: usernameTextEditingController.text,
                        password: passwordTextEditingController.text,
                        memberType: selectedType,
                        code: this.currentUser.code,
                        tradesmanType: tradesmanString,
                      );
                      currentUser = user;
                      // print("current user add =${user.tradesmanType}");
                      // return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SwitchAccountSignUpPage2(
                                currentUser: currentUser),
                          ));
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(
                          'By continuing, you agree with our' + " ",
                        ),
                        style: buttonTextStyle.copyWith(
                          color: greyColor,
                        ),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(
                          'Terms',
                        ),
                        style: buttonTextStyle.copyWith(
                          color: primaryBlackColor,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebsiteView(
                                          url: 'https://www.bebuzee.com/terms',
                                          heading: 'Terms',
                                        )));
                          },
                      ),
                    ],
                  ),
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
                //           style: TextStyle(
                //             color: primaryBlackColor,
                //             fontSize: 16,
                //           ),
                //         ),
                //         // TextSpan(
                //         //   text: AppLocalizations.of(
                //         //     'Log In',
                //         //   ),
                //         //   style: TextStyle(
                //         //     color: primaryBlueColor,
                //         //     fontSize: 16,
                //         //   ),
                //         // ),
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
