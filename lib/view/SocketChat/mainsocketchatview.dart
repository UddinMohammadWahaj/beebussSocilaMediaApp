import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/api/api.dart';
import 'package:bizbultest/models/Chat/direct_message_user_list_model.dart';
import 'package:bizbultest/models/Chat/direct_user_model.dart';
import 'package:bizbultest/models/userDetailModel.dart';
import 'package:bizbultest/services/Chat/chat_api.dart';
import 'package:bizbultest/services/Chat/direct_api.dart';
import 'package:bizbultest/services/Chat/refresh_content.dart';
import 'package:bizbultest/services/country_name.dart';
import 'package:bizbultest/services/current_user.dart';
import 'package:bizbultest/utilities/Chat/colors.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/constant.dart';
import 'package:bizbultest/utilities/snack_bar.dart';
import 'package:bizbultest/view/Chat/call_history_screen.dart';
import 'package:bizbultest/view/Chat/detailed_direct_screen.dart';
import 'package:bizbultest/view/Chat/direct_chat_screen.dart';
import 'package:bizbultest/view/Chat/settings_screen.dart';
import 'package:bizbultest/view/Chat/starred_messages_screen.dart';
import 'package:bizbultest/widgets/Chat/chat_camera_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import 'package:bizbultest/view/Chat/archived_chats.dart';
import 'package:bizbultest/view/Chat/controllers/chat_home_controller.dart';
import 'package:bizbultest/view/Chat/detailed_broadcast_screen.dart';
import 'package:bizbultest/view/Chat/detailed_chat_screen.dart';
import 'package:bizbultest/view/Chat/detailed_group_chat_screen.dart';
import 'package:bizbultest/view/Chat/new_broadcast_select_users_page.dart';
import 'package:bizbultest/view/Chat/new_chat_screen.dart';
import 'package:bizbultest/view/Chat/new_group_select_users_page.dart';

enum HomeOptions {
  settings,
  // Chats Tab
  newGroup,
  newBroadcast,
  whatsappWeb,
  starredMessages,
  // Status Tab
  statusPrivacy,
  // Calls Tab
  clearCallLog,
  readMe,
}

class SocketChatHome extends StatefulWidget {
  final Function? setNavbar;
  final String? from;

  SocketChatHome({Key? key, this.setNavbar, this.from}) : super(key: key);

  @override
  _SocketChatHomeState createState() => _SocketChatHomeState();
}

class _SocketChatHomeState extends State<SocketChatHome>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _tabIndex = 1;
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              title: Text(
                'Bebuzee',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
              ),
              brightness: Brightness.dark,
              toolbarHeight: 56,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              pinned: true,
              floating: true,
              expandedHeight: _tabIndex == 0 ? 0 : 100,
              flexibleSpace: _tabIndex == 0 ? null : gradientContainer(null),
            )
          ];
        },
        body: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: TabBarView(
              controller: TabController(length: 3, vsync: this),
              children: [Container(), Container(), Container()]),
        ),
      ),
    );

    throw UnimplementedError();
  }
}
