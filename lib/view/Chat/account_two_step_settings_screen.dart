import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';

import 'package:flutter/material.dart';

import '2Stepverification/two_step_verification.dart';

class AccountTwoStepSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String text =
        AppLocalizations.of('For added security, enable two-step') +
            " " +
            AppLocalizations.of('verification, which will require a PIN when') +
            ' ' +
            AppLocalizations.of('registering your phone number with') +
            ' ' +
            AppLocalizations.of('Bebuzee again.');

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: gradientContainer(null),
        title: Text(
          AppLocalizations.of(
            'Two-step verification',
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, bottom: 28.0),
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.0),
                            color: secondaryColor.withOpacity(0.2),
                          ),
                        ),
                        Container(
                          height: 35,
                          width: 70,
                          decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              shape: BoxShape.rectangle,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                        Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: secondaryColor,
                                  size: 20,
                                ),
                                Icon(
                                  Icons.star,
                                  color: secondaryColor,
                                  size: 20,
                                ),
                                Icon(
                                  Icons.star,
                                  color: secondaryColor,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.1,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(fabBgColor)),
              child: Text(
                AppLocalizations.of(
                  'ENABLE',
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountTwoStepPINScreen()),
                );
                // Application.router.navigateTo(
                //   context,
                //   //Routes.accountEnableTwoStepSettings,
                //   Routes.futureTodo,
                //   transition: TransitionType.inFromRight,
                // );
              },
            ),
          )
        ],
      ),
    );
  }
}
