import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/view/Chat/AppInfo/appinfo.dart';
import 'package:bizbultest/view/Chat/ContactUs/contact_us.dart';
import 'package:bizbultest/widgets/Chat/chat_settings_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        flexibleSpace: gradientContainer(null),
        title: Text(
          AppLocalizations.of('Help'),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SettingItem(
            icon: Icons.help_outline,
            title: 'FAQ',
            onTap: () {
              // String url = 'https://faq.whatsapp.com/';
              _launchURL("https://www.bebuzee.com/help");
            },
          ),
          SettingItem(
            icon: Icons.group,
            title: AppLocalizations.of("Contact us"),
            subtitle: AppLocalizations.of(
              'Questions? Need help?',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactUS(),
                ),
              );

              // Application.router.navigateTo(
              //   context,
              //   //Routes.helpContactSettings,
              //   Routes.futureTodo,
              //   transition: TransitionType.inFromRight,
              // );
            },
          ),
          SettingItem(
              icon: Icons.insert_drive_file,
              title: AppLocalizations.of("Terms and Privacy Policy"),
              onTap: () {
                _launchURL("https://www.bebuzee.com/privacy-policy");
                // String url = 'https://whatsapp.com/legal';
                // _launchURL(url);
              }),
          SettingItem(
            icon: Icons.info_outline,
            title: 'App info',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppInfoScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
