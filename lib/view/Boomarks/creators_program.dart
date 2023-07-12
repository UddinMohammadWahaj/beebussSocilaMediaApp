import 'dart:io';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/view/Boomarks/creator_program_join_now.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CreatorsProgram extends StatefulWidget {
  const CreatorsProgram({Key? key}) : super(key: key);

  @override
  _CreatorsProgramState createState() => _CreatorsProgramState();
}

class _CreatorsProgramState extends State<CreatorsProgram>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _controller.repeat();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isShowLoading = false;
  var loadingProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlueColor,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: WebView(
              initialUrl: 'https://www.bebuzee.com/creators1',
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (String url) {
                print('Page started loading: $url');
                setState(() {
                  isShowLoading = true;
                });
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                setState(() {
                  isShowLoading = false;
                });
              },
              onProgress: (int progress) {
                print("WebView is loading (progress : $progress%)");
                setState(() {
                  loadingProgress = progress;
                  if (progress > 99) {
                    isShowLoading = false;
                  }
                });
              },
            ),
          ),
          if (isShowLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                    child: CircularProgressIndicator(
                      value: loadingProgress / 100,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreatorsJoinNow()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(
                      "Apply Now",
                    ),
                    style: blackBold.copyWith(
                      fontSize: 16.0.sp,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
