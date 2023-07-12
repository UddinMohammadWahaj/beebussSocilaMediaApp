import 'dart:async';
import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/Chat/dialogue_helpers.dart';
import 'package:bizbultest/utilities/Chat/shared_preferences_helper.dart';
import 'package:bizbultest/view/Chat/ChatHistory/chat_history.dart';
import 'package:bizbultest/view/Chat/ChatWallpaper/chat_wallpaper.dart';
import 'package:bizbultest/widgets/Chat/chat_settings_card.dart';
import 'package:bizbultest/widgets/Chat/settings_item_header.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bizbultest/widgets/Chat/switch_settings_item.dart';

enum FontSizeOptions {
  small,
  medium,
  large,
}

var fontSizeOptionsList = [
  FontSizeOptions.small,
  FontSizeOptions.medium,
  FontSizeOptions.large,
];

class ChatsSettingsScreen extends StatefulWidget {
  @override
  _ChatsSettingsScreenState createState() => _ChatsSettingsScreenState();
}

class _ChatsSettingsScreenState extends State<ChatsSettingsScreen> {
  FontSizeOptions defaultFontSize = FontSizeOptions.medium;

  late Future<bool> _enterIsSend;
  late Future<bool> _mediaVisibility;
  late Future<FontSizeOptions> _fontSize;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int chatSend = 0;
  int mediaVisibility = 0;
  String memberId = "";
  String fontSizes = "small";

  @override
  void initState() {
    super.initState();

    // initialize variables
    _enterIsSend = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool(SharedPreferencesHelpers.enterIsSend) ??
          SharedPreferencesHelpers.defaultEnterIsSend);
    });
    _mediaVisibility = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool(SharedPreferencesHelpers.mediaVisibility) ??
          SharedPreferencesHelpers.defaultMediaVisibility);
    });
    _fontSize = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt(SharedPreferencesHelpers.fontSize) != null
          ? fontSizeOptionsList[
              prefs.getInt(SharedPreferencesHelpers.fontSize)!]
          : defaultFontSize);
    });

    getChatsData();
  }

  UserDetailModel objUserDetailModel = new UserDetailModel();

  getChatsData() async {
    memberId = CurrentUser().currentUser.memberID!;
    chatSend = await _enterIsSend ? 1 : 0;
    mediaVisibility = await _mediaVisibility ? 1 : 0;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        flexibleSpace: gradientContainer(null),
        title: Text('Chats'),
      ),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            future: _enterIsSend,
            builder: (context, dynamic snapshot) {
              var onChanged;
              bool enterIsSend = SharedPreferencesHelpers.defaultEnterIsSend;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  break;
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  } else {
                    enterIsSend = snapshot.data!;
                    onChanged = (bool value) {
                      _setEnterIsSend(value);
                    };
                  }
              }
              return SwitchSettingItem(
                title: 'Enter is send',
                subtitle: 'Enter key will send your message',
                onChanged: onChanged,
                value: enterIsSend,
                padding: EdgeInsets.only(
                    right: 16.0, left: 70.0, top: 12.0, bottom: 12.0),
              );
            },
          ),
          FutureBuilder(
            future: _mediaVisibility,
            builder: (context, dynamic snapshot) {
              var onChanged;
              bool mediaVisibility =
                  SharedPreferencesHelpers.defaultMediaVisibility;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  break;
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  } else {
                    mediaVisibility = snapshot.data!;
                    onChanged = (bool value) {
                      _setMediaVisibility(value);
                    };
                  }
              }
              return SwitchSettingItem(
                title: 'Media visibility',
                subtitle:
                    'Show newly downloaded media in your phone\'s gallery',
                onChanged: onChanged,
                value: mediaVisibility,
                padding: EdgeInsets.only(
                    right: 16.0, left: 70.0, top: 12.0, bottom: 12.0),
              );
            },
          ),
          FutureBuilder(
            future: _fontSize,
            builder: (context, dynamic snapshot) {
              String fontSize = '-';
              var onTap;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  fontSize = '-';
                  break;
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    fontSize = 'Error: ${snapshot.error}';
                    print(snapshot.error);
                  } else {
                    fontSize = _getFontSizeText(snapshot.data!);
                    onTap = () {
                      DialogHelpers.showRadioDialog(
                          fontSizeOptionsList,
                          'Font size',
                          _getFontSizeText,
                          context,
                          snapshot.data,
                          false, (FontSizeOptions value) {
                        _setFontSize(value.index);
                      });

                      fontSizes = fontSize;
                    };
                  }
              }
              return SettingItem(
                title: 'Font size',
                subtitle: fontSize,
                onTap: onTap,
                padding: EdgeInsets.only(
                  right: 16.0,
                  left: 70.0,
                ),
              );
            },
          ),
          Divider(),
          SettingItem(
            icon: Icons.wallpaper,
            title: 'Wallpaper',
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatWallpaper()),
              );
            },
          ),
          SettingItem(
            icon: Icons.cloud_upload,
            title: 'Chat backup',
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            onTap: () {
              // Application.router.navigateTo(
              //   context,
              //   Routes.futureTodo,
              //   transition: TransitionType.inFromRight,
              // );
            },
          ),
          SettingItem(
            icon: Icons.history,
            title: 'Chat history',
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatHistory(),
                ),
              );
              // Application.router.navigateTo(
              //   context,
              //   Routes.futureTodo,
              //   transition: TransitionType.inFromRight,
              // );
            },
          ),
        ],
      ),
    );
  }

  String _getFontSizeText(FontSizeOptions option) {
    switch (option) {
      case FontSizeOptions.small:
        return 'Small';
      case FontSizeOptions.medium:
        return 'Medium';
      case FontSizeOptions.large:
        return 'Large';
    }
    return ''; // unreachable
  }

  update() async {
    bool chatNotificationSetting = await ApiProvider().chatNotificationSetting(
        memberId, chatSend, mediaVisibility, fontSizes);

    if (chatNotificationSetting) {
      print("Done");
    }
  }

  _setEnterIsSend(bool value) async {
    final SharedPreferences prefs = await _prefs;

    _enterIsSend = prefs
        .setBool(SharedPreferencesHelpers.enterIsSend, value)
        .then((bool success) {
      return value;
    });

    chatSend = await _enterIsSend ? 1 : 0;

    await update();

    setState(() {});
    print("object");
  }

  _setMediaVisibility(bool value) async {
    final SharedPreferences prefs = await _prefs;

    _mediaVisibility = prefs
        .setBool(SharedPreferencesHelpers.mediaVisibility, value)
        .then((bool success) {
      return value;
    });

    mediaVisibility = await _mediaVisibility ? 1 : 0;

    await update();

    setState(() {});
  }

  _setFontSize(int value) async {
    final SharedPreferences prefs = await _prefs;

    _fontSize = prefs
        .setInt(SharedPreferencesHelpers.fontSize, value)
        .then((bool success) {
      return fontSizeOptionsList[value];
    });

    print(fontSizeOptionsList[value].index);

    fontSizes = fontSizeOptionsList[value].index == 0
        ? "small"
        : fontSizeOptionsList[value].index == 1
            ? "medium"
            : "large";

    await update();

    setState(() {});
  }
}
