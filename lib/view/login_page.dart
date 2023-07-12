import 'dart:async';
import 'dart:convert';

import 'package:bizbultest/push/notification_utils.dart';
import 'package:bizbultest/services/login_api_calls.dart';
import 'package:bizbultest/utilities/custom_toast_message.dart';
import 'package:bizbultest/view/homepage.dart';
import 'package:bizbultest/view/onboarding/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../models/user.dart';
import '../services/current_user.dart';
import '../utilities/colors.dart';
import 'onboarding/signup_page1.dart';

class LoginPage extends StatefulWidget {
  final String? from;
  static const String routeName = '/login';
  var isSwitch = false;

  LoginPage({Key? key, this.from, this.isSwitch = false}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggingIn = false;
  String logo = "";
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool emailMatch = false;
  bool passwordMatch = false;
  var countryName = "";
  bool hidePassword = true;

  OutlineInputBorder _outlineDecoration = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: Colors.grey,
      width: 0.8,
    ),
  );

  void _emailListener() {
    emailNode.addListener(() {
      if (!emailNode.hasFocus) {
        LoginApiCalls.checkEmail(_emailController.text).then((value) {
          if (value == "success") {
            if (mounted) {
              setState(() {
                emailMatch = true;
              });
            }
          }
        });
      }
    });
  }

  void _passwordListener() {
    passwordNode.addListener(() {
      if (!passwordNode.hasFocus) {
        LoginApiCalls.checkPassword(
                _emailController.text, _passwordController.text)
            .then((value) {
          if (value == "success") {
            if (mounted) {
              setState(() {
                passwordMatch = true;
              });
            }
          }
        });
      }
    });
  }

  void _getCountryAndLogo() {
    LoginApiCalls.getCountry().then((name) {
      if (mounted) {
        setState(() {
          countryName = name;
          CurrentUser().currentUser.country = name;
          print("get country called on login ${countryName}");
        });
      }
      print(name);
      LoginApiCalls.getCountryLogo(name).then((value) {
        if (mounted) {
          setState(() {
            logo = value;
            CurrentUser().currentUser.logo = logo;
          });
        }
        print(value);
      });
    });
  }

  void logout() async {
    var data = await getMembers();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("memberID");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    if (data.isNotEmpty) {
      await pref.setString('bebuzeememberlist', json.encode(data));
      print("logout data success");
    }
  }

  Future<Map> getMembers() async {
    var pref = await SharedPreferences.getInstance();
    String encodedMap;
    try {
      encodedMap = pref.getString('bebuzeememberlist')!;
    } catch (e) {
      return {};
    }
    if (encodedMap == null) return {};
    Map<String, dynamic> decodedMap = json.decode(encodedMap);
    print('logintest length=${decodedMap['data'].length}');
    return decodedMap;
  }

  void addNewMember(User user) async {
    var pref = await SharedPreferences.getInstance();

    Map<String, dynamic> memberData = {
      "user_id": user.memberID,
      "member_image": user.image,
      "member_shortcode": user.shortcode,
      "member_email": user.email,
      "member_password": user.password,
      "member_token": user.token,
      "member_name": user.fullName,
      "member_type": user.memberType,
      "member_country": user.country,
    };
    print(
        "mem data=${memberData} pass=${user.password} mem type=${user.memberType}");

    if (await getMembers().then((value) => value.isNotEmpty)) {
      print("get member success");
      var data = pref.getString('bebuzeememberlist');
      var decodeddata = json.decode(data!);
      var exist = false;
      decodeddata['data'].forEach((element) {
        if (element['member_email'] == CurrentUser().currentUser.email) {
          print("already exist");
          exist = true;
          return;
        }
      });

      print("already exist 2");
      if (!exist) {
        decodeddata['data'].add(memberData);
        pref.setString('bebuzeememberlist', json.encode(decodeddata));
      }
    } else {
      print("get member fail");
      var data = pref.setString(
          'bebuzeememberlist',
          json.encode({
            "data": [memberData]
          }));
    }
    print("success add member");
  }

  void _navigateToHome() {
    if (widget.from == 'switchaccount') {
      Navigator.popUntil(
        context,
        ModalRoute.withName('/login'),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    hasMemberLoaded: true,
                    currentMemberImage: CurrentUser().currentUser.image,
                    memberID: CurrentUser().currentUser.memberID,
                    country: CurrentUser().currentUser.country,
                    logo: CurrentUser().currentUser.logo,
                  )));
      return;
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  hasMemberLoaded: true,
                  currentMemberImage: CurrentUser().currentUser.image,
                  memberID: CurrentUser().currentUser.memberID,
                  country: CurrentUser().currentUser.country,
                  logo: CurrentUser().currentUser.logo,
                )));
  }

  void _navigateToHometest(ctx) {
    Navigator.pushReplacement(
        ctx,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  hasMemberLoaded: true,
                  currentMemberImage: CurrentUser().currentUser.image,
                  memberID: CurrentUser().currentUser.memberID,
                  country: CurrentUser().currentUser.country,
                  logo: CurrentUser().currentUser.logo,
                )));
  }

  Widget _textField(FocusNode node, TextEditingController controller,
      String hintText, bool matchText, bool obscure) {
    return Container(
      height: 50,
      child: TextFormField(
        obscureText: obscure,
        cursorColor: Colors.grey,
        cursorHeight: 20,
        focusNode: node,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 15),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: _outlineDecoration,
            border: _outlineDecoration,
            focusedBorder: _outlineDecoration,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                hintText == "Password"
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: !hidePassword ? Colors.green : Colors.grey,
                        ),
                      )
                    : Container(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.check_circle,
                    color: matchText ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _loginButton() {
    return GestureDetector(
      onTap: () async {
        if (_emailController.text == "") {
          customToastBlack(
              "Please enter your email address", 16, ToastGravity.BOTTOM);
        }
        else if (_passwordController.text == "") {
          customToastBlack(
              "Please enter your password", 16, ToastGravity.BOTTOM);
        }
        else {
          await SystemChannels.textInput.invokeMethod('TextInput.hide');
          // setState(() {
          //   isLoggingIn = true;
          // });
          if (widget.from == 'switchaccount') logout();

          await LoginApiCalls.checkLogin(_emailController.text, _passwordController.text)
              .then((value) async {

            if (value[0] == "success") {
              setState(() {
                CurrentUser().currentUser.memberID = value[1];
              });
              // SharedPreferences pref = await SharedPreferences.getInstance();
              // print("after login country token=${pref.getString('token')}");
              print("after login country token=");
              LoginApiCalls.insertCountry(value[1], countryName)
                  .then((value) async {

                SharedPreferences sp = await SharedPreferences.getInstance();
                print("after insert country token=${sp.getString('token')}");
              });

              LoginApiCalls.getCurrentMember(value[1]).then((data) async {
                if (mounted) {
                  // SharedPreferences.setMockInitialValues({});
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.setString("email", _emailController.text);
                  print("Login api has been called ${data}");
                  setState(() {
                    CurrentUser().currentUser.fullName = data[0];
                    CurrentUser().currentUser.image = data[2];
                    CurrentUser().currentUser.shortcode = data[1];
                    CurrentUser().currentUser.memberType = int.parse(data[3]);
                    print("country code=${data[4]} ");
                    CurrentUser().currentUser.code = data[4].toString();
                    CurrentUser().currentUser.email = _emailController.text;
                    CurrentUser().currentUser.password =
                        _passwordController.text;
                  });

                }
                addNewMember(CurrentUser().currentUser);
                print("Login api has been called success 123");
                _navigateToHome();
                return data;
              });
            } else {
              setState(() {
                isLoggingIn = false;
              });
              customToastBlack(
                  "Email or password incorrect", 16, ToastGravity.BOTTOM);
            }
          });
        }
      },
      child: Container(
        decoration: new BoxDecoration(
          color: isLoggingIn ? Colors.grey.withOpacity(0.2) : primaryBlueColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          shape: BoxShape.rectangle,
        ),
        height: 50,
        width: 100.0.w - 20,
        child: Center(
          child: Text(
            !isLoggingIn ? "Log In" : "Logging In...",
            style: TextStyle(
                color: isLoggingIn ? Colors.grey.shade600 : Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _loginButtonTest() {
    return GestureDetector(
      onTap: () async {
        _navigateToHome();
        return;
        if (_emailController.text == "") {
          customToastBlack(
              "Please enter your email address", 16, ToastGravity.BOTTOM);
        } else if (_passwordController.text == "") {
          customToastBlack(
              "Please enter your password", 16, ToastGravity.BOTTOM);
        } else {
          await SystemChannels.textInput.invokeMethod('TextInput.hide');
          // setState(() {
          //   isLoggingIn = true;
          // });
          if (widget.from == 'switchaccount') logout();
          print("Login api has been called");
          LoginApiCalls.checkLogin(
                  _emailController.text, _passwordController.text)
              .then((value) {
            if (value[0] == "success") {
              setState(() {
                CurrentUser().currentUser.memberID = value[1];
              });
              LoginApiCalls.insertCountry(value[1], countryName);
              LoginApiCalls.getCurrentMember(value[1]).then((data) async {
                if (mounted) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString("email", _emailController.text);
                  setState(() {
                    CurrentUser().currentUser.fullName = data[0];
                    CurrentUser().currentUser.image = data[2];
                    CurrentUser().currentUser.shortcode = data[1];
                    // CurrentUser().currentUser.memberType = int.parse(data[3]);
                    print("country code=${data[4]}");
                    CurrentUser().currentUser.code = data[4].toString();
                    CurrentUser().currentUser.email = _emailController.text;
                    CurrentUser().currentUser.password =
                        _passwordController.text;
                  });
                }
                addNewMember(CurrentUser().currentUser);
                // _navigateToHome();
                return data;
              });
            } else {
              setState(() {
                isLoggingIn = false;
              });
              customToastBlack(
                  "Email or password incorrect", 16, ToastGravity.BOTTOM);
            }
          });
        }
      },
      child: Container(
        decoration: new BoxDecoration(
          color: isLoggingIn ? Colors.grey.withOpacity(0.2) : primaryBlueColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          shape: BoxShape.rectangle,
        ),
        height: 50,
        width: 100.0.w - 20,
        child: Center(
          child: Text(
            !isLoggingIn ? "Continue as " : "Logging In...",
            style: TextStyle(
                color: isLoggingIn ? Colors.grey.shade600 : Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _resetButton() {
    return Container(
      child: TextButton(
        style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PasswordReset(
              logo: logo,
              country: countryName,
            );
          }));
        },
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: primaryBlueColor),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage1()));
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Don\'t have an account?  ",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                "Sign Up",
                style: TextStyle(
                    color: primaryBlueColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _greyDivider() {
    return Container(
      height: 1.5,
      width: 50.0.w - 25,
      color: Colors.grey,
    );
  }

  Widget _divider() {
    return Container(
      child: Row(
        children: [
          _greyDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "OR",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          _greyDivider(),
        ],
      ),
    );
  }

  Widget _sizeBox(double h) {
    return SizedBox(
      height: h,
    );
  }

  Widget _logoAsset() {
    return Image.asset(
      'assets/images/splash_main.png',
      height: 10.0.h,
      width: 15.0.w,
      fit: BoxFit.contain,
    );
  }

  @override
  void initState() {
    _getCountryAndLogo();
    _emailListener();
    _passwordListener();

    // Timer(Duration(milliseconds: 650), () {
    //   _navigateToHometest(this.context);
    // });

    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible == true) {
        Timer(Duration(milliseconds: 650), () {
          if (mounted) {
            setState(() {
              CurrentUser().currentUser.keyBoardHeight = double.parse(
                  EdgeInsets.fromWindowPadding(
                          WidgetsBinding.instance.window.viewInsets,
                          WidgetsBinding.instance.window.devicePixelRatio)
                      .toString()
                      .replaceAll("EdgeInsets", "")
                      .replaceAll("(", "")
                      .replaceAll(")", "")
                      .split(", ")[3]);
            });
          }
          print(CurrentUser().currentUser.keyBoardHeight);
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
            height: 50,
            child: logo != ""
                ? Image.network(logo, fit: BoxFit.contain)
                : Container()),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 3,
      ),
      body: WillPopScope(
          onWillPop: () async {
            if (widget.from == "disable") {
              SystemNavigator.pop();
              return true;
            } else {
              Navigator.pop(context);
              return true;
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _logoAsset(),
                    _sizeBox(10),
                    _textField(emailNode, _emailController, "Email", emailMatch,
                        false),
                    _sizeBox(10),
                    _textField(passwordNode, _passwordController, "Password",
                        passwordMatch, hidePassword),
                    _sizeBox(10),
                    _loginButton(),
                    _sizeBox(15),
                    widget.from == 'switchaccount' ? Container() : _divider(),
                    _sizeBox(30),
                    widget.from == 'switchaccount'
                        ? Container()
                        : _resetButton(),
                    widget.from == 'switchaccount'
                        ? Container()
                        : _signUpButton()
                  ],
                ),
              ),
            ),
          )
          // : Container(
          //     alignment: Alignment.center,
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 10),
          //       child: SingleChildScrollView(
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             _logoAsset(),
          //             _sizeBox(10),
          //             // _textField(
          //             //     emailNode, _emailController, "Email", emailMatch, false),
          //             // _sizeBox(10),
          //             // _textField(passwordNode, _passwordController, "Password",
          //             //     passwordMatch, hidePassword),
          //             _sizeBox(10),
          //             _loginButtonTest(),

          //             _sizeBox(15),
          //             // widget.from == 'switchaccount' ? Container() : _divider(),
          //             // _sizeBox(30),
          //             // widget.from == 'switchaccount' ? Container() : _resetButton(),
          //             // widget.from == 'switchaccount' ? Container() : _signUpButton()
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          ),
    );
  }
}
