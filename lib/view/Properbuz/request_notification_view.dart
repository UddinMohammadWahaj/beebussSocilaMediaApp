import 'dart:async';

import 'package:bizbultest/view/Chat/notifications_settings_screen.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../Language/appLocalization.dart';
import '../../services/Properbuz/hot_properties_controller.dart';
import '../../services/Properbuz/tradesmen_results_controller.dart';
import '../../utilities/Chat/colors.dart';
import '../../utilities/colors.dart';
import '../../utilities/custom_icons.dart';
import '../../widgets/Properbuz/tradesmen/detailed_tradesmen/review_model.dart';

class RequestNotificationView extends StatefulWidget {
  final RequestedData objTradesmanRequestedModel;
  RequestNotificationView(this.objTradesmanRequestedModel, {Key? key})
      : super(key: key);

  @override
  State<RequestNotificationView> createState() =>
      _RequestNotificationViewState();
}

class _RequestNotificationViewState extends State<RequestNotificationView> {
  TradesmenResultsController ctr = Get.put(TradesmenResultsController());
  PropertiesController ctrl = Get.put(PropertiesController());

  List read = [];
  bool va1 = false;

  @override
  void initState() {
    print("object... ${widget.objTradesmanRequestedModel.fullName}");
    ctr.fetchenquiryList(
        tradesmenId: int.parse(widget.objTradesmanRequestedModel.tradesmanId!),
        companyId: int.parse(widget.objTradesmanRequestedModel.companyId!));
    Timer(Duration(seconds: 2), () {
      setState(
        () {
          va1 = true;
        },
      );
    });
    super.initState();
  }

  Widget imageCard() {
    return Container(
      height: 60,
      width: 60,
      child: CircleAvatar(
        backgroundColor: settingsColor,
        child: ClipOval(
            child: Image.network(
          widget.objTradesmanRequestedModel.profile!,
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
          widget.objTradesmanRequestedModel.logo!,
          fit: BoxFit.fill,
          height: 60,
          width: 60,
        )),
      ),
    );
  }

  Widget _customText(String title, String value) {
    return Container(
      // width: 100.0.w - 80,
      child: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          "$title" + value,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _customerCard(index) {
    DateTime dt = DateTime.parse(ctr.lstEnquiryData[index].createdAt!);
    return Padding(
        padding: EdgeInsets.only(bottom: 5, right: 5),
        child: Text(
          DateFormat('dd-MMM,yy hh:mm a').format(dt),
          style: TextStyle(color: Colors.black, fontSize: 12),
        ));
  }

  Widget noDataView() {
    return Center(
      child: Container(
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
            AppLocalizations.of("No Requested Tradesman's History Yet..!"),
            style: TextStyle(fontSize: 20, color: settingsColor),
          ),
        ],
      )),
    );
  }

  void deleteDialog(BuildContext context, int index, StateSetter setsate) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return view(context, setsate, index);
            }),
          );
        });
  }

  Future showSuccess(context, msg) async {
    await Get.showSnackbar(GetBar(
      messageText: Text(
        // "Feedback added Successfully..",
        AppLocalizations.of(msg),
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      icon: Icon(
        Icons.done_all_rounded,
        color: Colors.green,
      ),
      duration: Duration(seconds: 3),
    ));
  }

  errorView(msg) {
    Get.showSnackbar(GetBar(
      messageText: Text(AppLocalizations.of(msg),
          style: TextStyle(color: Colors.white, fontSize: 20)),
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.error,
        color: Colors.red,
      ),
    ));
  }

  Widget view(context, StateSetter setState, index) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of('Delete'),
          style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 20,
              fontWeight: FontWeight.bold),

          // color: settingsColor,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Align(
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of(
              'Are you sure, You want to delete this Request ?'),
          style: TextStyle(
              color: settingsColor, fontSize: 16, fontWeight: FontWeight.bold),

          // color: settingsColor,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                // color: settingsColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                      color: settingsColor,
                    ),
                    Text(AppLocalizations.of("Back"),
                        style: TextStyle(color: settingsColor, fontSize: 15)),
                  ],
                )),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(settingsColor)),
              onPressed: () {
                setState(() async {
                  String mssg = await ctr.deleteRquest(
                      int.parse(ctr.lstEnquiryData[index].enquiryId!));
                  navigator!.pop(context);

                  if (mssg == "false") {
                    errorDialog(
                      context,
                      AppLocalizations.of(
                          "There is Some Issue please try again!"),
                      showNeutralButton: false,
                    );
                    Timer(const Duration(seconds: 2), () {
                      return setState(() {});
                    });
                  } else {
                    setState(
                      () async {
                        ctr.fetchenquiryList(
                            tradesmenId: int.parse(
                                widget.objTradesmanRequestedModel.tradesmanId!),
                            companyId: int.parse(
                                widget.objTradesmanRequestedModel.companyId!));

                        successDialog(
                          context,
                          AppLocalizations.of("${mssg.toString()}"),
                          showNeutralButton: false,
                          icon: NotificationDialog.SUCCESS_ICON,
                        );

                        Timer(const Duration(seconds: 1), () {
                          return setState(() {
                            navigator!.pop(context);
                          });
                        });
                      },
                    );
                  }
                });
              },
              child: Text(AppLocalizations.of("Done"),
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    ]);
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
                  child: GetX<TradesmenResultsController>(builder: (controlr) {
                    return ctr.lstEnquiryData.length > 0 &&
                            ctr.lstEnquiryData != null
                        ? ListView.builder(
                            itemCount: ctr.lstEnquiryData.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),

                                decoration: new BoxDecoration(
                                  color:
                                      ctr.lstEnquiryData[index].isRead == false
                                          ? lightGrey
                                          : Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  shape: BoxShape.rectangle,
                                  border: new Border.all(
                                    color: settingsColor,
                                    width: 1,
                                  ),
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: ListTile(
                                        title: Text(
                                          AppLocalizations.of("Name") +
                                              " : ${ctr.lstEnquiryData[index].name}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _customText(
                                              AppLocalizations.of("Member") +
                                                  " " +
                                                  AppLocalizations.of("Name") +
                                                  " : ",
                                              "${ctr.lstEnquiryData[index].memberName}",
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  ctrl.callAgent(
                                                      "tel:${ctr.lstEnquiryData[index].mobile}");
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.call,
                                                    // size: 30,
                                                    color: primaryPinkColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  _customText(
                                                    AppLocalizations.of(""),
                                                    "${ctr.lstEnquiryData[index].mobile}",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  deleteDialog(
                                                      context, index, setState);
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete_forever,
                                                color: primaryPinkColor,
                                                size: 25,
                                              ),
                                            ),
                                            ctr.lstEnquiryData[index].isRead ==
                                                    false
                                                ? InkWell(
                                                    onTap: () {
                                                      setState(() async {
                                                        String mssg = await ctr
                                                            .ReadRequest(int.parse(ctr
                                                                .lstEnquiryData[
                                                                    index]
                                                                .enquiryId!));

                                                        if (mssg == "false") {
                                                          setState(() {
                                                            errorDialog(
                                                              context,
                                                              "There is Some Issue please try again!",
                                                              showNeutralButton:
                                                                  false,
                                                            );
                                                            Timer(
                                                                const Duration(
                                                                    seconds: 1),
                                                                () {
                                                              navigator!
                                                                  .pop(context);
                                                            });
                                                          });
                                                        } else {
                                                          setState(
                                                            () async {
                                                              ctr.fetchenquiryList(
                                                                  tradesmenId: int
                                                                      .parse(widget
                                                                          .objTradesmanRequestedModel
                                                                          .tradesmanId!),
                                                                  companyId: int
                                                                      .parse(widget
                                                                          .objTradesmanRequestedModel
                                                                          .companyId!));

                                                              successDialog(
                                                                context,
                                                                "${mssg.toString()}",
                                                                showNeutralButton:
                                                                    false,
                                                                icon: NotificationDialog
                                                                    .SUCCESS_ICON,
                                                              );

                                                              Timer(
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                                  () {
                                                                navigator!.pop(
                                                                    context);
                                                              });
                                                            },
                                                          );
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            new BoxDecoration(
                                                          color: settingsColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          2)),
                                                          shape: BoxShape
                                                              .rectangle,
                                                        ),
                                                        // color: settingsColor,
                                                        height: 30,
                                                        width: 130,
                                                        child: Text(
                                                          "MARK AS READ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                  )
                                                : Text("")
                                          ],
                                        ),
                                      ),
                                    ),

                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(),
                                        _customerCard(index),
                                      ],
                                    ),
                                    //   ],
                                    // ),
                                    // ),
                                    // ),
                                  ],
                                ),
                                // ),
                              );
                            },
                          )
                        : noDataView();
                  }),
                ),
              )
            : Center(
                child: Container(
                    height: 30,
                    child: CircularProgressIndicator(
                      color: settingsColor,
                    ))));
  }
}
