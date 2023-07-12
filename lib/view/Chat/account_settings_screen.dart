import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/view/Chat/2Stepverification/edit2stepverification.dart';
import 'package:bizbultest/view/Chat/ChangePhone/change_number.dart';
import 'package:bizbultest/view/Chat/RequestAccountInfo/requesAcInfo.dart';
import 'package:bizbultest/view/Chat/account_privacy_settings_screen.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/widgets/Chat/chat_settings_card.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/view/Chat/account_security_settings_screen.dart';
import 'package:bizbultest/view/Chat/account_two_step_settings_screen.dart';

class AccountSettingsScreenChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        flexibleSpace: gradientContainer(null),
        title: Text(AppLocalizations.of("Account")),
      ),
      body: ListView(
        children: <Widget>[
          SettingItem(
            icon: Icons.lock,
            title: AppLocalizations.of("Privacy"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountPrivacySettingsScreen()));
            },
          ),
          SettingItem(
            icon: Icons.security,
            title: AppLocalizations.of("Security"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountSecuritySettingsScreen()));
            },
          ),
          SettingItem(
            icon: Icons.verified_user,
            title: AppLocalizations.of(
              'Two-step verification',
            ),
            onTap: () async {
              UserDetailModel objUserDetailModel = new UserDetailModel();
              String uid = CurrentUser().currentUser.memberID!;
              objUserDetailModel = await ApiProvider().getUserDetail(uid);

              if (objUserDetailModel != null &&
                  objUserDetailModel.twoStepVerificationPin != null &&
                  objUserDetailModel.twoStepVerificationPin != "") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Edit2StepVerification(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountTwoStepSettingsScreen(),
                  ),
                );
              }
            },
          ),
          SettingItem(
            icon: Icons.phonelink_setup,
            title: AppLocalizations.of("Change number"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNumberPage(),
                ),
              );
              // Application.router.navigateTo(
              //   context,
              //   //Routes.accountChangeNumSettings,
              //   Routes.futureTodo,
              //   transition: TransitionType.inFromRight,
              // );
            },
          ),
          SettingItem(
            icon: Icons.insert_drive_file,
            title: AppLocalizations.of(
              'Request account info',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RequestAccountInfo(),
                ),
              );
              // Application.router.navigateTo(
              //   context,
              //   //Routes.accountRequestSettings,
              //   Routes.futureTodo,
              //   transition: TransitionType.inFromRight,
              // );
            },
          ),
          // SettingItem(
          //   icon: Icons.delete,
          //   title: AppLocalizations.of("Delete my account"),
          //   onTap: () {
          //     // Application.router.navigateTo(
          //     //   context,
          //     //   //Routes.accountDeleteSettings,
          //     //   Routes.futureTodo,
          //     //   transition: TransitionType.inFromRight,
          //     // );
          //   },
          // ),
        ],
      ),
    );
  }
}
