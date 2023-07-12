import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/onboarding/signup_page2.dart';
import 'package:bizbultest/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final _currentScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryWhiteColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          width: _currentScreenSize.width,
          height: _currentScreenSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 130,
                width: 100,
                fit: BoxFit.fill,
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
                showIcon: false,
                textEditingController: TextEditingController(),
                focusNode: FocusNode(),
              ),
              CustomTextField(
                label: AppLocalizations.of(
                  'Password',
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                icon: FontAwesomeIcons.solidEyeSlash,
                showIcon: false,
                textEditingController: TextEditingController(),
                focusNode: FocusNode(),
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
                        'Log In',
                      ),
                      style: buttonTextStyle,
                    ),
                  ),
                ),
                color: primaryBlueColor,
                onPressed: () {
                  Navigator.pushNamed(context, SignUpPage2.routeName);
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
                        'Forgot Password?',
                      ),
                      style: buttonTextStyle.copyWith(
                        color: primaryBlueColor,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigator.pushNamed(
                          //   context,
                          //   WebsiteView.routeName,
                          //   arguments: WebsiteViewArguments(
                          //     url: 'https://www.bebuzee.com/terms',
                          //     heading: 'Terms',
                          //   ),
                          // );
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CupertinoButton(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        
                        text: 'Don\'t have an account?  ',
                        style: TextStyle(
                          color: primaryBlackColor,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(
                          'Sign up',
                        ),
                        style: TextStyle(
                          color: primaryBlueColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                color: Colors.transparent,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
