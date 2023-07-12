import 'package:bizbultest/services/Properbuz/tradesmen_results_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/view/Properbuz/menu/detailed_tradesmen_view.dart';
import 'package:bizbultest/view/Properbuz/request_notification_view.dart';
import 'package:bizbultest/widgets/Properbuz/tradesmen/detailed_tradesmen/review_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';

class RqeusetedTradesmenDetails extends GetView<TradesmenResultsController> {
  final int? index;
  final RequestedData? objTradesmanRequestedModel;

  RqeusetedTradesmenDetails({
    Key? key,
    this.index,
    this.objTradesmanRequestedModel,
  }) : super(key: key);
  TradesmenResultsController ctr = Get.put(TradesmenResultsController());

  Widget imageCard() {
    return Container(
      height: 60,
      width: 60,
      child: CircleAvatar(
        backgroundColor: settingsColor,
        child: ClipOval(
            child: Image.network(
          objTradesmanRequestedModel!.profile!,
          // : objTradesmanRequestedModel.logo,
          fit: BoxFit.fill,
          height: 60,
          width: 60,
        )),
      ),
    );
  }

  Widget imageCard2() {
    return Container(
      height: 60,
      width: 60,
      child: CircleAvatar(
        backgroundColor: settingsColor,
        child: ClipOval(
            child: Image.network(
          // objTradesmanRequestedModel.profile,
          objTradesmanRequestedModel!.logo!,
          fit: BoxFit.fill,
          height: 60,
          width: 60,
        )),
      ),
    );
  }

  Widget _customText(String title, String value) {
    return Text(
      "$title" + value,
      style:
          TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TradesmenResultsController());
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RequestNotificationView(objTradesmanRequestedModel!),
            ),
          ).then((value) => ctr.fetchRequestedList());
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            //
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                    leading: objTradesmanRequestedModel!.type == "solo"
                        ? imageCard()
                        : imageCard2(),
                    title: Text(
                      AppLocalizations.of("Name") +
                          " : ${objTradesmanRequestedModel!.fullName}",
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _customText(
                          AppLocalizations.of("Email") + " : ",
                          "${objTradesmanRequestedModel!.email}",
                        ),
                        _customText(
                          AppLocalizations.of("Contact") +
                              " " +
                              AppLocalizations.of("number") +
                              ": ",
                          "${objTradesmanRequestedModel!.mobile}",
                        ),
                      ],
                    ),
                    trailing: objTradesmanRequestedModel!.totalRequest == 0
                        ? Container(
                            child: Text(""),
                          )
                        : Container(
                            alignment: Alignment.center,
                            height: 25,
                            width: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryPinkColor),
                            child: Text(
                              (objTradesmanRequestedModel!.totalRequest)
                                  .toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text(AppLocalizations.of(
                          objTradesmanRequestedModel!.createdAt!)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
