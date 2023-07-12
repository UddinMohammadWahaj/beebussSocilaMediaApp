import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Chat/StorageAndData/storage_and_data.dart';
import 'package:bizbultest/widgets/Chat/chat_settings_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bizbultest/view/Chat/user_profile_screen.dart';
import 'package:bizbultest/view/Chat/account_settings_screen.dart';
import 'package:bizbultest/view/Chat/chats_setting_screen.dart';
import 'package:bizbultest/view/Chat/notifications_settings_screen.dart';
import 'package:bizbultest/view/Chat/help_settings_screen.dart';
import 'package:share/share.dart';

class SettingsScreenChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          flexibleSpace: gradientContainer(null),
          title: Text(
            AppLocalizations.of("Settings"),
          ),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              leading: Hero(
                tag: 'profile-pic',
                child: CircleAvatar(
                  radius: 35.0,
                  backgroundColor: darkColor,
                  backgroundImage: CachedNetworkImageProvider(
                      CurrentUser().currentUser.image!),
                ),
              ),
              title: Text(
                CurrentUser().currentUser.fullName!,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: SelectedAboutStatus(),
              onTap: () {
                /* Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 1000),
                    pageBuilder: (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return UserProfileScreen();
                    },
                    transitionsBuilder: (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return Align(
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                );*/
                // Navigator.push(context, PageTransition(type: PageTransitionType.fade, curve: Curves.bounceInOut, child: UserProfileScreen()));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileScreen()));
              },
            ),
            Divider(
              height: 0.0,
            ),
            SettingItem(
                icon: Icons.vpn_key,
                title: AppLocalizations.of("Account"),
                subtitle: AppLocalizations.of(
                  'Privacy, security, change number',
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountSettingsScreenChat()));
                }),
            SettingItem(
                icon: Icons.chat,
                title: AppLocalizations.of('CHATS'),
                subtitle: AppLocalizations.of(
                  'Backup, history, wallpaper',
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatsSettingsScreen()));
                }),
            SettingItem(
                icon: Icons.notifications,
                title: AppLocalizations.of("Notifications"),
                subtitle: AppLocalizations.of(
                  'Message, group & call tones',
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsSettingsScreen()));
                }),
            SettingItem(
                icon: Icons.data_usage,
                title: AppLocalizations.of(
                  'Storage and data',
                ),
                subtitle: AppLocalizations.of(
                  'Network usage, auto-download',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StorageAndData(),
                    ),
                  );

                  // Application.router.navigateTo(
                  //   context,
                  //   //Routes.dataSettings,
                  //   Routes.futureTodo,
                  //   transition: TransitionType.inFromRight,
                  // );
                }),
            SettingItem(
                icon: Icons.help_outline,
                title: AppLocalizations.of('Help'),
                subtitle: AppLocalizations.of(
                  'Help centre, contact us, privacy policy',
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HelpSettingsScreen()));
                }),
            Divider(
              indent: 72.0,
              height: 0.0,
            ),
            Builder(builder: (context) {
              return SettingItem(
                  icon: Icons.group,
                  title: AppLocalizations.of('Invite friends'),
                  onTap: () {
                    print("object");
                    Share.share(
                        'check out my App https://www.bebuzee.com/get-the-app#');
                    // AndroidIntentHelpers.inviteFriend(context);
                  });
            }),
            DisableDirect()
          ],
        ));
  }
}

class DisableDirect extends StatefulWidget {
  @override
  _DisableDirectState createState() => _DisableDirectState();
}

class _DisableDirectState extends State<DisableDirect> {
  bool isDirectSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                CustomIcons.chat_icon,
                color: darkColor,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  AppLocalizations.of(
                    "Direct Message",
                  ),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Switch(
                value: isDirectSwitched,
                onChanged: (value) {
                  setState(() {
                    isDirectSwitched = value;
                  });
                  print(isDirectSwitched);
                  if (value == true) {
                    // updateAccountPrivacy(1);
                  } else {
                    //updateAccountPrivacy(0);
                  }
                },
                activeTrackColor: darkColor.withOpacity(0.4),
                activeColor: darkColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SelectedAboutStatus extends StatefulWidget {
  @override
  _SelectedAboutStatusState createState() => _SelectedAboutStatusState();
}

class _SelectedAboutStatusState extends State<SelectedAboutStatus> {
  late Future _selectedStatusFuture;
  AboutRefresh _refresh = AboutRefresh();
  String status = "Available";

  _getSelectedStatusLocal() {
    _selectedStatusFuture =
        DirectApiCalls.getUserSelectedStatusLocal().then((value) {
      setState(() {
        status = value;
      });
      return value;
    });
  }

  @override
  void initState() {
    _getSelectedStatusLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        initialData: _refresh.currentSelect,
        stream: _refresh.observableCart,
        builder: (context, dynamic snapshot) {
          if (snapshot.data) {
            print("changeeeeeee");
            _getSelectedStatusLocal();
            _refresh.updateRefresh(false);
          }
          return Container(
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          );
        });
  }
}
