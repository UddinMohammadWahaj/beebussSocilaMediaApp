import 'dart:async';

import 'package:bizbultest/models/TradesmanSearchModel.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/widgets/Properbuz/menu/manage_tradesman/manage_tradesman_card.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Language/appLocalization.dart';
import '../../../services/Properbuz/add_tradesman_controller.dart';
import '../../../utilities/custom_icons.dart';

class ManageTradesmanView extends StatefulWidget {
  String? companyId;
  ManageTradesmanView(this.companyId, {Key? key, this.objTradesmanSearchModel})
      : super(key: key);

  final TradesmanSearchModel? objTradesmanSearchModel;

  @override
  State<ManageTradesmanView> createState() => _ManageTradesmanViewState();
}

class _ManageTradesmanViewState extends State<ManageTradesmanView> {
  AddTradesmenController ctr1 = Get.put(AddTradesmenController());
  @override
  void initState() {
    super.initState();
    setState(() {
      callBack1();
      Timer(Duration(seconds: 2), () {
        setState(
          () {
            va1 = true;
          },
        );
      });
    });
  }

  callBack1() async {
    setState(() async {
      await ctr1.fetchTradesmenList(
          companyId: int.parse(widget.companyId!), setsate: setState);
    });
  }

  bool va1 = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
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
            AppLocalizations.of("Manage") +
                " " +
                AppLocalizations.of("Tradesmen"),
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        body: va1 == true
            ? StatefulBuilder(builder: (context, setState) {
                if (ctr1.lstTradesmenData.length > 0) {
                  return Container(
                      height: height / 1.135,
                      width: double.infinity,
                      child: ListView.builder(
                          itemCount: ctr1.lstTradesmenData.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return ManageTradesmanCard(
                              id: ctr1.lstTradesmenData[index].tradesmanId!,
                              fullName: ctr1.lstTradesmenData[index].fullName,
                              mobile: ctr1.lstTradesmenData[index].mobile,
                              email: ctr1.lstTradesmenData[index].email,
                              index: 0,
                              experience:
                                  ctr1.lstTradesmenData[index].experience,
                              createdAt: ctr1.lstTradesmenData[index].createdAt,
                              profileImage: ctr1.lstTradesmenData[index]
                                              .profile ==
                                          null ||
                                      ctr1.lstTradesmenData[index].profile == ""
                                  ? ""
                                  : ctr1.lstTradesmenData[index].profile,
                              passData: [
                                widget.companyId,
                                ctr1.lstTradesmenData[index].profile,
                                ctr1.lstTradesmenData[index].fullName,
                                ctr1.lstTradesmenData[index].mobile,
                                ctr1.lstTradesmenData[index].atMobile,
                                ctr1.lstTradesmenData[index].email,
                                ctr1.lstTradesmenData[index].experience,
                                ctr1.lstTradesmenData[index].countryId,
                                ctr1.lstTradesmenData[index].location,
                                ctr1.lstTradesmenData[index].workArea,
                                ctr1.lstTradesmenData[index].category,
                                ctr1.lstTradesmenData[index].subcategory,
                                ctr1.lstTradesmenData[index].workType,
                                ctr1.lstTradesmenData[index].callOutHours,
                                ctr1.lstTradesmenData[index].publicLibility,
                                ctr1.lstTradesmenData[index].workUndertaken,
                                ctr1.lstTradesmenData[index].details,
                                ctr1.lstTradesmenData[index].tradesmanId,
                              ],
                              setstate: setState,
                              companyId: widget.companyId,
                            );
                          }));
                } else {
                  return noTradView();
                }
              })
            : Center(
                child: Container(
                    height: 30,
                    child: CircularProgressIndicator(
                      color: settingsColor,
                    ))));
  }

  Widget noTradView() {
    return Center(
      child: Container(
          height: 200,
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
                AppLocalizations.of('No Tradesmen Added Yet..!'),
                style: TextStyle(fontSize: 20, color: settingsColor),
              ),
            ],
          )),
    );
  }
}
