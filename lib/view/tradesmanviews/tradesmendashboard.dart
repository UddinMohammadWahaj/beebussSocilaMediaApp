import 'package:bizbultest/view/homepage.dart';
import 'package:bizbultest/view/tradesmanviews/bulkuploadtradesman.dart';
import 'package:bizbultest/view/tradesmanviews/companylist.dart';
import 'package:bizbultest/view/tradesmanviews/editsolotradesmenview.dart';
import 'package:bizbultest/view/tradesmanviews/tradesmenrequestcacllback.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../services/Tradesmen/tradesmendashbooarcontroller.dart';
import '../../services/current_user.dart';
import '../../utilities/custom_icons.dart';
import '../Properbuz/add_items/add_New_tradesmen_view.dart';
import '../Properbuz/add_items/add_solo_tradesmen.dart';
import '../Properbuz/add_items/tradesmanpayment.dart';
import 'newaddcompanyview.dart';
import 'newsolotradesmanview.dart';

class TradesmenDashboard extends StatefulWidget {
  const TradesmenDashboard({Key? key}) : super(key: key);

  @override
  State<TradesmenDashboard> createState() => _TradesmenDashboardState();
}

class _TradesmenDashboardState extends State<TradesmenDashboard> {
  var tradesmenmaincontroler = Get.put(TrademenMaincontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text('Your Dashboard', style: TextStyle(color: Colors.black)),
        actions: [
          // CircleAvatar(
          //   radius: 5.0.w,
          // )
          // CircleAvatar(
          //     radius: 5.5.w,
          //     backgroundColor: Colors.black,
          //     child: CircleAvatar(
          //       radius: 5.0.w,
          //       backgroundColor: Colors.white,
          //       child: Icon(Icons.notifications_none_outlined,
          //           color: Colors.black),
          //     )),

          CircleAvatar(
            radius: 5.0.w,
            backgroundColor: Colors.white,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.0.h,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 6.0.w,
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(
                    CurrentUser().currentUser.image!),
              ),
              title: Text('${CurrentUser().currentUser.fullName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CurrentUser()
                              .currentUser
                              .tradesmanType
                              .toString()
                              .toLowerCase() ==
                          "solo"
                      ? "Solo Tradesman"
                      : "Tradesmen Company")
                ],
              ),
            ),
            Container(
              width: 100.0.w,
              child: Row(
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => TradesmanPaymentView(
                                  controller: tradesmenmaincontroler,
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0.w)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2.0.w),
                            child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Subscription',
                                        style: TextStyle(
                                            fontSize: 2.5.h,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    tradesmenmaincontroler.isSubscribed.value ==
                                            true
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 1.5.w,
                                                  backgroundColor: Colors.green,
                                                ),
                                                SizedBox(
                                                  width: 1.0.w,
                                                ),
                                                Text('Active')
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 1.5.w,
                                                  backgroundColor: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 1.0.w,
                                                ),
                                                Text('Inactive')
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                                height: 12.0.h,
                                width: 40.0.w,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => TradeesmenRequestedCallback()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0.w)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.0.w),
                              child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Requested Callback',
                                          style: TextStyle(
                                              fontSize: 2.0.h,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 2.5.w,
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.phone_callback_outlined,
                                                color: Colors.black,
                                                size: 3.5.w,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 1.0.w,
                                            ),
                                            Obx(() => Text(
                                                '${tradesmenmaincontroler.listofcacallbacack.length} people'))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height: 12.0.h,
                                  width: 40.0.w,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          child: CircleAvatar(
                        radius: 4.0.w,
                        child: Obx(() => Text(
                            '${tradesmenmaincontroler.listofcacallbacack.length}',
                            style: TextStyle(color: Colors.white))),
                        backgroundColor: Colors.red,
                      )),
                    ],
                  )
                ],
              ),
            ),
            Obx(() => !tradesmenmaincontroler.isSubscribed.value
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>

                                      // CurrentUser()
                                      //             .currentUser
                                      //             .tradesmanType
                                      //             .toLowerCase() ==
                                      //         'solo'
                                      //     ?

                                      // EditSoloTradesmenView()
                                      // AddNewTradesmenView("company", [])
                                      CompanyListView()

                                  // TradesmanPaymentView()

                                  // NewSoloTradesmenView("solo", "0", [])
                                  // : CurrentUser()
                                  //             .currentUser
                                  //             .tradesmanType
                                  //             .toLowerCase() ==
                                  //         'company'
                                  //     ? AddNewTradesmenView("company", [])
                                  //     : Container()

                                  // ExitingCompanyView(),
                                  // AddTradesmenView(null)
                                  ));
                        },
                        leading:
                            Icon(CustomIcons.employee, color: Colors.black),
                        title: Text('Manage Tradesman'
                            // AppLocalizations.of("Add") +
                            //   " " +
                            //   AppLocalizations.of("Tradesmen")

                            ),
                      ),
                    ),
                  )),
            Obx(() => !tradesmenmaincontroler.isSubscribed.value
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BulkUploadTradesmen()));
                        },
                        leading: Icon(Icons.file_upload_outlined,
                            color: Colors.black),
                        title: Text('Bulk upload'
                            // AppLocalizations.of("Add") +
                            //   " " +
                            //   AppLocalizations.of("Tradesmen")

                            ),
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
