import 'dart:async';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/models/Chat/blocked_users_chat_model.dart';
import 'package:bizbultest/services/Chat/profile_api.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/Chat/shared_preferences_helper.dart';
import 'package:bizbultest/widgets/Chat/chat_settings_card.dart';
import 'package:bizbultest/widgets/Chat/settings_item_header.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bizbultest/widgets/Chat/switch_settings_item.dart';

import 'blocked_users.dart';

enum PrivacyOptions {
  everyone,
  myContacts,
  nobody,
}

var privacyOptionList = [
  PrivacyOptions.everyone,
  PrivacyOptions.myContacts,
  PrivacyOptions.nobody,
];

class AccountPrivacySettingsScreen extends StatefulWidget {
  @override
  _AccountPrivacySettingsScreenState createState() =>
      _AccountPrivacySettingsScreenState();
}

class _AccountPrivacySettingsScreenState
    extends State<AccountPrivacySettingsScreen> {
  PrivacyOptions defaultLastSeen = PrivacyOptions.nobody;
  PrivacyOptions defaultProfilePhoto = PrivacyOptions.myContacts;
  PrivacyOptions defaultAbout = PrivacyOptions.everyone;
  bool defaultReadReceipts = true;

  late Future<PrivacyOptions> _lastSeen;
  late Future<PrivacyOptions> _profilePhoto;
  late Future<PrivacyOptions> _about;
  late Future<bool> _readReceipts;
  late int _blockedUsersCount = 0;
  BlockedUsers _users = new BlockedUsers([]);

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _getBlockedUsers() {
    ProfileApiCallsChat.getBlockedUsers().then((value) async {
      setState(() {
        _users.users = value!.users;
        _blockedUsersCount = _users.users.length;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("blocked_count", _blockedUsersCount);
      return value;
    });
  }

  void _setBlockedUsersCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? count = prefs.getInt("blocked_count");
    if (count != null) {
      setState(() {
        _blockedUsersCount = count;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setBlockedUsersCount();
    ProfileApiCallsChat.userPrivacyDetails().then((value) async {
      final SharedPreferences prefs = await _prefs;
      prefs.setInt(SharedPreferencesHelpers.about, value[0]);
      prefs.setInt(SharedPreferencesHelpers.profilePhoto, value[1]);
    });

    _getBlockedUsers();

    // initialize variables
    _lastSeen = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt(SharedPreferencesHelpers.lastSeen) != null
          ? privacyOptionList[prefs.getInt(SharedPreferencesHelpers.lastSeen)!]
          : defaultLastSeen);
    });
    _profilePhoto = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt(SharedPreferencesHelpers.profilePhoto) != null
          ? privacyOptionList[
              prefs.getInt(SharedPreferencesHelpers.profilePhoto)!]
          : defaultProfilePhoto);
    });
    _about = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt(SharedPreferencesHelpers.about) != null
          ? privacyOptionList[prefs.getInt(SharedPreferencesHelpers.about)!]
          : defaultAbout);
    });
    _readReceipts = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool(SharedPreferencesHelpers.readReceipts) ??
          defaultReadReceipts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        flexibleSpace: gradientContainer(null),
        title: Text(AppLocalizations.of("Privacy")),
      ),
      body: ListView(children: <Widget>[
        SettingItemHeader(
          title: AppLocalizations.of(
            'Who can see my personal info',
          ),
          subtitle: AppLocalizations.of(
            "If you don't share your Last Seen, you won't be able to see other people's Last Seen",
          ),
          padding:
              EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0, bottom: 4.0),
        ),
        _buildFutureSettingItem(context, AppLocalizations.of("Last seen"),
            _lastSeen, _getPrivacyText, (PrivacyOptions value) {
          _setLastSeen(value.index);
        }),
        _buildFutureSettingItem(context, AppLocalizations.of("Profile photo"),
            _profilePhoto, _getPrivacyText, (PrivacyOptions value) {
          _setProfilePhoto(value.index);
        }),
        _buildFutureSettingItem(
            context, AppLocalizations.of("About"), _about, _getPrivacyText,
            (PrivacyOptions value) {
          _setAbout(value.index);
        }),
        SettingItem(
            title: AppLocalizations.of("Status"),
            subtitle: AppLocalizations.of("No contacts selected"),
            onTap: () {
              // Application.router.navigateTo(
              //   context,
              //   //Routes.statusPrivacy,
              //   Routes.futureTodo,
              //   transition: TransitionType.inFromRight,
              // );
            },
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 24.0)),
        FutureBuilder(
          future: _readReceipts,
          builder: (context, dynamic snapshot) {
            var onChanged;
            bool readReceipts = false;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                break;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  print(snapshot.error);
                } else {
                  readReceipts = snapshot.data;
                  onChanged = (bool value) {
                    _setReadReceipts(value);
                  };
                }
            }
            return SwitchSettingItem(
              title: AppLocalizations.of(
                'Read receipts',
              ),
              subtitle: AppLocalizations.of(
                  "If turned off, you won't send or receive Read receipts. Read receipts are always sent for group chats."),
              value: readReceipts,
              onChanged: onChanged,
            );
          },
        ),
        Divider(),
        SettingItem(
            title: AppLocalizations.of("Live location"),
            subtitle: AppLocalizations.of("None"),
            onTap: () {
              // Application.router.navigateTo(
              //   context,
              //   //Routes.privacyLiveLocation,
              //   Routes.futureTodo,
              //   transition: TransitionType.inFromRight,
              // );
            },
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 24.0)),
        SettingItem(
            title: AppLocalizations.of("Blocked contacts"),
            subtitle: _blockedUsersCount == 0
                ? AppLocalizations.of("None")
                : _blockedUsersCount.toString(),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlockedUsersScreen(
                            users: _users.users,
                          )));
            },
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 24.0)),
      ]),
    );
  }

  String _getPrivacyText(PrivacyOptions option) {
    switch (option) {
      case PrivacyOptions.everyone:
        return AppLocalizations.of("Everyone");
      case PrivacyOptions.myContacts:
        return AppLocalizations.of('My contacts');
      case PrivacyOptions.nobody:
        return AppLocalizations.of('Nobody');
      default:
        return '';
    }
  }

  _buildFutureSettingItem(
      BuildContext context, String title, future, getText, onChanged) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        String subtitle = '-';
        var onTap;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            subtitle = '-';
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              subtitle = 'Error: ${snapshot.error}';
              print(snapshot.error);
            } else {
              subtitle = getText(snapshot.data);
              onTap = () {
                DialogHelpers.showRadioDialog(privacyOptionList, title, getText,
                    context, snapshot.data, false, onChanged);
              };
            }
        }
        return SettingItem(
            title: title,
            subtitle: subtitle,
            onTap: onTap,
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 24.0));
      },
    );
  }

  _setLastSeen(int value) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _lastSeen = prefs
          .setInt(SharedPreferencesHelpers.lastSeen, value)
          .then((bool success) {
        return privacyOptionList[value];
      });
    });
  }

  _setProfilePhoto(int value) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _profilePhoto = prefs
          .setInt(SharedPreferencesHelpers.profilePhoto, value)
          .then((bool success) {
        return privacyOptionList[value];
      });
    });
    ProfileApiCallsChat.profilePicturePrivacy(value);
  }

  _setAbout(int value) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _about = prefs
          .setInt(SharedPreferencesHelpers.about, value)
          .then((bool success) {
        return privacyOptionList[value];
      });
    });

    print(value);
    ProfileApiCallsChat.aboutStatusPrivacy(value);
  }

  _setReadReceipts(bool value) async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      _readReceipts = prefs
          .setBool(SharedPreferencesHelpers.readReceipts, value)
          .then((bool success) {
        return value;
      });
    });
  }
}
