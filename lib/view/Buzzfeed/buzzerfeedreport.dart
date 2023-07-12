import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';

class BuzzerFeedReport extends StatefulWidget {
  const BuzzerFeedReport({Key? key}) : super(key: key);

  @override
  State<BuzzerFeedReport> createState() => _BuzzerFeedReportState();
}

class _BuzzerFeedReportState extends State<BuzzerFeedReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 20.h,
        elevation: 0.0,
        title: Text(
          AppLocalizations.of('Report') + ' ' + AppLocalizations.of('Buzz'),
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),

        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        height: 100.0.h,
        width: 100.0.w,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Get.snackbar(AppLocalizations.of('Success'),
                    AppLocalizations.of('Buzz reported successfully!!'),
                    backgroundColor: HexColor('#FFFFFF'));
              },
              title:
                  Text(AppLocalizations.of('I m not interested in this buzz')),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Get.snackbar(AppLocalizations.of('Success'),
                    AppLocalizations.of('Buzz reported successfully!!'),
                    backgroundColor: HexColor('#FFFFFF'));
              },
              title: Text(AppLocalizations.of('Its Suspicious or Spam')),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Get.snackbar(AppLocalizations.of('Success'),
                    AppLocalizations.of('Buzz reported successfully!!'),
                    backgroundColor: HexColor('#FFFFFF'));
              },
              title: Text(AppLocalizations.of('Its abusive or harmful')),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Get.snackbar(AppLocalizations.of('Success'),
                    AppLocalizations.of('Buzz reported successfully!!'),
                    backgroundColor: HexColor('#FFFFFF'));
              },
              title: Text(AppLocalizations.of(
                  'It expresses intentions of self-harm or suicide')),
            )
          ],
        ),
      ),
    );
  }
}
