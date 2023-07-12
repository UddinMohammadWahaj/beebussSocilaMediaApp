import 'package:bizbultest/view/tradesmanviews/tradesmendashboard.dart';
import 'package:bizbultest/view/tradesmanviews/tradesmenfind.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../services/Tradesmen/tradesmendashbooarcontroller.dart';
import '../../services/current_user.dart';
import '../../utilities/custom_icons.dart';
import '../Properbuz/add_items/tradesmanpayment.dart';
import '../Properbuz/add_new_item_view.dart';
import '../Properbuz/request_tradesmen.dart';

class TradesmenMainView extends StatefulWidget {
  Function? setNavbar;
  TradesmenMainView({Key? key, this.setNavbar}) : super(key: key);

  @override
  State<TradesmenMainView> createState() => _TradesmenMainViewState();
}

class _TradesmenMainViewState extends State<TradesmenMainView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.delete<TrademenMaincontroller>();

        widget.setNavbar!(false);
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 27, 26, 26),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          CurrentUser().currentUser.image!))),
              child: Container(),
            ),
            CurrentUser().currentUser.memberType == 3
                ? ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => TradesmenDashboard()));
                    },
                    leading: Icon(Icons.person_pin),
                    title: Text('Tradesmen Dashboard'),
                  )
                : Container(),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestTradesmenView(),
                      //  WriteLocationReviewView(),
                    ));
              },
              leading: Icon(CustomIcons.rebuzz),
              title: Text('Tradsmen Enquiry'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Get.delete<TrademenMaincontroller>();
                widget.setNavbar!(false);
              },
              leading: Icon(Icons.exit_to_app_outlined),
              title: Text('Back to Home'),
            )
          ]),
        ),
        appBar: AppBar(
            // leading: IconButton(
            //     icon: Icon(Icons.arrow_back),
            //     color: Colors.black,
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     }),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Stack(
              children: [
                CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  imageUrl: CurrentUser().currentUser.tradesmenLogo!,
                  height: 5.0.h,
                  alignment: Alignment.topLeft,
                ),
                Positioned(
                    top: 1.0.h,
                    left: 12.0.w,
                    child: Text(
                      'Tradesmen',
                      style: TextStyle(color: Colors.black, fontSize: 2.0.h),
                    )),
              ],
            )),
        body: TradesmanPageView(),
      ),
    );
  }
}
