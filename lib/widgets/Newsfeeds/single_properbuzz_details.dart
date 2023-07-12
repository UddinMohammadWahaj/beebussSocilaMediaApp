import 'package:bizbultest/services/Properbuz/properbuz_feed_controller.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/feed_post_card.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/trending_tags.dart';
import 'package:bizbultest/widgets/Properbuz/feeds/upload_post_card.dart';
import 'package:bizbultest/widgets/Properbuz/utils/header_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';

class singleProperbuzzPost extends StatefulWidget {
  const singleProperbuzzPost({Key? key}) : super(key: key);

  @override
  State<singleProperbuzzPost> createState() => _singleProperbuzzPostState();
}

class _singleProperbuzzPostState extends State<singleProperbuzzPost> {
  // @override
  // Widget build(BuildContext context) {
  // return Container(

//     );
//   }
// }

// class ProperbuzFeedsView1 extends StatefulWidget {
//   ProperbuzFeedsView1({
//     Key key,
//   }) : super(key: key);

  Widget _separator() {
    return Container(
      width: 100.0.w,
      height: 10,
      color: HexColor("#e9e6df"),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProperbuzFeedController ctr = Get.put(ProperbuzFeedController());
    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.black,
          onPressed: () {
            // widget.setNavBar(false);
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of('Feed Post'),
          style: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        brightness: Brightness.light,
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          // widget.setNavBar(false);
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            child: ProperbuzFeedPostCard(
              navigate: true,
              showMenu: true,
              maxLines: 3,
              index: 0,
              val: 1,
            ),
          ),
        ),
      ),
    );
  }
}
