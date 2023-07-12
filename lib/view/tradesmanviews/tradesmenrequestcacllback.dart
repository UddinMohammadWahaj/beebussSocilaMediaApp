import 'package:bizbultest/services/Tradesmen/tradesmanapi.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Language/appLocalization.dart';
import '../../models/Tradesmen/requested_tradesmen_enqury_model.dart';
import '../../utilities/custom_icons.dart';

class TradeesmenRequestedCallback extends StatefulWidget {
  const TradeesmenRequestedCallback({Key? key}) : super(key: key);

  @override
  State<TradeesmenRequestedCallback> createState() =>
      _TradeesmenRequestedCallbackState();
}

class _TradeesmenRequestedCallbackState
    extends State<TradeesmenRequestedCallback> {
  @override
  Widget build(BuildContext context) {
    Widget noDataView() {
      return Center(
        child: Container(
            // height: 100,
            // width: double.infinity,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CustomIcons.customer,
              size: 70,
              color: settingsColor,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              AppLocalizations.of("No Requested tradesman's History Yet..!"),
              style: TextStyle(fontSize: 20, color: settingsColor),
            ),
          ],
        )),
      );
    }

    _launchCaller(String num) async {
      var url = "tel:$num";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    var ctr = Get.put(RequestedCallbackcontroller());
    return Scaffold(
        appBar: AppBar(
            backgroundColor: settingsColor, title: Text('Requested Callback')),
        body: Obx(() => ctr.listofcacallbacack.length == 0
            ? noDataView()
            : ListView.builder(
                itemCount: ctr.listofcacallbacack.length,
                itemBuilder: ((context, index) => Card(
                      child: ListTile(
                          leading: CircleAvatar(backgroundColor: settingsColor),
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(ctr.listofcacallbacack[index].name!),
                          ),
                          isThreeLine: true,
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.phone, size: 15),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                    Text(ctr.listofcacallbacack[index]
                                        .contactNumber!)
                                  ],
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.date_range, size: 15),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                    Text(ctr.listofcacallbacack[index]
                                            .createdAt!.day
                                            .toString() +
                                        '.' +
                                        ctr.listofcacallbacack[index].createdAt!
                                            .month
                                            .toString() +
                                        '.' +
                                        ctr.listofcacallbacack[index].createdAt!
                                            .year
                                            .toString()),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.0.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.comment, size: 15),
                                    SizedBox(
                                      width: 2.0.w,
                                    ),
                                    Text(ctr.listofcacallbacack[index]
                                        .description!),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.phone, color: Colors.green),
                            onPressed: () {
                              _launchCaller(
                                  ctr.listofcacallbacack[index].contactNumber!);
                            },
                          )),
                    )))));
  }
}

class RequestedCallbackcontroller extends GetxController {
  var listofcacallbacack = <RequestedTradesmenRecord>[].obs;
  void fetchCallback() async {
    var data =
        await TradesmanApi.fetchTradesmenEnquiry().then((value) => value);
    listofcacallbacack.value = data!;
  }

  @override
  void onInit() {
    fetchCallback();
    super.onInit();
  }
}
