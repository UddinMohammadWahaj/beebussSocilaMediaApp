import 'dart:async';
import 'dart:ui';

import 'package:bizbultest/view/Properbuz/request_tradesmen_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../services/Properbuz/add_tradesman_controller.dart';
import '../../services/Properbuz/tradesmen_results_controller.dart';
import '../../utilities/colors.dart';
import '../../utilities/custom_icons.dart';
import '../../widgets/Properbuz/tradesmen/refine_sheet.dart';
import '../../widgets/Properbuz/tradesmen/sort_sheet.dart';
import '../../widgets/Properbuz/tradesmen/tradesmen_card.dart';

class RequestTradesmenView extends StatefulWidget {
  const RequestTradesmenView({Key? key}) : super(key: key);

  @override
  State<RequestTradesmenView> createState() => _RequestTradesmenViewState();
}

class _RequestTradesmenViewState extends State<RequestTradesmenView> {
  TradesmenResultsController ctr = Get.put(TradesmenResultsController());
  bool va1 = false;

  @override
  void initState() {
    ctr.fetchRequestedList();
    Timer(Duration(seconds: 2), () {
      setState(
        () {
          va1 = true;
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<AddTradesmenController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //  backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: appBarColor,
        brightness: Brightness.dark,
        leading: IconButton(
          splashRadius: 20,
          icon: Icon(
            Icons.keyboard_backspace,
            size: 28,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);

            // Get.delete<AddTradesmenController>();
          },
        ),
        title: Text(
          AppLocalizations.of("Requested") +
              " " +
              AppLocalizations.of("Tradesmen"),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: va1 == true
          ? Container(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GetX<TradesmenResultsController>(
                  builder: (controlr) {
                    return
                        // controlr.lstRequestData.length > 0
                        //     ? ListView.builder(
                        //         // physics: NeverScrollableScrollPhysics(),
                        //         itemCount: controlr.lstRequestData.length,
                        //         itemBuilder: (context, index) {
                        //           print(
                        //               "object... length ${controlr.lstRequestData.length}");
                        //           return RqeusetedTradesmenDetails(
                        //             index: index,
                        //             objTradesmanRequestedModel:
                        //                 controlr.lstRequestData[index],
                        //           );
                        //         },
                        //       )
                        //     :

                        noDataView();
                  },
                ),
              ),
              // ),
            )
          : Center(
              child: Container(
                  height: 30,
                  child: CircularProgressIndicator(
                    color: settingsColor,
                  ))),
    );
  }

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
}
